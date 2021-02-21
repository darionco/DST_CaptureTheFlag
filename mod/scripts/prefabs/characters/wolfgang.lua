---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-02-14 12:20 a.m.
---

TUNING.WOLFGANG_ATTACKMULT_NORMAL = 1;
TUNING.WOLFGANG_ATTACKMULT_MIGHTY_MIN = 1;
TUNING.WOLFGANG_ATTACKMULT_MIGHTY_MAX = 1;

local WOLFGANG_HUNGER_THRESHOLD = 100;

local WOLFGANG_DAMAGE_ABSORPTION_MIN = 0.8;
local WOLFGANG_DAMAGE_ABSORPTION_MAX = 1.6;

local WOLFGANG_WALK_SPEED_MULT_MIN = 0.6;
local WOLFGANG_WALK_SPEED_MULT_MAX = 1.0;

local WOLFGANG_SPAWN_HUNGER = 200;

AddPrefabPostInit('wolfgang', function(inst)
    if inst.data == nil then
        inst.data = {};
    end
    inst.data.ctf_spawnHunger = WOLFGANG_SPAWN_HUNGER;

    local OldApplyScale = inst.ApplyScale;
    inst.ApplyScale = function(f_inst, source, scale)
        OldApplyScale(f_inst, source, scale);
        if f_inst.components and f_inst.components.locomotor then
            if scale > 1 then
                f_inst.components.locomotor:SetExternalSpeedMultiplier(f_inst, 'ctf_anti_mightiness', 1 / scale);
            else
                f_inst.components.locomotor:RemoveExternalSpeedMultiplier(f_inst, 'ctf_anti_mightiness');
            end
        end
    end

    if inst.components and inst.components.health and inst.components.hunger then
        local hungerDomain = inst.components.hunger.max - WOLFGANG_HUNGER_THRESHOLD;

        local absorptionDomain = WOLFGANG_DAMAGE_ABSORPTION_MAX - WOLFGANG_DAMAGE_ABSORPTION_MIN;
        local OldDoDelta = inst.components.health.DoDelta;
        inst.components.health.DoDelta = function (self, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
            local hungerMult = math.max(0, inst.components.hunger.current - WOLFGANG_HUNGER_THRESHOLD) / hungerDomain;
            local absorption = WOLFGANG_DAMAGE_ABSORPTION_MIN + hungerMult * absorptionDomain;
            local absorptionMult = 2.0 - absorption;
            amount = amount * absorptionMult;
            return OldDoDelta(self, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb);
        end

        local walkSpeedDomain = WOLFGANG_WALK_SPEED_MULT_MAX - WOLFGANG_WALK_SPEED_MULT_MIN;
        inst:ListenForEvent('hungerdelta', function(f_inst, data, forcesilent)
            local hungerMult = math.max(0, f_inst.components.hunger.current - WOLFGANG_HUNGER_THRESHOLD) / hungerDomain;
            local speedMult = WOLFGANG_WALK_SPEED_MULT_MAX - walkSpeedDomain * hungerMult;
            f_inst.components.locomotor:SetExternalSpeedMultiplier(f_inst, 'ctf_mightiness_slowdown', speedMult);
        end);
    end
end);
