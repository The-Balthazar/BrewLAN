local VersionIsSC = import(import( '/lua/game.lua' ).BrewLANPath() .. '/lua/legacy/VersionCheck.lua').VersionIsSC()
do
    UEFT1Land['F'] = 'sel0119'
    UEFT3Land['F'] = 'sel0319'
    UEFT3Land['S'] = 'sel0320'
    UEFT3Land['V'] = 'sel0322'
    UEFT3Land['K'] = 'sel0321'
    UEFT3Land['N'] = 'sel0324'

    UEFT1Air['G'] = 'sea0105'
    UEFT1Air['P'] = 'sea0106'
    UEFT2Air['S'] = 'sea0201'
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
    CybranT3Land['Y'] = 'srl0324' --recon

    CybranT1Air['P'] = 'sra0106'
    CybranT2Air['S'] = 'sra0201'
    CybranT3Air['T'] = 'sra0306'
    CybranT3Air['P'] = 'sra0307'

    --Engineer boats
    CybranT1Sea['F'] = 'srs0119'
    CybranT2Sea['F'] = 'srs0219'
    CybranT3Sea['F'] = 'srs0319'

    AeonT1Land['F'] = 'sal0119'
    AeonT2Land['F'] = 'sal0209'
    AeonT2Land['K'] = 'sal0323' --anti-tac
    AeonT3Land['A'] = 'sal0311'
    AeonT3Land['F'] = 'sal0319'
    AeonT3Land['K'] = 'sal0321'
    AeonT3Land['N'] = 'sal0320' --AA
    AeonT3Land['V'] = 'sal0322' --Shield
    AeonT3Land['Y'] = 'sal0324' --recon

    AeonT1Air['G'] = 'saa0105'
    AeonT1Air['P'] = 'saa0106'
    AeonT2Air['O'] = 'saa0211'
    AeonT2Air['D'] = 'saa0201'
    AeonT3Air['T'] = 'saa0306'

    UEFT1Eng['V'] = 'seb4102'
    UEFT1Eng['G'] = 'seb5104'
    UEFT1Eng['R'] = 'seb2103'

    UEFT3Eng['A'] = 'xeb0204'
    UEFT3Eng['T'] = 'seb2308'
    UEFT3Eng['S'] = 'seb3303'
    UEFT3Eng['Y'] = 'seb4303'--ADG

    UEFT4Eng['C'] = 'sea0401'--Centurion
    UEFT4Eng['I'] = 'seb2404'--Ivan
    UEFT4Eng['G'] = 'seb0401'--Gantry
    UEFT4Eng['P'] = 'seb3404'--Panopticon
    UEFT4Eng['E'] = 'seb2401'--Excalibur

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
    CybranT4Eng['T'] = 'srb0401'
    CybranT4Eng['Y'] = 'srl0401'

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
    --
    buildModeKeys['ueb1301'] = {['U'] = 'seb1311',}
    buildModeKeys['urb1301'] = {['U'] = 'srb1311',}
    buildModeKeys['uab1301'] = {['U'] = 'sab1311',}

    buildModeKeys['ueb1302'] = {['U'] = 'seb1312',}
    buildModeKeys['urb1302'] = {['U'] = 'srb1312',}
    buildModeKeys['uab1302'] = {['U'] = 'sab1312',}

    buildModeKeys['ueb1303'] = {['U'] = 'seb1313',}
    buildModeKeys['urb1303'] = {['U'] = 'srb1313',}
    buildModeKeys['uab1303'] = {['U'] = 'sab1313',}
    ----------------------------------------------------------------------------
    -- Field Engineer tech
    ----------------------------------------------------------------------------
    local UEFT1FEng, UEFT2FEng, UEFT3FEng = table.deepcopy(UEFT1Eng), table.deepcopy(UEFT2Eng), table.deepcopy(UEFT3Eng)
    local CybranT1FEng, CybranT2FEng, CybranT3FEng = table.deepcopy(CybranT1Eng), table.deepcopy(CybranT2Eng), table.deepcopy(CybranT3Eng)
    local AeonT1FEng, AeonT2FEng, AeonT3FEng = table.deepcopy(AeonT1Eng), table.deepcopy(AeonT2Eng), table.deepcopy(AeonT3Eng)
    -- Mines
    UEFT1FEng['X'] = 'seb2220'
    UEFT2FEng['X'] = 'seb2221'
    UEFT3FEng['X'] = 'seb2222'
    CybranT1FEng['X'] = 'srb2220'
    CybranT2FEng['X'] = 'srb2221'
    CybranT3FEng['X'] = 'srb2222'
    AeonT1FEng['X'] = 'sab2220'
    AeonT2FEng['X'] = 'sab2221'
    AeonT3FEng['X'] = 'sab2222'
    -- Advanced resource buildings
    UEFT3FEng['P'] = 'seb1311'
    UEFT3FEng['E'] = 'seb1312'
    UEFT3FEng['F'] = 'seb1313'
    CybranT3FEng['P'] = 'srb1311'
    CybranT3FEng['E'] = 'srb1312'
    CybranT3FEng['F'] = 'srb1313'
    AeonT3FEng['P'] = 'sab1311'
    AeonT3FEng['E'] = 'sab1312'
    AeonT3FEng['F'] = 'sab1313'
    -- Walls
    UEFT2FEng['W'] = 'seb5210'
    UEFT3FEng['W'] = 'seb5310'
    CybranT2FEng['W'] = 'srb5210'
    CybranT3FEng['W'] = 'srb5310'
    AeonT2FEng['W'] = 'sab5210'
    AeonT3FEng['W'] = 'sab5301'
    -- Gates
    UEFT3FEng['G'] = 'seb5311'
    CybranT3FEng['G'] = 'srb5311'
    -- AntiArmor PD
    UEFT3FEng['A'] = 'seb2311'
    CybranT3FEng['A'] = 'srb2311'
    AeonT3FEng['A'] = 'sab2311'
    -- ED5
    CybranT3FEng['V'] = 'urb4207'
    ----------------------------------------------------------------------------
    -- Field Engineers
    ----------------------------------------------------------------------------
    buildModeKeys['sel0119'] = {
        [1] = UEFT1FEng
    }
    buildModeKeys['xel0209'] = {
        [1] = UEFT1FEng,
        [2] = UEFT2FEng
    }
    buildModeKeys['sel0319'] = {
        [1] = UEFT1FEng,
        [2] = UEFT2FEng,
        [3] = UEFT3FEng,
        [4] = UEFT4Eng
    }

    buildModeKeys['srl0119'] = {
        [1] = CybranT1FEng
    }
    buildModeKeys['srl0209'] = {
        [1] = CybranT1FEng,
        [2] = CybranT2FEng
    }
    buildModeKeys['srl0319'] = {
        [1] = CybranT1FEng,
        [2] = CybranT2FEng,
        [3] = CybranT3FEng,
        [4] = CybranT4Eng
    }

    buildModeKeys['sal0119'] = {
        [1] = AeonT1FEng
    }
    buildModeKeys['sal0209'] = {
        [1] = AeonT1FEng,
        [2] = AeonT2FEng
    }
    buildModeKeys['sal0319'] = {
        [1] = AeonT1FEng,
        [2] = AeonT2FEng,
        [3] = AeonT3FEng,
        [4] = AeonT4Eng
    }
    ----------------------------------------------------------------------------
    -- Seraphim things
    ----------------------------------------------------------------------------
    if not VersionIsSC then --If not original Steam SupCom
        SeraphimT1Land['F'] = 'ssl0119'
        SeraphimT2Land['F'] = 'ssl0219'
        SeraphimT2Land['V'] = 'ssl0222'--shield
        SeraphimT3Land['F'] = 'ssl0319'
        SeraphimT3Land['A'] = 'xsl0303'
        SeraphimT3Land['O'] = 'ssl0311'
        SeraphimT3Land['K'] = 'ssl0321'
        SeraphimT3Land['N'] = 'ssl0320'--AA
        SeraphimT3Land['Y'] = 'ssl0324'--Recon

        SeraphimT1Air['P'] = 'ssa0106'
        SeraphimT1Air['G'] = 'ssa0105'
        SeraphimT2Air['S'] = 'ssa0201'
        SeraphimT3Air['G'] = 'ssa0305'
        SeraphimT3Air['T'] = 'ssa0306'
        SeraphimT3Air['P'] = 'ssa0307'

        SeraphimT1Eng['V'] = 'ssb4102'
        SeraphimT1Eng['G'] = 'ssb5104'
        SeraphimT1Eng['R'] = 'ssb2103'

        SeraphimT2Eng['A'] = 'ssb0104' --Engineering station
        SeraphimT2Eng['Y'] = 'ssb1205' --T2 storage
        SeraphimT2Eng['X'] = 'ssb1206' --T2 storage

        SeraphimT3Eng['D'] = 'ssb2306'
        SeraphimT3Eng['O'] = 'sss0305'
        SeraphimT3Eng['S'] = 'ssb3301'
        SeraphimT3Eng['T'] = 'sss0306'
        SeraphimT3Eng['J'] = 'ssb4317'

        SeraphimT4Eng['R'] = 'ssb2404'
        SeraphimT4Eng['S'] = 'ssb5401'
        SeraphimT4Eng['F'] = 'ssl0403'
        SeraphimT4Eng['I'] = 'ssb0401'
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

        buildModeKeys['xsb1301'] = {['U'] = 'ssb1311',}
        buildModeKeys['xsb1302'] = {['U'] = 'ssb1312',}
        buildModeKeys['xsb1303'] = {['U'] = 'ssb1313',}

        ------------------------------------------------------------------------
        -- Field tech
        ------------------------------------------------------------------------
        local SeraphimT1FEng, SeraphimT2FEng, SeraphimT3FEng = table.deepcopy(SeraphimT1Eng), table.deepcopy(SeraphimT2Eng), table.deepcopy(SeraphimT3Eng)
        SeraphimT2FEng['W'] = 'ssb5210'
        SeraphimT3FEng['W'] = 'ssb5301'

        SeraphimT3FEng['P'] = 'ssb1311'
        SeraphimT3FEng['E'] = 'ssb1312'
        SeraphimT3FEng['F'] = 'ssb1313'

        SeraphimT1FEng['X'] = 'ssb2220'
        SeraphimT2FEng['X'] = 'ssb2221'
        SeraphimT3FEng['X'] = 'ssb2222'
        -- AntiArmor PD
        SeraphimT3FEng['A'] = 'ssb2311'
        ------------------------------------------------------------------------
        -- Field Engineers
        ------------------------------------------------------------------------
        buildModeKeys['ssl0119'] = {
            [1] = SeraphimT1FEng
        }
        buildModeKeys['ssl0219'] = {
            [1] = SeraphimT1FEng,
            [2] = SeraphimT2FEng
        }
        buildModeKeys['ssl0319'] = {
            [1] = SeraphimT1FEng,
            [2] = SeraphimT2FEng,
            [3] = SeraphimT3FEng,
            [4] = SeraphimT4Eng
        }

        ------------------------------------------------------------------------
        -- Boring Gantry tables
        ------------------------------------------------------------------------
        buildModeKeys['ssb0401'] = {
            [1] = SeraphimT1Sea,
            [2] = SeraphimT2Sea,
            [3] = SeraphimT3Sea,
            [4] = SeraphimT4Eng
        }
    end

    ----------------------------------------------------------------------------
    -- Boring Gantry tables
    ----------------------------------------------------------------------------
    buildModeKeys['srb0401'] = {
        [1] = CybranT1Land,
        [2] = CybranT2Land,
        [3] = CybranT3Land,
        [4] = CybranT4Eng,
    }
    buildModeKeys['sab0401'] = {
        [1] = AeonT1Air,
        [2] = AeonT2Air,
        [3] = AeonT3Air,
        [4] = AeonT4Eng,
    }
    ----------------------------------------------------------------------------
    -- Gantry dynamic table
    ----------------------------------------------------------------------------
    local validKeys = {
        'Q','W','E','R','T','Y','U','I','O','P',
         'A','S','D','F','G','H','J','K','L',
           'Z','X','C','V','N','M',--B can't be used
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
    if not VersionIsSC then
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
