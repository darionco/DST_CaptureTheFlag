---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-02-07 10:28 p.m.
---

local require = _G.require;
local CTF_CONSTANTS = require('teams/CTFTeamConstants');
local wortox_soul_common = require("prefabs/wortox_soul_common");

wortox_soul_common.HasSoul = function(victim)
    return
        victim.components and
        victim.components.combat and
        victim.components.combat.lastattacker and
        victim.components.combat.lastattacker.prefab == 'wortox' and
        (
            victim:HasTag(CTF_CONSTANTS.TEAM_PLAYER_TAG) or
            victim.prefab == 'wasphive' or
            victim.prefab == 'pigguard'
        );
end;

local function PatchSpecialActions(inst)
    if inst.components.playeractionpicker ~= nil and inst.components.playeractionpicker.pointspecialactionsfn ~= nil then
        local OldFunction = inst.components.playeractionpicker.pointspecialactionsfn;
        inst.components.playeractionpicker.pointspecialactionsfn = function(f_inst, pos, useitem, right)
            if f_inst.components and f_inst.components.inventory then
                local item = f_inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.BODY);
                if item ~= nil and item:HasTag(CTF_CONSTANTS.TEAM_FLAG_TAG) then
                    return {};
                end
            end
            return OldFunction(f_inst, pos, useitem, right);
        end
    end
end

AddPrefabPostInit('wortox', function(inst)
    inst.nosoultask = true;

    PatchSpecialActions(inst);
    inst:ListenForEvent("setowner", PatchSpecialActions);
end);
