--------------------------------------------------------------------------------
--  Summary  :  UEF Tier 3 Power Generator Script
--------------------------------------------------------------------------------
local TEngineeringResourceStructureUnit = import('/lua/terranunits.lua').TEngineeringResourceStructureUnit

SEB1311 = Class(TEngineeringResourceStructureUnit) {

    ActiveState = State {
        Main = function(self)
            -- Play the "activate" sound
            local myBlueprint = self:GetBlueprint()
            if myBlueprint.Audio.Activate then
                self:PlaySound(myBlueprint.Audio.ActiveLoop)
            end
        end,
    },

    SetupBuildBones = function(self)
        TEngineeringResourceStructureUnit.SetupBuildBones(self)
        local bp = self:GetBlueprint().General
        self.BuildArmManipulator2 = CreateBuilderArmController(self, bp.BuildBones2.YawBone or 0 , bp.BuildBones2.PitchBone or 0, bp.BuildBones2.AimBone or 0):SetPrecedence(5):SetAimingArc(-180, 180, 360, -90, 90, 360)
        self.BuildArmManipulator3 = CreateBuilderArmController(self, bp.BuildBones3.YawBone or 0 , bp.BuildBones3.PitchBone or 0, bp.BuildBones3.AimBone or 0):SetPrecedence(5):SetAimingArc(-180, 180, 360, -90, 90, 360)
        self.BuildArmManipulator4 = CreateBuilderArmController(self, bp.BuildBones4.YawBone or 0 , bp.BuildBones4.PitchBone or 0, bp.BuildBones4.AimBone or 0):SetPrecedence(5):SetAimingArc(-180, 180, 360, -90, 90, 360)
    end,
}

TypeClass = SEB1311
