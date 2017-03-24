--------------------------------------------------------------------------------
-- Summary  :  Cybran Power Generator Script
--------------------------------------------------------------------------------
local CEnergyCreationUnit = import('/lua/cybranunits.lua').CEnergyCreationUnit
local EffectUtil = import('/lua/EffectUtilities.lua')

SRB1311 = Class(CEnergyCreationUnit) {

    OnStopBeingBuilt = function(self, builder, layer)
        self:SetMaintenanceConsumptionActive()
        self:SetScriptBit('RULEUTC_CloakToggle', false)
        CEnergyCreationUnit.OnStopBeingBuilt(self, builder, layer)
        --Force update of the cloak effect if there is a cloak mesh. For FAF graphics
        if self:GetBlueprint().Display.CloakMeshBlueprint then
            self:ForkThread(
                function()
                    WaitTicks(1)
                    self:UpdateCloakEffect(true, 'Cloak')
                end
            )
        end
    end,

    OnIntelEnabled = function(self)
        CEnergyCreationUnit.OnIntelEnabled(self)
        if self.IntelEffects and not self.IntelFxOn then
            self.IntelEffectsBag = {}
            self.CreateTerrainTypeEffects( self, self.IntelEffects, 'FXIdle',  self:GetCurrentLayer(), nil, self.IntelEffectsBag )
            self.IntelFxOn = true
        end
    end,

    OnIntelDisabled = function(self)
        CEnergyCreationUnit.OnIntelDisabled(self)
        EffectUtil.CleanupEffectBag(self,'IntelEffectsBag')
        self.IntelFxOn = false
    end,

    IntelEffects = {
        {
            Bones = {
                'SRB1311',
            },
            Offset = {
                1.5,
                3,
                0,
            },
            Scale = 5,
            Type = 'Cloak01',
        },
        {
            Bones = {
                'SRB1311',
            },
            Offset = {
                -1.5,
                3,
                0,
            },
            Scale = 5,
            Type = 'Cloak01',
        },
    },
}

TypeClass = SRB1311
