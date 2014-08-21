#****************************************************************************
#**
#**  Summary  :  Cybran Maser Tower Script
#**
#****************************************************************************

local CStructureUnit = import('/lua/cybranunits.lua').CStructureUnit
local CDFHeavyMicrowaveLaserGeneratorCom = import('/lua/cybranweapons.lua').CDFHeavyMicrowaveLaserGeneratorCom 

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
                self.TimeSinceLastFire = GetGameTimeSeconds() - (self.StopFireTime or GetGameTimeSeconds())
                local aiBrain = self.unit:GetAIBrain()
                local energyIncome = aiBrain:GetEconomyIncome( 'ENERGY' ) * 10 # per tick to per seconds
                local energyStored = aiBrain:GetEconomyStored( 'ENERGY' )
                local nrgReq = self.EnergyCost * (self.AdjEnergyMod or 1)
                local nrgDrain = self.EnergyCost
                local nrgReqAlt = (math.max(self.EnergyMin, self.EnergyCost - math.floor((self.TimeSinceLastFire*self.EnergyDissRate)/10)*10)) * (self.AdjEnergyMod or 1)
                local nrgDrainAlt = math.max(self.EnergyMin, self.EnergyCost - math.floor((self.TimeSinceLastFire*self.EnergyDissRate)/10)*10)
                      
                if self.PerformOnFireChecks then 
                    if energyStored < nrgReqAlt and energyIncome < nrgDrainAlt then
                        return false
                    end      
                else   
                    if energyStored < nrgReq and energyIncome < nrgDrain then
                        return false
                    end
                    if nrgDrain > self.EnergyMax then   
                        self.ForceCooldown = true
                        -- Insert casual setting on fire effects here.
                        return false
                    end      
                end
                if self.ForceCooldown and nrgDrainAlt > (self.EnergyMax / 2) then
                    return false
                else
                    self.ForceCooldown = false
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
                        self.StopFireTime = GetGameTimeSeconds()
                        self.PerformIdleChecks = false 
                        self.PerformOnFireChecks = true
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
                    if self.PerformOnFireChecks then
                        self.EnergyCost = math.max(self.EnergyMin, self.EnergyCost - math.floor((self.TimeSinceLastFire*self.EnergyDissRate)/10)*10)
                        self.PerformOnFireChecks = false
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
}

TypeClass = SRB2306