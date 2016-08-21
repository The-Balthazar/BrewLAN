#****************************************************************************
#**
#**  Summary  :  UEF Gunship Script
#**
#****************************************************************************

local EffectTemplate = import('/lua/EffectTemplates.lua') 
local EffectUtil = import('/lua/EffectUtilities.lua')
local TAirUnit = import('/lua/terranunits.lua').TAirUnit

TEA0001 = Class(TAirUnit) {
    EngineRotateBones = {'Jet_Front', 'Jet_Back',},
    
    OnCreate = function(self)
        TAirUnit.OnCreate(self)
        self:SetCapturable(false)
        --self:SetupBuildBones()
        --self:AddBuildRestriction( categories.UEF * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER) )
    end,
    
    OnStopBeingBuilt = function(self,builder,layer)
        TAirUnit.OnStopBeingBuilt(self,builder,layer)
        self.EngineManipulators = {}

        for key, value in self.EngineRotateBones do
            table.insert(self.EngineManipulators, CreateThrustController(self, "thruster", value))
        end

        -- set up the thursting arcs for the engines
        for key,value in self.EngineManipulators do
            --                          XMAX, XMIN, YMAX,YMIN, ZMAX,ZMIN, TURNMULT, TURNSPEED
            value:SetThrustingParam( -0.0, 0.0, -0.25, 0.25, -0.1, 0.1, 1.0,      0.25 )
        end
        for k, v in self.EngineManipulators do
            self.Trash:Add(v)
        end
        --if self:BeenDestroyed() then return end
        --self:BuildManipulatorSetEnabled(false)
        self:ForkThread(self.GiveInitialResources)
    end,
      
    CreateBuildEffects = function( self, unitBeingBuilt, order )
        if (order == 'Repair' and not unitBeingBuilt:IsBeingBuilt()) then
            EffectUtil.CreateDefaultBuildBeams( self, unitBeingBuilt, self:GetBlueprint().General.BuildBones.BuildEffectBones, self.BuildEffectsBag )
        else    
            EffectUtil.CreateDefaultBuildBeams( self, unitBeingBuilt, self:GetBlueprint().General.BuildBones.BuildEffectBones, self.BuildEffectsBag )
            --EffectUtil.CreateUEFCommanderBuildSliceBeams( self, unitBeingBuilt, self:GetBlueprint().General.BuildBones.BuildEffectBones, self.BuildEffectsBag )        
        end           
    end,
          
    GiveInitialResources = function(self)
        WaitTicks(5)
        self:GetAIBrain():GiveResource('Energy', self:GetBlueprint().Economy.StartingEnergy )
        self:GetAIBrain():GiveResource('Mass', self:GetBlueprint().Economy.StartingMass )
    end,
           
    PlayCommanderWarpInEffect = function(self)
        self:HideBone(0, true)
        --self:SetUnSelectable(true)
        --self:SetBusy(true)
        --self:SetBlockCommandQueue(true)
        self:ForkThread(self.WarpInEffectThread)
    end,
    
    WarpInEffectThread = function(self)
        self:PlayUnitSound('CommanderArrival')
        self:CreateProjectile( '/effects/entities/UnitTeleport01/UnitTeleport01_proj.bp', 0, 1.35, 0, nil, nil, nil):SetCollision(false)
        WaitSeconds(2.1)
        --self:SetMesh('/units/uel0001/UEL0001_PhaseShield_mesh', true)
        self:ShowBone(0, true)
        --self:HideBone('Right_Upgrade', true)
        --self:HideBone('Left_Upgrade', true)
        --self:HideBone('Back_Upgrade_B01', true)
        --self:SetUnSelectable(false)
        --self:SetBusy(false)
        --self:SetBlockCommandQueue(false)

        local totalBones = self:GetBoneCount() - 1
        local army = self:GetArmy()
        for k, v in EffectTemplate.UnitTeleportSteam01 do
            for bone = 1, totalBones do
                CreateAttachedEmitter(self,bone,army, v)
            end
        end

        WaitSeconds(6)
        --self:SetMesh(self:GetBlueprint().Display.MeshBlueprint, true)
    end,
}

TypeClass = TEA0001 
