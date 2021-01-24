modimport('scripts/init/prefab_on_load');
modimport('scripts/init/crafting');
modimport('scripts/init/player');

modimport('scripts/teams/CTFTeamManager');

local function handlePlayerDisconnect(inst, args)
    CTFTeamManager:removePlayer(args.player);
end

AddPrefabPostInit('world', function(world)
    --local OldSpawnAtLocation = world.components.playerspawner.SpawnAtLocation;
    --world.components.playerspawner.SpawnAtLocation = function(inst, player, x, y, z, isloading)
    --    OldSpawnAtLocation(inst, player, x, y, z, isloading);
    --end
    TheWorld:ListenForEvent('ms_playerdisconnected', handlePlayerDisconnect);
end);


