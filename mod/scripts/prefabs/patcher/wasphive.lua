---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-01-17 1:11 p.m.
---
local require = _G.require;
local CTF_CONSTANTS = require('teams/CTFTeamConstants');

CTFPrefabPatcher:registerPrefabPatcher('wasphive', function(inst, data)
    if TheWorld.ismastersim then
        inst.components.lootdropper:SetLoot({'goldnugget', 'goldnugget', 'goldnugget', 'goldnugget'});
        if data.ctf_team then
            TheWorld:ListenForEvent(CTF_CONSTANTS.PLAYER_CONNECTED_EVENT, function()
                CTFTeamManager:registerTeamObject(inst, data);
            end);
        end
    end
end)
