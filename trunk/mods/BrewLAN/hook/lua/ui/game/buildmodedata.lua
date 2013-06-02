AeonT2Eng['Y'] = 'sab1205'
CybranT2Eng['Y'] = 'srb1205'
SeraphimT2Eng['Y'] = 'ssb1205'
UEFT2Eng['Y'] = 'seb1205'

AeonT2Eng['X'] = 'sab1206'
CybranT2Eng['X'] = 'srb1206'
SeraphimT2Eng['X'] = 'ssb1206'
UEFT2Eng['X'] = 'seb1206'

AeonT1Air['G'] = 'saa0105' 
SeraphimT1Air['G'] = 'ssa0105'
UEFT1Air['G'] = 'sea0105'                
UEFT1Air['P'] = 'sea0106'

AeonT2Air['O'] = 'saa0211'

AeonT2Land['F'] = 'sal0209' 
CybranT2Land['F'] = 'srl0209' 

AeonT3Land['A'] = 'sal0311' 
SeraphimT3Land['A'] = 'xsl0303'
SeraphimT3Land['O'] = 'ssl0311' 
UEFT3Land['S'] = 'sel0320' 

SeraphimT3Air['G'] = 'ssa0305'   
AeonT3Air['T'] = 'saa0306'     
SeraphimT3Air['T'] = 'ssa0306'  
CybranT3Air['T'] = 'sra0306'
CybranT3Air['P'] = 'sra0307' 
SeraphimT3Air['P'] = 'ssa0307'
UEFT3Air['P'] = 'sea0307'     
AeonT3Air['D'] = 'saa0310'     

buildModeKeys['seb0401'] = {
        [1] = UEFT1Land,
        [2] = UEFT2Land,
        [3] = UEFT3Land,
        [4] = UEFT4Eng,   
-- Need to find out if it is even possible to merge these 
--        [1] = UEFT1Air,
--        [2] = UEFT2Air,
--        [3] = UEFT3Air,
--        [1] = UEFT1Sea,
--        [2] = UEFT2Sea,
--        [3] = UEFT3Sea,
    }
         
    -- Aeon T1 shield
buildModeKeys['sab4102'] = {
        ['U'] = 'sab4301',
    }
      
    -- UEF T1 shield
buildModeKeys['seb4102'] = {
        ['U'] = 'seb4301',
    }
    
    -- Seraphim T1 shield
buildModeKeys['ssb4102'] = {
        ['U'] = 'xsb4202',
    }
    
    -- Seraphim Engineering stations 
buildModeKeys['ssb0104'] = {
        ['U'] = 'ssb0204',
    } 
buildModeKeys['ssb0204'] = {
        ['U'] = 'ssb0304',
    } 
buildModeKeys['ssb0304'] = {
        [2] = {
            ['A'] = 'ssb0104',
        },
    }