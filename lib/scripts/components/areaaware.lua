local AreaAware = Class(function(self, inst)
    self.inst = inst
    self.current_area = -1
    self.current_area_data = nil
    self.lastpt = Vector3(-9999,0,-9999)
	self.updatedistsq = 16 --4*4

    self.inst:StartUpdatingComponent(self)

	self._ForceUpdate = function() self:UpdatePosition(self.inst.Transform:GetWorldPosition()) end
    self.inst:ListenForEvent("done_embark_movement", self._ForceUpdate)                
	
end)

function AreaAware:OnRemoveFromEntity()
    self:StopUpdating()
    self.inst:RemoveEventCallback("done_embark_movement", self._ForceUpdate)
end

function AreaAware:_TestArea(pt_x, pt_z, on_land, r)
	local best = {tile_type = GROUND.INVALID, render_layer = -1}

	for _z = -1, 1 do
		for _x = -1, 1 do
			local x, z = pt_x + _x*r, pt_z + _z*r

			local tile_type = TheWorld.Map:GetTileAtPoint(x, 0, z)
			if on_land == IsLandTile(tile_type) then
				local tile_info = GetTileInfo(tile_type)
				local render_layer = tile_info ~= nil and tile_info._render_layer or 0
				if render_layer > best.render_layer then
					best.tile_type = tile_type
					best.render_layer = render_layer
					best.x = x
					best.z = z
				end
			end
		end
	end

	return best.tile_type ~= GROUND.INVALID and best or nil
end


function AreaAware:UpdatePosition(x, y, z)
	local on_land = TheWorld.Map:IsVisualGroundAtPoint(x, 0, z)

	local best = self:_TestArea(x, z, on_land, 0.95)
				or self:_TestArea(x, z, on_land, 1.25) -- this is the handle some of the corner case when there the player is really standing quite far into the water tile, but logically on land
				or self:_TestArea(x, z, on_land, 1.5) 

	local node_index = (on_land and best ~= nil) and TheWorld.Map:GetNodeIdAtPoint(best.x, 0, best.z) or 0
	if node_index ~= self.current_area then
		self.current_area = node_index

		local node = node_index ~= 0 and TheWorld.topology.nodes[node_index]
		self.current_area_data = node and {
			id = TheWorld.topology.ids[node_index],
			type = node.type,
			center = node.cent,
			poly = node.poly,
			tags = node.tags,
		}
		or nil

		self.inst:PushEvent("changearea", self.current_area_data)
	end
end

function AreaAware:OnUpdate(dt)
    local x, y, z = self.inst.Transform:GetWorldPosition()
    if distsq(x, z, self.lastpt.x, self.lastpt.z) > self.updatedistsq then
        self:UpdatePosition(x, 0, z)
		self.lastpt.x, self.lastpt.z = x, z
    end
end

function AreaAware:SetUpdateDist(dist)
	self.updatedistsq = dist*dist
end

function AreaAware:GetCurrentArea()
    return self.current_area_data
end

function AreaAware:CurrentlyInTag(tag)
    return self.current_area_data and self.current_area_data.tags and table.contains(self.current_area_data.tags, tag)
end

function AreaAware:GetDebugString()
    local node = TheWorld.topology.nodes[self.current_area]
    if node then
        local s = string.format("%s: %s [%d]",tostring(TheWorld.topology.ids[self.current_area]), table.reverselookup(NODE_TYPE, node.type), self.current_area)
        if node.tags then
            s = string.format("%s, {%s}", s, table.concat(node.tags, ", "))
        else
            s = string.format("%s, No tags.", s)
        end
        return s
    else

        return "No current node."
    end
end

function AreaAware:StartCheckingPosition(checkinterval)
    self.checkpositiontask = self.inst:DoPeriodicTask(checkinterval or self.checkinterval, function() self:UpdatePosition() end)
end

return AreaAware
