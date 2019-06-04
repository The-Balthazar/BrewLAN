--------------------------------------------------------------------------------
--  Summary  :  UEF Gunship Script
--------------------------------------------------------------------------------
local EffectTemplate = import('/lua/EffectTemplates.lua')
local TAirUnit = import('/lua/terranunits.lua').TAirUnit
local TDFRiotWeapon = import('/lua/terranweapons.lua').TDFRiotWeapon

local BrewLANPath = import('/lua/game.lua').BrewLANPath()
local VersionIsFAF = import(BrewLANPath .. "/lua/legacy/versioncheck.lua").VersionIsFAF()
if VersionIsFAF then
    TAirUnit = import('/lua/defaultunits.lua').AirTransport
end

SEA0105 = Class(TAirUnit) {

    Weapons = {
        Turret = Class(TDFRiotWeapon) {
            FxMuzzleFlash = EffectTemplate.TRiotGunMuzzleFxTank,
            FxMuzzleFlashScale = 0.6,

            IdleState = State(TDFRiotWeapon.IdleState) {
                Main = function(self)
                    self:SetAgressiveStance(0)
                    TDFRiotWeapon.IdleState.Main(self)
                end,

                OnGotTarget = function(self)
                    TDFRiotWeapon.OnGotTarget(self)
                    self:SetAgressiveStance(15)
                end,
            },

            SetAgressiveStance = function(self, stance)
                if self.Stance ~= stance then
                    self.Stance = stance
                    if not self.StanceRotator then
                        self.StanceRotator = CreateRotator(self.unit, 0, 'x', self.Stance, 10, 1)
                    else
                        self.StanceRotator:SetGoal(self.Stance)
                    end
                end
            end,
        },
    },

    OnStopBeingBuilt = function(self,builder,layer)
        TAirUnit.OnStopBeingBuilt(self,builder,layer)                                               --XMAX, XMIN, YMAX,YMIN, ZMAX,ZMIN, TURNMULT, TURNSPEED
        self.EngineManipulator = CreateThrustController(self, "thruster", 'Engines'):SetThrustingParam( -0.0, 0.0, -0.25, 0.25, -0.1, 0.1, 1.0, 0.25 )
    end,

    DestroyedOnTransport = function(self)
        if self.AttachedUnits then
            for k,v in self.AttachedUnits do
                v:Destroy()
            end
        end
    end,
}

TypeClass = SEA0105
