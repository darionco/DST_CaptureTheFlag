---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-01-16 6:49 p.m.
---

CTFPrefabPatcher = {};

function CTFPrefabPatcher:patchStats(inst, data)
    if data and inst.components then
        if inst.components.health then
            if data.ctf_health ~= nil then
                inst.components.health:SetMaxHealth(data.ctf_health);
            end

            if data.ctf_armour ~= nil then
                inst.components.health:SetAbsorptionAmount(data.ctf_armour);
            end

            if data.ctf_armour_player ~= nil then
                inst.components.health:SetAbsorptionAmountFromPlayer(data.ctf_armour_player);
            end
        end

        if inst.components.combat then
            if data.ctf_attack_speed ~= nil then
                inst.components.combat:SetAttackPeriod(data.ctf_attack_speed);
            end

            if data.ctf_attack_range_min ~= nil then
                inst.components.combat:SetRange(data.ctf_attack_range_min);
            end

            if data.ctf_attack_damage ~= nil then
                inst.components.combat:SetDefaultDamage(data.ctf_attack_damage);
            end
        end

        if inst.components.inventory then
            local weapon = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS);
            if weapon then
                if data.ctf_attack_damage ~= nil then
                    weapon.components.weapon:SetDamage(data.ctf_attack_damage);
                end

                if data.ctf_attack_range_min ~= nil and data.ctf_attack_range_max ~= nil then
                    weapon.components.weapon:SetRange(data.ctf_attack_range_min, data.ctf_attack_range_max);
                end
            end
        end

        if inst.components.locomotor then
            if data.ctf_movement_speed ~= nil then
                inst.components.locomotor.walkspeed = data.ctf_movement_speed;
            end
        end
    end
end

function CTFPrefabPatcher:registerPrefabPatcher(prefab, patcher)
    AddPrefabPostInit(prefab, function(instance)
        local OldOnLoad = instance.OnLoad or nil;
        instance.OnLoad = function(inst, data)
            if data and data.ctf_team then
                --print(inst.prefab, 'CTF_TEAM', data.ctf_team);
                -- CTFTeamManager:registerTeamObject(inst, data);
                patcher(inst, data);
            end
            if OldOnLoad ~= nil then
                OldOnLoad(inst, data);
            end
        end
    end);
end
