---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-01-16 4:51 p.m.
---

local require = GLOBAL.require;
local CTF_CONSTANTS = require('teams/CTFTeamConstants');
local CTFTeamCombat = require('teams/CTFTeamCombat');

modimport('scripts/prefabs/patcher/CTFPrefabPatcher');

local CTF_FLAG_TAGS = { CTF_CONSTANTS.TEAM_FLAG_TAG };
local function TestWinState(inst, self)
    local ents = TheSim:FindEntities(
            self.basePosition.x,
            self.basePosition.y,
            self.basePosition.z,
            10,
            CTF_FLAG_TAGS
    );

    for _, v in ipairs(ents) do
        if v:HasTag(CTF_CONSTANTS.TEAM_FLAG_TAG) and not v:HasTag(self.teamTag) then
            c_announce('Team ' .. self.id .. ' wins!');
            c_announce('Game restarting in 10 seconds!');
            TheWorld:DoTaskInTime(10, c_regenerateworld);
            TheWorld:PushEvent(CTF_CONSTANTS.GAME_ENDED);
        end
    end
end

local function FindSpawnerTarget(inst, team)
    local spawner = team.minionSpawners[inst.data.ctf_minion_spawner];
    if spawner then
        return spawner:GetPosition();
    end
    return team.basePosition;
end

local function SpawnMinions(inst, team)
    if CTFTeamManager.gameStarted then
        if inst.components and inst.components.health and inst.components.health.currenthealth <= 0 then
            return;
        end

        local instPosition = inst:GetPosition();
        for _, v in ipairs(CTFTeamManager.teams) do
            if v.id ~= team.id then
                local target = FindSpawnerTarget(inst, v);
                local minionPrefab = CTF_CONSTANTS.MINION_PREFABS[(inst.data.ctf_minion_count % 4) + 1];
                local minion = inst.components.childspawner:DoSpawnChild(nil, minionPrefab, 5);
                if minion ~= nil then
                    inst.data.ctf_minion_count = inst.data.ctf_minion_count + 1;
                    local targetVector = {
                        x = target.x - instPosition.x,
                        y = target.y - instPosition.y,
                        z = target.z - instPosition.z,
                    };
                    local targetDistance = math.sqrt(math.pow(targetVector.x, 2) + math.pow(targetVector.y, 2) + math.pow(targetVector.z, 2));
                    local targetNormal = {
                        x = targetVector.x / targetDistance,
                        y = targetVector.y / targetDistance,
                        z = targetVector.z / targetDistance,
                    };

                    minion.Transform:SetPosition(instPosition.x + targetNormal.x * 3, instPosition.y + targetNormal.y * 3, instPosition.z + targetNormal.z * 3);

                    if minion.components.knownlocations then
                        minion.components.knownlocations:RememberLocation('investigate', target);
                    end

                    if minion.components.sleeper then
                        minion.components.sleeper:SetSleepTest(function() return false end);
                    end

                    if minion.components.combat then
                        local OldShareTarget = minion.components.combat.ShareTarget;
                        minion.components.combat.ShareTarget = function(f_self, f_target, range, fn, maxnum, musttags)
                            OldShareTarget(f_self, f_target, range, function(dude)
                                return fn(dude) and dude.components.knownlocations and dude.components.knownlocations:GetLocation('investigate') == target;
                            end, maxnum, musttags);
                        end
                    end

                    minion.entity:SetCanSleep(false);
                end
            end
        end
    end
end

CTFTeam = Class(function(self, id)
    self.id = id;
    self.teamTag = self:makeTeamTag(self.id);
    self.noTeamTag = self:makeExcludeTag(self.teamTag);
    self.flag = nil;
    self.winTask = nil;
    self.players = {};
    self.minionSpawners = {};
    self.playerCount = 0;
    self.basePosition = {
        x = 0,
        y = 0,
        z = 0,
    };
end);

function CTFTeam:makeTeamTag(id)
    return CTF_CONSTANTS.TEAM_PREFIX_TAG .. id;
end

