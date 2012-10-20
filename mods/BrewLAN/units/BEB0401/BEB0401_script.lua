#****************************************************************************
#**
#**  File     :  /cdimage/units/UEB0301/UEB0301_script.lua
#**  Author(s):  David Tomandl
#**
#**  Summary  :  Terran Unit Script
#**
#**  Copyright © 2006 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TLandFactoryUnit = import('/lua/terranunits.lua').TLandFactoryUnit

BEB0401 = Class(TLandFactoryUnit) {

    OnLayerChange = function(self, new, old)
        TLandFactoryUnit.OnLayerChange(self, new, old)
        if new == 'Land' then
#            self:RestoreBuildRestrictions()
            self:AddBuildRestriction(categories.NAVAL)
            self:RequestRefreshUI()
        elseif new == 'Water' then
#            self:RestoreBuildRestrictions()
            self:AddBuildRestriction(categories.LAND)
            self:RequestRefreshUI()     
        end
    end,
}

TypeClass = BEB0401