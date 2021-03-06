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

AddPrefabPostInit('ctf_player_net', function(inst)
    if not TheWorld.ismastersim then
        inst:ListenForEvent(inst.user_id.event, function()
            CTFPlayer(inst);
        end);
    end
end);

CTFPlayer = Class(function(self, net)
    print('======================================== CTFPlayer', net, net.user_id.var:value());
    -- this is supposed to run on both server and client
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
end

function CTFPlayer:initMaster()
    local player = self:getPlayer();
    if player then
        player:SpawnChild('ctf_team_marker');

        print('======================================== CTFPlayer:initMaster', player);
        inventory.removeAllItems(player);
        inventory.initializeInventory(player);

        local function OnPlayerSpawned(f_player)
            print('======================================== OnPlayerSpawned', f_player);
            f_player:RemoveEventCallback('colourtweener_end', OnPlayerSpawned);
            self.net.spawned.var:push();
        end
        player:ListenForEvent('colourtweener_end', OnPlayerSpawned);
    end
end

function CTFPlayer:initNet()
    if not TheNet:IsDedicated() then
        print('======================================== initNet');
        self:initNetEvents();
    end
end

function CTFPlayer:initNetEvents()
    print('======================================== initNetEvents');
    self.net:ListenForEvent(self.net.spawned.event, function() self:netHandleSpawnedEvent() end);
    self.net:ListenForEvent(self.net.player.event, function()
        print('=========================================== new player:', self:getPlayer());
    end);
end

function CTFPlayer:netHandleSpawnedEvent()
    print('======================================== netHandleSpawnedEvent');
    local player = self:getPlayer();
    if player and player == ThePlayer then
        ShowWelcomeScreen(function()
            SendModRPCToServer(MOD_RPC[CTF_TEAM_CONSTANTS.RPC_NAMESPACE][CTF_TEAM_CONSTANTS.RPC.PLAYER_JOINED_CTF]);
        end);
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

function CTFPlayer:isReady()
    return self.net.ready.var:value();
end

function CTFPlayer:setReady(ready)
    self.net.ready.var:set(ready);
    if TheWorld.ismastersim then
        CTFTeamManager:playerReadyUpdated(self);
    end
end

function CTFPlayer.createPlayerNet(player)
    print('=================================================== createPlayerNet', player);
    local net = SpawnPrefab('ctf_player_net');

    net.player.var:set(player);
    net.name.var:set(player.name);
    net.user_id.var:set(player.userid);

    return net;
end
