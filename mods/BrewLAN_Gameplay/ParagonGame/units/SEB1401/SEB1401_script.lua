local AStructureUnit = import('/lua/seraphimunits.lua').SStructureUnit
local AIFParagonDeathWeapon = {}

if string.sub(GetVersion(),1,3) == '1.5' and tonumber(string.sub(GetVersion(),5)) > 3603 then
    AIFParagonDeathWeapon = import('/lua/sim/defaultweapons.lua').DeathNukeWeapon
else
    AIFParagonDeathWeapon = import('/lua/aeonweapons.lua').AIFParagonDeathWeapon
end

SEB1401 = Class(AStructureUnit) {

    Weapons = {
        DeathWeapon = Class(AIFParagonDeathWeapon) {},
    },

    OnStopBeingBuilt = function(self, builder, layer)
        AStructureUnit.OnStopBeingBuilt(self, builder, layer)
        ChangeState( self, self.ResourceOn )
        self:ForkThread(self.ResourceMonitor)

        self.Tesseract = CreateAnimator(self)
        self.Tesseract:PlayAnim(string.gsub(self:GetBlueprint().Source,'unit.bp','')..'ATesseract.sca', true):SetRate(1+math.random()*0.5)

        local army = self:GetArmy()
        for i = 1, 4 do
            for j, k in {{'A','B'},{'B','C'},{'C','D'},{'D','A'}} do
                if not self.BeamEffectsBag then self.BeamEffectsBag = {} end
                table.insert(self.BeamEffectsBag, AttachBeamEntityToEntity(self, 'Tesseract_'..k[1]..'_00'..i, self, 'Tesseract_'..k[1]..'_00'..(math.mod(i, 4) + 1), army, '/effects/emitters/build_beam_01_emit.bp'))
                table.insert(self.BeamEffectsBag, AttachBeamEntityToEntity(self, 'Tesseract_'..k[1]..'_00'..i, self, 'Tesseract_'..k[2]..'_00'..i, army, '/effects/emitters/build_beam_01_emit.bp'))
            end
        end

        self.Trash:Add(CreateRotator(self, 'Tesseract', 'x', nil, 0, 15, 40 + Random(0, 20)))
        self.Trash:Add(CreateRotator(self, 'Tesseract', 'y', nil, 0, 15, 40 + Random(0, 20)))
        self.Trash:Add(CreateRotator(self, 'Tesseract', 'z', nil, 0, 15, 40 + Random(0, 20)))
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

TypeClass = SEB1401
