UEFT1Land['F'] = 'sel0119'
UEFT3Land['F'] = 'sel0319'     
UEFT3Land['S'] = 'sel0320' 
UEFT3Land['V'] = 'sel0322' 
UEFT3Land['K'] = 'sel0321'
        
UEFT1Air['G'] = 'sea0105'                
UEFT1Air['P'] = 'sea0106'
UEFT3Air['P'] = 'sea0307'     

CybranT1Land['F'] = 'srl0119'
CybranT2Land['F'] = 'srl0209' 
CybranT3Land['F'] = 'srl0319' 
CybranT3Land['N'] = 'srl0320' 
CybranT3Land['K'] = 'srl0321'     
 
CybranT1Air['P'] = 'sra0106'
CybranT3Air['T'] = 'sra0306'
CybranT3Air['P'] = 'sra0307'  

AeonT1Land['F'] = 'sal0119'
AeonT2Land['F'] = 'sal0209'
AeonT3Land['A'] = 'sal0311' 
AeonT3Land['F'] = 'sal0319' 
AeonT3Land['K'] = 'sal0321'

AeonT1Air['G'] = 'saa0105'       
AeonT1Air['P'] = 'saa0106'
AeonT2Air['O'] = 'saa0211'
AeonT3Air['T'] = 'saa0306'    
AeonT3Air['D'] = 'saa0310'  

SeraphimT1Land['F'] = 'ssl0119'
SeraphimT2Land['F'] = 'ssl0219'
SeraphimT3Land['F'] = 'ssl0319'   
SeraphimT3Land['A'] = 'xsl0303'
SeraphimT3Land['O'] = 'ssl0311' 
SeraphimT3Land['K'] = 'ssl0321'
      
SeraphimT1Air['P'] = 'ssa0106'
SeraphimT1Air['G'] = 'ssa0105'
SeraphimT3Air['G'] = 'ssa0305'    
SeraphimT3Air['T'] = 'ssa0306'
SeraphimT3Air['P'] = 'ssa0307'  

UEFT1Eng['V'] = 'seb4102'
UEFT1Eng['G'] = 'seb5104'
UEFT1Eng['R'] = 'seb2103'

UEFT3Eng['A'] = 'xeb0204'
UEFT3Eng['T'] = 'seb2308'
UEFT3Eng['S'] = 'seb3303'

UEFT4Eng['C'] = 'sea0401'
UEFT4Eng['I'] = 'seb2404'
UEFT4Eng['G'] = 'seb0401'

AeonT1Eng['V'] = 'sab4102'
AeonT1Eng['G'] = 'sab5104'
AeonT1Eng['R'] = 'sab2103'

AeonT3Eng['T'] = 'sab2308'
AeonT3Eng['D'] = 'sab2306'
AeonT3Eng['S'] = 'xab3301'
AeonT3Eng['C'] = ''

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

SeraphimT1Eng['V'] = 'ssb4102'
SeraphimT1Eng['G'] = 'ssb5104'
SeraphimT1Eng['R'] = 'ssb2103'

SeraphimT2Eng['A'] = 'ssb0104'

SeraphimT3Eng['D'] = 'ddb2306'
SeraphimT3Eng['O'] = 'sss0305'
SeraphimT3Eng['S'] = 'ssb3301'

SeraphimT4Eng['R'] = 'ssb2404'
SeraphimT4Eng['S'] = 'ssb5401'
SeraphimT4Eng['F'] = 'ssl0403'

AeonT2Eng['Y'] = 'sab1205'
CybranT2Eng['Y'] = 'srb1205'
SeraphimT2Eng['Y'] = 'ssb1205'
UEFT2Eng['Y'] = 'seb1205'

AeonT2Eng['X'] = 'sab1206'
CybranT2Eng['X'] = 'srb1206'
SeraphimT2Eng['X'] = 'ssb1206'
UEFT2Eng['X'] = 'seb1206'

      
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

-- Gantry awkwardness
    

local UEFGANTRYT1 = {
    ['E'] = 'uel0105',
    ['S'] = 'uel0101', 
    ['O'] = 'uel0106',
    ['T'] = 'uel0201',
    ['R'] = 'uel0103',
    ['N'] = 'uel0104',
    ['F'] = 'uea0102',    
    ['S'] = 'uea0101',
    ['O'] = 'uea0103',
    ['T'] = 'uea0107',
}
local UEFGANTRYT2 = {
    ['O'] = 'del0204',
    ['E'] = 'uel0208',
    ['F'] = 'xel0209',
    ['T'] = 'uel0202',
    ['M'] = 'uel0111',
    ['N'] = 'uel0205',
    ['P'] = 'uel0203',
    ['V'] = 'uel0307',
    ['F'] = 'dea0202',
    ['P'] = 'uea0204',
    ['G'] = 'uea0203',
    ['T'] = 'uea0104',
}
local UEFGANTRYT3 = {
    ['A'] = 'xel0305',
    ['M'] = 'xel0306',
    ['E'] = 'uel0309',
    ['O'] = 'uel0303',
    ['R'] = 'uel0304',
    ['T'] = 'xea0306',
    ['S'] = 'uea0302',
    ['F'] = 'uea0303',
    ['O'] = 'uea0304',
    ['G'] = 'uea0305',
}

do -- I probably have something very wrong here
    local function joinMyTables(t1, t2)
     
       for k,v in ipairs(t2) do
          table.insert(t1, v)
       end 
     
       return t1
    end
    
    joinMyTables(UEFGANTRYT1, UEFT1Land)
    joinMyTables(UEFGANTRYT1, UEFT1Air)
    joinMyTables(UEFGANTRYT1, UEFT1Sea)
                                    
    joinMyTables(UEFGANTRYT2, UEFT2Land)
    joinMyTables(UEFGANTRYT2, UEFT2Air)
    joinMyTables(UEFGANTRYT2, UEFT2Sea)
                                      
    joinMyTables(UEFGANTRYT3, UEFT3Land)
    joinMyTables(UEFGANTRYT3, UEFT3Air)
    joinMyTables(UEFGANTRYT3, UEFT3Sea)
end

buildModeKeys['seb0401'] = {
    [1] = UEFGANTRYT1,
    [2] = UEFGANTRYT2,
    [3] = UEFGANTRYT3,
    [4] = UEFT4Eng, 
}
