local TLandUnit = import('/lua/terranunits.lua').TLandUnit

SEL0326 = Class(TLandUnit) {

    OnCreate = function(self)
        TLandUnit.OnCreate(self )
        --self.slots = {}
    end,

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
             --This doesn't free up the platform node for future use
            local cargo = self:GetCargo()
            for _, unit in cargo do
                --unit:DoUnitCallbacks('OnDetachedFromTransport', self)
                unit:DetachFrom()
            end
            --[[for i = 1, self:GetBoneCount() do
                if string.sub(self:GetBoneName(i) or 'nope',1,11) == 'Attachpoint' then
                    self:DetachAll(i)
                end
            end]]
        elseif new == 'Stopped' and (self.LastTransportedTime or 0) + 2 < GetGameTimeSeconds() then
            self:PlatformToggle(true)
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
