---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-03-31 5:22 p.m.
---

local CTFClassPatcher = use('scripts/tools/CTFClassPatcher');
local CTFInit = use('scripts/tools/CTFInit');

local function common_post_init(inst)

end

local function master_post_init(inst)
    inst:AddComponent('pvp_stun_resistance');
end

CTFInit:AllCharacters(common_post_init, master_post_init);

local function canWeaponStun(inst, weapon)
    return not weapon or not weapon.components or not weapon.components.weapon or weapon.components.weapon:CanStun(inst);
end

local function canInstBeStunned(inst)
    return not inst.components or not inst.components.pvp_stun_resistance or inst.components.pvp_stun_resistance:canBeStunned();
end

-- patch stunlock
CTFClassPatcher(_G.EventHandler, function(self, ctor, name, fn)
    if name == 'attacked' then
        local new_fn = function(inst, data)
            -- check if the target should be stunned
            local stun = canWeaponStun(inst, data.weapon) and canInstBeStunned(inst);
            -- if the target is a player and the attacker has a combat component, use the system to handle the stunlock
            if inst:HasTag('player') and data.attacker.components and data.attacker.components.combat then
                if stun then
                    data.attacker.components.combat.playerstunlock =  PLAYERSTUNLOCK.ALWAYS;
                else
                    data.attacker.components.combat.playerstunlock = PLAYERSTUNLOCK.NEVER;
                end
                fn(inst, data);
            elseif stun then
                fn(inst, data);
            end
        end
        ctor(self, name, new_fn);
    else
        ctor(self, name, fn);
    end
end);
