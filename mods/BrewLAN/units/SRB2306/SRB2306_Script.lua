#****************************************************************************
#**
#**  Summary  :  Cybran Maser Tower Script
#**
#****************************************************************************

local CStructureUnit = import('/lua/cybranunits.lua').CStructureUnit
local CDFHeavyMicrowaveLaserGeneratorCom = import('/lua/cybranweapons.lua').CDFHeavyMicrowaveLaserGeneratorCom
local explosion = import('/lua/defaultexplosions.lua') 

SRB2306 = Class(CStructureUnit) {   
    Weapons = {
        MainGun = Class(CDFHeavyMicrowaveLaserGeneratorCom) {  
            EconomySupportsBeam = function(self)     
                if not self.EnergyCost then
                    self.EnergyInc = self:GetBlueprint().EnergyCumulativeUpkeepCost or 10
                    self.EnergyMin = self:GetBlueprint().EnergyConsumptionPerSecondMin or 10
                    self.EnergyMax = self:GetBlueprint().EnergyConsumptionPerSecondMax or 1000
                    self.EnergyDissRate = self:GetBlueprint().EnergyDissipationPerSecond or 30
                    self.EnergyCost = self.EnergyMin                 
                end
                self.TimeSinceLastFire = GetGameTimeSeconds() - (self.unit.StopFireTime or GetGameTimeSeconds())
                local aiBrain = self.unit:GetAIBrain()
                local energyIncome = aiBrain:GetEconomyIncome( 'ENERGY' ) * 10 # per tick to per seconds
                local energyStored = aiBrain:GetEconomyStored( 'ENERGY' )
                local nrgReq = self.EnergyCost * (self.AdjEnergyMod or 1)
                local nrgDrain = self.EnergyCost
                local nrgReqAlt = (math.max(self.EnergyMin, self.EnergyCost - math.floor((self.TimeSinceLastFire*self.EnergyDissRate)/10)*10)) * (self.AdjEnergyMod or 1)
                local nrgDrainAlt = math.max(self.EnergyMin, self.EnergyCost - math.floor((self.TimeSinceLastFire*self.EnergyDissRate)/10)*10)
                self.unit.deathdamage = nrgDrainAlt      
                if self.unit.PerformOnFireChecks then 
                    if energyStored < nrgReqAlt and energyIncome < nrgDrainAlt then
                        return false
                    end      
                else   
                    if energyStored < nrgReq and energyIncome < nrgDrain then
                        return false
                    end
                    if nrgDrain > self.EnergyMax then   
                        self.ForceCooldown = true
                        self.unit:Overheat()
                        return false
                    end      
                end
                if self.ForceCooldown and nrgDrainAlt > (self.EnergyMax / 2) then
                    return false
                else
                    self.ForceCooldown = false
                    self.unit.isexploding = false
                end
                return true    
            end,  
            
            IdleState = State(CDFHeavyMicrowaveLaserGeneratorCom.IdleState) { 
                 Main = function(self)      
                    if self.RotatorManip then
                        self.RotatorManip:SetSpeed(0)
                    end
                    if self.SliderManip then
                        self.SliderManip:SetGoal(0,0,0)
                        self.SliderManip:SetSpeed(2)
                    end        
                    CDFHeavyMicrowaveLaserGeneratorCom.IdleState.Main(self)
                    
                    if self.PerformIdleChecks then
                        self.FirstShot = true
                        self.unit.StopFireTime = GetGameTimeSeconds()
                        self.PerformIdleChecks = false 
                        self.unit.PerformOnFireChecks = true
                    end
                end,    
            },
                       
            StartEconomyDrain = function(self)
                local bp = self:GetBlueprint()
                if not self.EconDrain and not self:EconomySupportsBeam() then
                    return
                end
                if self.FirstShot then return end  
                if not self.EconDrain then               
                    if self.unit.PerformOnFireChecks then
                        self.EnergyCost = math.max(self.EnergyMin, self.EnergyCost - math.floor((self.TimeSinceLastFire*self.EnergyDissRate)/10)*10)
                        self.unit.PerformOnFireChecks = false
                    end  
                    local nrgReq = self.EnergyCost * (self.AdjEnergyMod or 1)
                    local nrgDrain = self.EnergyCost
                    if self > 0 and nrgDrain > 0 then
                        local time = math.max(nrgReq / nrgDrain, 0.1)                  
                        self.EconDrain = CreateEconomyEvent(self.unit, nrgReq, 0, time)   
                        self.FirstShot = true
                    end
                end
            end,
            
            CreateProjectileAtMuzzle = function(self, muzzle) 
                if not self.SliderManip then
                    self.SliderManip = CreateSlider(self.unit, 'Center_Turret_Barrel')
                    self.unit.Trash:Add(self.SliderManip)
                end
                if not self.RotatorManip then
                    self.RotatorManip = CreateRotator(self.unit, 'Center_Turret_Barrel', 'z')
                    self.unit.Trash:Add(self.RotatorManip)
                end
                self.RotatorManip:SetSpeed(180)
                self.SliderManip:SetPrecedence(11)
                self.SliderManip:SetGoal(0, 0, -1)
                self.SliderManip:SetSpeed(-1)  
                CDFHeavyMicrowaveLaserGeneratorCom.CreateProjectileAtMuzzle(self, muzzle)  
                    
                self.EnergyCost = self.EnergyCost + self.EnergyInc 
                self.PerformIdleChecks = true    
            end,
        },
    },
    Overheat = function(self)
        if not self.isexploding then
            self.isexploding = true
            CreateEmitterAtBone(self, 'Turret_Muzzle01', self:GetArmy(),'/effects/emitters/destruction_explosion_fire_plume_02_emit.bp'):ScaleEmitter( 0.33 )
            CreateEmitterAtBone(self, 'Turret_Muzzle01', self:GetArmy(),'/effects/emitters/destruction_damaged_smoke_01_emit.bp'):SetEmitterParam('LIFETIME', 150):ScaleEmitter( 0.6 )
            CreateEmitterAtBone(self, 'Turret_Muzzle01', self:GetArmy(),'/effects/emitters/destruction_damaged_smoke_01_emit.bp'):SetEmitterParam('LIFETIME', 120)
            
            DamageArea(self, self:GetPosition(), 1, 500, 'Default', true, true)
            explosion.CreateDefaultHitExplosionAtBone( self, 'Turret_Muzzle01', 1.0 )
            explosion.CreateDebrisProjectiles(self, explosion.GetAverageBoundingXYZRadius(self), {self:GetUnitSizes()})
        end
    end,
    
    OnKilled = function(self, instigator, type, overkillRatio)
        
        if self.PerformOnFireChecks then
            self.deathdamage = self.deathdamage - (GetGameTimeSeconds() - (self.StopFireTime or GetGameTimeSeconds()))*30
        end
        local radius = 3 * self.deathdamage/1000
        DamageArea(self, self:GetPosition(), radius, self.deathdamage, 'Default', true, true)
        explosion.CreateDefaultHitExplosionAtBone( self, 0, radius )
        explosion.CreateDebrisProjectiles(self, explosion.GetAverageBoundingXYZRadius(self), {self:GetUnitSizes()})
        CStructureUnit.OnKilled(self, instigator, type, overkillRatio)
    end, 
}

TypeClass = SRB2306
