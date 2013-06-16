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
    ['S '] = 'uea0101',
    ['O '] = 'uea0103',
    ['T '] = 'uea0107',
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