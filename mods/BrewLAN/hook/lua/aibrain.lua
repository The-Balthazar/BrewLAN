do
    local OldAIBrain = AIBrain

    AIBrain = Class(OldAIBrain) {

        OnCreateHuman = function(self, planName)
            OldAIBrain.OnCreateHuman(self, planName)
            if __blueprints.saa0105.Desync then
                self:ForkThread(
                    function()
                        coroutine.yield(21)
                        local message = ""
                        for i, v in __blueprints.saa0105.Desync do
                            message = message .. "\n" .. v
                        end
                        table.insert(Sync.AIChat, {group='all', text=message, sender=self.Nickname})
                    end
                )
            end
        end,

    }
end
