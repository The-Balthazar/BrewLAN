do
    local Currency = {
        Fiat = {
            Value = 1,
        },
        Brewcoin = {
            Limit = 1000000,
            Value = 0.001,
            Crypto = true,
        },
        Teatherium = {
            Limit = 690000,
            Value = 0.0001,
            Crypto = true,
        },
    }

    local OldCollectCurrentScores = CollectCurrentScores
    function CollectCurrentScores()
        for coin, coindata in Currency do
            if coindata.Crypto then
                coindata.Total = 0
                coindata.BrainTotals = {}
                for index, brain in ArmyBrains do
                    coindata.BrainTotals[index] = 0
                end
            end
        end
        Sync.Currency = Currency
        OldCollectCurrentScores()
    end

    local OldBrain = AIBrain
    AIBrain = Class(OldBrain){

        MintCrypto = function(self, coin)
            coin = Currency[coin]
            if not coin.Crypto then
                return false, 'not valid'
            end
            if coin.Total == (coin.Limit or 1000000) then
                return false, 'cap reached'
            end

            local total = coin.Total or 0
            local limit = coin.Limit or 1000000

            local army = self:GetArmyIndex()
            if total < limit
            and Random(1, 4) == 4
            and Random(0,Random(Random(0,limit),limit)) >= total then
                coin.BrainTotals[army] = coin.BrainTotals[army]+1
                coin.Total = total+1
                Sync.Currency = Currency
                return true
            end
        end

    }
end
