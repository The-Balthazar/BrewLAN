local TAirUnit = import('/lua/terranunits.lua').TAirUnit
local VizMarker = import('/lua/sim/VizMarker.lua').VizMarker
local BrewLANPath = import( '/lua/game.lua' ).BrewLANPath()
local OffsetBoneToTerrain = import(BrewLANPath .. '/lua/TerrainUtils.lua').OffsetBoneToTerrain

SEA0002 = Class(TAirUnit) {
    DestroyNoFallRandomChance = 0,

    HideBones = { 'Shell01', 'Shell02', 'Shell03', 'Shell04' },

    OnStopBeingBuilt = function(self, ...)
        TAirUnit.OnStopBeingBuilt(self, unpack(arg) )
        --Less fuel for smaller maps. Max fuel only on 81k.
        self:SetFuelRatio(math.max(ScenarioInfo.size[1], ScenarioInfo.size[2]) / 4096)
    end,

    PreLaunchSetup = function(self, parent)
        self:SetScriptBit('RULEUTC_IntelToggle', true)
    end,

    Setup = function(self, parent)
        ChangeState( self, self.OpenState )
    end,

    SetupIntel = function(self)
        return false --OpenState.Main calls parent TAirUnit.SetupIntel(self)
    end,

    OnScriptBitClear = function(self, bit)
        if bit == 3 and not self.IntelDisables then
            LOG("Someone tried to enable satellite intel before it's ready.")
        else
            TAirUnit.OnScriptBitClear(self, bit)
        end
    end,

    OpenState = State() {
        Main = function(self)
            self.OpenAnim = CreateAnimator(self)
            self.OpenAnim:PlayAnim( '/units/XEA0002/xea0002_aopen01.sca' )
            self.Trash:Add( self.OpenAnim )
            WaitFor( self.OpenAnim )
            for k, v in self.HideBones do
                self:HideBone( v, true )
            end
            self.OpenAnim:PlayAnim( '/units/XEA0002/xea0002_aopen02.sca' )
            WaitFor( self.OpenAnim )
            TAirUnit.SetupIntel(self)--self:SetupIntel()
            self:CreateVisEntity()
            self:SetScriptBit('RULEUTC_IntelToggle', false)
        end,
    },

    StartUnguidedOrbitalDecay = function(self)
        if not self.UnguidedOrbitalDecay then
            self.UnguidedOrbitalDecay = self:ForkThread(
                function()
                    local pos = self:GetPosition()
                    while not self.Dead do
                        self:OnDamage(self, 1, pos, 'Decay')
                        WaitTicks(1)
                    end
                end
            )
        end
    end,

    StopUnguidedOrbitalDecay = function(self)
        if self.UnguidedOrbitalDecay then
            KillThread(self.UnguidedOrbitalDecay)
            self.UnguidedOrbitalDecay = nil
        end
    end,

    OnIntelEnabled = function(self)
        TAirUnit.OnIntelEnabled(self)
        if self.VisEntity then
            self.VisEntity:SetIntelRadius('vision', self.VisEntity.Radius)
            self.VisEntity:EnableIntel('WaterVision')
        end
    end,

    OnIntelDisabled = function(self)
        TAirUnit.OnIntelDisabled(self)
        if self.VisEntity then
            self.VisEntity:SetIntelRadius('vision', 0)
            self.VisEntity:DisableIntel('WaterVision')
        end
    end,

    CreateVisEntity = function(self)
        local pos = self:GetPosition()
        local bp = self:GetBlueprint().Intel
        self.VisEntity = VizMarker({
            X = pos[1],
            Z = pos[3],
            Radius = bp.OrbitIntelRadius or 45,
            LifeTime = -1,
            Omni = bp.OrbitOmni or false,
            Radar = bp.OrbitRadar or false,
            Sonar = bp.OrbitSonar or false,
            Vision = bp.OrbitVision or true,
            WaterVision = bp.OrbitWaterVision or true,
            Army = self:GetAIBrain():GetArmyIndex(),
        })
        self.VisEntity:AttachTo(self, 'VisEntity')
        self.VisEntity.Radius = bp.OrbitIntelRadius
        self.Trash:Add(self.VisEntity)
        OffsetBoneToTerrain(self, 'VisEntity')
    end,

    OnRunOutOfFuel = function(self)
        TAirUnit.OnRunOutOfFuel(self)
        self:SetSpeedMult(self:GetBlueprint().Physics.NoFuelSpeedMult)
        self:SetAccMult(1)
        self:SetTurnMult(1)
    end,

    --[[ disabled because self.Parent is no longer defined.
    OnKilled = function(self, instigator, type, overkillRatio)
        if self.IsDying then return end
        self.IsDying = true
        if instigator and self.Parent then --Don't do anything on a suicide.
            self.Parent:Rebuild(self:GetPosition())
        end
        TAirUnit.OnKilled(self, instigator, type, overkillRatio)
    end,]]
}

TypeClass = SEA0002
