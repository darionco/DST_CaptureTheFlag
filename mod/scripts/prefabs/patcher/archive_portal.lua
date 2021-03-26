---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-03-20 2:43 p.m.
---

local require = _G.require;
local CTFBossFight = require('bossfight/CTFBossFight');

CTFPrefabPatcher:registerPrefabPatcher('archive_portal', function(inst, data)
    if data.ctf_boss_spawner then
        CTFBossFight:registerSpawner(inst, data.ctf_boss_spawner);
    end
end);
