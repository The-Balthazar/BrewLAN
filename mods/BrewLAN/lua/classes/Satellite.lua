--------------------------------------------------------------------------------
-- Copyright : Sean 'Balthazar' Wheeldon
-- Geosynchronous satellite with orbital decay without uplink
--------------------------------------------------------------------------------
local BrewLANGetSatFuelRatio = math.max(ScenarioInfo.size[1], ScenarioInfo.size[2]) / 4096
local AirUnit = import('/lua/defaultunits.lua').AirUnit

GeoSatelliteUnit = Class(AirUnit) {

    OnStopBeingBuilt = function(self, ...)
        AirUnit.OnStopBeingBuilt(self, unpack(arg) )
        --Less fuel for smaller maps. Max fuel only on 81k.
        self:SetFuelRatio(BrewLANGetSatFuelRatio)
    end,

    OpenState = State() {
        Main = function(self)
            self.OpenAnim = CreateAnimator(self)
            self.Trash:Add( self.OpenAnim )

            local bp = __blueprints[self.BpId] or self:GetBlueprint()

            if bp.Display and bp.Display.AnimationOpenStage1 then
                self.OpenAnim:PlayAnim( bp.Display.AnimationOpenStage1 )
                WaitFor( self.OpenAnim )
            end

            if bp.Display and bp.Display.AnimationOpenHideBones then
                for k, v in bp.Display.AnimationOpenHideBones do
                    self:HideBone( v, true )
                end
            end

            if bp.Display and bp.Display.AnimationOpenStage2 then
                self.OpenAnim:PlayAnim( bp.Display.AnimationOpenStage2 )
                WaitFor( self.OpenAnim )
            end
        end,
    },

    StartUnguidedOrbitalDecay = function(self)
        if not self.UnguidedOrbitalDecay then
            self.UnguidedOrbitalDecay = self:ForkThread(
                function(self)
                    local pos = self:GetPosition()
                    while not self.Dead do
                        self:OnDamage(self, 2, pos, 'Decay')
                        coroutine.yield(2)
                    end
                end
            )
        end
    end,

    StopUnguidedOrbitalDecay = function(self)
        if self.UnguidedOrbitalDecay then
            KillThread(self.UnguidedOrbitalDecay)
            self.UnguidedOrbitalDecay = nil
        end
    end,

    OnRunOutOfFuel = function(self)
        AirUnit.OnRunOutOfFuel(self)
        self:SetSpeedMult(self:GetBlueprint().Physics.NoFuelSpeedMult)
        self:SetAccMult(1)
        self:SetTurnMult(1)
    end,

    OnLayerChange = function(self, new, old)
        AirUnit.OnLayerChange(self, new, old)
        if new == 'Air' and self:GetFractionComplete() == 1 then
            ChangeState( self, self.OpenState )
        end
    end,
}
