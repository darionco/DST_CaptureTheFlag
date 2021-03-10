---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-03-09 9:45 p.m.

local require = _G.require;
local CTF_TEAM_CONSTANTS = require('constants/CTFTeamConstants');

local function castAOE(act)
    local doer = act.doer;
    local pos = act:GetActionPoint();
    if doer and doer.components.ghostlybond then
        local abi = doer.components.ghostlybond.ghost;
        abi.Physics:SetActive(false);
        abi.Physics:SetCollides(false);
        doer.components.ghostlybond:Summon(act.invobject);
        abi.Transform:SetPosition(pos.x, pos.y, pos.z);
        abi.sg:GoToState('ctf_appear');
        return true;
    end
end

local function ReticuleTargetFn()
    local player = ThePlayer
    local ground = TheWorld.Map
    local pos = Vector3()
    -- this need to be fixed!
    --Cast range is 8, leave room for error
    --4 is the aoe range
    for r = 7, 0, -.25 do
        pos.x, pos.y, pos.z = player.entity:LocalToWorldSpace(r, 0, 0)
        if ground:IsPassableAtPoint(pos:Get()) and not ground:IsGroundTargetBlocked(pos) then
            return pos
        end
    end
    return pos
end

AddPrefabPostInit('abigail_flower', function(inst)
    inst:AddComponent('aoetargeting');
    inst.components.aoetargeting.reticule.reticuleprefab = 'reticuleaoesmall';
    inst.components.aoetargeting.reticule.pingprefab = 'reticuleaoesmallping';
    inst.components.aoetargeting.reticule.targetfn = ReticuleTargetFn;
    inst.components.aoetargeting.reticule.validcolour = { 1, .75, 0, 1 };
    inst.components.aoetargeting.reticule.invalidcolour = { .5, 0, 0, 1 };
    inst.components.aoetargeting.reticule.ease = true;
    inst.components.aoetargeting.reticule.mouseenabled = true;

    inst:AddComponent('aoespell');
    inst.components.aoespell.cast_spell = castAOE;
    inst.components.aoespell.str = 'Summon Abigail';
    inst.components.aoespell.can_cast = function(act)
        local doer = act.doer;
        if doer and doer.components and doer.components.ghostlybond and doer.components.ghostlybond.notsummoned then
            return true;
        end
        return false;
    end;

    if TheWorld.ismastersim then
        inst:AddComponent('equippable');
        inst.components.equippable:SetOnEquip(function(f_inst, owner)
            if owner.data and owner.data.ctf_team_id then
                f_inst.components.aoetargeting.reticule.validcolour = CTF_TEAM_CONSTANTS.TEAM_COLORS[owner.data.ctf_team_id];
            end
        end);
    end

    inst:RemoveComponent('summoningitem');
end);

AddComponentAction('POINT', 'aoetargeting', function(item, doer, point, actions)
    local aoetargeting = doer.components.playercontroller:IsAOETargeting();
    if aoetargeting and doer.prefab == 'wendy' and item.prefab == 'abigail_flower' then
        table.insert(actions, ACTIONS.CASTAOE);
    end
end);

AddStategraphState('abigail', State{
    name = 'ctf_appear',
    tags = { 'busy', 'noattack', 'nointerrupt' },

    onenter = function(inst)
        inst.AnimState:PlayAnimation('appear')
        inst.AnimState:SetTime(0);
        inst.Physics:Stop()
        -- inst.SoundEmitter:PlaySound('dontstarve/characters/wendy/abigail/howl_one_shot')
        if inst.components.health ~= nil then
            inst.components.health:SetInvincible(true)
        end
    end,

    events =
    {
        EventHandler('animover', function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState('ctf_attack')
            end
        end),
    },

    onexit = function(inst)
        inst.components.aura:Enable(true)
        inst.components.health:SetInvincible(false)
        if inst._playerlink ~= nil then
            inst._playerlink.components.ghostlybond:SummonComplete()
        end
    end,
});

AddStategraphState('abigail', State{
    name = 'ctf_attack',
    tags = { 'busy', 'noattack', 'nointerrupt' },

    onenter = function(inst)
        -- inst.SoundEmitter:PlaySound('dontstarve/characters/wendy/abigail/howl_one_shot')
        inst:PushEvent('ctf_attack');
        inst.AnimState:PlayAnimation('hit')
        inst.Physics:Stop()
        --inst.sg.statemem.fx = SpawnPrefab('abigail_vex_hit');
        --inst.sg.statemem.fx.entity:AddNetwork();
        --inst.sg.statemem.fx:RemoveTag('CLASSIFIED');
        --inst.sg.statemem.fx.entity:SetPristine()
        --inst.sg.statemem.fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
        --inst.sg.statemem.fx.entity:SetParent(inst.entity)
        --inst.sg.statemem.fx.Transform:SetRotation(inst.Transform:GetRotation())
        --inst.sg.statemem.fx.AnimState:SetTime(0) -- hack to force update the initial facing direction
        local fx = SpawnPrefab('ctf_abigail_hit');
        fx.Transform:SetPosition(inst.Transform:GetWorldPosition());
    end,

    events =
    {
        EventHandler('animover', function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState('dissipate')
            end
        end),
    },
});
