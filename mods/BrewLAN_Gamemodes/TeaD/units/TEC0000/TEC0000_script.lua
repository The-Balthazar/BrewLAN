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
        local buildorder = {
            'tec0001',
            'tec0002',
            'tec0003',
        }
        for i, v in buildorder do
            self:GetAIBrain():BuildUnit(self,v,math.random(8,12) ) 
        end
    end,  
       
    OnStopBuild = function(self, unitBeingBuilt)     
        TQuantumGateUnit.OnStopBuild(self, unitBeingBuilt)    
        IssueMove({unitBeingBuilt}, {ScenarioInfo.size[1]/2, 0, ScenarioInfo.size[2]/2})      
    end,    
}

TypeClass = TEC0000