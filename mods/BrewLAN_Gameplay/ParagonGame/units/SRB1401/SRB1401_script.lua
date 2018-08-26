local AStructureUnit = import('/lua/cybranunits.lua').CEnergyCreationUnit
local FxAmbient = import('/lua/effecttemplates.lua').AResourceGenAmbient
local AIFParagonDeathWeapon = {}

if string.sub(GetVersion(),1,3) == '1.5' and tonumber(string.sub(GetVersion(),5)) > 3603 then
    AIFParagonDeathWeapon = import('/lua/sim/defaultweapons.lua').DeathNukeWeapon
else
    AIFParagonDeathWeapon = import('/lua/aeonweapons.lua').AIFParagonDeathWeapon
end

SRB1401 = Class(AStructureUnit) {

    Weapons = {
        DeathWeapon = Class(AIFParagonDeathWeapon) {},
    },

    OnStopBeingBuilt = function(self, builder, layer)
        AStructureUnit.OnStopBeingBuilt(self, builder, layer)

        --self.BallManip = CreateRotator(self, 'Orb', 'y', nil, 0, 15, 80 + Random(0, 20) * (1 - 2 * Random(0,1)))
        --self.Trash:Add(self.BallManip)

        ChangeState( self, self.ResourceOn )
        self:ForkThread(self.ResourceMonitor)

        --for k, v in FxAmbient do
        --    CreateAttachedEmitter( self, 'Orb', self:GetArmy(), v )
        --end
    end,

    ResourceOn = State {
        Main = function(self)
            local aiBrain = self:GetAIBrain()
            local massAdd = 0
            local energyAdd = 0
            local maxMass = self:GetBlueprint().Economy.MaxMass
            local maxEnergy = self:GetBlueprint().Economy.MaxEnergy

            while true do
                local massNeed = aiBrain:GetEconomyRequested('MASS') * 10
                local energyNeed = aiBrain:GetEconomyRequested('ENERGY') * 10

                local massIncome = (aiBrain:GetEconomyIncome( 'MASS' ) * 10) - massAdd
                local energyIncome = (aiBrain:GetEconomyIncome( 'ENERGY' ) * 10) - energyAdd

                massAdd = 20
                if massNeed - massIncome > 0 then
                    massAdd = massAdd + massNeed - massIncome
                end

                if maxMass and massAdd > maxMass then
                   massAdd = maxMass
                end
                self:SetProductionPerSecondMass(massAdd)

                energyAdd = 1000
                if energyNeed - energyIncome > 0 then
                    energyAdd = energyAdd + energyNeed - energyIncome
                end
                if maxEnergy and energyAdd > maxEnergy then
                    energyAdd = maxEnergy
                end
                self:SetProductionPerSecondEnergy(energyAdd)

                WaitSeconds(.5)
            end
        end,
    },
}

TypeClass = SRB1401
