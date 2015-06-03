#
# UEF Anti-Matter Shells
#
local TArtilleryAntiMatterProjectile = import('/lua/terranprojectiles.lua').TArtilleryAntiMatterProjectile02
local utilities = import('/lua/utilities.lua')
TIFDropPodArtilleryMechMarine = Class(TArtilleryAntiMatterProjectile) {

    FxLandHitScale = 0.2,
    FxUnitHitScale = 0.2,
    FxSplatScale = 1,


    OnCreate = function(self, inWater)
        TArtilleryAntiMatterProjectile.OnCreate(self, inWater)

        self.ProjBounceCounter = 0  #since it refuses to bounce off a shield.
        self.DropHealth = 1
        self.DropUnitCode = self:GetBlueprint().General.DropUnit or 'uel0106'

    end,


    OnImpact = function(self, TargetType, TargetEntity)

        #LOG('updated 4')

        if TargetType == 'Shield' and self.ProjBounceCounter >= 1 then

                #TargetEntity:CreateImpactEffect(self:GetPosition())

                if not self.ProjVelocity then
                    local vx, vy, vz = self:GetVelocity()
                    self.ProjVelocity = {}
                    table.insert(self.ProjVelocity, {X = vx, Y = -vy, Z = vz})
                end
    
                local ran = utilities.GetRandomFloat(1.0,1.1) 
                local mod_vx = ( self.ProjVelocity[1].X * self.ProjBounceCounter * ran )
                local mod_vy = ( self.ProjVelocity[1].Y * self.ProjBounceCounter * ran )
                local mod_vz = ( self.ProjVelocity[1].Z * self.ProjBounceCounter * ran )

                self:SetVelocityAlign(true)
                self:SetVelocity(mod_vx, mod_vy, mod_vz)
                self:SetVelocity(120)

                self.ProjBounceCounter = self.ProjBounceCounter - 1 

                #self:SetOrientation(OrientFromDir(Vector(mod_vx, mod_vy, mod_vz)), true)

                #LOG('Updated impact 16 ' .. repr(self:GetVelocity() ) .. ' ' ..  repr(self.ProjVelocity) )
                #LOG(repr(Vector(mod_vx, mod_vy, mod_vz) ) )

        elseif TargetType == 'Shield' and self.ProjBounceCounter == 0 then

            self.DropHealth = .25

            TArtilleryAntiMatterProjectile.OnImpact(self, TargetType, TargetEntity)
            self.DropUnit(self)

        else

            TArtilleryAntiMatterProjectile.OnImpact(self, TargetType, TargetEntity)
            self.DropUnit(self)

        end
    end,
        
    DropUnit = function(self)
        if self.Data then
            local pos = self:GetPosition()
            local AssaultBot = CreateUnitHPR(self.Data,self:GetArmy(),pos[1], pos[2], pos[3],0, math.random(0,360), 0)
            
            AssaultBot:SetHealth(AssaultBot,AssaultBot:GetHealth()*self.DropHealth or 1)
            
            local target = self:GetCurrentTargetPosition()
            IssueMove( {AssaultBot},  {target[1] + Random(-3, 3), target[2], target[3]+ Random(-3, 3)} )
        else
            LOG("YOU GET NOTHING. GOOD DAY")
        end
        self:Kill()
    end,     
}

TypeClass = TIFDropPodArtilleryMechMarine