function CTFTeam:makeExcludeTag(teamTag)
    return CTF_CONSTANTS.EXCLUDE_PREFIX_TAG .. teamTag;
end

function CTFTeam:getTeamColor(id)
    return unpack(CTF_CONSTANTS.TEAM_COLORS[math.min(id, 5)]);
end

function CTFTeam:makeMinionSpawner(obj)
    if obj.components then
        if obj.components.childspawner then
            obj:RemoveComponent('childspawner');
        end

        obj:AddComponent('childspawner');
        TheWorld:ListenForEvent(CTF_CONSTANTS.GAME_STARTED, function()
            SpawnMinions(obj, self);
            obj:DoPeriodicTask(10, SpawnMinions, nil, self);
        end);

        obj:AddTag(CTF_CONSTANTS.TEAM_MINION_SPAWNER_TAG);
    end
end

function CTFTeam:patchPlayerProx(obj)
    if obj.components and obj.components.playerprox then
        local OldOnNear = obj.components.playerprox.onnear;
        local teamTag = self.teamTag;

        obj.components.playerprox:SetTargetMode(function(inst, comp)
            if not comp.isclose then
                local target = CTFTeamCombat.findEnemy(inst, comp.near, teamTag);
                if target ~= nil then
                    comp.isclose = true
                    if comp.onnear ~= nil then
                        comp.onnear(inst, target)
                    end
                end
            elseif not CTFTeamCombat.findEnemy(inst, comp.far, teamTag) then
                comp.isclose = false
                if comp.onfar ~= nil then
                    comp.onfar(inst)
                end
            end
        end);

        obj.components.playerprox:SetOnPlayerNear(function (inst, player)
            if not player:HasTag(teamTag) then
                OldOnNear(inst, player);
            end
        end);
    end
end

function CTFTeam:patchChildSpawner(obj)
    if obj.components and obj.components.childspawner then
        local OldOnSpawned = obj.components.childspawner.onspawned;
        local team = self;
        obj.components.childspawner:SetSpawnedFn(function(inst, child)
            child:AddTag(CTF_CONSTANTS.TEAM_MINION_TAG);
            CTFPrefabPatcher:patchStats(child, inst.data);

            team:registerObject(child, nil);
            if OldOnSpawned then
                OldOnSpawned(inst, child);
            end
        end);
    end
end

function CTFTeam:patchSpawner(obj)
    if obj.components and obj.components.spawner then
        local OldTakeOwnership = obj.components.spawner.TakeOwnership;
        local team = self;
        obj.components.spawner.TakeOwnership = function(inst, child)
            if inst.child ~= child then
                child:AddTag(CTF_CONSTANTS.TEAM_MINION_TAG);
                CTFPrefabPatcher:patchStats(child, obj.data);

                team:registerObject(child, nil);
                OldTakeOwnership(inst, child);
            end
        end
        if obj.components.spawner.child then
            obj.components.spawner.child:AddTag(CTF_CONSTANTS.TEAM_MINION_TAG);
            team:registerObject(obj.components.spawner.child, nil);
            CTFPrefabPatcher:patchStats(obj.components.spawner.child, obj.data);
        end
    end
end

function CTFTeam:patchBuilder(obj, teamTag)
    if obj.components and obj.components.builder then
        local OldOnBuild = obj.components.builder.onBuild;
        obj.components.builder.onBuild = function(inst, prod)
            if prod and (not prod.components or not prod.components.edible) then
                if prod:HasTag('structure') then
                    self:registerObject(prod, nil);
                else
                    prod:AddTag(CTF_CONSTANTS.TEAM_ITEM_TAG);
                    prod:AddTag(teamTag);
                end
            end

            if OldOnBuild then
                OldOnBuild(inst, prod);
            end
        end
    end
end

