---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-01-23 4:49 p.m.
---
local require = _G.require;
local CTF_TEAM_CONSTANTS = require('constants/CTFTeamConstants');

CTFPrefabPatcher:registerPrefabPatcher('wall_ruins_2', function(inst, data)
    if TheWorld.ismastersim then
        if data.ctf_team then
            if inst.components and inst.components.combat then
                local OldGetAttacked = inst.components.combat.GetAttacked;
                inst.components.combat.GetAttacked = function(self, attacker, damage, weapon, stimuli)
                    if weapon and weapon:HasTag('projectile') then
                        damage = 0;
                    end
                    return OldGetAttacked(self, attacker, damage, weapon, stimuli);
                end
            end
            CTFTeamManager:registerTeamObject(inst, data);
        end
    end
end)
