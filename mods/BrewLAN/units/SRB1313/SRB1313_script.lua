--------------------------------------------------------------------------------
-- Summary  :  Cybran T3 Mass Fabricator
--------------------------------------------------------------------------------
local CMassFabricationUnit = import('/lua/cybranunits.lua').CMassFabricationUnit
local EffectUtil = import('/lua/EffectUtilities.lua')

local bpEco = __blueprints.srb1313.Economy
local Maintenance = bpEco.MaintenanceConsumptionPerSecondEnergy
local MaintenanceMass = Maintenance * (2/3)
local MaintenanceCloak = Maintenance * (1/3)

SRB1313 = Class(CMassFabricationUnit) {

    IntelEffects = {
        {
            Bones = {0},
            Offset = {0, 2, 0},
            Scale = 5,
            Type = 'Cloak01',
        },
    },

    MainToggle = function(self)
        self:SetEnergyMaintenanceConsumptionOverride((self.Production and MaintenanceMass or 0)+(self:IsIntelEnabled('Cloak') and MaintenanceCloak or 0))
        self:SetProductionPerSecondMass(self.Production and (bpEco.ProductionPerSecondMass or 0) * (self.MassProdAdjMod or 1) or 0)
        if self.Production or self.Shield then
            self:SetMaintenanceConsumptionActive()
        else
            self:SetMaintenanceConsumptionInactive()
        end
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        CMassFabricationUnit.OnStopBeingBuilt(self,builder,layer)

        self.Rotator = CreateRotator(self, 'Spinner', 'z')
        self.Rotator:SetAccel(10)
        self.Rotator:SetTargetSpeed(60)
        self.Trash:Add(self.Rotator)

        self.Production = true
        self:SetScriptBit('RULEUTC_CloakToggle', false)
        self:MainToggle(self)

        if __blueprints.srb1313.Display.CloakMeshBlueprint then
            self:ForkThread(
                function()
                    coroutine.yield(1)
                    self:UpdateCloakEffect(true, 'Cloak')
                end
            )
        end
    end,

    OnProductionUnpaused = function(self)
        CMassFabricationUnit.OnProductionUnpaused(self)
        self.Rotator:SetTargetSpeed(60)
        self.Production = true
        self:MainToggle(self)
    end,

    OnProductionPaused = function(self)
        CMassFabricationUnit.OnProductionPaused(self)
        self.Rotator:SetTargetSpeed(0)
        self.Production = nil
        self:MainToggle(self)
    end,

    OnIntelEnabled = function(self)
        CMassFabricationUnit.OnIntelEnabled(self)
        if self.IntelEffects and not self.IntelFxOn then
            self.IntelEffectsBag = {}
            self.CreateTerrainTypeEffects( self, self.IntelEffects, 'FXIdle',  self:GetCurrentLayer(), nil, self.IntelEffectsBag )
            self.IntelFxOn = true
        end
        self:MainToggle(self)
    end,

    OnIntelDisabled = function(self)
        CMassFabricationUnit.OnIntelDisabled(self)
        EffectUtil.CleanupEffectBag(self,'IntelEffectsBag')
        self.IntelFxOn = false
        self:MainToggle(self)
    end,

}

TypeClass = SRB1313
