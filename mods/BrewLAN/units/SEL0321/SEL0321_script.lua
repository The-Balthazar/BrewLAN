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
--local nukeFiredOnGotTarget = false

SEL0321 = Class(TLandUnit) {
    Weapons = {
        AntiNuke = Class(TAMInterceptorWeapon) {
            RackSalvoFireReadyState = State(TAMInterceptorWeapon.RackSalvoFireReadyState) {
                Main = function(self)
                    if self.unit:GetTacticalSiloAmmoCount() < 3 then
                        self:ForkThread(
                            function(self)
                                WaitTicks(1)
                                if self.unit:GetTacticalSiloAmmoCount() > 2 then
                                    --Last minute panic check, not sure if it will actually work, very hard to test chance to test it
                                    TAMInterceptorWeapon.RackSalvoFireReadyState.Main(self)
                                end
                            end
                        ) 
                        return
                    else
                        TAMInterceptorWeapon.RackSalvoFireReadyState.Main(self)
                    end
                end,    
            },
        },
    },
    
    --[[OnStopBeingBuilt = function(self,builder,layer)
        TLandUnit.OnStopBeingBuilt(self,builder,layer)
        self:ForkThread(
            function(self)
                WaitSeconds(1)
                LOG(self:GetTacticalSiloAmmoCount())
            end
        )
    end,]]--
}

TypeClass = SEL0321
