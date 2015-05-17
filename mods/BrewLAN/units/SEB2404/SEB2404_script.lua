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
                    LOG("DUUUUUUDE ARE WE READY TO FIRE?")  
                    if self.unit.AmmoList[1] then
                        TIFArtilleryWeapon.RackSalvoFireReadyState.Main(self)
                    else
                        IssueStop({self.unit})
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
                self.unit.DropPod0Slider:SetGoal(0,0,55)  
                self.unit:AmmoStackThread()
                if proj and not proj:BeenDestroyed() then
                    proj:PassData(data)
                end
            end,
        },
    },
             
    OnCreate = function(self)
        TStructureUnit.OnCreate(self)   
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
        unitBuilding:HideBone(0, true)
    end,          

    OnStopBuild = function(self, unitBeingBuilt)
        if unitBeingBuilt:GetFractionComplete() == 1 then
            if not self.AmmoList then self.AmmoList = {} end
            table.insert(self.AmmoList,unitBeingBuilt:GetBlueprint().BlueprintId)
            unitBeingBuilt:Destroy() 
            --self:tprint(self.AmmoList)     
            self:AmmoStackThread()
        end
        TStructureUnit.OnStopBuild(self, unitBeingBuilt)    
    end,     

    OnFailedToBuild = function(self)
        TStructureUnit.OnFailedToBuild(self)  
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
        end
    end,
    
    OnKilled = function(self, instigator, type, overkillRatio)
        if self.AmmoList[1] then
            for k,v in self.AmmoList do  
                local pos = self:GetPosition()
                local dude = CreateUnitHPR(v,self:GetArmy(),pos[1] + math.random(-2,2), pos[2], pos[3] + math.random(-2,2),0 , math.random(0,360), 0)
                local health = math.min(math.max((math.random(-300,100)/100)+(dude:GetHealth()/4500),0),1) * math.min(math.random(0,120)/100,1)  
                LOG(health)  
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
    
    tprint = function(self, tbl, indent)
        if not indent then indent = 0 end
        for k, v in pairs(tbl) do
            formatting = string.rep("  ", indent) .. k .. ": "
            if type(v) == "table" then
                LOG(formatting)
                self:tprint(v, indent+1)
            elseif type(v) == 'boolean' then
                LOG(formatting .. tostring(v))		
            elseif type(v) == 'string' or type(v) == 'number' then
                LOG(formatting .. v)
            else
                LOG(formatting .. type(v))
            end
        end
    end,
}

TypeClass = SEB2404