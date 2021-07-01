local TAirUnit = import('/lua/defaultunits.lua').BrewLANGeoSatelliteUnit
local VizMarker = import('/lua/sim/VizMarker.lua').VizMarker

SEA4301 = Class(TAirUnit) {
    DestroyNoFallRandomChance = 0,

    OnCreate = function(self)
        TAirUnit.OnCreate(self)
        self:SetScriptBit('RULEUTC_JammingToggle', true)
        self:RemoveToggleCap('RULEUTC_JammingToggle')
    end,

    OpenState = State(TAirUnit.OpenState) {
        Main = function(self)
            TAirUnit.OpenState.Main(self)
            self:AddToggleCap('RULEUTC_JammingToggle')
            self:SetScriptBit('RULEUTC_JammingToggle', false)
        end,
    },

    OnIntelEnabled = function(self)
        TAirUnit.OnIntelEnabled(self)
        if not self.Hologram then
            self.Hologram = {}
            local pos = self:GetPosition()
            local army = self:GetArmy()
            for i = 1, 3 do
                local x,z = pos[1] + Random(-10, 10), pos[3] + Random(-10, 10)
                local y = GetTerrainHeight(x,z)
                self.Hologram[i] = CreateUnitHPR('sea4302', army, x, y, z, 0, 0, 0)
            end
            IssueGuard(self.Hologram, self)
        end
    end,

    OnIntelDisabled = function(self)
        TAirUnit.OnIntelDisabled(self)
        if self.Hologram then
            for i, v in self.Hologram do
                v:Destroy()
            end
            self.Hologram = nil
        end
    end,
}

TypeClass = SEA4301
