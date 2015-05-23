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
        

    OnCollisionCheckWeapon = function(self, firingWeapon)
      LOG("OnCollisionCheckWeapon")
		# if this unit category is on the weapon's do-not-collide list, skip!
		local weaponBP = firingWeapon:GetBlueprint()	
		if weaponBP.DoNotCollideList then
			for k, v in pairs(weaponBP.DoNotCollideList) do
				if EntityCategoryContains(ParseEntityCategory(v), self) then
					return false
				end
			end
		end    
        return true
    end,

    OnCollisionCheck = function(self,other)
        LOG("OnCollisionCheck")
        self:tprint(other)
        -- If we return false the thing hitting us has no idea that it came into contact with us.
        # By default, anything hitting us should know about it so we return true.
        if (EntityCategoryContains(categories.TORPEDO, self) and EntityCategoryContains(categories.TORPEDO, other)) or 
           (EntityCategoryContains(categories.TORPEDO, self) and EntityCategoryContains(categories.DIRECTFIRE, other)) or
           (EntityCategoryContains(categories.MISSILE, self) and EntityCategoryContains(categories.MISSILE, other)) or 
           (EntityCategoryContains(categories.MISSILE, self) and EntityCategoryContains(categories.DIRECTFIRE, other)) or 
           (EntityCategoryContains(categories.DIRECTFIRE, self) and EntityCategoryContains(categories.MISSILE, other)) or 
           (self:GetArmy() == other:GetArmy()) then
            return false
        end
        
        if other:GetBlueprint().Physics.HitAssignedTarget then
            if other:GetTrackingTarget() != self then
                return false
            end
        end
        
		local bp = other:GetBlueprint()	
		if bp.DoNotCollideList then
			for k, v in pairs(bp.DoNotCollideList) do
				if EntityCategoryContains(ParseEntityCategory(v), self) then
					return false
				end
			end
		end
		
		bp = self:GetBlueprint()
		if bp.DoNotCollideList then
			for k, v in pairs(bp.DoNotCollideList) do
				if EntityCategoryContains(ParseEntityCategory(v), other) then
					return false
				end
			end
		end		            
        
        return true
    end,

    DropUnit = function(self)
        if self.Data then
            local pos = self:GetPosition()
            local AssaultBot = CreateUnitHPR(self.Data,self:GetArmy(),pos[1], pos[2], pos[3],0, 0, 0)
            
            AssaultBot:SetHealth(AssaultBot,AssaultBot:GetHealth()*self.DropHealth or 1)
            
            local target = self:GetCurrentTargetPosition()
            IssueMove( {AssaultBot},  {target[1] + Random(-3, 3), target[2], target[3]+ Random(-3, 3)} )
            --IssueAttack( {AssaultBot}, target )
        else
            LOG("YOU GET NOTHING. GOOD DAY")
        end
        self:Kill()
    end,      
    
    tprint = function(self, tbl, indent)
        if not indent then indent = 0 end
        for k, v in pairs(tbl) do
            formatting = string.rep("  ", indent) .. k .. ": "
            if type(v) == "table" then
                LOG(formatting)
                self:tprint(v, indent+1)
            elseif type(v) == 'boolean' then
                LOG(formatting .. tostring(v))		
            elseif type(v) == 'string' or type(v) == 'number' then
                LOG(formatting .. v)
            else
                LOG(formatting .. type(v))
            end
        end
    end,
}

TypeClass = TIFDropPodArtilleryMechMarine