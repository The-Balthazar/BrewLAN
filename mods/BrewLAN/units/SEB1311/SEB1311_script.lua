#****************************************************************************
#**
#**  File     :  /cdimage/units/UEB1301/UEB1301_script.lua
#**  Author(s):  John Comes, Dave Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Tier 3 Power Generator Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TEngineeringResourceStructureUnit = import('/mods/brewlan/lua/uefunits.lua').TEngineeringResourceStructureUnit    

SEB1311 = Class(TEngineeringResourceStructureUnit) {

    ActiveState = State {
        Main = function(self)
            # Play the "activate" sound
            local myBlueprint = self:GetBlueprint()
            if myBlueprint.Audio.Activate then
                self:PlaySound(myBlueprint.Audio.ActiveLoop)
            end
        end,
    },

    SetupBuildBones = function(self)       
        TEngineeringResourceStructureUnit.SetupBuildBones(self) 
        local bp = self:GetBlueprint()
        self.BuildArmManipulator2 = CreateBuilderArmController(self, bp.General.BuildBones2.YawBone or 0 , bp.General.BuildBones2.PitchBone or 0, bp.General.BuildBones2.AimBone or 0)
        self.BuildArmManipulator3 = CreateBuilderArmController(self, bp.General.BuildBones3.YawBone or 0 , bp.General.BuildBones3.PitchBone or 0, bp.General.BuildBones3.AimBone or 0)
        self.BuildArmManipulator4 = CreateBuilderArmController(self, bp.General.BuildBones4.YawBone or 0 , bp.General.BuildBones4.PitchBone or 0, bp.General.BuildBones4.AimBone or 0)
        self.BuildArmManipulator2:SetAimingArc(-180, 180, 360, -90, 90, 360)
        self.BuildArmManipulator3:SetAimingArc(-180, 180, 360, -90, 90, 360)
        self.BuildArmManipulator4:SetAimingArc(-180, 180, 360, -90, 90, 360)
        self.BuildArmManipulator2:SetPrecedence(5)
        self.BuildArmManipulator3:SetPrecedence(5)
        self.BuildArmManipulator4:SetPrecedence(5)
        self.Trash:Add(self.BuildArmManipulator2)   
        self.Trash:Add(self.BuildArmManipulator3)
        self.Trash:Add(self.BuildArmManipulator4)
    end,
}

TypeClass = SEB1311