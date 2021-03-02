local require = _G.require;
local CTF_TEAM_CONSTANTS = require('constants/CTFTeamConstants');

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
modimport('scripts/teams/CTFTeamManager');


local function handlePlayerJoined(_, player)
    TheWorld:PushEvent(CTF_TEAM_CONSTANTS.PLAYER_CONNECTED_EVENT, player);
end

local function handlePlayerDisconnected(_, args)
    TheWorld:PushEvent(CTF_TEAM_CONSTANTS.PLAYER_DISCONNECTED_EVENT, args.player);
    CTFTeamManager:removePlayer(args.player);
end

AddPrefabPostInit('world', function(world)
    --local OldSpawnAtLocation = world.components.playerspawner.SpawnAtLocation;
    --world.components.playerspawner.SpawnAtLocation = function(inst, player, x, y, z, isloading)
    --    OldSpawnAtLocation(inst, player, x, y, z, isloading);
    --end
    TheWorld:ListenForEvent('ms_playerjoined', handlePlayerJoined);
    TheWorld:ListenForEvent('ms_playerdisconnected', handlePlayerDisconnected);
end);

AddPrefabPostInit('forest_network', function(inst)
    CTFTeamManager:registerNetEvents(inst);
end);


