local require = _G.require;
local CTF_TEAM_CONSTANTS = require('constants/CTFTeamConstants');

modimport('use');

--modimport('scripts/teams/CTFTeamManager');
--modimport('scripts/teams/CTFTeam');
--modimport('scripts/teams/CTFPlayer');
--
--modimport('scripts/init/screens');
--modimport('scripts/init/assets');
--modimport('scripts/init/prefab_on_load');
--modimport('scripts/init/crafting');
--modimport('scripts/init/crafting_descriptions');
--modimport('scripts/init/loot');
--modimport('scripts/init/food');
--modimport('scripts/init/characters');
--modimport('scripts/init/character_descriptions');
--modimport('scripts/init/player');
--modimport('scripts/init/chat');
--modimport('scripts/init/network');


local function handlePlayerJoined(world, player)
    world:PushEvent(CTF_TEAM_CONSTANTS.PLAYER_CONNECTED_EVENT, player);
end

local function handlePlayerDisconnected(world, args)
    world:PushEvent(CTF_TEAM_CONSTANTS.PLAYER_DISCONNECTED_EVENT, args.player);
    --CTFTeamManager:removePlayer(args.player);
end

local function handlePlayerSpawn(world, player)
    print('========================================== handlePlayerSpawn', player);
    player:ListenForEvent("setowner", function(...)
        print('====================================== setowner', ...);
    end);
end

AddPrefabPostInit('world', function(inst)
    inst:ListenForEvent('ms_playerjoined', handlePlayerJoined);
    inst:ListenForEvent('ms_playerdisconnected', handlePlayerDisconnected);
    inst:ListenForEvent("ms_playerspawn", handlePlayerSpawn);

    ---- check world completeness
    --if inst.ismastersim then
    --    inst:DoTaskInTime(0, function()
    --        local team = CTFTeamManager:getTeamWithLeastPlayers();
    --        if not team then
    --            c_regenerateworld();
    --        end
    --    end);
    --end
end);
