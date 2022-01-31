local AMassFabricationUnit = import('/lua/aeonunits.lua').AMassFabricationUnit

local bpEco = __blueprints.sab1313.Economy
local Maintenance = bpEco.MaintenanceConsumptionPerSecondEnergy
local MaintenanceMass = Maintenance * (35/38)
local MaintenanceShield = Maintenance * (3/38)

local function YeetBag(self, bag)
    if self[bag] then
        for k, v in self[bag] do
            v:Destroy()
        end
    end
end

SAB1313 = Class(AMassFabricationUnit) {

    ShieldEffects = {
        '/effects/emitters/aeon_shield_generator_t2_01_emit.bp',
        '/effects/emitters/aeon_shield_generator_t3_03_emit.bp',
        '/effects/emitters/aeon_shield_generator_t3_04_emit.bp',
    },

    ManipulatorsToggle = function(self)
        local active = self.Production and {
            {'B01', 'x', 45},
            {'B02', 'x', -45},
            {'B03', 'y', Random(60, 100)},
            {'B04', 'z', Random(60, 100)},
            {'B04', 'y', Random(60, 100)},
            {'B04', 'x', Random(60, 100)},
        }
        for i = 1, 6 do
            if active and not (self.Manipulators and self.Manipulators[i]) then
                self.Manipulators = self.Manipulators or {}
                self.Manipulators[i] = CreateRotator(self, active[i][1], active[i][2], nil, 0, 15, active[i][3])
                self.Trash:Add(self.Manipulators[i])
            elseif self.Manipulators then
                self.Manipulators[i]:SetSpinDown(not active)
                if active then
                    self.Manipulators[i]:SetTargetSpeed(active[i][3])
                end
            end
        end
    end,

    MainToggle = function(self)
        self:SetEnergyMaintenanceConsumptionOverride((self.Production and MaintenanceMass or 0)+(self.Shield and MaintenanceShield or 0))
        self:SetProductionPerSecondMass(self.Production and (bpEco.ProductionPerSecondMass or 0) * (self.MassProdAdjMod or 1) or 0)
        self['SetMaintenanceConsumption'..((self.Production or self.Shield) and 'Active' or 'Inactive')](self)
    end,

    OnStopBeingBuilt = function(self, builder, layer)
        AMassFabricationUnit.OnStopBeingBuilt(self, builder, layer)
        self.Production, self.Shield = true, true
        self:ManipulatorsToggle()
        self:MainToggle()
    end,

    OnProductionPaused = function(self)
        AMassFabricationUnit.OnProductionPaused(self)
        self.Production = nil
        self:ManipulatorsToggle()
        self:MainToggle()
    end,

    OnProductionUnpaused = function(self)
        AMassFabricationUnit.OnProductionUnpaused(self)
        self.Production = true
        self:ManipulatorsToggle()
        self:MainToggle()
    end,

    OnShieldEnabled = function(self)
        AMassFabricationUnit.OnIntelEnabled(self)
        self.Shield = true
        YeetBag(self, 'ShieldEffectsBag')
        self.ShieldEffectsBag = {}
        local army = self:GetArmy()
        for k, v in self.ShieldEffects do
            table.insert( self.ShieldEffectsBag, CreateAttachedEmitter( self, 0, army, v ):ScaleEmitter(0.4) )
        end
        self:MainToggle()
    end,

    OnShieldDisabled = function(self)
        AMassFabricationUnit.OnIntelDisabled(self)
        self.Shield = nil
        YeetBag(self, 'ShieldEffectsBag')
        self:MainToggle()
    end,
}

TypeClass = SAB1313
