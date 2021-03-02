---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-01-23 5:14 p.m.
---

local require = GLOBAL.require;
local CTF_TEAM_CONSTANTS = require('constants/CTFTeamConstants');
local CTFTeamCombat = require('teams/CTFTeamCombat');

AddPrefabPostInit('pigguard', function(inst)
    if TheWorld.ismastersim then
        local OldRetargetFunction = inst.components.combat.targetfn;
        inst.components.combat:SetRetargetFunction(0.1, function(self)
            if self:HasTag(CTF_TEAM_CONSTANTS.TEAM_MINION_TAG) then
                local radius = self.components.knownlocations:GetLocation("investigate") ~= nil and TUNING.SPIDER_INVESTIGATETARGET_DIST or TUNING.SPIDER_TARGET_DIST;
                return CTFTeamCombat.findEnemy(self, SpringCombatMod(radius), self.data.ctf_team_tag);
            end
            return OldRetargetFunction(self);
        end)
    end
end);
