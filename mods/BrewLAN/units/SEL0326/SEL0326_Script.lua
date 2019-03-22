local TLandUnit = import('/lua/terranunits.lua').TLandUnit

SEL0326 = Class(TLandUnit) {

    OnStopBeingBuilt = function(self, ...)
        TLandUnit.OnStopBeingBuilt(self, unpack(arg) )
        self:PlatformToggle(true)
    end,

    OnStartTransportBeamUp = function(self, transport, bone)
        TLandUnit.OnStartTransportBeamUp(self, transport, bone)
        self:PlatformToggle(false)
        self.LastTransportedTime = GetGameTimeSeconds()
    end,

    OnMotionHorzEventChange = function(self, new, old)
        if new ~= 'Stopped' then
            self:PlatformToggle(false)

            --This cancels the move order, which would break AI platoon orders, but doesn't break the units.
            for _, unit in self:GetCargo() do
                --LOG("YEEET")
                IssueClearCommands({self}) -- Without this, the transport order is ignored.
                IssueTransportUnload( {self}, self:GetPosition() )
                break
            end
            --This doesn't free up the platform node for future use
            --[[
            local cargo = self:GetCargo()
            for _, unit in cargo do
                --unit:DoUnitCallbacks('OnDetachedFromTransport', self)
                unit:DetachFrom()
                self.ForceDeploy = true
            end
            ]]
            --This also doesn't free up the platform node for future use
            --[[
            for i = 1, self:GetBoneCount() do
                if string.sub(self:GetBoneName(i) or 'nope',1,11) == 'Attachpoint' then
                    self:DetachAll(i)
                    self.ForceDeploy = true
                end
            end
            ]]
        elseif new == 'Stopped' and (self.LastTransportedTime or 0) + 2 < GetGameTimeSeconds() then
            self:PlatformToggle(true)--[[
            --This doesn't work to refresh the pads.
            if self.ForceDeploy then
                IssueTransportUnload( {self}, self:GetPosition() )
                self.ForceDeploy = nil
            end]]
        end
        TLandUnit.OnMotionHorzEventChange(self, new, old)
    end,

    PlatformToggle = function(self, toggle)
        if not self.AnimationManipulator then
            self.AnimationManipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator)
            self.AnimationManipulator:PlayAnim(self:GetBlueprint().Display.AnimationOpen, false)
        end
        local bp = self:GetBlueprint()
        if toggle then
            self.AnimationManipulator:SetRate(1)
            self:SetCollisionShape(
                'Box',
                bp.CollisionOffsetX or 0,
                bp.CollisionOffsetY or 0,
                (bp.CollisionOffsetZ or 0) - 0.65,
                bp.SizeX,
                bp.SizeY * 0.5,
                bp.SizeZ
            )
        else
            self.AnimationManipulator:SetRate(-1)
            self:SetCollisionShape(
                'Box',
                bp.CollisionOffsetX or 0,
                (bp.CollisionOffsetY or 0) + 0.3,
                bp.CollisionOffsetZ or 0,
                bp.SizeX * 0.5,
                bp.SizeY * 0.5,
                bp.SizeZ * 0.5
            )
        end
    end,
}

TypeClass = SEL0326
