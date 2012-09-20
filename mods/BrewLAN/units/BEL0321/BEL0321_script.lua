#****************************************************************************
#**
#**  File     :  /data/units/XEL0306/XEL0306_script.lua
#**  Author(s):  Jessica St. Croix, Dru Staltman
#**
#**  Summary  :  UEF Mobile Missile Platform Script
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TLandUnit = import('/lua/terranunits.lua').TLandUnit
local TAMInterceptorWeapon = import('/lua/terranweapons.lua').TAMInterceptorWeapon
local nukeFiredOnGotTarget = false

BEL0321 = Class(TLandUnit) {
    Weapons = {
        AntiNuke = Class(TAMInterceptorWeapon) {
            IdleState = State(TAMInterceptorWeapon.IdleState) {
                OnGotTarget = function(self)
                    local bp = self:GetBlueprint()
                    #only say we've fired if the parent fire conditions are met
                    if (bp.WeaponUnpackLockMotion != true or (bp.WeaponUnpackLocksMotion == true and not self.unit:IsUnitState('Moving'))) then
                        if (bp.CountedProjectile == false) or self:CanFire() then
                             nukeFiredOnGotTarget = true
                        end
                    end
                    TAMInterceptorWeapon.IdleState.OnGotTarget(self)
                end,
                # uses OnGotTarget, so we shouldn't do this.
                OnFire = function(self)
                    if not nukeFiredOnGotTarget then
                        TAMInterceptorWeapon.IdleState.OnFire(self)
                    end
                    nukeFiredOnGotTarget = false
                    
                    self:ForkThread(function()
                        self.unit:SetBusy(true)
                        WaitSeconds(1/self.unit:GetBlueprint().Weapon[1].RateOfFire + .2)
                        self.unit:SetBusy(false)
                    end)
                end,
            },    
        },
    },
}

TypeClass = BEL0321