local CLandUnit = import('/lua/cybranunits.lua').CLandUnit
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
                if muzzle == 'Turret_Muzzle_001' then
                    if self.RecoilManipulatorThreads then
                        for k, v in self.RecoilManipulatorThreads do
                            KillThread(v)
                            v:Destroy()
                        end
                    end
                    self.RecoilManipulatorThreads = {}
                    --Pretty sure this results in thread accumulation still, but at this point a million iterations and STRESS.  
                end
                local missile = 'Missile' .. string.sub(muzzle, -4, -1) 
                if not self.RecoilManipulators[missile] then 
                    self.RecoilManipulators[missile] = CreateSlider(self.unit, missile )
                end
                self.RecoilManipulators[missile]:SetGoal(0, 0, -.9)
                self.RecoilManipulators[missile]:SetSpeed(-1)
                table.insert( self.RecoilManipulatorThreads,
                    self:ForkThread(
                        function(self)
                            WaitFor(self.RecoilManipulators[missile])
                            self.RecoilManipulators[missile]:SetSpeed(.06)
                            self.RecoilManipulators[missile]:SetGoal(0, 0, 0)
                        end
                    )
                )
            end,
        }
    },
}

TypeClass = SRL0311