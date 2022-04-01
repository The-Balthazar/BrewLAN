
CryptoMintStructureUnit = Class(StructureUnit) {

    OnStopBeingBuilt = function(self,builder,layer)
        StructureUnit.OnStopBeingBuilt(self,builder,layer)

        self:SetMaintenanceConsumptionActive()
        self.MineThread = self:ForkThread(self:Mint(self:GetNextCoin()))
    end,

    OnScriptBitSet = function(self, bit)
        StructureUnit.OnScriptBitSet(self, bit)
        if bit == 4 then
            KillThread(self.MineThread)
            self.MineThread = self:ForkThread(self:Mint(self:GetNextCoin()))
            self:SetScriptBit('RULEUTC_ProductionToggle', false)
        end
    end,

    GetNextCoin = function(self)
        local AIBrain = self:GetAIBrain()
        self.SelectedCoin = AIBrain:NextCoin(self.SelectedCoin)
        FloatingEntityText(self.Sync.id, self.SelectedCoin)
        return self.SelectedCoin
    end,

    Mint = function(self, coin)
        return function(self)
            local AIBrain = self:GetAIBrain()
            while not self.Dead do
                if self:GetResourceConsumed() == 1 then
                    AIBrain:MintCrypto(coin)
                end
                coroutine.yield(10)
            end
        end
    end,

}
