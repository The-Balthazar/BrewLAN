#****************************************************************************
#**
#**  File     :  /cdimage/units/XSB2302/XSB2302_script.lua
#**  Author(s):  Drew Staltman, Jessica St. Croix, Gordon Duclos, Aaron Lundquist
#**
#**  Summary  :  Seraphim Long Range Artillery Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local SStructureUnit = import('/lua/seraphimunits.lua').SStructureUnit
local SIFSuthanusArtilleryCannon = import('/lua/seraphimweapons.lua').SIFSuthanusArtilleryCannon

SSB2404 = Class(SStructureUnit) {
    Weapons = {
        MainGun = Class(SIFSuthanusArtilleryCannon) {
            CreateProjectileAtMuzzle = function(self, muzzle)
                local proj = SIFSuthanusArtilleryCannon.CreateProjectileAtMuzzle(self, muzzle)
                local data = self:GetBlueprint().ShieldDamage
                if proj and not proj:BeenDestroyed() then
                    proj:PassData(data)
                end
            end,
               
            PlayRackRecoil = function(self, rackList)   
                SIFSuthanusArtilleryCannon.PlayRackRecoil(self, rackList)
                if not self.Rotator then
                    self.Rotator = CreateRotator(self.unit, 'Spinner', 'x')
                end
                self.Rotator:SetSpeed(240)
                if not self.Goal then
                    self.Goal = 360
                end
                self.Goal = self.Goal - 120
                if self.Goal <= 0 then
                    self.Goal = 360
                end 
                self.Rotator:SetGoal(self.Goal)
            end, 
        },
    },
}
TypeClass = SSB2404