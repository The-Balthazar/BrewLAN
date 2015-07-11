local CrateUnitOld = Unit

--[[
Unit = Class(CrateUnitOld) {    
    OnCreate = function(self)  
        --Should this have legs?
        
        --Leg entity script
        local CRATES = function(self, floatation, size)  
            self.Cratething = import('/lua/sim/Entity.lua').Entity({Owner = self,})
            Warp(self.Cratething,self:GetPosition())
            --self.Floatation:AttachBoneTo( -1, self, 0 )
            self.Cratething:SetMesh('/mods/cratedrop/effects/entities/' .. floatation .. '/' .. floatation ..'_mesh')
            self.Cratething:SetDrawScale(size)
            self.Cratething:SetVizToAllies('Intel')
            self.Cratething:SetVizToNeutrals('Intel')
            self.Cratething:SetVizToEnemies('Intel')         
            self.Trash:Add(self.Cratething)
        end
        --Which legs?
        CRATES(self, 'CRATE_Dodecahedron', 0.083)
        CrateUnitOld.OnCreate(self)      
    end,
}
]]--