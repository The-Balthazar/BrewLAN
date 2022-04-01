do
    local Currency = {
        --[[Fiat = {
            Value = 1,
        },]]
        Brewcoin = {
            Limit = 1000000,
            Value = 0.001,
            Crypto = true,
            Chance = 4,
        },
        Teatherium = {
            Limit = 690000,
            Value = 0.0001,
            Crypto = true,
            Chance = 5,
        },
        Sprouter = {
            Limit = 2000000,
            Value = 0.00069,
            Crypto = true,
            Chance = 3,
        },
        Dosh = {
            Limit = 1690000,
            Value = 0.0005,
            Crypto = true,
            Chance = 2,
        }
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
        ForkThread(function()
            for index, brain in ArmyBrains do
                ArmyScore[index].crypto = {}
                for coin, coindata in Currency do
                    ArmyScore[index].crypto[coin] = {}
                    ArmyScore[index].crypto[coin].total = 0
                end
            end
        end)
        Sync.Currency = Currency
        OldCollectCurrentScores()
    end

    local OldSyncScores = SyncScores
    function SyncScores()
        OldSyncScores()
        for index, brain in ArmyBrains do
            Sync.Score[index].crypto = {}
            for coin, coindata in Currency do
                Sync.Score[index].crypto[coin] = {}
                Sync.Score[index].crypto[coin].total = ArmyScore[index].crypto[coin].total
            end
        end
    end

    local OldBrain = AIBrain
    AIBrain = Class(OldBrain){

        NextCoin = function(self, coin)
            local selectedcoin = next(Currency, coin) or next(Currency) -- don't return directly because we only want to pass the index name
            return selectedcoin
        end,

        MintCrypto = function(self, coinName)
            coin = Currency[coinName]
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
            and Random(1, coin.Chance) == coin.Chance
            and Random(0,Random(Random(0,limit),limit)) >= total then
                coin.BrainTotals[army] = coin.BrainTotals[army]+1
                coin.Total = total+1
                Sync.Currency = Currency
                ArmyScore[army].crypto[coinName].total = coin.Total
                return true
            end
        end

    }
end
