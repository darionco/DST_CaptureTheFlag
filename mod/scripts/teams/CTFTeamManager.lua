---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-01-16 4:45 p.m.
---
local require = _G.require;

local CTF_TEAM_CONSTANTS = require('constants/CTFTeamConstants');

CTFTeamManager = {
    teamCount = 0,
    teams = {},
    gameStarted = false,
    gameStartCount = 0,

    players = {},
};

function CTFTeamManager:initNet(net)
    self.net = net;
    self.ctf_player_table = net_string(self.net.GUID, 'ctf_player_table', 'ctf_player_table');
    if not TheNet:IsDedicated() then
        self.net:ListenForEvent('ctf_player_table', function() self:handleNetPlayerTable() end);
    end
end

function CTFTeamManager:netUpdatePlayerTable()
    local serialized = '|';
    for k, _ in pairs(self.players) do
        serialized = serialized .. k .. '|';
    end
    self.ctf_player_table:set(serialized);
end

function CTFTeamManager:handleNetPlayerTable()
    local serialized = self.ctf_player_table:value();
    local newList = {};
    -- deserialize the table and add placeholders for missing players
    for userid in string.gmatch(serialized, '([^|]+)') do
        if userid then
            newList[userid] = true;
            if not self.players[userid] then
                self.players[userid] = false;
            end
        end
    end

    -- run through the local list and remove any players that have left
    for k, _ in pairs(self.players) do
        if not newList[k] then
            self.players[k] = nil;
        end
    end
end

function CTFTeamManager:getCTFPlayer(userid)
    local player = self.players[userid];
    if player then
        return player;
    end
    return nil;
end

function CTFTeamManager:registerTeamObject(obj, data)
    if (self.teams[data.ctf_team] == nil) then
        print('Creating CTF team ' .. data.ctf_team);
        table.insert(self.teams, data.ctf_team, CTFTeam(data.ctf_team));
        self.teamCount = self.teamCount + 1;
    end
    self.teams[data.ctf_team]:registerObject(obj, data);
end

function CTFTeamManager:getTeamWithLeastPlayers()
    local minPlayerCount = 9999999;
    local team;
    for _, v in ipairs(self.teams) do
        if v.playerCount < minPlayerCount then
            minPlayerCount = v.playerCount;
            team = v;
        end
    end
    return team;
end

function CTFTeamManager:shouldStartGame()
    -- gameStartCount other than 0 means the game is starting
    if self.gameStarted == false and self.gameStartCount == 0 then
        local totalReadyPlayers = 0;
        for _, v in pairs(self.players) do
            if v:isReady() then
                totalReadyPlayers = totalReadyPlayers + 1;
            end
        end
        local minPlayerCount = GetModConfigData('CTF_MIN_PLAYERS_TO_START');
        if totalReadyPlayers >= minPlayerCount then
            return true;
        end
    end
    return false;
end

function CTFTeamManager:gameStartTick()
    if self.gameStartCount > 0 then
        c_announce('Game starting in ' .. self.gameStartCount);
        self.gameStartCount = self.gameStartCount - 1;
        TheWorld:DoTaskInTime(1, function() CTFTeamManager:gameStartTick() end);
    else
        self.gameStartCount = 0;
        self:startGame();
    end
end

function CTFTeamManager:scheduleGameStart()
    if self.gameStarted == false and self.gameStartCount == 0 then
        self.gameStartCount = 5;
        self:gameStartTick();
    end
end

function CTFTeamManager:startGame()
    if self.gameStarted == false and self.gameStartCount == 0 then
        self.gameStarted = true;
        for _, v in ipairs(self.teams) do
            v:teleportAllPlayersToBase();
        end
        TheWorld:PushEvent(CTF_TEAM_CONSTANTS.GAME_STARTED);
    end
end

function CTFTeamManager:playerReadyUpdated(ctfPlayer)
    if ctfPlayer:isReady() and self.gameStarted then
        local team = self.teams[ctfPlayer:getTeamID()];
        if team then
            team:teleportPlayerToBase(ctfPlayer:getPlayer());
        end
    elseif self:shouldStartGame() then
        self:scheduleGameStart();
    end
end

function CTFTeamManager:getPlayerTeam(userid)
    local player = self:getCTFPlayer(userid);
    if player then
        return self.teams[player:getTeamID()];
    end
    return nil;
end

function CTFTeamManager:getObjectTeam(obj)
    if obj.data and obj.data.ctf_team_id ~= nil then
        return self.teams[obj.data.ctf_team_id];
    end
    return nil;
end

function CTFTeamManager:registerCTFPlayer(ctfPlayer)
    self.players[ctfPlayer:getUserID()] = ctfPlayer;

    if TheWorld.ismastersim then
        -- this should be useless
        self:netUpdatePlayerTable();

        local team = self:getTeamWithLeastPlayers();
        if not team then
            c_regenerateworld();
        else
            c_announce(ctfPlayer:getName() .. ' joins team ' .. team.id);
            ctfPlayer:setTeamID(team.id);
            local player = ctfPlayer:getPlayer();
            if player then
                team:registerPlayer(player);
                team:setPlayerInvincibility(player, true);
            end
        end
    end
end

function CTFTeamManager:removePlayer(player)
    local ctfPlayer = self.players[player.userid];
    if ctfPlayer then
        local teamID = ctfPlayer:getTeamID();
        local team = teamID ~= 0 and self.teams[teamID] or nil;
        if team then
            team:removePlayer(player);
            TheWorld:PushEvent(CTF_TEAM_CONSTANTS.PLAYER_LEFT_TEAM_EVENT, player, team);
        end
        ctfPlayer:kill();

        -- if all the players left, regenerate the world
        local count = 0
        for _, _ in pairs(self.players) do
            count = count + 1
        end

        if count == 0 then
            c_regenerateworld();
        else
            self:netUpdatePlayerTable();
        end
    end
end
