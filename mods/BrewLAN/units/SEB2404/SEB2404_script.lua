#****************************************************************************
#**
#**  File     :  /cdimage/units/UEB2302/UEB2302_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Long Range Artillery Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TStructureUnit = import('/lua/terranunits.lua').TLandFactoryUnit
local TIFArtilleryWeapon = import('/lua/terranweapons.lua').TIFArtilleryWeapon    

SEB2404 = Class(TStructureUnit) {
    
    Weapons = {
        MainGun = Class(TIFArtilleryWeapon) {
            FxMuzzleFlashScale = 3,
            
            RackSalvoFireReadyState = State(TIFArtilleryWeapon.RackSalvoFireReadyState) {
                Main = function(self)
                    if self.unit.AmmoList[1] then
                        if self.unit.RepeatOrders and not self.unit.FactoryOrdersList then
                            self.unit.FactoryOrdersList = {}
                            for k, v in self.unit.AmmoList do
                                self.unit.FactoryOrdersList[k] = v
                            end
                        end
                        TIFArtilleryWeapon.RackSalvoFireReadyState.Main(self)
                    else
                        IssueClearCommands({self.unit})  
                        if self.unit.RepeatOrders and self.unit.FactoryOrdersList then
                            self.unit:PostFireOrders()   
                            self.unit.FactoryOrdersBackup = {} 
                            for k, v in self.unit.FactoryOrdersList do
                                self.unit.FactoryOrdersBackup[k] = v
                            end
                            self.unit.FactoryOrdersList = nil   
                        end     
                    end
                end,    
            },
                               
            CreateProjectileAtMuzzle = function(self, muzzle)   
                local proj = TIFArtilleryWeapon.CreateProjectileAtMuzzle(self, muzzle)
                local data = false
                if self.unit.AmmoList[1] then
                    local num = table.getn(self.unit.AmmoList)
                    data = self.unit.AmmoList[num]
                    table.remove(self.unit.AmmoList,num)
                end  
                self.unit:HideBone('DropPod', true)
                self.unit:AmmoStackThread()
                if proj and not proj:BeenDestroyed() then
                    proj:PassData(data)
                end
            end,   
        },          
    },
    
    PostFireOrders = function(self)
        for k, v in self.FactoryOrdersList do
            self:GetAIBrain():BuildUnit(self, v, 1)   
        end
    end,
             
    OnCreate = function(self)
        TStructureUnit.OnCreate(self)   
        self.Sync.Abilities = self:GetBlueprint().Abilities
        self.Sync.Abilities.TargetLocation.Active = true
        self:HideBone('DropPod', true)
        self.DropPod0Slider = CreateSlider(self, 'DropPod', 0, 0, 55, 100)
    end,
    
    OnStopBeingBuilt = function(self,builder,layer)
        TStructureUnit.OnStopBeingBuilt(self,builder,layer)   
        --CreateSlider(unit, bone, [goal_x, goal_y, goal_z, [speed,
        CreateSlider(self, 'AmmoExtender', 0, 0, 110, 100)
    end,
    
    OnStartBuild = function(self, unitBuilding, order)
        TStructureUnit.OnStartBuild(self, unitBuilding, order) 
        self.DropPod0Slider:SetGoal(0,0,55)
        unitBuilding:HideBone(0, true)          
    end,          

    OnStopBuild = function(self, unitBeingBuilt)
        if unitBeingBuilt:GetFractionComplete() == 1 then
            if not self.AmmoList then self.AmmoList = {} end
            table.insert(self.AmmoList,unitBeingBuilt:GetBlueprint().BlueprintId)
            unitBeingBuilt:Destroy()     
            self:AmmoStackThread()
        end
        TStructureUnit.OnStopBuild(self, unitBeingBuilt)
        if self.AmmoList[1] then
            if table.getn(self.AmmoList) >= self.FireNextOrders.count and self.RepeatOrders then
                IssueAttack({self}, self.FireNextOrders.target)
            end
        end
    end,     

    OnFailedToBuild = function(self)          
        self:AmmoStackThread()
        TStructureUnit.OnFailedToBuild(self)  
    end,
    
    OnScriptBitSet = function(self, bit)
        TStructureUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
            self.RepeatOrders = true
            FloatingEntityText(self:GetEntityId(),'<LOC floatingtextIVAN01>Repeating orders enabled')
        end
    end,

    OnScriptBitClear = function(self, bit)
        TStructureUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
            self.RepeatOrders = false   
            FloatingEntityText(self:GetEntityId(),'<LOC floatingtextIVAN02>Repeating orders disabled')
        end
    end,
    
    OnTargetLocation = function(self, location)                        
        
        --If there are already orders, and we are still set to repeat, assume we are updating the location for the same orders.
        if self.FireNextOrders and self.RepeatOrders and self.FactoryOrdersBackup[1] then
            self.FireNextOrders.target = location
            
            --If we are part way through the build, continue where we left off
            if self.AmmoList[1] then
                for k, v in self.FactoryOrdersBackup do
                    if not self.AmmoList[k] then
                        self:GetAIBrain():BuildUnit(self, v, 1)   
                    end
                end 
                      
            --And then double check we aren't already over the ammo count for some reason.
                if self.FireNextOrders.count < table.getn(self.AmmoList) then
                    self.FireNextOrders.count = table.getn(self.AmmoList)
                end
            
            --Otherwise we need to redo the whole list
            else     
                for k, v in self.FactoryOrdersList do
                    self:GetAIBrain():BuildUnit(self, v, 1)  
                end
            end
        
        --If there is no ammo, set to fire on repeat of whatever the first thing built is.     
        elseif not self.AmmoList[1] then
            self.FireNextOrders = {
                count = 1,
                target = location,
            }
        
        --Otherwise we probably have a load, and no orders, so FIRE ZE CANNON.
        else
            self.FireNextOrders = {
                count = table.getn(self.AmmoList),
                target = location,
            }
            IssueAttack({self}, location)
        end
        
        --Regardless, we want repeat on now.
        if not self.RepeatOrders then
            self:SetScriptBit('RULEUTC_WeaponToggle', true)
        end
    end,
    
    AmmoStackThread = function(self)
        local ammocount = 0
        if self.AmmoList then
            ammocount = table.getn(self.AmmoList)
        end 
        if not self.AmmoStackGoals then
            self.AmmoStackGoals = {
                ["DropPod001"] = 55,
                ["DropPod002"] = 110,
                ["DropPod003"] = 165,
            }
            self.AmmoSliders = {}
            for k, v in self.AmmoStackGoals do
                self.AmmoSliders[k] = CreateSlider(self, k, 0, 0, v, 100)
            end
        end
        for k, v in self.AmmoSliders do
            v:SetGoal(0,0,self.AmmoStackGoals[k] - math.min(ammocount, 4) * 55)
        end
        if ammocount > 0 then 
            self:ShowBone('DropPod', true)
            self.DropPod0Slider:SetGoal(0,0,0)
        elseif ammocount == 0 then
            self.DropPod0Slider:SetGoal(0,0,55)  
        end
    end,
    
    OnKilled = function(self, instigator, type, overkillRatio)
        if self.AmmoList[1] then
            for k,v in self.AmmoList do  
                local pos = self:GetPosition()
                local dude = CreateUnitHPR(v,self:GetArmy(),pos[1] + math.random(-2,2), pos[2], pos[3] + math.random(-2,2),0 , math.random(0,360), 0)
                local health = math.min(math.max((math.random(-300,100)/100)+(dude:GetHealth()/4500),0),1) * math.min(math.random(0,120)/100,1)
                if health == 0 then
                    dude:Kill()
                else          
                    dude:SetHealth(dude,dude:GetHealth()*health)
                end
            end
            self.AmmoList = {}
        end
        TStructureUnit.OnKilled(self, instigator, type, overkillRatio)
    end,
    
    OnDestroy = function(self)
        if self.AmmoList[1] then
            for k,v in self.AmmoList do  
                local pos = self:GetPosition()
                CreateUnitHPR(v,self:GetArmy(),pos[1] + math.random(-2,2), pos[2], pos[3] + math.random(-2,2),0, math.random(0,360), 0)
            end
        end
        TStructureUnit.OnDestroy(self)
    end,
}

TypeClass = SEB2404