function CTFTeam:patchCombat(obj, teamTag)
    if obj.components and obj.components.combat then
        obj.components.combat.IsAlly = function(inst, target)
            return target:HasTag(teamTag);
        end

        local OldCanTarget = obj.components.combat.CanTarget;
        obj.components.combat.CanTarget = function(inst, target)
            if target and target:HasTag(teamTag) then
                return false;
            end
            return OldCanTarget(inst, target);
        end

        
        local OldIsValidTarget = obj.components.combat.IsValidTarget;
        obj.components.combat.IsValidTarget = function(inst, target)
            if target then
                if target:HasTag(teamTag) then
                    return false;
                elseif target:HasTag(CTF_CONSTANTS.TEAM_MINION_TAG) then
                    return true;
                end
            end
            return OldIsValidTarget(inst, target);
        end
    end

    if obj.replica and obj.replica.combat then
        local OldCanTarget = obj.replica.combat.CanTarget;
        obj.replica.combat.CanTarget = function(inst, target)
            if target and target:HasTag(teamTag) then
                return false;
            end
            return OldCanTarget(inst, target);
        end
    end
end

function CTFTeam:patchPlayerController(player, teamTag)
    if player.components.playercontroller then
        local OldGetActionButtonAction = player.components.playercontroller.GetActionButtonAction;
        player.components.playercontroller.GetActionButtonAction = function(inst, force_target)
            local result = OldGetActionButtonAction(inst, force_target);
            if result
                    and result.target
                    and ((result.target:HasTag(CTF_CONSTANTS.TEAM_FLAG_TAG) and result.target:HasTag(teamTag))
                    or (result.target:HasTag(CTF_CONSTANTS.TEAM_ITEM_TAG) and not result.target:HasTag(teamTag))) then
                local target = result.target;
                target:AddTag('fire');
                result = OldGetActionButtonAction(inst, force_target)
                target:RemoveTag('fire');
            end
            return result;
        end
    end
end

function CTFTeam:patchInventory(inst)
    if inst.components and inst.components.inventory then
        local OldEquip = inst.components.inventory.Equip;
        inst.components.inventory.Equip = function(inventory, item, old_to_active)
            local body = inventory:GetEquippedItem(EQUIPSLOTS.BODY);
            if body ~= nil and body:HasTag(CTF_CONSTANTS.TEAM_FLAG_TAG) then
                item = nil
            end
            return OldEquip(inventory, item, old_to_active);
        end
    end
end

function CTFTeam:patchFlagEquippable(flag)
    if flag.components and flag.components.equippable then
        local OldOnEquipped = flag.components.equippable.onequipfn;
        flag.components.equippable:SetOnEquip(function(inst, owner)
            if owner.components and owner.components.inventory then
                local hands = owner.components.inventory:Unequip(EQUIPSLOTS.HANDS, false);
                if hands ~= nil then
                    owner.components.inventory.silentfull = true;
                    owner.components.inventory:GiveItem(hands);
                    owner.components.inventory.silentfull = false;
                end

                local head = owner.components.inventory:Unequip(EQUIPSLOTS.HEAD, false);
                if head ~= nil then
                    owner.components.inventory.silentfull = true;
                    owner.components.inventory:GiveItem(head);
                    owner.components.inventory.silentfull = false;
                end
            end

            self:setPlayerSanity(owner, 0);
            if OldOnEquipped ~= nil then
                OldOnEquipped(inst, owner);
            end
        end);

        local OldOnUnequipped = flag.components.equippable.onunequipfn;
        flag.components.equippable:SetOnUnequip(function(inst, owner)
            self:setPlayerSanity(owner, 1);
            if OldOnUnequipped then
                OldOnUnequipped(inst, owner);
            end
        end);

        flag.components.equippable.walkspeedmult = CTF_CONSTANTS.TEAM_FLAG_WALK_SPEED_MULT;
    end
end

function CTFTeam:setTeamColor(obj)
    local amt = 0.2;
    local multAmt = math.pow(1 - amt, 2);
    local r, g, b, a = self:getTeamColor(self.id);
    obj.AnimState:SetMultColour(r * multAmt, g * multAmt, b * multAmt, a);
    obj.AnimState:SetAddColour(r * amt, g * amt, b * amt, a);
end

