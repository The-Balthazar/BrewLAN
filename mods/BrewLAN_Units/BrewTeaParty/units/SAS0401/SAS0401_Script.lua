local ASeaUnit = import('/lua/aeonunits.lua').ASeaUnit
--------------------------------------------------------------------------------
local WeaponsFile = import('/lua/aeonweapons.lua')
local ADFCannonOblivionWeapon = WeaponsFile.ADFCannonOblivionWeapon
local AIFQuanticArtillery = WeaponsFile.AIFQuanticArtillery
local AAAZealotMissileWeapon = WeaponsFile.AAAZealotMissileWeapon
local ADFDisruptorCannonWeapon = WeaponsFile.ADFDisruptorWeapon
local AIFQuasarAntiTorpedoWeapon = WeaponsFile.AIFQuasarAntiTorpedoWeapon
--------------------------------------------------------------------------------
local CleanShieldBag = function(self) if self.ShieldEffect then self.ShieldEffect:Destroy() self.ShieldEffect = nil end end
local NegPos = function(b) if math.random(0, 1) == 1 then return b else return -b end end --return b * (1 - 2 * math.random(0, 1))
--------------------------------------------------------------------------------
local ShipNumber = 0

SAS0401 = Class(ASeaUnit) {
    FxDamageScale = 2,
    DestructionTicks = 400,

    Weapons = {
        Oblivion = Class(ADFCannonOblivionWeapon) {
            FxChargeMuzzleFlash = {
                '/effects/emitters/oblivion_cannon_flash_01_emit.bp',
                '/effects/emitters/oblivion_cannon_flash_02_emit.bp',
            },
        },
        Salvation = Class(AIFQuanticArtillery) {},
        Zealot = Class(AAAZealotMissileWeapon) {},
        Disruptor = Class(ADFDisruptorCannonWeapon) {
            CreateProjectileAtMuzzle = function(self, muzzle)
                local proj = ADFDisruptorCannonWeapon.CreateProjectileAtMuzzle(self, muzzle)
                if not self.data then self.data = self:GetBlueprint().DamageToShields end
                if proj and not proj:BeenDestroyed() then
                    proj:PassData(self.data)
                end
            end,
        },
        AntiTorpedo = Class(AIFQuasarAntiTorpedoWeapon) {},
    },

    HidePanels = function(self)
        for i = 1, 9 do self:HideBone('Panel_00'..i, false) end
        for i = 0, 2 do self:HideBone('Panel_01'..i, false) end
        self:SetCustomName('Indulge Class')
    end,

    OnCreate = function(self)
        ASeaUnit.OnCreate(self)
        --Yes, this means it's shared between all players.
        ShipNumber = ShipNumber + 1
        --First two ever get a cool pair of names.
        local UniqueShips = {
            [1] = 'Scylla',
            [2] = 'Charybdis',
            [69] = self.HidePanels,
        }
        if UniqueShips[ShipNumber] then
            if type(UniqueShips[ShipNumber]) == 'string' then
                self:SetCustomName(UniqueShips[ShipNumber])
            elseif type(UniqueShips[ShipNumber]) == 'function' then
                UniqueShips[ShipNumber](self)
            end
        end
        if math.mod(ShipNumber, 2) == 1 then
            --Flip directional turrets every other one built
            CreateRotator(self, 'Front_Turrets_Switch', 'y', 180, 999999999)
            CreateRotator(self, 'Mid_Turrets_Switch', 'y', 180, 999999999)
            --Position the front turrets in the correct place for their arcs centres
            CreateRotator(self, 'MB2_Turret', 'y', 157.5, 999999999)
            CreateRotator(self, 'AS1_Turret', 'y', -157.5, 999999999)
        else
            --Position the front turrets in the correct place for their arcs centres
            CreateRotator(self, 'MB2_Turret', 'y', 22.5, 999999999)
            CreateRotator(self, 'AS1_Turret', 'y', -22.5, 999999999)
        end
        --Position the rear turrets in the correct place for their arcs centres
        CreateRotator(self, 'AS2_Turret', 'y', 90, 999999999)
        CreateRotator(self, 'MB3_Turret', 'y', -90, 999999999)
    end,

    ----------------------------------------------------------------------------
    -- Shield functions
    CreateShield = function(self, shieldSpec)
        ASeaUnit.CreateShield(self, shieldSpec)
        local bp = self:GetBlueprint()                  --BL     --LOUD
        self.MyShield.CollisionSizeX = bp.SizeX / 2 + 1 --2.65   --2
        self.MyShield.CollisionSizeY = bp.SizeY / 2 + 1 --2.4    --1.75
        self.MyShield.CollisionSizeZ = bp.SizeZ / 2 + 1 --10.9   --6.35

        self.MyShield.ImpactVals = {
            self.MyShield.CollisionSizeZ * 0.55,
            self.MyShield.CollisionSizeZ * -0.6422,
            self.MyShield.CollisionSizeZ * -0.3211,
            self.MyShield.CollisionSizeX * 0.9433,
        }

        --SizeX = 3.3,
        --SizeY = 2.8,
        --SizeZ = 19.8,

        self.MyShield.CollisionCenterX = (bp.CollisionOffsetX or 0)
        self.MyShield.CollisionCenterY = (bp.CollisionOffsetY or 0) + 2
        self.MyShield.CollisionCenterZ = (bp.CollisionOffsetZ or 0)
        --Change the function that sets the collision, rather than trying to track and change it from here.
        local oldCreateShieldMesh = self.MyShield.CreateShieldMesh
        self.MyShield.CreateShieldMesh = function(self)
            oldCreateShieldMesh(self)
            self:SetCollisionShape( 'Box', self.CollisionCenterX, self.CollisionCenterY, self.CollisionCenterZ, self.CollisionSizeX, self.CollisionSizeY, self.CollisionSizeZ)
        end

        self.MyShield.CreateImpactEffect = function(self, vector)
            --------------------------------------------------------------------
            -- Centre the vector so we can do comparisons
            --------------------------------------------------------------------
            local heading = self:GetHeading()
            local v = {}
            if heading ~= 0 then
                local hsin = math.sin(heading)
                local hcos = math.cos(heading)
                v[2] = vector[2]
                if heading > 0 then
                    v[1] = vector[1] * hcos + vector[3] * hsin
                    v[3] = vector[1] * hsin - vector[3] * hcos
                elseif heading < 0 then
                    v[1] = vector[1] * hcos - vector[3] * hsin
                    v[3] = vector[1] * hsin + vector[3] * hcos
                end
            end
            --Just in case heading was 0
            if not v[1] then v = vector end

            --------------------------------------------------------------------
            -- Side check function
            --------------------------------------------------------------------
            local getSide = function(v, cutoff)
                --2.65
                if v[1] < - (cutoff or 0) then
                    return 'port'
                elseif v[1] > (cutoff or 0) then
                    return 'star'
                elseif cutoff then
                    return 'top'
                else
                    return 'port'
                end
            end

            --------------------------------------------------------------------
            -- Pick the impact mesh
            --------------------------------------------------------------------
            -- The numbers within assume the unit hasn't been scaled,
            -- and I can't be aresed to make them dynamic
            --------------------------------------------------------------------
            local impactmeshbp = self.ImpactMeshBp
            if v[3] > self.ImpactVals[1] then
                impactmeshbp = impactmeshbp .. 'aft_mesh'
            elseif v[3] < self.ImpactVals[2] then
                impactmeshbp = impactmeshbp .. 'front_mesh'
            elseif v[3] < self.ImpactVals[3] then
                impactmeshbp = impactmeshbp .. getSide(v) .. '1_mesh'
            elseif v[3] < 0 then
                impactmeshbp = impactmeshbp .. getSide(v) .. '2_mesh'
            elseif v[3] <= self.ImpactVals[1] then
                impactmeshbp = impactmeshbp .. getSide(v,self.ImpactVals[4]) .. '3_mesh'
            end

            --------------------------------------------------------------------
            -- Mostly, but not quite, normal function with vector orientation off
            --------------------------------------------------------------------
            local army = self:GetArmy()
            local Entity = import('/lua/sim/Entity.lua').Entity
            local ImpactMesh = Entity { Owner = self.Owner }

            Warp( ImpactMesh, self:GetPosition())
            ImpactMesh:AttachBoneTo(-1,self,-1)
            if impactmeshbp ~= '' then
                ImpactMesh:SetMesh(impactmeshbp)
                ImpactMesh:SetDrawScale(self.Size)
                ImpactMesh:SetOrientation(self:GetOrientation(),true)
            end
            for k, v in self.ImpactEffects do
                CreateEmitterAtBone( ImpactMesh, -1, army, v )--:OffsetEmitter(0,0,OffsetLength)
            end

            coroutine.yield(51)
            ImpactMesh:Destroy()
        end
    end,

    OnShieldEnabled = function(self)
        ASeaUnit.OnShieldEnabled(self)
        if not self.ShieldRotators then
            self.ShieldRotators = {
                CreateRotator(self, 'Ball', 'x', nil, 0, 45, NegPos(45 ) ),
                CreateRotator(self, 'Ball', 'y', nil, 0, 45, NegPos(45 ) ),
                CreateRotator(self, 'Ball', 'z', nil, 0, 45, NegPos(45 ) )
            }
        else
            for i, v in self.ShieldRotators do
                v:SetTargetSpeed(NegPos(45))
            end
        end

        CleanShieldBag(self)
        self.ShieldEffect = CreateAttachedEmitter( self, 'Panel_008', self:GetArmy(), '/effects/emitters/aeon_shield_generator_t3_03_emit.bp' ):ScaleEmitter(0.3):OffsetEmitter(-0.5,-1.375,0)
        self:SetMaintenanceConsumptionActive()
    end,

    OnShieldDisabled = function(self)
        ASeaUnit.OnShieldEnabled(self)
        CleanShieldBag(self)
        for i, v in self.ShieldRotators do
            --Pcall because the manipulator is uncleanly destroyed by one of the death animations.
            pcall(v.SetTargetSpeed, v, 0)
        end
        self:SetMaintenanceConsumptionInactive()
    end,

    ----------------------------------------------------------------------------
    -- Intel effects. Here just in case it's set to be toggle-able in the future.
    OnIntelEnabled = function(self)
        ASeaUnit.OnIntelEnabled(self)
        if not self.IntelMast then
            self.IntelMast = CreateRotator(self, 'Mast', 'z', nil, 0, 20, NegPos(20) )
        else
            self.IntelMast:SetTargetSpeed(NegPos(20))
        end
    end,

    OnIntelDisabled = function(self)
        ASeaUnit.OnIntelDisabled(self)
        if self.IntelMast then self.IntelMast:SetTargetSpeed(0) end
    end,

    ----------------------------------------------------------------------------
    -- Additional destruction cleanup
    OnKilled = function(self, instigator, type, overkillRatio)
        ASeaUnit.OnKilled(self, instigator, type, overkillRatio)
        CleanShieldBag(self)
        if self.IntelMast then self.IntelMast:Destroy() self.IntelMast = nil end
    end,

    OnDestroy = function(self)
        CleanShieldBag(self)
        if self.IntelMast then self.IntelMast:Destroy() self.IntelMast = nil end
        ASeaUnit.OnDestroy(self)
    end,
}

--SAS0401.BuffTypes.MoveMult = {BuffType = 'VETERANCYSPEED', BuffValFunction = 'Mult', BuffDuration = -1, BuffStacks = 'REPLACE'}

TypeClass = SAS0401
