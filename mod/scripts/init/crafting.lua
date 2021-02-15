---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-01-17 11:52 a.m.
---

local function registerRecipes(content)
    for _, v in ipairs(content) do
        -- AddRecipeTab = function( rec_str, rec_sort, rec_atlas, rec_icon, rec_owner_tag, rec_crafting_station )
        -- WAR =           { str = "WAR",          sort = 5,   icon = "tab_fight.tex" },
        local recipe_tab = AddRecipeTab(
                v.tab,
                v.order,
                nil,
                v.icon,
                v.owner_tag,
                nil
        );

        -- AddRecipe = function(arg1, ...)
        -- Recipe("spear", {Ingredient("twigs", 2), Ingredient("rope", 1), Ingredient("flint", 1) }, RECIPETABS.WAR,  TECH.SCIENCE_ONE)
        -- (name, ingredients, tab, level, placer, min_spacing, nounlock, numtogive, builder_tag, atlas, image)
        for _, vv in ipairs(v.recipes) do
            AddRecipe(vv.prefab, vv.ingredients, recipe_tab, vv.level, vv.placer, vv.spacing, nil, vv.count);
        end
    end
end

local function buildNewCrafting()
    local content = {
		{
            tab = 'Fight',
            order = 1,
            icon = 'tab_fight.tex',
            recipes = {
                {
                    prefab = 'spear',
                    ingredients = { Ingredient('goldnugget', 10) },
                    count = 1
                },
				{
                    prefab = 'boomerang',
                    ingredients = { Ingredient('goldnugget', 15) },
                    level = TECH.SCIENCE_ONE,
                    count = 1
                },
				{
                    prefab = 'whip',
                    ingredients = { Ingredient('goldnugget', 15) },
                    level = TECH.SCIENCE_ONE,
                    count = 1
                },
				{
                    prefab = 'cookiecutterhat',
                    ingredients = { Ingredient('goldnugget', 20) },
                    level = TECH.SCIENCE_ONE,
                    count = 1
                },
				{
                    prefab = 'footballhat',
                    ingredients = { Ingredient('goldnugget', 20) },
                    level = TECH.SCIENCE_ONE,
                    count = 1
                },
				{
                    prefab = 'armorwood',
                    ingredients = { Ingredient('goldnugget', 20) },
                    level = TECH.SCIENCE_ONE,
                    count = 1
                },
				{
                    prefab = 'tentaclespike',
                    ingredients = { Ingredient('goldnugget', 10), Ingredient('spear', 1) },
                    level = TECH.SCIENCE_ONE,
                    count = 1
                },
				{
                    prefab = 'spear_wathgrithr',
                    ingredients = { Ingredient('goldnugget', 10), Ingredient('spear', 1) },
                    level = TECH.SCIENCE_ONE,
                    count = 1
                },
				{
                    prefab = 'hambat',
                    ingredients = { Ingredient('goldnugget', 15), Ingredient('spear_wathgrithr', 1) },
                    level = TECH.SCIENCE_ONE,
                    count = 1
                },
				{
                    prefab = 'wathgrithrhat',
                    ingredients = { Ingredient('goldnugget', 20), Ingredient('footballhat', 1) },
                    level = TECH.SCIENCE_ONE,
                    count = 1
                },
				{
                    prefab = 'armormarble',
                    ingredients = { Ingredient('goldnugget', 20), Ingredient('armorwood', 1) },
                    level = TECH.SCIENCE_ONE,
                    count = 1
                },
            }
        },
		{
            tab = 'Food',
            order = -1,
            icon = 'tab_farm.tex',
            recipes = {
                {
                    prefab = 'jellybean',
                    ingredients = { Ingredient('goldnugget', 4) },
                    count = 1
                },
				{
                    prefab = 'cookedmeat',
                    ingredients = { Ingredient('goldnugget', 2) },
                    level = TECH.SCIENCE_ONE,
                    count = 1
                },
				{
                    prefab = 'bird_egg_cooked',
                    ingredients = { Ingredient('goldnugget', 1) },
                    level = TECH.SCIENCE_ONE,
                    count = 1
                },
				{
                    prefab = 'dragonfruit_cooked',
                    ingredients = { Ingredient('goldnugget', 3) },
                    level = TECH.SCIENCE_ONE,
                    count = 1
                },
				{
                    prefab = 'potato_cooked',
                    ingredients = { Ingredient('goldnugget', 3) },
                    level = TECH.SCIENCE_ONE,
                    count = 1
                },
				{
                    prefab = 'garlic_cooked',
                    ingredients = { Ingredient('goldnugget', 1) },
                    level = TECH.SCIENCE_ONE,
                    count = 1
                },
				{
                    prefab = 'carrot_cooked',
                    ingredients = { Ingredient('goldnugget', 1) },
                    level = TECH.SCIENCE_ONE,
                    count = 1
                },
				{
                    prefab = 'butterflywings',
                    ingredients = { Ingredient('goldnugget', 2) },
                    level = TECH.SCIENCE_ONE,
                    count = 1
                },
				{
                    prefab = 'honey',
                    ingredients = { Ingredient('goldnugget', 1) },
                    level = TECH.SCIENCE_ONE,
                    count = 1
                },
            }
        },
		{
            tab = 'Slingshot',
            order = 10,
            icon = 'tab_slingshot.tex',
			owner_tag = 'pebblemaker',
            recipes = {
                {
                    prefab = 'slingshot',
                    ingredients = { Ingredient('goldnugget', 10) },
                    count = 1
                },
				{
                    prefab = 'slingshotammo_rock',
                    ingredients = { Ingredient('goldnugget', 2) },
                    count = 5
                },
				{
                    prefab = 'slingshotammo_gold',
                    ingredients = { Ingredient('goldnugget', 4) },
                    count = 5
                },
				{
                    prefab = 'slingshotammo_marble',
                    ingredients = { Ingredient('goldnugget', 10) },
                    count = 5
                },
				{
                    prefab = 'slingshotammo_freeze',
                    ingredients = { Ingredient('goldnugget', 10) },
                    count = 5
                },
				{
                    prefab = 'slingshotammo_slow',
                    ingredients = { Ingredient('goldnugget', 10) },
                    count = 5
                },
				{
                    prefab = 'slingshotammo_thulecite',
                    ingredients = { Ingredient('goldnugget', 5), Ingredient('slingshotammo_marble', 5) },
                    count = 10
                },
			}
		},
		{
            tab = 'Green Thumb',
            order = 10,
            icon = 'tab_nature.tex',
			owner_tag = 'plantkin',
            recipes = {
                {
                    prefab = 'armor_bramble',
                    ingredients = { Ingredient('goldnugget', 15), Ingredient('armorwood', 1) },
                    count = 1
                },
				{
                    prefab = 'trap_bramble',
                    ingredients = { Ingredient('goldnugget', 15) },
                    count = 1
                },
				{
                    prefab = 'compostwrap',
                    ingredients = { Ingredient('goldnugget', 5), Ingredient('dragonfruit_cooked', 1) },
                    count = 1
                },
			}
		},
		{
            tab = 'Books',
            order = 10,
            icon = 'tab_book.tex',
			owner_tag = 'bookbuilder',
            recipes = {
                {
                    prefab = 'book_silviculture',
                    ingredients = { Ingredient('goldnugget', 35), Ingredient('tallbirdegg', 1) },
                    count = 1
                },
			}
		},
		{
            tab = 'Idols',
            order = 10,
            icon = 'tab_arcane.tex',
			owner_tag = 'werehuman',
            recipes = {
                {
                    prefab = 'wereitem_moose',
                    ingredients = { Ingredient('goldnugget', 50), Ingredient('tallbirdegg', 1) },
                    count = 1
                },
			}
		},
		{
            tab = 'Engineering ',
            order = 10,
            icon = 'tab_engineering.tex',
			owner_tag = 'handyperson',
            recipes = {
                {
                    prefab = 'winona_catapult',
                    ingredients = { Ingredient('goldnugget', 20), Ingredient('boomerang', 1) },
                    count = 1,
                    placer = 'winona_catapult_placer',
                    spacing = TUNING.WINONA_ENGINEERING_SPACING,
                },
                {
                    prefab = 'winona_battery_high',
                    ingredients = { Ingredient('goldnugget', 30) },
                    count = 1,
                    placer = 'winona_battery_high_placer',
                    spacing = TUNING.WINONA_ENGINEERING_SPACING,
                },
                {
                    prefab = 'bluegem',
                    ingredients = { Ingredient('goldnugget', 10) },
                    count = 1,
                },
			}
		},
		{
            tab = 'Seasonings',
            order = 10,
            icon = 'tab_foodprocessing.tex',
			owner_tag = 'masterchef',
            recipes = {
                {
                    prefab = 'portablecookpot_item',
                    ingredients = { Ingredient('goldnugget', 20) },
                    count = 1
                },
				{
                    prefab = 'portablespicer_item',
                    ingredients = { Ingredient('goldnugget', 20) },
                    count = 1
                },
				{
                    prefab = 'spice_garlic',
                    ingredients = { Ingredient('goldnugget', 5) },
                    count = 1
                },
				{
                    prefab = 'spice_chili',
                    ingredients = { Ingredient('goldnugget', 5) },
                    count = 1
                },
				{
                    prefab = 'spice_salt',
                    ingredients = { Ingredient('goldnugget', 5) },
                    count = 1
                },
			}
		},
    }

    registerRecipes(content);
end

AddPrefabPostInit('world', function()
    RemoveAllRecipes();
    buildNewCrafting();
end);