function CTFTeam:registerObject(obj, data)
    if obj:HasTag(self.teamTag) then
        return;
    end

    if not obj.data then
        if data then
            obj.data = data;
        else
            obj.data = {};
        end
    end

    if obj.entity then
        obj.entity:SetCanSleep(false);
    end

    obj.data.ctf_team_id = self.id;
    obj.data.ctf_team_tag = self.teamTag;
    obj:AddTag(self.teamTag);

    if obj.prefab == CTF_CONSTANTS.TEAM_FLAG_PREFAB then
        self.flag = obj;
        self.flag:AddTag(CTF_CONSTANTS.TEAM_FLAG_TAG);
        self.flag:AddTag(self.noTeamTag);

        self:patchFlagEquippable(self.flag);

        self.basePosition = obj:GetPosition();
        self.winTask = self.flag:DoPeriodicTask(0.2, TestWinState, nil, self);

        if obj.components and obj.components.hauntable then
            obj:RemoveComponent('hauntable');
        end

        TheWorld:ListenForEvent(CTF_CONSTANTS.GAME_ENDED, function()
            if self.winTask then
                self.winTask:Cancel();
                self.winTask = nil;
            end
        end);
    end

    if data and data.ctf_minion_spawner then
        obj.data.ctf_minion_spawner = data.ctf_minion_spawner;
        obj.data.ctf_minion_count = 0;
        self.minionSpawners[data.ctf_minion_spawner] = obj;
        self:makeMinionSpawner(obj);
    end

    self:patchPlayerProx(obj);
    self:patchChildSpawner(obj);
    self:patchSpawner(obj);
    self:patchCombat(obj, self.teamTag);

    if obj.AnimState then
        self:setTeamColor(obj);
    end
end

function CTFTeam:setPlayerHealth(player, n)
    if player ~= nil and player.components.health ~= nil and not player:HasTag('playerghost') then
        player.components.health:SetPercent(n);
    end
end

function CTFTeam:setPlayerHealthValue(player, n)
    if player ~= nil and player.components.health ~= nil and not player:HasTag('playerghost') then
        self:SetPlayerHealth(player, n / player.components.health.maxhealth);
    end
end

function CTFTeam:setPlayerSanity(player, n)
    if player ~= nil and player.components.sanity ~= nil and not player:HasTag('playerghost') then
        local redirect = player.components.sanity.redirect;
        player.components.sanity.redirect = nil;
        player.components.sanity:SetPercent(n);
        player.components.sanity.redirect = redirect;
    end
end

function CTFTeam:setPlayerSanityValue(player, n)
    if player ~= nil and player.components.sanity ~= nil and not player:HasTag('playerghost') then
        self:setPlayerSanity(player, n / player.components.sanity.max);
    end
end

function CTFTeam:setPlayerHunger(player, n)
    if player ~= nil and player.components.hunger ~= nil and not player:HasTag('playerghost') then
        player.components.hunger:SetPercent(n);
    end
end

function CTFTeam:setPlayerHungerValue(player, n)
    if player ~= nil and player.components.hunger ~= nil and not player:HasTag('playerghost') then
        self:setPlayerHunger(player, n / player.components.hunger.max);
    end
end

function CTFTeam:setPlayerMoisture(player, n)
    if player ~= nil and player.components.moisture ~= nil and not player:HasTag('playerghost') then
        player.components.moisture:SetPercent(n);
    end
end

function CTFTeam:setPlayerMoistureValue(player, n)
    if player ~= nil and player.components.moisture ~= nil and not player:HasTag('playerghost') then
        self:setPlayerMoisture(player, n / player.components.moisture.maxmoisture);
    end
end

function CTFTeam:setPlayerTemperature(player, n)
    if player ~= nil and player.components.temperature ~= nil and not player:HasTag('playerghost') then
        player.components.temperature:SetTemperature(n);
    end
end

