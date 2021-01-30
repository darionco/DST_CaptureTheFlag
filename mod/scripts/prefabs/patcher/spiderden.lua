---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-01-17 1:43 p.m.
---
local require = _G.require;
local CTF_CONSTANTS = require('teams/CTFTeamConstants');

local patchSetStageFunctions = function(inst)
    local OldSetSmall = inst.SetSmall;
    inst.SetSmall = function(den)
        OldSetSmall(den);
        den.components.lootdropper:SetLoot({'goldnugget', 'goldnugget'});
    end

    local OldSetMedium = inst.SetMedium;
    inst.SetMedium = function(den)
        OldSetMedium(den);
        den.components.lootdropper:SetLoot({'goldnugget', 'goldnugget', 'goldnugget', 'goldnugget'});
    end

    local OldSetLarge = inst.SetLarge;
    inst.SetLarge = function(den)
        OldSetLarge(den);
        den.components.lootdropper:SetLoot({'goldnugget', 'goldnugget', 'goldnugget', 'goldnugget', 'goldnugget', 'goldnugget'});
    end
end

local patchDefaultLoot = function(inst)
    if inst.data then
        if inst.data.stage == 1 then
            inst.components.lootdropper:SetLoot({'goldnugget', 'goldnugget'});
        elseif inst.data.stage == 2 then
            inst.components.lootdropper:SetLoot({'goldnugget', 'goldnugget', 'goldnugget', 'goldnugget'});
        elseif inst.data.stage == 3 then                inst.components.lootdropper:SetLoot({'goldnugget', 'goldnugget', 'goldnugget', 'goldnugget', 'goldnugget', 'goldnugget'});
        end
    end
end

CTFPrefabPatcher:registerPrefabPatcher('spiderden', function(inst, data)
    if TheWorld.ismastersim then
        patchSetStageFunctions(inst);
        patchDefaultLoot(inst);

        if data.ctf_team then
            TheWorld:ListenForEvent(CTF_CONSTANTS.PLAYER_CONNECTED_EVENT, function()
                CTFTeamManager:registerTeamObject(inst, data);
            end);
        end
    end
end);
