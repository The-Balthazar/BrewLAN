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
            
            #IdleState = State(TIFArtilleryWeapon.IdleState) {
            #    OnGotTarget = function(self)
            #        TIFArtilleryWeapon.IdleState.OnGotTarget(self)
            #        if not self.ArtyAnim then
            #            self.ArtyAnim = CreateAnimator(self.unit)
            #            self.ArtyAnim:PlayAnim(self.unit:GetBlueprint().Display.AnimationOpen)
            #            self.unit.Trash:Add(self.ArtyAnim)
            #        end
            #    end,
            #},
        },
    },

    BuildAttachBone = 'Box059',
           
    OnStopBeingBuilt = function(self,builder,layer)
        TStructureUnit.OnStopBeingBuilt(self,builder,layer)
        
        #CreateSlider(unit, bone, [goal_x, goal_y, goal_z, [speed,
        CreateSlider(self, 'AmmoExtender', 0, 0, 110, 100)
        LOG("FUCKING DOOR ASdTO OTHER WORLDS")
    end,

    OnFailedToBuild = function(self)
        TStructureUnit.OnFailedToBuild(self)
    end,
    
    OnStartBuild = function(self, unitBuilding, order)
        TStructureUnit.OnStartBuild(self, unitBuilding, order)
        unitBuilding:HideBone(0, true)
    end,
    --},
         
    --BuildingState = State {
     --   Main = function(self)
      --      local unitBuilding = self.UnitBeingBuilt
       --     self:SetBusy(true)
        --    local bone = self.BuildAttachBone
         --   self:DetachAll(bone)
          --  unitBuilding:HideBone(0, true)
           -- self.UnitDoneBeingBuilt = false
        --end,
    
    AmmoStackThread = function(self)
        if not self.AmmoStackGoals then
            self.AmmoStackGoals = {
            } 
        end
        if table.getn(self.AmmoList) then
        
        end
    end,


    OnStopBuild = function(self, unitBeingBuilt)
        if unitBeingBuilt:GetFractionComplete() == 1 then
            if not self.AmmoList then self.AmmoList = {} end
            table.insert(self.AmmoList,unitBeingBuilt:GetBlueprint().BlueprintId)
            unitBeingBuilt:Destroy() 
            self:tprint(self.AmmoList)
        end
        TStructureUnit.OnStopBuild(self, unitBeingBuilt)    
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