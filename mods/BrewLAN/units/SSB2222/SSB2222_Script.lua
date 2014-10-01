#****************************************************************************
#**
#**  Summary  :  Seraphim Stationary Explosive Script
#**
#****************************************************************************

local NukeMineStructureUnit = import('/mods/brewlan/lua/defaultunits.lua').NukeMineStructureUnit       
local SIFCommanderDeathWeapon = import('/lua/seraphimweapons.lua').SIFCommanderDeathWeapon

SSB2222 = Class(NukeMineStructureUnit) {
                 
    Weapons = {
        DeathWeapon = Class(SIFCommanderDeathWeapon) {},
        Suicide = Class(SIFCommanderDeathWeapon) {
            OnFire = function(self)
            end,
        
            Fire = function(self)
                local myBlueprint = self:GetBlueprint()
                local myProjectile = self.unit:CreateProjectile( myBlueprint.ProjectileId, 0, 0, 0, nil, nil, nil):SetCollision(false)
                myProjectile:PassDamageData(self:GetDamageTable())
                if self.Data then
                    myProjectile:PassData(self.Data)
                end 
                self.unit:SetWeaponEnabledByLabel('DeathWeapon', false)
                self.unit:PlaySound(self.unit:GetBlueprint().Audio.NukeExplosion)
                self.unit:Destroy()
            end,
        },
    },
}

TypeClass = SSB2222