local TAirStagingPlatformUnit = import('/lua/terranunits.lua').TAirStagingPlatformUnit

SEL0326 = Class(TAirStagingPlatformUnit) {
    --[[OnCreate = function(self)
        TAirStagingPlatformUnit.OnCreate(self)
        self:PlatformToggle(true)
    end,]]

    OnStopBeingBuilt = function(self, ...)
        TAirStagingPlatformUnit.OnStopBeingBuilt(self, unpack(arg) )
        self:PlatformToggle(true)
    end,

    OnStartTransportBeamUp = function(self, transport, bone)
        TAirStagingPlatformUnit.OnStartTransportBeamUp(self, transport, bone)
        self:PlatformToggle(false)
        self.LastTransportedTime = GetGameTimeSeconds()
    end,

    OnMotionHorzEventChange = function(self, new, old)
        if new ~= 'Stopped' then
            self:PlatformToggle(false)
            --LOG("OnMotionHorzEventChange become visible")
        elseif new == 'Stopped' and (self.LastTransportedTime or 0) + 2 < GetGameTimeSeconds() then
            self:PlatformToggle(true)
            --LOG("OnMotionHorzEventChange become invisible", new, old)
        end
        TAirStagingPlatformUnit.OnMotionHorzEventChange(self, new, old)
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
