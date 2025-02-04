---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-03-31 4:50 p.m.
---

local CTF_TEAM_CONSTANTS = require('constants/CTFTeamConstants');

local PVPStunResistance = Class(function(self, inst)
    self.inst = inst;

    self.value = 0;
    self.multiplier = CTF_TEAM_CONSTANTS.PLAYER_STUN_RESISTANCE;
    self.cooldown = CTF_TEAM_CONSTANTS.PLAYER_STUN_RESISTANCE_COOLDOWN;
    self.cooldownTask = nil;

    self.inst:ListenForEvent('healthdelta', function(_, data) self:handleHealthDelta(data) end);
end);

function PVPStunResistance:handleHealthDelta(data)
    if data and data.amount and data.amount < 0 then
        if self.cooldownTask then
            self.cooldownTask:Cancel();
        end

        self.cooldownTask = self.inst:DoTaskInTime(self.cooldown, function()
            self.cooldownTask = nil;
            self.value = 0;
        end);

        -- schedule the increase in value to the next loop so the initial value is counted rather than the end value
        self.inst:DoTaskInTime(0, function()
            self.value = self.value - data.amount; -- this increases the value
        end);
    end
end

function PVPStunResistance:getMaxValue()
    return self.inst.components and self.inst.components.health and self.inst.components.health.maxhealth * self.multiplier or 0;
end

function PVPStunResistance:canBeStunned()
    return self.value >= self:getMaxValue();
end

return PVPStunResistance;
