---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-03-06 4:27 p.m.
---

AddPrefabPostInit('tallbirdnest', function(inst)
    if inst.components and inst.components.childspawner then
        inst.components.childspawner:SetRegenPeriod(TUNING.TOTAL_DAY_TIME * 3.5);
    end
end);
