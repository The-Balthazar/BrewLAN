do
    UEFT1Land['F'] = 'sel0119'
    UEFT3Land['F'] = 'sel0319'
    UEFT3Land['S'] = 'sel0320'
    UEFT3Land['V'] = 'sel0322'
    UEFT3Land['K'] = 'sel0321'
    UEFT3Land['N'] = 'sel0324'

    UEFT1Air['G'] = 'sea0105'
    UEFT1Air['P'] = 'sea0106'
    UEFT3Air['P'] = 'sea0307'

    --Engineer boats
    UEFT1Sea['F'] = 'ses0119'
    UEFT2Sea['F'] = 'ses0219'
    UEFT3Sea['F'] = 'ses0319'

    CybranT1Land['F'] = 'srl0119'
    CybranT2Land['F'] = 'srl0209'
    CybranT3Land['F'] = 'srl0319'
    CybranT3Land['N'] = 'srl0320' --AA
    CybranT3Land['K'] = 'srl0321' --anti-strat
    CybranT3Land['M'] = 'srl0311' --MRL
    CybranT3Land['C'] = 'srl0316' --Stealth

    CybranT1Air['P'] = 'sra0106'
    CybranT3Air['T'] = 'sra0306'
    CybranT3Air['P'] = 'sra0307'

    AeonT1Land['F'] = 'sal0119'
    AeonT2Land['F'] = 'sal0209'
    AeonT2Land['K'] = 'sal0323' --anti-tac
    AeonT3Land['A'] = 'sal0311'
    AeonT3Land['F'] = 'sal0319'
    AeonT3Land['K'] = 'sal0321'
    AeonT3Land['N'] = 'sal0320' --AA
    AeonT3Land['V'] = 'sal0322' --Shield

    AeonT1Air['G'] = 'saa0105'
    AeonT1Air['P'] = 'saa0106'
    AeonT2Air['O'] = 'saa0211'
    AeonT2Air['D'] = 'saa0310'
    AeonT3Air['T'] = 'saa0306'

    UEFT1Eng['V'] = 'seb4102'
    UEFT1Eng['G'] = 'seb5104'
    UEFT1Eng['R'] = 'seb2103'

    UEFT3Eng['A'] = 'xeb0204'
    UEFT3Eng['T'] = 'seb2308'
    UEFT3Eng['S'] = 'seb3303'
    UEFT3Eng['B'] = 'seb4303'--ADG

    UEFT4Eng['C'] = 'sea0401'--Centurion
    UEFT4Eng['I'] = 'seb2404'--Ivan
    UEFT4Eng['G'] = 'seb0401'--Gantry
    UEFT4Eng['P'] = 'seb3404'--Panopticon

    AeonT1Eng['V'] = 'sab4102'
    AeonT1Eng['G'] = 'sab5104'
    AeonT1Eng['R'] = 'sab2103'

    AeonT3Eng['T'] = 'sab2308'
    AeonT3Eng['D'] = 'sab2306'
    AeonT3Eng['S'] = 'xab3301'

    AeonT4Eng['I'] = 'sab0401'
    AeonT4Eng['S'] = 'xab2307'
    AeonT4Eng['A'] = 'sal0401'

    CybranT1Eng['V'] = 'urb4202'
    CybranT1Eng['G'] = 'srb5104'
    CybranT1Eng['R'] = 'srb2103'

    CybranT2Eng['V'] = 'urb4205'

    CybranT3Eng['D'] = 'srb2306'
    CybranT3Eng['A'] = 'xrb0304'
    CybranT3Eng['S'] = 'xrb3301'
    CybranT3Eng['C'] = 'srb4313'
    CybranT3Eng['V'] = 'urb4206'

    CybranT4Eng['V'] = 'srb4401'
    CybranT4Eng['A'] = 'srb2401'
    CybranT4Eng['C'] = 'srb4402'

    --T2 storage
    AeonT2Eng['Y'] = 'sab1205'
    CybranT2Eng['Y'] = 'srb1205'
    UEFT2Eng['Y'] = 'seb1205'

    AeonT2Eng['X'] = 'sab1206'
    CybranT2Eng['X'] = 'srb1206'
    UEFT2Eng['X'] = 'seb1206'

    -- Aeon T1 shield
    buildModeKeys['sab4102'] = {['U'] = 'sab4301',}
    -- UEF T1 shield
    buildModeKeys['seb4102'] = {['U'] = 'seb4301',}

    --buildModeKeys[]

    ----------------------------------------------------------------------------
    -- Seraphim things
    ----------------------------------------------------------------------------
    if GetVersion() != '1.1.0' then --If not original Steam SupCom
        SeraphimT1Land['F'] = 'ssl0119'
        SeraphimT2Land['F'] = 'ssl0219'
        SeraphimT2Land['V'] = 'ssl0222'--shield
        SeraphimT3Land['F'] = 'ssl0319'
        SeraphimT3Land['A'] = 'xsl0303'
        SeraphimT3Land['O'] = 'ssl0311'
        SeraphimT3Land['K'] = 'ssl0321'
        SeraphimT3Land['N'] = 'ssl0320'--AA

        SeraphimT1Air['P'] = 'ssa0106'
        SeraphimT1Air['G'] = 'ssa0105'
        SeraphimT3Air['G'] = 'ssa0305'
        SeraphimT3Air['T'] = 'ssa0306'
        SeraphimT3Air['P'] = 'ssa0307'


        SeraphimT1Eng['V'] = 'ssb4102'
        SeraphimT1Eng['G'] = 'ssb5104'
        SeraphimT1Eng['R'] = 'ssb2103'

        SeraphimT2Eng['A'] = 'ssb0104'

        SeraphimT3Eng['D'] = 'ssb2306'
        SeraphimT3Eng['O'] = 'sss0305'
        SeraphimT3Eng['S'] = 'ssb3301'

        SeraphimT4Eng['R'] = 'ssb2404'
        SeraphimT4Eng['S'] = 'ssb5401'
        SeraphimT4Eng['F'] = 'ssl0403'

        SeraphimT2Eng['Y'] = 'ssb1205' --T2 storage
        SeraphimT2Eng['X'] = 'ssb1206' --T2 storage

        -- Seraphim T1 shield
        buildModeKeys['ssb4102'] = {['U'] = 'xsb4202',}

        -- Seraphim Engineering stations
        buildModeKeys['ssb0104'] = {['U'] = 'ssb0204',}
        buildModeKeys['ssb0204'] = {['U'] = 'ssb0304',}
        buildModeKeys['ssb0304'] = {
            [2] = {
                ['A'] = 'ssb0104',
            },
        }
    end
    ----------------------------------------------------------------------------
    -- Gantry dynamic table
    ----------------------------------------------------------------------------
    local validKeys = {
        'Q','W','E','R','T','Y','U','I','O','P',
         'A','S','D','F','G','H','J','K','L',
           'Z','X','C','V','B','N','M',
    }
    local UEFGANTRYTparts = {
        {UEFT1Land, UEFT1Air, UEFT1Sea},
        {UEFT2Land, UEFT2Air, UEFT2Sea},
        {UEFT3Land, UEFT3Air, UEFT3Sea},
        {UEFT4Eng, CybranT4Eng, AeonT4Eng},
    }
    buildModeKeys['seb0401'] = {
        [1] = {},
        [2] = {},
        [3] = {},
        [4] = {},
    }
    ----------------------------------------------------------------------------
    -- Add Seraphim if we aren't on v1.1.0
    ----------------------------------------------------------------------------
    if GetVersion() != '1.1.0' then
        table.insert(UEFGANTRYTparts[4], SeraphimT4Eng)
    end
    ----------------------------------------------------------------------------
    -- Marge and swap where overlaps occur
    ----------------------------------------------------------------------------
    for techI, techTable in UEFGANTRYTparts do
        for tableI, keyTable in techTable do
            for key, uid in keyTable do
                if not buildModeKeys['seb0401'][techI][key] then
                    buildModeKeys['seb0401'][techI][key] = uid
                    --LOG(key .. " " .. uid)
                else
                    local keyindex = table.find(validKeys, key)
                    for i = 1, table.getn(validKeys) do
                        --Starting from one after starting key cycle through whole scope with wrap around
                        local newkeyi = keyindex + i
                        if newkeyi > table.getn(validKeys) then
                            newkeyi = newkeyi - table.getn(validKeys)
                        end
                        local newkey = validKeys[newkeyi]

                        if not buildModeKeys['seb0401'][techI][newkey] then
                            buildModeKeys['seb0401'][techI][newkey] = uid
                            --LOG(newkey .. " bumped " .. uid)
                            break
                        end
                    end
                end
            end
        end
    end
end
