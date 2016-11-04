local CLandUnit = import('/lua/cybranunits.lua').CLandUnit
local CAAMissileNaniteWeapon = import('/lua/cybranweapons.lua').CAAMissileNaniteWeapon
local EffectUtil = import('/lua/EffectUtilities.lua')

SRL0320 = Class(CLandUnit) {

    IntelEffects = {
        {
            Bones = {
            	0,
            },
            Offset = {
              	0,
              	1,
              	0,
            },
            Type = 'Jammer01',
        },
    },
    
    Weapons = {
        MainGun = Class(CAAMissileNaniteWeapon) {     
            CreateProjectileAtMuzzle = function(self, muzzle)
                if self.unit:IsIntelEnabled('Cloak') then
                    self.unit:SetMaintenanceConsumptionInactive()
                    self.unit:SetScriptBit('RULEUTC_CloakToggle', true)
                    self.unit:DisableUnitIntel('Cloak')
                    self.unit:RequestRefreshUI()			
                    self.unit.IntelWasOn = true
                end
                CAAMissileNaniteWeapon.CreateProjectileAtMuzzle(self, muzzle)   
            end,  
            OnWeaponFired = function(self)
                if self.unit.IntelWasOn then
                    self.unit:SetMaintenanceConsumptionActive()
                    self.unit:SetScriptBit('RULEUTC_CloakToggle', false)
                    self.unit:EnableUnitIntel('Cloak')
                    self.unit:RequestRefreshUI()			
                    self.unit.IntelWasOn = false
                end 
                CAAMissileNaniteWeapon.OnWeaponFired(self)  
            end,
        },
    },
    OnStopBeingBuilt = function(self,builder,layer)
        CLandUnit.OnStopBeingBuilt(self,builder,layer)
        if self:GetAIBrain().BrainType == 'Human' then
            self:SetMaintenanceConsumptionInactive()
            self:SetScriptBit('RULEUTC_CloakToggle', true)
            self:RequestRefreshUI()
        else
            self:SetMaintenanceConsumptionActive()
            self:SetScriptBit('RULEUTC_CloakToggle', false)
            self:EnableUnitIntel('Cloak')
            self:RequestRefreshUI()   
        end
    end,
    
    
    OnIntelEnabled = function(self) 
        self:PlaySound(self:GetBlueprint().Audio.Cloak)
        CLandUnit.OnIntelEnabled(self)
        if self.IntelEffects and not self.IntelFxOn then
            self.IntelEffectsBag = {}
            self.CreateTerrainTypeEffects( self, self.IntelEffects, 'FXIdle',  self:GetCurrentLayer(), nil, self.IntelEffectsBag )
            self.IntelFxOn = true
        end
    end,

    OnIntelDisabled = function(self)
        self:PlaySound(self:GetBlueprint().Audio.Decloak)
        CLandUnit.OnIntelDisabled(self)
        EffectUtil.CleanupEffectBag(self,'IntelEffectsBag')
        self.IntelFxOn = false
    end,
}

TypeClass = SRL0320
