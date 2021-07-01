local TAirUnit = import('/lua/defaultunits.lua').BrewLANGeoSatelliteUnit
local VizMarker = import('/lua/sim/VizMarker.lua').VizMarker
local OffsetBoneToTerrain = import('../../lua/terrainutils.lua').OffsetBoneToTerrain

SEA3301 = Class(TAirUnit) {
    DestroyNoFallRandomChance = 0,

    OnCreate = function(self)
        TAirUnit.OnCreate(self)
        self:SetScriptBit('RULEUTC_IntelToggle', true)
        self:RemoveToggleCap('RULEUTC_IntelToggle')
    end,

    OpenState = State(TAirUnit.OpenState) {
        Main = function(self)
            TAirUnit.OpenState.Main(self)
            self:CreateVisEntity()
            self:AddToggleCap('RULEUTC_IntelToggle')
            self:SetScriptBit('RULEUTC_IntelToggle', false)
        end,
    },

    OnIntelEnabled = function(self)
        TAirUnit.OnIntelEnabled(self)
        if self.VisEntity then
            self.VisEntity:SetIntelRadius('vision', self.VisEntity.Radius)
            self.VisEntity:EnableIntel('WaterVision')
        end
    end,

    OnIntelDisabled = function(self)
        TAirUnit.OnIntelDisabled(self)
        if self.VisEntity then
            self.VisEntity:SetIntelRadius('vision', 0)
            self.VisEntity:DisableIntel('WaterVision')
        end
    end,

    CreateVisEntity = function(self)
        local pos = self:GetPosition()
        local bp = self:GetBlueprint().Intel
        self.VisEntity = VizMarker({
            X = pos[1],
            Z = pos[3],
            Radius = bp.OrbitIntelRadius or 45,
            LifeTime = -1,
            Omni = bp.OrbitOmni or false,
            Radar = bp.OrbitRadar or false,
            Sonar = bp.OrbitSonar or false,
            Vision = bp.OrbitVision or true,
            WaterVision = bp.OrbitWaterVision or true,
            Army = self:GetAIBrain():GetArmyIndex(),
        })
        self.VisEntity:AttachTo(self, 'VisEntity')
        self.VisEntity.Radius = bp.OrbitIntelRadius
        self.Trash:Add(self.VisEntity)
        OffsetBoneToTerrain(self, 'VisEntity')
    end,
}

TypeClass = SEA3301
