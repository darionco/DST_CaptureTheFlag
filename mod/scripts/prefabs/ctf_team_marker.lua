---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-03-02 6:38 p.m.
---

local assets = {
    Asset('ANIM', 'anim/ctf_team_marker.zip'),
};
local prefabs = {};

local function ctf()
    local inst = CreateEntity();

    inst.entity:AddTransform();
    inst.entity:AddFollower();
    inst.entity:AddAnimState();

    inst.Transform:SetPosition(0, -0.05, 0);

    inst.AnimState:SetBank('ctf_team_marker');
    inst.AnimState:SetBuild('ctf_team_marker');
    inst.AnimState:PlayAnimation('idle');
    inst.AnimState:SetMultColour(1, 1, 1, 1);
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround);

    inst.entity:SetPristine();

    inst:AddTag('FX');
    inst.persists = false;

    return inst;
end

return Prefab( 'ctf_team_marker', ctf, assets, prefabs);
