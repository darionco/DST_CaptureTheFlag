---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-01-16 4:57 p.m.
---
modimport('scripts/prefabs/patcher/CTFPrefabPatcher');

modimport('scripts/prefabs/patcher/piggyback');
modimport('scripts/prefabs/patcher/killerbee');
modimport('scripts/prefabs/patcher/wasphive');
modimport('scripts/prefabs/patcher/spider');
modimport('scripts/prefabs/patcher/spider_warrior');
modimport('scripts/prefabs/patcher/spiderden');
modimport('scripts/prefabs/patcher/mushroom_light');
modimport('scripts/prefabs/patcher/multiplayer_portal');
modimport('scripts/prefabs/patcher/wall_ruins_2');
modimport('scripts/prefabs/patcher/pigtorch');
modimport('scripts/prefabs/patcher/bishop_nightmare');
modimport('scripts/prefabs/patcher/pigguard');
modimport('scripts/prefabs/patcher/skeleton_player');
modimport('scripts/prefabs/patcher/tallbirdnest');
modimport('scripts/prefabs/patcher/wormhole');
modimport('scripts/prefabs/patcher/abigail');
modimport('scripts/prefabs/patcher/poop');
modimport('scripts/prefabs/patcher/armor_skeleton');
modimport('scripts/prefabs/patcher/moose_nesting_ground');
modimport('scripts/prefabs/patcher/archive_portal');
modimport('scripts/prefabs/patcher/lighter');

--modimport('scripts/teams/CTFTeamManager');
--
--AddPrefabPostInitAny(function(instance)
--    if (instance.OnLoad) then
--        local OldOnLoad = instance.OnLoad;
--        instance.OnLoad = function(inst, data)
--            if data and data.ctf_team then
--                print(inst.prefab, 'CTF_TEAM', data.ctf_team);
--                CTFTeamManager:registerTeamObject(inst, data);
--            end
--            OldOnLoad(inst, data);
--        end
--    end
--end)
