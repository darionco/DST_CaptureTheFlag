---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-03-05 9:39 a.m.
---
local require = _G.require;
local inventory = require('init/player_inventory');
local ShowWelcomeScreen = require('screens/CTFInstructionsPopup');
local CTF_TEAM_CONSTANTS = require('constants/CTFTeamConstants');

AddPrefabPostInit('ctf_player_net', function(inst)
    if not TheWorld.ismastersim then
        inst:ListenForEvent(inst.user_id.event, function()
            CTFPlayer(inst);
        end);
    end
end);

CTFPlayer = Class(function(self, net)
    self.net = net;

    self.net:DoTaskInTime(0, function()
        self:initNet();
        self:initCommon();
        if TheWorld.ismastersim then
            self:initMaster();
        end
    end);
end);

function CTFPlayer:kill()
    print('============================================ CTFPlayer:kill');
end

function CTFPlayer:initCommon()
    CTFTeamManager:registerCTFPlayer(self);
    TheWorld:ListenForEvent('showworldreset', function()
        local player = self:getPlayer();
        if player and player.HUD and player.HUD.controls then
            player.HUD.controls:HideCraftingAndInventory();
        end
    end);
end

function CTFPlayer:initMaster()
    local player = self:getPlayer();
    if player then
        local marker = player:SpawnChild('ctf_team_marker');
        marker.ctf_team_id:set(self:getTeamID());

        inventory.initializeInventory(player);

        local function OnPlayerSpawned(f_player)
            f_player:RemoveEventCallback('colourtweener_end', OnPlayerSpawned);
            self.net.spawned.var:push();
        end
        player:ListenForEvent('colourtweener_end', OnPlayerSpawned);

        player:ListenForEvent('death', function() self:handleDeath(player) end);
    end
end

function CTFPlayer:initNet()
    if not TheNet:IsDedicated() then
        self:initNetEvents();
    end
end

function CTFPlayer:initNetEvents()
    self.net:ListenForEvent(self.net.spawned.event, function() self:netHandleSpawnedEvent() end);
end

function CTFPlayer:netHandleSpawnedEvent()
    local player = self:getPlayer();
    if player and player == ThePlayer then
        self:patchPlayerComponents(player);
        ShowWelcomeScreen(function()
            SendModRPCToServer(MOD_RPC[CTF_TEAM_CONSTANTS.RPC_NAMESPACE][CTF_TEAM_CONSTANTS.RPC.PLAYER_JOINED_CTF]);
        end);
    end
end

function CTFPlayer:patchPlayerComponents(player)
    if player then
        local teamID = self:getTeamID();
        if teamID ~= 0 then
            local teamTag = CTFTeam:makeTeamTag(teamID);
            CTFTeam:patchPlayerController(player, teamTag);
            CTFTeam:patchCombat(player, teamTag);
        end
    end
end

function CTFPlayer:handleDeath(player)
    print('=================================== player death', player);
    self:addDeaths(1);
    print('deaths:', self:getDeaths());
    if player.components and player.components.ctf_stats then
        local stats = player.components.ctf_stats;
        local attackers = stats:getAttackers();
        if #attackers > 0 then
            local bounty = self:getBounty();
            self:setBounty(CTF_TEAM_CONSTANTS.PLAYER_BOUNTY_INITIAL);

            local killer;
            local assistants = {};
            local assistantCount = 0;

            for i, v in pairs(attackers) do
                if i == 1 then
                    killer = CTFTeamManager:getCTFPlayer(v);
                else
                    local p = CTFTeamManager:getCTFPlayer(v);
                    if p and not assistants[v] then
                        assistants[v] = p;
                        assistantCount = assistantCount + 1;
                    end
                end
            end

            if killer then
                killer:addKills(1);
                killer:setBounty(killer:getBounty() + CTF_TEAM_CONSTANTS.PLAYER_BOUNTY_KILL);

                local killerPlayer = killer:getPlayer();
                if killerPlayer then
                    print('============================= killed by:', killerPlayer);
                    if killerPlayer.components and killerPlayer.components.ctf_stats then
                        local helpers = killerPlayer.components.ctf_stats:getHelpers();
                        for _, v in pairs(helpers) do
                            local p = CTFTeamManager:getCTFPlayer(v);
                            if p and not assistants[v] then
                                assistants[v] = p;
                                assistantCount = assistantCount + 1;
                            end
                        end
                    end

                    local killerBounty = assistantCount == 0 and bounty or math.ceil(bounty * 0.5);
                    inventory.putInInventory(killerPlayer, 'goldnugget', killerBounty);
                    bounty = bounty - killerBounty;
                end
            end

            if assistantCount > 0 then
                local perAssistBounty = math.max(1, math.floor(bounty / assistantCount));
                for _, v in ipairs(assistants) do
                    v:addAssists(1);
                    v:setBounty(v:getBounty() + CTF_TEAM_CONSTANTS.PLAYER_BOUNTY_ASSIST);
                    local assistPlayer = v:getPlayer();
                    if assistPlayer then
                        print('=========================== assisted by:', assistPlayer);
                        inventory.putInInventory(assistPlayer, 'goldnugget', perAssistBounty);
                    end
                end
            end
        end
    end
end

function CTFPlayer:getPlayer()
    return self.net.player.var:value();
end

function CTFPlayer:getUserID()
    return self.net.user_id.var:value();
end

function CTFPlayer:getName()
    return self.net.name.var:value();
end

function CTFPlayer:getTeamID()
    return self.net.team_id.var:value();
end

function CTFPlayer:setTeamID(teamID)
    self.net.team_id.var:set(teamID);
end

function CTFPlayer:getKills()
    return self.net.kills.var:value();
end

function CTFPlayer:addKills(num)
    local v = self:getKills();
    self.net.kills.var:set(v + num);
end

function CTFPlayer:getDeaths()
    return self.net.deaths.var:value();
end

function CTFPlayer:addDeaths(num)
    local v = self:getDeaths();
    self.net.deaths.var:set(v + num);
end

function CTFPlayer:getAssists()
    return self.net.assists.var:value();
end

function CTFPlayer:addAssists(num)
    local v = self:getAssists();
    self.net.assists.var:set(v + num);
end

function CTFPlayer:isReady()
    return self.net.ready.var:value();
end

function CTFPlayer:setReady(ready)
    self.net.ready.var:set(ready);
    if TheWorld.ismastersim then
        CTFTeamManager:playerReadyUpdated(self);
    end
end

function CTFPlayer:getBounty()
    return self.net.bounty.var:value();
end

function CTFPlayer:setBounty(v)
    self.net.bounty.var:set(v);
end

function CTFPlayer.createPlayerNet(player)
    local net = SpawnPrefab('ctf_player_net');

    net.player.var:set(player);
    net.name.var:set(player.name);
    net.user_id.var:set(player.userid);
    net.kills.var:set(0);
    net.deaths.var:set(0);
    net.assists.var:set(0);
    net.bounty.var:set(CTF_TEAM_CONSTANTS.PLAYER_BOUNTY_INITIAL);

    net.bountyTask = net:DoPeriodicTask(CTF_TEAM_CONSTANTS.PLAYER_BOUNTY_PERIOD, function()
        net.bounty.var:set(net.bounty.var:value() + CTF_TEAM_CONSTANTS.PLAYER_BOUNTY_INCREASE);
        print('======================================== bounty hb', net.bounty.var:value());
    end);

    return net;
end
