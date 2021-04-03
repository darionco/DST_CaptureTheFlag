---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-04-02 7:46 p.m.
---

local CTF_ARMOUR = {
    -- SUITS
    armorgrass = {
        durability = 120,
        absorption = 0.25,
        walkspeedmult = 0.05,
    },

    armorwood = {
        durability = 150,
        absorption = 0.4,
    },

    armor_sanity = {
        durability = 200,
        absorption = 0.5,
        aoe_damage = 2,
        aoe_damage_radius = 1.5,
        aoe_damage_period = 2,
    },

    -- skeleton armour doesn't have standard durability or absorption
    armorskeleton = {
        aoe_damage = 5,
        aoe_damage_radius = 2,
    },

    armorsnurtleshell = {
        durability = 400,
        absorption = 0.5,
    },

    armorruins = {
        durability = 600,
        absorption = 0.57,
        tentacle_chance = 0.1,
    },

    armordragonfly = {
        durability = 800,
        absorption = 0.6,
        raw_damage_multiplier = 0.0,
    },

    armormarble = {
        durability = 1200,
        absorption = 0.7,
    },

    armor_bramble = {
        key = 'armorbramble',
        durability = 300,
        absorption = 0.55,
    },

    -- HATS
    beehat = {
        durability = 80,
        absorption = 0.1,
        bee_absorption_mult = 6.0,
    },

    hivehat = {
        durability = 150,
        absorption = 0.25,
    },

    slurtlehat = {
        durability = 200,
        absorption = 0.4,
        costume_slow_duration = 1.0,
        costume_slow_percent = 0.2,
    },

    skeletonhat = {
        durability = 250,
        absorption = 0.5,
        costume_aoe_damage_mult = 2.0,
        costume_aoe_damage_radius = 3.0,
    },

    ruinshat = {
        durability = 700,
        absorption = 0.52,
    },

    footballhat = {
        durability = 150,
        absorption = 0.3,
        durability_speed_mult = 0.07,
    },

    cookiecutterhat = {
        durability = 200,
        absorption = 0.32,
    },

    wathgrithrhat = {
        durability = 400,
        absorption = 0.52,
    },
}

return CTF_ARMOUR;
