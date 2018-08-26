local AStructureUnit = import('/lua/cybranunits.lua').CEnergyCreationUnit
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
        --Effects
        local army = self:GetArmy()
        self.Trash:Add(CreateRotator(self, 'Orb', 'y', nil, 0, 15, (80 + Random(0, 20)) * (1 - 2 * Random(0,1))))
        self.Trash:Add(CreateAttachedEmitter(self, 'Orb', army, '/effects/emitters/uef_t3_massfab_ambient_01_emit.bp'):OffsetEmitter(0,-0.5,0) )
        for i = 6, 20 do
            self.Trash:Add(CreateAttachedEmitter( self, 'Panel_0' .. i, army, '/effects/emitters/cybran_t2power_ambient_01_emit.bp' ):OffsetEmitter(0,1,-.5):ScaleEmitter(math.random(10,15)*0.15 ) )
        end
        --Real stuff
        ChangeState( self, self.ResourceOn )
        self:ForkThread(self.ResourceMonitor)
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
