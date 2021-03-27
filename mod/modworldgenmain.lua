GLOBAL.setmetatable(env,{
	__index = function(t,k)
		return GLOBAL.rawget(GLOBAL,k);
	end
});

local Layouts =  require('map/layouts').Layouts
local StaticLayout = require('map/static_layout')
require('constants')
require('map/tasks')
require('map/level')


--Add static_layout. Note that there must be a gate in this, otherwise the map cannot be generated
Layouts['CTFMap'] = StaticLayout.Get('map/static_layouts/test_map_01', {
	start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
	fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
	layout_position = LAYOUT_POSITION.CENTER,
	disable_transform = true,
	defs={
	},
});
	
AddStartLocation('CTFStartLocation', {
    name = STRINGS.UI.SANDBOXMENU.DEFAULTSTART,
    location = 'forest',
    start_setpeice = 'CTFMap',
    start_node = 'Blank',
});

Layouts['CTFBossRushMap'] = StaticLayout.Get('map/static_layouts/boss_rush_01', {
	start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
	fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
	layout_position = LAYOUT_POSITION.CENTER,
	disable_transform = true,
	defs={
	},
});

AddStartLocation('CTFBossRushStartLocation', {
	name = STRINGS.UI.SANDBOXMENU.DEFAULTSTART,
	location = 'forest',
	start_setpeice = 'CTFBossRushMap',
	start_node = 'Blank',
});

AddTask('CTFGenerationTask', {
	locks={},
	keys_given={},
	room_choices={
		--['Forest'] = function() return 1 + math.random(SIZE_VARIATION) end,
		--['BarePlain'] = 1,
		--['Plain'] = function() return 1 + math.random(SIZE_VARIATION) end,
		--['Clearing'] = 1,
		['Blank'] = 1,
	},
	room_bg=GROUND.GRASS,
	--background_room='BGGrass',
	background_room = 'Blank',
	colour={r=0,g=1,b=0,a=1}
});

AddLevel( 'WARSAK_BOSS_RUSH', {
	id = 'BOSS_RUSH',
	name = 'Warsak! - Boss Rush',
	desc = 'Warsak! but the only thing you can do is the boss rush!',
	location = 'forest',
	version = 2,
	overrides = {},
});
	
AddLevelPreInitAny(function(level)
	if level.location ~= 'forest' then
		return
	end

	level.ocean_population = nil
	level.ocean_prefill_setpieces = nil
	level.tasks = {'CTFGenerationTask'}
	level.numoptionaltasks = 0
	level.optionaltasks = {}
	level.valid_start_tasks = nil
	level.set_pieces = {}

	level.random_set_pieces = {}
	level.ordered_story_setpieces = {}
	level.numrandom_set_pieces = 0


	level.overrides.start_location = level.id == 'BOSS_RUSH' and 'CTFBossRushStartLocation' or 'CTFStartLocation'
	level.overrides.keep_disconnected_tiles = true
	level.overrides.roads = 'never'
	level.overrides.birds = 'never'
	level.overrides.has_ocean = true
	level.required_prefabs = {} --Wendy's update fix

	local status, net = pcall(function() return GLOBAL.TheNet end);
	local gameMode = status and net:GetServerGameMode() or 'warsak';
	print('=============================================== gameMode', gameMode);

	local mapFile = true and 'map/static_layouts/boss_rush_01' or 'map/static_layouts/test_map_01';
	print('=============================================== mapFile', mapFile);

	-- Monkey patch BunchSpawnerInit since it's the last function that gets `ents` before the check for a spawn point
	--local OldBunchSpawnerInit = _G.BunchSpawnerInit;
	--_G.BunchSpawnerInit = function(ents, map_width, map_height)
	--	ents.spawnpoint_multiplayer = {{x=ents.ctf_spawn[1].x,y=0,z=ents.ctf_spawn[1].z}};
	--	ents.ctf_spawn = nil;
	--	OldBunchSpawnerInit(ents, map_width, map_height);
	--end
end);
