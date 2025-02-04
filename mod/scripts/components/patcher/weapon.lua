---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-04-03 11:33 a.m.
---

local Weapon = require('components/weapon');
local CTFClassPatcher = use('scripts/tools/CTFClassPatcher');

CTFClassPatcher(Weapon, function(self, ctor, inst)
    ctor(self, inst);
    -- weapons can stun anything by default
    self.canStunFn = nil;
end);

function Weapon:CanStun(target)
    if self.canStunFn then
        return self.canStunFn(self.inst, target);
    end
    return true;
end

