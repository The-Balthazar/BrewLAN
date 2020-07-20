local SWalkingLandUnit = import('/lua/seraphimunits.lua').SWalkingLandUnit
local ChonkChromBeam = import('/lua/seraphimweapons.lua').BrewLANUltraChonkChromBeamGenerator
local TracerChromBeam = import('/lua/seraphimweapons.lua').BrewLANTracerChromBeamGenerator
local EffectUtil = import('/lua/EffectUtilities.lua')
--local RemoteViewing = import(import( '/lua/game.lua' ).BrewLANPath() .. '/lua/RemoteViewing.lua').RemoteViewing
--SWalkingLandUnit = RemoteViewing(SWalkingLandUnit)

SSL0404 = Class(SWalkingLandUnit) {

    Weapons = {
        MainGun = Class(ChonkChromBeam) {},
        MainTracer = Class(TracerChromBeam) {
			OnWeaponFired = function(self, target)
				TracerChromBeam.OnWeaponFired(self, target)
				ChangeState( self.unit, self.unit.VisibleState )
			end,

			OnLostTarget = function(self)
				TracerChromBeam.OnLostTarget(self)
				if not self.unit:IsUnitState('Busy') then
				    ChangeState( self.unit, self.unit.InvisState )
				end
			end,
        },
    },

    StartBeingBuiltEffects = function(self, builder, layer)
		SWalkingLandUnit.StartBeingBuiltEffects(self, builder, layer)
		self:ForkThread( EffectUtil.CreateSeraphimExperimentalBuildBaseThread, builder, self.OnBeingBuiltEffectsBag )
    end,

    OnAnimCollision = function(self, bone, x, y, z)
        SWalkingLandUnit.OnAnimCollision(self, bone, x, y, z)
    end,

    OnStopBeingBuilt = function(self, builder, layer)
        SWalkingLandUnit.OnStopBeingBuilt(self, builder, layer)

        --These start enabled, so before going to InvisState, disabled them.. they'll be reenabled shortly
        self:DisableUnitIntel('RadarStealth')
		self:DisableUnitIntel('Cloak')
		self.Cloaked = false
        ChangeState( self, self.InvisState ) -- If spawned in we want the unit to be invis, normally the unit will immediately start moving
        --self:ForkThread(self.VisualThread)
    end,
--[[
    VisualThread = function(self)
        local pos = self:GetPosition()
        local bp = self:GetBlueprint().Intel
        self.VisEnt = VizMarker({
            X = pos[1],
            Z = pos[3],
            Radius = bp.VisionRadius or 45,
            LifeTime = -1,
            Vision = true,
            Army = self:GetArmy(),
        })
        self.VisEnt:AttachTo(self, 'Intel_Node')
        self.Trash:Add(self.VisEnt)
        while true do
            coroutine.yield(50)
            self.VisSlider = CreateSlider(self, 'Intel_Node', 0, 0, 0, 300)
            if self.MoveIntel and self.VisSlider and not self.Stopped then
                self.VisSlider:SetGoal(0, 0, 300)
                self.Stopped = true
            elseif self.VisSlider and self.Stopped then
                self.VisSlider:SetGoal(0, 0, 0)
                self.Stopped = false
            end
        end
    end,]]

    InvisState = State() {
        Main = function(self)
            self.Cloaked = false
            local bp = self:GetBlueprint()
            if bp.Intel.StealthWaitTime then
                WaitSeconds( bp.Intel.StealthWaitTime )
            end
			self:EnableUnitIntel('RadarStealth')
			self:EnableUnitIntel('Cloak')
			self.Cloaked = true
            if bp.Display.CloakMeshBlueprint then
                self:SetMesh(bp.Display.CloakMeshBlueprint, true)
            end
        end,

        OnMotionHorzEventChange = function(self, new, old)
            if new != 'Stopped' then
                ChangeState( self, self.VisibleState )
                --self.MoveIntel = false
            --else
                --self.MoveIntel = true
            end
            SWalkingLandUnit.OnMotionHorzEventChange(self, new, old)
        end,
    },

    VisibleState = State() {
        Main = function(self)
            if self.Cloaked then
                self:DisableUnitIntel('RadarStealth')
			    self:DisableUnitIntel('Cloak')
                local bp = self:GetBlueprint()
                if bp.Display.CloakMeshBlueprint then
                    self:SetMesh(bp.Display.MeshBlueprint, true)
                end
    			self.Cloaked = false
			end
        end,

        OnMotionHorzEventChange = function(self, new, old)
            if new == 'Stopped' then
                ChangeState( self, self.InvisState )
                --self.MoveIntel = true
            --else
                --self.MoveIntel = false
            end
            SWalkingLandUnit.OnMotionHorzEventChange(self, new, old)
        end,
    },
}

TypeClass = SSL0404
