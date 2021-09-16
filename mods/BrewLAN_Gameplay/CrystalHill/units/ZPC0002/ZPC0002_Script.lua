--------------------------------------------------------------------------------
--  Summary:  The neutral crystal script
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
local SStructureUnit = import('/lua/seraphimunits.lua').SStructureUnit
local VizMarker = import('/lua/sim/VizMarker.lua').VizMarker

ZPC0002 = Class(SStructureUnit) {

    OnCreate = function(self, builder, layer)
        self:HideBone(0,true)
        local aiBrain = self:GetAIBrain()
        if not ScenarioInfo.Crystal.FirstCapture then
            ScenarioInfo.Crystal = {}
            ScenarioInfo.Crystal.FirstCapture = true
        end
        self:ForkThread(self.TeamChange)
        SStructureUnit.OnCreate(self)
        self:ForkThread(self.WarpInEffectThread)
        for i, brain in ArmyBrains do
            self.Trash:Add(VizMarker({
                X = self:GetPosition()[1],
                Z = self:GetPosition()[3],
                Radius = self:GetBlueprint().Intel.VisionRadius or 20,
                LifeTime = -1,
                Army = brain:GetArmyIndex(),
                Omni = false,
                Radar = false,
            }))
        end
    end,

    WarpInEffectThread = function(self)
        self:CreateProjectile( '/effects/entities/UnitTeleport01/UnitTeleport01_proj.bp', 0, 1.35, 0, nil, nil, nil):SetCollision(false)
        WaitTicks(22)
        self:ShowBone(0, true)

        local UnitTeleportSteam01 = import('/lua/EffectTemplates.lua').UnitTeleportSteam01
        local totalBones = self:GetBoneCount() - 1
        local army = self:GetArmy()

        for k, v in UnitTeleportSteam01 do
            for bone = 1, totalBones do
                CreateAttachedEmitter(self,bone,army, v)
            end
        end

        WaitSeconds(6)
    end,

    TeamChange = function(self)
        local aiBrain = self:GetAIBrain()
        local pos = self:GetPosition()
        local radius = self:GetBlueprint().Intel.VisionRadius or 20
        local Units
        while true do
            local Units = aiBrain:GetUnitsAroundPoint(categories.SELECTABLE - categories.WALL - categories.SATELLITE - categories.UNTARGETABLE, pos, radius)
            while aiBrain:GetNoRushTicks() ~= 0 do
                -- Just in case the map has a spawn in the middle
                WaitSeconds(10)
            end
            if Units then
                for i,v in Units do
                    local civilian = false
                    for name,data in ScenarioInfo.ArmySetup do
                        if name == v:GetAIBrain().Name then
                            civilian = data.Civilian
                            break
                        end
                    end
                    if v:GetEntityId() ~= self:GetEntityId() and not civilian then
                        pos = self:GetPosition()
                        CreateUnitHPR('ZPC0001',v:GetArmy(), pos[1],pos[2],pos[3],0,0,0)
                        self:Destroy()
                    end
                end
            end
            WaitSeconds(1)
        end
    end,

    OnDamage = function()
    end,

    OnKilled = function()
    end,
}

TypeClass = ZPC0002
