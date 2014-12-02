#****************************************************************************
#**
#**  File     :  /cdimage/units/XSC9002/XSC9002_script.lua
#**  Author   :  Greg Kohne
#**  Summary  :  Jamming Crystal
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local SStructureUnit = import('/lua/seraphimunits.lua').SStructureUnit

ZPC0001 = Class(SStructureUnit) {

    OnCreate = function(self, builder, layer)
        self:ForkThread(self.TeamChange)
        SStructureUnit.OnCreate(self)
    end,
              
    TeamChange = function(self)
        local pos = self:GetPosition()   
        local aiBrain = self:GetAIBrain()
        local radius = self:GetBlueprint().Intel.VisionRadius or 20
        while true do
            if aiBrain:GetNoRushTicks() == 0 then   
                --First check anyone is actually nearby   
                local Units = aiBrain:GetUnitsAroundPoint( categories.ALLUNITS, pos, radius)
                local UnitNo = self.Count(self, Units)
                if UnitNo != 0 then
                    --Then check there if there are no teammates
                    Units = aiBrain:GetUnitsAroundPoint( categories.ALLUNITS, pos, radius, 'Ally' )
                    UnitNo = self.Count(self, Units)
                    if UnitNo == 0 then
                        Units = aiBrain:GetUnitsAroundPoint( categories.ALLUNITS, pos, radius, 'Enemy' ) 
                        --self.Winner(self, Units)
                        if not Units[1]:IsDead() then
                            --Award control to someone alive nearby. First one detected.     
                            ChangeUnitArmy(self,Units[1]:GetArmy())
                        end
                    end
                end     
                WaitSeconds(1)
            else
                WaitSeconds(10)
            end          
        end
    end,
    
    Count = function(self, units)    
        local count = 0
        for k, v in units do
            if v:GetEntityId() != self:GetEntityId() and not v:IsDead() and not EntityCategoryContains( categories.WALL, v ) then
                count = count + 1
            end
        end
        return count
    end,
    
    Winner = function(self, units)    
        local count = {}
        for k, v in units do
            if v:GetEntityId() != self:GetEntityId() and not v:IsDead() and not EntityCategoryContains( categories.WALL, v ) then
                if not count[v:GetArmy()] then count[v:GetArmy()] = 0 end
                count[v:GetArmy()] = count[v:GetArmy()] + 1
                LOG(v:GetArmy()," ",count[v:GetArmy()]," ",v:GetAIBrain():GetArmyIndex())
            end
        end
        --return count
        --self.tprint(count)
    end,  
    
    OnDamage = function()
    end,   
}
TypeClass = ZPC0001