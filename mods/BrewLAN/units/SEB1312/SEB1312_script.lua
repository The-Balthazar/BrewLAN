#****************************************************************************
#**
#**  File     :  /cdimage/units/UEB1302/UEB1302_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Tier 3 Mass Extractor Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TEngineeringResourceStructureUnit = import('/mods/brewlan/lua/uefunits.lua').TEngineeringResourceStructureUnit  

SEB1312 = Class(TEngineeringResourceStructureUnit) {
    
    
    PlayActiveAnimation = function(self)
        TEngineeringResourceStructureUnit.PlayActiveAnimation(self)
        if not self.AnimationManipulator then
            self.AnimationManipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator)
        end
        self.AnimationManipulator:PlayAnim(self:GetBlueprint().Display.AnimationOpen, true)
    end,

    OnStartBuild = function(self, unitBeingBuilt, order)
        TEngineeringResourceStructureUnit.OnStartBuild(self, unitBeingBuilt, order)
        if not self.AnimationManipulator then return end
        self.AnimationManipulator:SetRate(0)
        self.AnimationManipulator:Destroy()
        self.AnimationManipulator = nil
    end,

    OnProductionPaused = function(self)
        TEngineeringResourceStructureUnit.OnProductionPaused(self)
        if not self.AnimationManipulator then return end
        self.AnimationManipulator:SetRate(0)
    end,

    OnProductionUnpaused = function(self)
        TEngineeringResourceStructureUnit.OnProductionUnpaused(self)
        if not self.AnimationManipulator then return end
        self.AnimationManipulator:SetRate(1)
    end,
}

TypeClass = SEB1312