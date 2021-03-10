modimport('use');

modimport('scripts/teams/CTFTeamManager');
modimport('scripts/teams/CTFTeam');
modimport('scripts/teams/CTFPlayer');
--
modimport('scripts/init/screens');
modimport('scripts/init/assets');
modimport('scripts/init/prefab_on_load');
modimport('scripts/init/crafting');
modimport('scripts/init/crafting_descriptions');
modimport('scripts/init/loot');
modimport('scripts/init/food');
modimport('scripts/init/characters');
modimport('scripts/init/character_descriptions');
modimport('scripts/init/player');
modimport('scripts/init/chat');
modimport('scripts/init/network');
modimport('scripts/init/actions');


AddPrefabPostInit('world', function(inst)
    ---- check world completeness
    if inst.ismastersim then
        inst:DoTaskInTime(0, function()
            local team = CTFTeamManager:getTeamWithLeastPlayers();
            if not team then
                c_regenerateworld();
            end
        end);
    end
end);

GLOBAL.ctf_freecrafting = function()
    for _, player in ipairs(AllPlayers) do
        player.components.builder:GiveAllRecipes();
        player:PushEvent('techlevelchange');
    end
end
