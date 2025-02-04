---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-01-23 5:10 p.m.
---
local require = _G.require;
local clockwork_common = require('prefabs/clockwork_common');
local CTFTeamCombat = require('teams/CTFTeamCombat');

local OldOnAttacked = clockwork_common.OnAttacked;
clockwork_common.OnAttacked = function(inst, data)
    local currentTarget = inst.components.combat.target;
    if not currentTarget or not currentTarget:IsValid() or currentTarget.components.health:IsDead() then
        if data ~= nil and data.attacker and data.attacker:HasTag('player') then
            local retarget = inst.components.combat.targetfn(inst);
            if retarget and not retarget:HasTag('player') then
                inst.components.combat:SetTarget(retarget);
                return;
            end
        end
        OldOnAttacked(inst, data);
    end
end

AddPrefabPostInit('bishop_charge', function(inst)
    if inst.components and inst.components.projectile then
        inst.components.projectile:SetHoming(true);
    end
end);

CTFPrefabPatcher:registerPrefabPatcher('bishop_nightmare', function(inst, data)
    if TheWorld.ismastersim then
        CTFPrefabPatcher:patchStats(inst, data);

        if inst.components then
            if inst.components.sleeper then
                inst.components.sleeper:SetSleepTest(function() return false end);
            end

            if inst.components.combat then
                inst.components.combat:SetRetargetFunction(0.25, function(self)
                    if self.data and self.data.ctf_team_tag then
                        local range = TUNING.BISHOP_TARGET_DIST;
                        local homePos = self.components.knownlocations:GetLocation("home")
                        if (
                                homePos ~= nil and
                                        self:GetDistanceSqToPoint(homePos:Get()) >= range * range and
                                        (self.components.follower == nil or self.components.follower.leader == nil)
                        ) then
                            return nil;
                        end
                        return CTFTeamCombat.findEnemy(self, range, self.data.ctf_team_tag);
                    end
                    return nil;
                end);
            end

            if inst.components.freezable then
                inst.components.freezable:SetResistance(5);
                inst.components.freezable:SetDefaultWearOffTime(5);
            end
        end

        if data.ctf_team then
            CTFTeamManager:registerTeamObject(inst, data);
        end
    end
end)
