#****************************************************************************
#**
#**  File     :  /cdimage/units/UEB2205/UEB2205_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Heavy Torpedo Launcher Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TStructureUnit = import('/lua/terranunits.lua').TStructureUnit
local TANTorpedoAngler = import('/lua/terranweapons.lua').TANTorpedoAngler

SEB2308 = Class(TStructureUnit) {

    UpsideDown = false,

    Weapons = {
         Torpedo = Class(TANTorpedoAngler) {
       },
    },     
    
    HideLandBones = function(self)  
        TStructureUnit.HideLandBones(self)     
        local pos = self:GetPosition()
        if pos[2] != 17.5 then
            for k, v in self.LandBuiltHiddenBones do
                if self:IsValidBone(v) then
                    self:HideBone(v, true)
                end
            end
        end
        LOG(pos[2])
    end,
}

TypeClass = SEB2308