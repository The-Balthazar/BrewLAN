local CLandUnit = import('/lua/cybranunits.lua').CDirectionalWalkingLandUnit
local CDFRocketIridiumWeapon = import('/lua/cybranweapons.lua').CDFRocketIridiumWeapon

SRL0311 = Class(CLandUnit) {
    Weapons = {
        MainGun = Class(CDFRocketIridiumWeapon) {
            FxMuzzleFlash = {
                '/effects/emitters/cybran_artillery_muzzle_flash_01_emit.bp',
                '/effects/emitters/cybran_artillery_muzzle_flash_02_emit.bp',
                '/effects/emitters/cybran_artillery_muzzle_smoke_01_emit.bp',
            },
            CreateProjectileAtMuzzle = function(self, muzzle)
                CDFRocketIridiumWeapon.CreateProjectileAtMuzzle(self, muzzle)
                if not self.RecoilManipulators then self.RecoilManipulators = {} end
                --LOG(self.CurrentRackSalvoNumber)
                if muzzle == 'Missile_001' then
                    self.MissileNo = 0
                    if self.RecoilManipulatorThreads then
                        for k, v in self.RecoilManipulatorThreads do
                            KillThread(v)
                            v:Destroy()
                        end
                    end
                    self.RecoilManipulatorThreads = {}
                    --Pretty sure this results in thread accumulation still, but at this point a million iterations and STRESS.
                else
                    self.MissileNo = self.MissileNo + 1
                end
                local missile = muzzle--'Missile_Slider' .. string.sub(muzzle, -4, -1)
                if not self.RecoilManipulators[missile] then
                    self.RecoilManipulators[missile] = CreateSlider(self.unit, missile )
                end
                self.RecoilManipulators[missile]:SetGoal(0, -0.75, -13):SetSpeed(-1)
                table.insert( self.RecoilManipulatorThreads,
                    self:ForkThread(
                        function(self, no)
                            coroutine.yield((8*no)+1)
                            if self.RecoilManipulators[missile] then
                                self.RecoilManipulators[missile]:SetSpeed(12):SetGoal(0, 0, 0)
                            end
                        end,
                        self.MissileNo
                    )
                )
            end,
        }
    },
}

TypeClass = SRL0311
