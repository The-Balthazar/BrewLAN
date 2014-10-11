#****************************************************************************
#**
#**  File     :  /cdimage/units/UAB1303/UAB1303_script.lua
#**  Author(s):  Jessica St. Croix, David Tomandl, John Comes
#**
#**  Summary  :  Aeon T3 Mass Fabricator
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AMassFabricationUnit = import('/lua/aeonunits.lua').AMassFabricationUnit

SAB1313 = Class(AMassFabricationUnit) {
         
    ShieldEffects = {
        '/effects/emitters/aeon_shield_generator_t2_01_emit.bp',
        --'/effects/emitters/aeon_shield_generator_t2_02_emit.bp',
        '/effects/emitters/aeon_shield_generator_t3_03_emit.bp',
        '/effects/emitters/aeon_shield_generator_t3_04_emit.bp',
    },
    
    OnStopBeingBuilt = function(self, builder, layer)  
	     self.ShieldEffectsBag = {}
        AMassFabricationUnit.OnStopBeingBuilt(self, builder, layer)  
        self.Prodon = true
        self.Shield = true  
        self:SetEnergyMaintenanceConsumptionOverride(self:GetBlueprint().Economy.MaintenanceConsumptionPerSecondEnergyFab + self:GetBlueprint().Economy.MaintenanceConsumptionPerSecondEnergyShield or 3000)
        self:SetProductionPerSecondMass((self:GetBlueprint().Economy.ProductionPerSecondMass or 0) * (self.MassProdAdjMod or 1))
        #B04 = parent, B03 = ball, B01/2 = rings
        #CreateRotator(unit, bone, axis, [goal], [speed], [accel], [goalspeed])
        local num = self:GetRandomDir()
        self.RingManip1 = CreateRotator(self, 'B01', 'x', nil, 0, 15, 45)
        self.Trash:Add(self.RingManip1)
        self.RingManip2 = CreateRotator(self, 'B02', 'x', nil, 0, 15, -45)
        self.Trash:Add(self.RingManip2)
        self.BallManip = CreateRotator(self, 'B03', 'y', nil, 0, 15, 80 + Random(0, 20) * num)
        self.Trash:Add(self.BallManip)
        self.ParentManip1 = CreateRotator(self, 'B04', 'z', nil, 0, 15, 80 + Random(0, 20) * num)
        self.Trash:Add(self.ParentManip1)
        self.ParentManip2 = CreateRotator(self, 'B04', 'y', nil, 0, 15, 80 + Random(0, 20) * num)
        self.Trash:Add(self.ParentManip2)
        self.ParentManip3 = CreateRotator(self, 'B04', 'x', nil, 0, 15, 80 + Random(0, 20) * num)
        self.Trash:Add(self.ParentManip3)
    end,

    OnProductionPaused = function(self)
        AMassFabricationUnit.OnProductionPaused(self)       
        self.Prodon = false
        local num = self:GetRandomDir()   
        self.RingManip1:SetSpinDown(true)
        self.RingManip2:SetSpinDown(true)
        self.BallManip:SetSpinDown(true)
        self.BallManip:SetTargetSpeed(80 + Random(0, 20) * num)
        self.ParentManip1:SetSpinDown(true)
        self.ParentManip1:SetTargetSpeed(80 + Random(0, 20) * num)
        self.ParentManip2:SetSpinDown(true)
        self.ParentManip2:SetTargetSpeed(80 + Random(0, 20) * num)
        self.ParentManip3:SetSpinDown(true)
        self.ParentManip3:SetTargetSpeed(80 + Random(0, 20) * num)    
        if self.Shield then
          	self:SetEnergyMaintenanceConsumptionOverride(self:GetBlueprint().Economy.MaintenanceConsumptionPerSecondEnergyShield or 375)
          	self:SetProductionPerSecondMass(0)
          	self:SetMaintenanceConsumptionActive()
        else
        	   self:SetEnergyMaintenanceConsumptionOverride(0)
            self:SetMaintenanceConsumptionInactive()  
        end
    end,
    
    OnProductionUnpaused = function(self)
        AMassFabricationUnit.OnProductionUnpaused(self)     
        self.Prodon = true
        self.RingManip1:SetSpinDown(false)
        self.RingManip2:SetSpinDown(false)
        self.BallManip:SetSpinDown(false)
        self.ParentManip1:SetSpinDown(false)
        self.ParentManip2:SetSpinDown(false)
        self.ParentManip3:SetSpinDown(false) 
		if self.Shield then
			self:SetEnergyMaintenanceConsumptionOverride(self:GetBlueprint().Economy.MaintenanceConsumptionPerSecondEnergyFab + self:GetBlueprint().Economy.MaintenanceConsumptionPerSecondEnergyShield or 3000)
			self:SetProductionPerSecondMass((self:GetBlueprint().Economy.ProductionPerSecondMass or 0) * (self.MassProdAdjMod or 1))
			self:SetMaintenanceConsumptionActive()  
		else
			self:SetEnergyMaintenanceConsumptionOverride(self:GetBlueprint().Economy.MaintenanceConsumptionPerSecondEnergyFab or 2625)
			self:SetProductionPerSecondMass((self:GetBlueprint().Economy.ProductionPerSecondMass or 0) * (self.MassProdAdjMod or 1))
			self:SetMaintenanceConsumptionActive()  
		end
    end,
            
    OnShieldEnabled = function(self)
        AMassFabricationUnit.OnIntelEnabled(self)
        self.Shield = true
        if self.ShieldEffectsBag then
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
            self.ShieldEffectsBag = {}
        end
        for k, v in self.ShieldEffects do
            table.insert( self.ShieldEffectsBag, CreateAttachedEmitter( self, 0, self:GetArmy(), v ):ScaleEmitter(0.4) )
        end
        if self.Prodon then
            self:SetEnergyMaintenanceConsumptionOverride(self:GetBlueprint().Economy.MaintenanceConsumptionPerSecondEnergyFab + self:GetBlueprint().Economy.MaintenanceConsumptionPerSecondEnergyShield or 3000)
            self:SetProductionPerSecondMass((self:GetBlueprint().Economy.ProductionPerSecondMass or 0) * (self.MassProdAdjMod or 1))
            self:SetMaintenanceConsumptionActive()  
        else
            self:SetEnergyMaintenanceConsumptionOverride(self:GetBlueprint().Economy.MaintenanceConsumptionPerSecondEnergyShield or 375)
            self:SetProductionPerSecondMass(0)
            self:SetMaintenanceConsumptionActive()  
        end
    end,

    OnShieldDisabled = function(self)
        AMassFabricationUnit.OnIntelDisabled(self)
        self.Shield = false   
        if self.ShieldEffectsBag then
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
            self.ShieldEffectsBag = {}
        end
        if self.Prodon then
            self:SetEnergyMaintenanceConsumptionOverride(self:GetBlueprint().Economy.MaintenanceConsumptionPerSecondEnergyFab or 2625)
            self:SetProductionPerSecondMass((self:GetBlueprint().Economy.ProductionPerSecondMass or 0) * (self.MassProdAdjMod or 1))
            self:SetMaintenanceConsumptionActive()  
        else
            self:SetEnergyMaintenanceConsumptionOverride(0) 
            self:SetMaintenanceConsumptionInactive()  
        end
    end,    

    GetRandomDir = function(self)
        local num = Random(0, 2)
        if num > 1 then
            return 1
        end
        return -1
    end,
}

TypeClass = SAB1313