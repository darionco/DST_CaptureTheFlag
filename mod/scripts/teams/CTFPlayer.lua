---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-03-05 9:39 a.m.
---
local require = _G.require;
local inventory = require('init/player_inventory');
local ShowWelcomeScreen = require('screens/CTFInstructionsPopup');
local CTF_TEAM_CONSTANTS = require('constants/CTFTeamConstants');
local CTFTeamMarker = use('scripts/teams/CTFTeamMarker');

CTFPlayer = Class(function(self, player, userid)
    print('======================================== CTFPlayer');
    -- this is supposed to run on both server and client
    self.player = player; -- only available in master
    self.userid = userid;
    self.net = self:createPlayerNet(CTFTeamManager.net, player.userid);

    self:initNet();
    self:initCommon();
    if TheWorld.ismastersim and self.player then
        self:initMaster();
    end
end);

function CTFPlayer:kill()
    print('============================================ CTFPlayer:kill');
end

function CTFPlayer:initCommon()
    CTFTeamManager:registerCTFPlayer(self);
end

function CTFPlayer:initMaster()
    local player = self.player;
    print('======================================== CTFPlayer:initMaster', player);
    inventory.removeAllItems(player);
    inventory.initializeInventory(player);

    local function OnPlayerSpawned(f_player)
        print('======================================== OnPlayerSpawned', f_player);
        f_player:RemoveEventCallback('colourtweener_end', OnPlayerSpawned);
        self.net.spawn_event.var:push();
    end
    player:ListenForEvent('colourtweener_end', OnPlayerSpawned);
end

function CTFPlayer:initNet()
    if not TheNet:IsDedicated() then
        self.player:DoTaskInTime(0, function ()
            print('======================================== initNet');
            self:initNetEvents();
        end);
    end
end

function CTFPlayer:initNetEvents()
    print('======================================== initNetEvents');
    if self.player == _G.ThePlayer then
        print('======================================== _G.ThePlayer');
        self.net.inst:ListenForEvent(self.net.spawn_event.event, function() self:netHandleSpawnedEvent() end);
        --self.player:DoTaskInTime(5, function() self:netHandleSpawnedEvent() end);
    end
end

function CTFPlayer:netHandleSpawnedEvent()
    print('======================================== netHandleSpawnedEvent');
    ShowWelcomeScreen(function()
        SendModRPCToServer(MOD_RPC[CTF_TEAM_CONSTANTS.RPC_NAMESPACE][CTF_TEAM_CONSTANTS.RPC.PLAYER_JOINED_CTF]);
    end);
end

function CTFPlayer:getTeamID()
    return self.net.team_id.var:value();
end

function CTFPlayer:setTeamID(teamID)
    self.net.team_id.var:set(teamID);
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

function CTFPlayer:createPlayerNet(inst, userid)
    print('=================================================== addPlayerNetVars', userid);
    local spawn_event_key = 'ctf_spawn_event.' .. userid;
    local team_id_key = 'ctf_team_id.' .. userid;
    local ready_key = 'ctf_ready.' .. userid;

    local ret = {
        inst = inst,
        spawn_event = { var = net_event(inst.GUID, spawn_event_key), event = spawn_event_key },
        team_id = { var = net_tinybyte(inst.GUID, team_id_key, team_id_key), event = team_id_key },
        ready = { var = net_bool(inst.GUID, ready_key, ready_key), event = ready_key },
    };

    ret.team_id.var:set(0);
    ret.ready.var:set(false);

    return ret;
end
