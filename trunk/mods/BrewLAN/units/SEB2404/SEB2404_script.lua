#****************************************************************************
#**
#**  File     :  /cdimage/units/UEB2302/UEB2302_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Long Range Artillery Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TStructureUnit = import('/lua/terranunits.lua').TStructureUnit
local TIFArtilleryWeapon = import('/lua/terranweapons.lua').TIFArtilleryWeapon

SEB2404 = Class(TStructureUnit) {
    Weapons = {
        MainGun = Class(TIFArtilleryWeapon) {
            FxMuzzleFlashScale = 3,
            
            IdleState = State(TIFArtilleryWeapon.IdleState) {
                OnGotTarget = function(self)
                    TIFArtilleryWeapon.IdleState.OnGotTarget(self)
                    if not self.ArtyAnim then
                        self.ArtyAnim = CreateAnimator(self.unit)
                        self.ArtyAnim:PlayAnim(self.unit:GetBlueprint().Display.AnimationOpen)
                        self.unit.Trash:Add(self.ArtyAnim)
                    end
                end,
            },
        }
    },
}

TypeClass = SEB2404