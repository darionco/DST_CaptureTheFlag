---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-01-23 5:10 p.m.
---

modimport('scripts/prefabs/patcher/CTFPrefabPatcher');
modimport('scripts/teams/CTFTeamManager');

CTFPrefabPatcher:registerPrefabPatcher('bishop', function(inst, data)
    if TheWorld.ismastersim then
        inst.components.lootdropper.chanceloottable = false;
        inst.components.lootdropper:SetLoot({'goldnugget', 'goldnugget', 'goldnugget', 'goldnugget', 'goldnugget'});

        if inst.components then
            if inst.components.health then
                inst.components.health:SetMaxHealth(800);
                inst.components.health:SetAbsorptionAmountFromPlayer(0.5);
            end

            if inst.components.combat then
                inst.components.combat:SetAttackPeriod(1.1);
                inst.components.combat:SetRange(8);
                inst.components.combat:SetDefaultDamage(100);
            end

            if inst.components.inventory then
                local weapon = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS);
                if weapon then
                    weapon.components.weapon:SetDamage(90);
                    weapon.components.weapon:SetRange(8, 14);
                end
            end
        end

        if data.ctf_team then
            CTFTeamManager:registerTeamObject(inst, data);
        end
    end
end)
