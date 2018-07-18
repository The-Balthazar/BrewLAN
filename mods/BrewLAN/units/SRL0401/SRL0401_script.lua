local CLandUnit = import('/lua/cybranunits.lua').CLandUnit
local cWeapons = import('/lua/cybranweapons.lua')
local CDFElectronBolterWeapon = cWeapons.CDFElectronBolterWeapon
local CANTorpedoLauncherWeapon = cWeapons.CANTorpedoLauncherWeapon

SRL0401 = Class(CLandUnit) {
    Weapons = {
        Turret = Class(CDFElectronBolterWeapon) {},
        Torpedo = Class(CANTorpedoLauncherWeapon) {},
    },

	OnLayerChange = function(self, new, old)
		CLandUnit.OnLayerChange(self, new, old)
		if new == 'Land' then
            self:SetSpeedMult(1)
		elseif new == 'Seabed' then
            self:SetSpeedMult(self:GetBlueprint().Physics.WaterSpeedMultiplier)
		end
	end,

    OnStopBeingBuilt = function(self,builder,layer)
        CLandUnit.OnStopBeingBuilt(self,builder,layer)
        self:SetMaintenanceConsumptionActive()
        self:EnableUnitIntel('RadarStealthField')
        self:EnableUnitIntel('SonarStealthField')
        self:RequestRefreshUI()
        self.AnimationManipulator = CreateAnimator(self)
        self.Trash:Add(self.AnimationManipulator)
        self.AnimationManipulator:PlayAnim(self:GetBlueprint().Display.AnimationOpen, false):SetRate(1)
        local beams = {
            --Front
            {'CablePointB_021', 'CablePointA_026', 'CablePointB_023', 'CablePointB_022'},
            {'CablePointB_024','CablePointA_025'},
            {'CablePointA_021', 'CablePointB_025', 'CablePointA_024', 'CablePointA_022'},
            {'CablePointB_026', 'CablePointA_023'},
            --Middle
            {'CablePointB_028', 'CablePointA_028', 'CablePointB_031', 'CablePointB_029'},
            {'CablePointA_029', 'CablePointB_032'},
            {'CablePointA_027', 'CablePointB_030', 'CablePointA_031', 'CablePointA_030'},
            {'CablePointB_027', 'CablePointA_032'},
            --Back
            {'CablePointB_034', 'CablePointA_034', 'CablePointB_037', 'CablePointB_035'},
            {'CablePointA_035', 'CablePointB_038'},
            {'CablePointA_033', 'CablePointB_036', 'CablePointA_037', 'CablePointA_036'},
            {'CablePointB_033', 'CablePointA_038'},
        }
        local army = self:GetArmy()
        for i, set in beams do
            for j = 1, table.getn(set) -1 do
                if not self.BeamEffectsBag then self.BeamEffectsBag = {} end
                table.insert(self.BeamEffectsBag, AttachBeamEntityToEntity(self, set[j], self, set[j + 1], army, '/effects/emitters/build_beam_02_emit.bp'))
            end
        end
    end,

    Kill = function(self, ...)
        self.Dying = true
        self:TransportDetachAllUnits(false)
        CLandUnit.Kill(self, unpack(arg))
    end,

    OnAttachedKilled = function(self, attached)
        attached:DetachFrom()
    end,

    OnTransportDetach = function(self, attachBone, unit)
        local pos
        if not self.Dying then
            pos = unit:GetPosition()
        end
        CLandUnit.OnTransportDetach(self, attachBone, unit)
        if not self.Dying then
            self:ForkThread( --This prevents units getting dumped into the earth.
                function()
                    WaitTicks(1)
                    local height = GetTerrainHeight(pos[1],pos[3])
                    --if pos[2] < height then
                        Warp(unit, {pos[1], height, pos[3]})
                    --end
                end
            )
        end
    end,

    OnMotionHorzEventChange = function(self, new, old)
        CLandUnit.OnMotionHorzEventChange(self, new, old)
        if new == 'Stopping' then
            self.AnimationManipulator:SetRate(4)
            self.Closed = nil
        elseif new == 'Cruise' then
            self.AnimationManipulator:SetRate(-2)
            self.Closed = true
        end
    end,

    PlayAnimationThread = function(self, anim, rate)
        if anim == 'AnimationDeath' then
            self.AnimationManipulator:Destroy()
            for i, v in self.BeamEffectsBag do
                v:Destroy()
            end
            self.DeathAnimManip = CreateAnimator(self)
            local bp = self:GetBlueprint().Display[anim]
            if self.Closed then
                --These should probably check bp[n].State, but meh.
                self.DeathAnimManip:PlayAnim(bp[2].Animation):SetRate(2)
            else
                self.DeathAnimManip:PlayAnim(bp[1].Animation):SetRate(2)
            end
            self.Trash:Add(self.DeathAnimManip)
            WaitFor(self.DeathAnimManip)
        else
            CLandUnit.PlayAnimationThread(self, anim, rate)
        end
    end,
}

TypeClass = SRL0401
