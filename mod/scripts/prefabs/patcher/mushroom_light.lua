---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-01-17 6:23 p.m.
---

AddPrefabPostInit('mushroom_light', function(inst)
    if TheWorld.ismastersim then
        --inst.Light:Enable(true);
        inst.components.container:GiveItem(SpawnPrefab('lightbulb'));
        inst.components.container:GiveItem(SpawnPrefab('lightbulb'));
        inst.components.container:GiveItem(SpawnPrefab('lightbulb'));
        inst.components.container:GiveItem(SpawnPrefab('lightbulb'));
    end
end);
