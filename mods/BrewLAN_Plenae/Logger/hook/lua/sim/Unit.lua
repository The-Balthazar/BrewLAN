do
    local UnitOld = Unit

    Unit = Class(UnitOld) {
        OnStopBeingBuilt = function(self,builder,layer, ...)
            UnitOld.OnStopBeingBuilt(self,builder,layer, unpack(arg))
            local pos = self:GetPosition()
            local ori = self:GetOrientation()
            LOG("[UNIT_" .. self:GetEntityId() .. "] = {" )
            LOG("    type = '" .. self:GetBlueprint().BlueprintId .. "',")
            LOG("    orders = '',")
            LOG("    platoon = '',")
            LOG("    Position = {" .. pos[1] .. "," .. pos[2] .. "," .. pos[3] .. "},")
            LOG("    Orientation = {" .. ori[1] .. "," .. ori[2] .. "," .. ori[3] .. "},")
            LOG("},")
        end,
    }
end
