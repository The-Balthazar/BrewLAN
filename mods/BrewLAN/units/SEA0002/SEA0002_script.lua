local TAirUnit = import('/lua/terranunits.lua').TAirUnit
local VizMarker = import('/lua/sim/VizMarker.lua').VizMarker

SEA0002 = Class(TAirUnit) {
    DestroyNoFallRandomChance = 0,

    HideBones = { 'Shell01', 'Shell02', 'Shell03', 'Shell04', },

    OnKilled = function(self, instigator, type, overkillRatio)
        if self.IsDying then
            return
        end
        self.IsDying = true
        self.Parent.Satellite = nil
        self.Parent:Rebuild()
        TAirUnit.OnKilled(self, instigator, type, overkillRatio)
    end,

    Open = function(self)
        ChangeState( self, self.OpenState )
    end,

    OpenState = State() {
        Main = function(self)
            self:SetMaintenanceConsumptionActive()
            self.OpenAnim = CreateAnimator(self)
            self.OpenAnim:PlayAnim( '/units/XEA0002/xea0002_aopen01.sca' )
            self.Trash:Add( self.OpenAnim )
            WaitFor( self.OpenAnim )

            self.OpenAnim:PlayAnim( '/units/XEA0002/xea0002_aopen02.sca' )

            for k,v in self.HideBones do
                self:HideBone( v, true )
            end
        end,
    },

    OnIntelEnabled = function(self)
        TAirUnit.OnIntelEnabled(self)
        self:SetIntelRadius('vision', self:GetBlueprint().Intel.VisionRadius)
        self:SetMaintenanceConsumptionActive()
    end,

    OnIntelDisabled = function(self)
        TAirUnit.OnIntelDisabled(self)
        self:SetIntelRadius('vision', 5)
        self:SetMaintenanceConsumptionInactive()
    end,
}
TypeClass = SEA0002
