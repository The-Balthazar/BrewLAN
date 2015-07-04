--------------------------------------------------------------------------------
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------

AIBrain = Class(AIBrain) {

--------------------------------------------------------------------------------
--  Summary:  BrewcklOps Raffle!
--------------------------------------------------------------------------------

    LuckyDip = function(self, strArmy)
        local ScenarioFramework = import('/lua/ScenarioFramework.lua')
        local unitconflicts = {
            -- T3 Point defences
            {
                'brb2306',
                'srb2306',
            },
            {
                'bab2306',
                'sab2306',
            },
            {
                'bsb2306',
                'ssb2306',
            },
            --T1 Air staging
            {
                'bsb5104',
                'ssb5104',
            },
            {
                'brb5102',
                'srb5104',
            },
            {
                'bab5104',
                'sab5104',
            },
            {
                'beb5102',
                'seb5104',
            },
            --T3  tansport
            {
                'bsa0309',
                'ssa0306',
            }, 
            {
                'bra0309',
                'sra0306',
            },
            {
                'baa0309',
                'saa0306',
            },
            --T3 sera gunship
            {
                'bsa0310',
                'ssa0305',
            },
            -- Cybran T3 mobile AA
            {
                'brlk001',
                'srl0320',
            },
            --[[
            {
                '',
                '',
            },
            ]]--
        }
        
        for array, group in unitconflicts do
            local groupchoices = {}
            for i, v in group do
                if __blueprints[v] then
                    table.insert(groupchoices,v) 
                end
            end
            if table.getn(groupchoices) > 1 then
                local winner = math.random(1,table.getn(groupchoices))
                for i, v in groupchoices do
                    if i == winner then
                        LOG("A WINNAR IS " .. v)
                    else
                        ScenarioFramework.AddRestriction(strArmy, categories[v])
                    end
                end
            end
        end
    end,
}