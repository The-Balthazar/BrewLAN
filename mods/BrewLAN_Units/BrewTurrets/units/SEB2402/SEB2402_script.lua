local TStructureUnit = import('/lua/terranunits.lua').TStructureUnit
local MaelstromDeathLaser = import('/lua/sim/defaultweapons.lua').MaelstromDeathLaser

SEB2402 = Class(TStructureUnit) {
    Weapons = {
        MainGun = Class(MaelstromDeathLaser){
            OnCreate = function(self)
                if not self.DamageModifiers then
                    self.DamageModifiers = {}
                end
                self.DamageModifiers.HealthNerf = 1
                MaelstromDeathLaser.OnCreate(self)
            end,

            CreateProjectileAtMuzzle = function(self, muzzle)
                self.DamageModifiers.HealthNerf = 0.1 + (self.unit:GetHealthPercent() * 0.9)
                MaelstromDeathLaser.CreateProjectileAtMuzzle(self, muzzle)
            end,

            PlayFxBeamStart = function(self, muzzle)
                MaelstromDeathLaser.PlayFxBeamStart(self, muzzle)
                if not self.CrystalBeams then
                    self.CrystalBeams = {}
                end
                local bones = {'Generator', 'Crystal', self:GetBlueprint().RackBones[1].RackBone}
                local army = self.unit:GetArmy()
                for i = 1, 2 do
                    table.insert(self.CrystalBeams, AttachBeamEntityToEntity(self.unit, bones[i], self.unit, bones[i + 1], army, '/effects/emitters/build_beam_01_emit.bp'))
                end
            end,

            PlayFxBeamEnd = function(self, beam)
                MaelstromDeathLaser.PlayFxBeamEnd(self, beam)
                if self.CrystalBeams then
                    for i, beam in self.CrystalBeams do
                        beam:Destroy()
                        beam = nil
                    end
                end
            end,
        },
    },

    OnCreate = function(self)
        TStructureUnit.OnCreate(self)
        local pos = self:GetPosition()
        self.GeneratorCollision = CreateUnitHPR('ZZZ2402',self:GetArmy(),pos[1],pos[2],pos[3],0,0,0)
        self.GeneratorCollision.Parent = self
    end,

    OnDestroy = function(self)
        self.GeneratorCollision:Destroy()
        TStructureUnit.OnDestroy(self)
    end,

    OnStopBeingBuilt = function(self, builder, layer)
        TStructureUnit.OnStopBeingBuilt(self, builder, layer)
        local army = self:GetArmy()
        if not self.BeamEffectsBag then self.BeamEffectsBag = {} end
        for i, v in {'A', 'B', 'C', 'D'} do
            for n = 1, 3 do
                table.insert(self.BeamEffectsBag, AttachBeamEntityToEntity(self, 'Turret' .. v .. '_Muzzle', self, 'Turret' .. v .. '_Bit_00' .. n, army, '/effects/emitters/build_beam_01_emit.bp'))
            end
        end
    end
}
TypeClass = SEB2402
