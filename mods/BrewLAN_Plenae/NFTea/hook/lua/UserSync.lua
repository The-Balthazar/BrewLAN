do
    local oldSync = OnSync
    OnSync = function()
        oldSync()
        if Sync.Currency then
            import'/lua/ui/game/economy.lua'.Currency = Sync.Currency
        end
    end
end
