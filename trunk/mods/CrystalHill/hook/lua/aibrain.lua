-- aibrain.lua (hooked)--
-- Author      : Daniel Teh
-- Description :
--
-- Copyright © 2007 Gas Powered Games - All rights reserved

AIBrain = Class(AIBrain) {
    SpawnCrystal = function(self)
        local factionIndex = self:GetFactionIndex()
        
        local crystal =  { { 'ZPC0002', 1 }, }  
        
        local posX = ScenarioInfo.size[1]/2
        local posY = ScenarioInfo.size[2]/2

        if crystal then
            # place land units down
            for j, u in crystal do
                
                local count = 0
                while count < u[2] do
                    local unit = self:CreateUnitNearSpot(u[1], posX, posY)
                    count = count + 1
                    unit:CreateTarmac(true,true,true,false,false)
                    --unit:ForkThread(unit.WarpIn)
                end
                
            end
        end
        
        self.PreBuilt = true
    end,
}