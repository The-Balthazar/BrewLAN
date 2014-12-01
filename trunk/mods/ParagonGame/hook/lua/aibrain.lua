-- aibrain.lua (hooked)--
-- Author      : Daniel Teh
-- Description :
--
-- Copyright © 2007 Gas Powered Games - All rights reserved

AIBrain = Class(AIBrain) {
    SpawnParagonUnits = function(self)
        local factionIndex = self:GetFactionIndex()
        
        local paragonunits = nil
        local airunits = nil
                
        local posX, posY = self:GetArmyStartPos()

        if factionIndex == 1 then

		    paragonunits = { { 'PEB1401', 1 },
		                  { 'UEB4301', 4 }, }
		                                      
		    landunits = { { 'UEL0301', 1 }, }
                        
        elseif factionIndex == 2 then

		    paragonunits = { { 'XAB1401', 1 },
		                  { 'UAB4301', 4 }, }    
		                                      
		    landunits = { { 'UAL0301', 1 }, }

        elseif factionIndex == 3 then

		    paragonunits = { { 'PRB1401', 1 },
		                  { 'URB4207', 4 }, }   
		                                      
		    landunits = { { 'URL0301', 1 }, }

	    elseif factionIndex == 4 then

		    paragonunits = { { 'PSB1401', 1 },
		                  { 'XSB4301', 4 }, } 
		                                      
		    landunits = { { 'XSL0301', 1 }, }

        end

	    if paragonunits then
		    # place land units down
		    for j, u in paragonunits do
		    
		        local count = 0
		        while count < u[2] do
                    local unit = self:CreateUnitNearSpot(u[1], posX, posY - 20)
                    count = count + 1
                    unit:CreateTarmac(true,true,true,false,false)
                end
                
		    end
	    end

	    if landunits then
		    # place air units down
		    for j, u in landunits do
		    
		        local count = 0
		        while count < u[2] do
                    local unit = self:CreateUnitNearSpot(u[1], posX, posY)
                    count = count + 1
                end
                
		    end
	    end

	    self.PreBuilt = true
    end,
    
    RestrictParagonUnits = function(self, strArmy)     
          AddBuildRestriction(strArmy,categories.xab1401)
          AddBuildRestriction(strArmy,categories.peb1401)
          AddBuildRestriction(strArmy,categories.prb1401)
          AddBuildRestriction(strArmy,categories.psb1401)   
    end,
    
}