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
            self:AddBuildRestriction(categories.NAVAL)
            self:AddBuildRestriction(categories.AIR)
            self:RequestRefreshUI()
        elseif new == 'Water' then
            self:AddBuildRestriction(categories.LAND)
            self:AddBuildRestriction(categories.AIR)
            self:RequestRefreshUI()     
        end
    end,

    OnScriptBitSet = function(self, bit)
        TLandFactoryUnit.OnScriptBitSet(self, bit)
        if bit == 1 then
            self:RestoreBuildRestrictions()
            self:AddBuildRestriction(categories.NAVAL)
            self:AddBuildRestriction(categories.LAND)
        end
    end,

    OnScriptBitClear = function(self, bit)
        TLandFactoryUnit.OnScriptBitClear(self, bit)
        if bit == 1 then	    
	    if self:GetCurrentLayer() == 'Land' then
                self:RestoreBuildRestrictions()
	        self:AddBuildRestriction(categories.NAVAL)
	        self:AddBuildRestriction(categories.AIR)
	        self:RequestRefreshUI()
	    elseif self:GetCurrentLayer() == 'Water' then
                self:RestoreBuildRestrictions()
	        self:AddBuildRestriction(categories.LAND)
	        self:AddBuildRestriction(categories.AIR)
	        self:RequestRefreshUI()     
	    end
        end
    end,

    StartBuildFx = function(self, unitBeingBuilt)
        if not unitBeingBuilt then
            unitBeingBuilt = self:GetFocusUnit()
        end
        
        # Start build process
        if not self.BuildAnimManip then
            self.BuildAnimManip = CreateAnimator(self)
            self.BuildAnimManip:PlayAnim(self:GetBlueprint().Display.AnimationBuild, true):SetRate(0)
            self.Trash:Add(self.BuildAnimManip)
        end

        self.BuildAnimManip:SetRate(1)
    end,
    
    StopBuildFx = function(self)
        if self.BuildAnimManip then
            self.BuildAnimManip:SetRate(0)
        end
    end,
    
    OnPaused = function(self)
        LandFactoryUnit.OnPaused(self)
        self:StopBuildFx(self:GetFocusUnit())
    end,

    OnUnpaused = function(self)
        LandFactoryUnit.OnUnpaused(self)
        if self:IsUnitState('Building') then
            self:StartBuildFx(self:GetFocusUnit())
        end
    end,
}

TypeClass = BEB0401