---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-04-03 3:02 p.m.
---

local CTFInit = use('scripts/tools/CTFInit');

local function master_post_init(inst)
    local OldOnEquip = inst.components.equippable.onequipfn;
    inst.components.equippable:SetOnEquip(function(f_inst, owner)
        OldOnEquip(f_inst, owner);
        if owner.components.sanity then
            owner.components.sanity:SetInducedInsanity(f_inst, false);
        end
    end);
end

CTFInit:Prefab('skeletonhat', nil, master_post_init);
