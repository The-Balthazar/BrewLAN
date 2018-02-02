#****************************************************************************
#**
#**  File     :  /data/units/XAB1401/XAB1401_script.lua
#**  Author(s):  Jessica St. Croix, Dru Staltman
#**
#**  Summary  :  Aeon Quantum Resource Generator
#**
#**  Copyright � 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local AStructureUnit = import('/lua/seraphimunits.lua').SEnergyCreationUnit
local FxAmbient = import('/lua/effecttemplates.lua').AResourceGenAmbient
local AIFParagonDeathWeapon = {}

if string.sub(GetVersion(),1,3) == '1.5' and tonumber(string.sub(GetVersion(),5)) > 3603 then
    AIFParagonDeathWeapon = import('/lua/sim/defaultweapons.lua').DeathNukeWeapon
else
    AIFParagonDeathWeapon = import('/lua/aeonweapons.lua').AIFParagonDeathWeapon
end

SSB1401 = Class(AStructureUnit) {
    AmbientEffects = 'ST3PowerAmbient',

    Weapons = {
        DeathWeapon = Class(AIFParagonDeathWeapon) {},
    },

    OnStopBeingBuilt = function(self, builder, layer)
        AStructureUnit.OnStopBeingBuilt(self, builder, layer)

        local num = self:GetRandomDir()
        --self.BallManip = CreateRotator(self, 'Orb', 'y', nil, 0, 15, 80 + Random(0, 20) * num)
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

    GetRandomDir = function(self)
        local num = Random(0, 2)
        if num > 1 then
            return 1
        end
        return -1
    end,
}

TypeClass = SSB1401
