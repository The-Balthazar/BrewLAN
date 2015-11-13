#****************************************************************************
#**
#**  File     :  /cdimage/units/UEB0304/UEB0304_script.lua
#**  Author(s):  John Comes, David Tomandl, Gordon Duclos
#**
#**  Summary  :  UEF Quantum Gate Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TQuantumGateUnit = import('/lua/terranunits.lua').TQuantumGateUnit
TEC0000 = Class(TQuantumGateUnit) {

	GateEffectVerticalOffset = 0.35,
	GateEffectScale = 0.42,

    OnStopBeingBuilt = function(self,builder,layer)
        self.GateEffectEntity = import('/lua/sim/Entity.lua').Entity()
        self.GateEffectEntity:AttachBoneTo(-1, self,'UEB0304')
        self.GateEffectEntity:SetMesh('/effects/entities/ForceField01/ForceField01_mesh')
        self.GateEffectEntity:SetDrawScale(self.GateEffectScale)
        self.GateEffectEntity:SetParentOffset(Vector(0,0,self.GateEffectVerticalOffset))
        self.GateEffectEntity:SetVizToAllies('Intel')
        self.GateEffectEntity:SetVizToNeutrals('Intel')
        self.GateEffectEntity:SetVizToEnemies('Intel')          
        self.Trash:Add(self.GateEffectEntity)
    
        CreateAttachedEmitter(self,'Left_Gate_FX',self:GetArmy(),'/effects/emitters/terran_gate_01_emit.bp')
        CreateAttachedEmitter(self,'Right_Gate_FX',self:GetArmy(),'/effects/emitters/terran_gate_01_emit.bp')
                
        TQuantumGateUnit.OnStopBeingBuilt(self, builder, layer)
        self:BuildThings()
    end,
    
    BuildThings = function(self)
        local buildorder = self:GetBlueprint().Economy.BuildOrder
        self.Build = (self.Build or 0) + 1
        if buildorder[self.Build].Wait then
            self:ForkThread(function()
                WaitSeconds(buildorder[self.Build].Wait)
                self:BuildThings()
            end)
        elseif buildorder[self.Build].Message then
            --MESSAGE GOES HERE
            self:BuildThings()
        elseif buildorder[self.Build] then
            self.BuildQuantity = math.random(buildorder[self.Build][2], buildorder[self.Build][3] or buildorder[self.Build][2])
            self:GetAIBrain():BuildUnit(self,buildorder[self.Build][1], self.BuildQuantity )
        end
    end,
    
    OnStopBuild = function(self, unitBeingBuilt)     
        TQuantumGateUnit.OnStopBuild(self, unitBeingBuilt)    
        if unitBeingBuilt:GetFractionComplete() == 1 then
            unitBeingBuilt.Target = self.Target
            self.BuildQuantity = self.BuildQuantity - 1
            if self.BuildQuantity < 1 then
                self:BuildThings()
            end
        end        
    end,     
}

TypeClass = TEC0000