function CTFTeam:resetPlayerStats(player)
    if player.data and player.data.ctf_spawnHealth then
        self:setPlayerHealthValue(player, player.data.ctf_spawnHealth);
    else
        self:setPlayerHealth(player,1);
    end

    if player.data and player.data.ctf_spawnSanity then
        self:setPlayerSanityValue(player, player.data.ctf_spawnSanity);
    else
        self:setPlayerSanity(player,1);
    end

    if player.data and player.data.ctf_spawnHunger then
        self:setPlayerHungerValue(player, player.data.ctf_spawnHunger);
    else
        self:setPlayerHunger(player,1);
    end

    if player.data and player.data.ctf_spawnMoisture then
        self:setPlayerMoistureValue(player, player.data.ctf_spawnMoisture);
    else
        self:setPlayerMoisture(player,0);
    end

    self:setPlayerTemperature(player, 25);
end

function CTFTeam:schedulePlayerRevive(player, seconds)
    c_announce(player.name .. ' will revive in ' .. seconds .. ' seconds');
    player:DoTaskInTime(seconds, function ()
        self:teleportPlayerToBase(player);
        self:revivePlayer(player);
    end);
end

function CTFTeam:revivePlayer(player)
    if player ~= nil then
        if player:HasTag('playerghost') then
            player:PushEvent('respawnfromghost')
        elseif player:HasTag('corpse') then
            player:PushEvent('respawnfromcorpse')
        end
    end
end

function CTFTeam:setPlayerInvincibility(player, invincible)
    if invincible then
        self:resetPlayerStats(player);
    end

    if player ~= nil and player.components and player.components.health then
        player.components.health:SetInvincible(invincible);
    end
end

function CTFTeam:teleportPlayerToBase(player)
    c_teleport(self.basePosition.x, self.basePosition.y, self.basePosition.z, player);
    self:setPlayerInvincibility(player, false);
end

function CTFTeam:teleportAllPlayersToBase()
    for _, v in ipairs(self.players) do
        self:teleportPlayerToBase(v);
    end
end

function CTFTeam:registerPlayer(player)
    if player.components then
        if player.components.itemtyperestrictions then
            player.components.itemtyperestrictions.ctfTeamTag = self.teamTag;
            player.components.itemtyperestrictions.noCtfTeamTag = self.noTeamTag;
        end

        if player.components.sanity then
            player.components.sanity.redirect = function() return;  end;
        end
    end



    if not player.data then
        player.data = {};
    end
    player.data.ctf_team_tag = self.teamTag;
    player.data.ctf_team_id = self.id;
    player:AddTag(self.teamTag);
    player:AddTag(CTF_CONSTANTS.TEAM_PLAYER_TAG);

    table.insert(self.players, player);

    self:patchCombat(player, self.teamTag);
    self:patchPlayerController(player, self.teamTag);
    self:patchBuilder(player, self.teamTag);
    self:patchInventory(player);

    self.playerCount = self.playerCount + 1;
    player:ListenForEvent('death', function()
        self:schedulePlayerRevive(player, 15);
    end);

    local team = self;
    player:ListenForEvent('ms_respawnedfromghost', function ()
        team:resetPlayerStats(player);
    end);

    self:setTeamColor(player);

    if player.player_classified and player.player_classified.ctf_net_on_player_team_id then
        player.player_classified.ctf_net_on_player_team_id:set(self.id);
    end

    TheWorld:PushEvent(CTF_CONSTANTS.PLAYER_JOINED_TEAM_EVENT, player, team);

    if player:HasTag('playerghost') or player:HasTag('corpse') then
        self:schedulePlayerRevive(player, 15);
    end
end

function CTFTeam:findPlayer(prefab, userid)
    for _, v in ipairs(self.players) do
        if v.prefab == prefab and v.userid == userid then
            return v;
        end
    end
    return nil;
end

function CTFTeam:hasPlayer(player)
    for _, v in ipairs(self.players) do
        if v == player then
            return true;
        end
    end
    return false;
end

function CTFTeam:removePlayer(player)
    for i, v in ipairs(self.players) do
        if v == player then
            c_announce(player.name .. ' has left team ' .. self.id);
            table.remove(self.players, i);
            self.playerCount = self.playerCount - 1;
            TheWorld:PushEvent(CTF_CONSTANTS.PLAYER_LEFT_TEAM_EVENT, player, team);
            return;
        end
    end
end
