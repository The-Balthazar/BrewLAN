Description['sar9100'] = "<LOC Unit_Description_RND_001>Unlocks additional tech 1 units and unit research."
Description['ser9100'] = "<LOC Unit_Description_RND_001>Unlocks additional tech 1 units and unit research."
Description['srr9100'] = "<LOC Unit_Description_RND_001>Unlocks additional tech 1 units and unit research."
Description['ssr9100'] = "<LOC Unit_Description_RND_001>Unlocks additional tech 1 units and unit research."
Description['sar9200'] = "<LOC Unit_Description_RND_002>Unlocks tech 2 units and unit research."
Description['ser9200'] = "<LOC Unit_Description_RND_002>Unlocks tech 2 units and unit research."
Description['srr9200'] = "<LOC Unit_Description_RND_002>Unlocks tech 2 units and unit research."
Description['ssr9200'] = "<LOC Unit_Description_RND_002>Unlocks tech 2 units and unit research."
Description['sar9300'] = "<LOC Unit_Description_RND_003>Unlocks tech 3 units and unit research."
Description['ser9300'] = "<LOC Unit_Description_RND_003>Unlocks tech 3 units and unit research."
Description['srr9300'] = "<LOC Unit_Description_RND_003>Unlocks tech 3 units and unit research."
Description['ssr9300'] = "<LOC Unit_Description_RND_003>Unlocks tech 3 units and unit research."
Description['sar9400'] = "<LOC Unit_Description_RND_004>Unlocks experimental units and unit research."
Description['ser9400'] = "<LOC Unit_Description_RND_004>Unlocks experimental units and unit research."
Description['srr9400'] = "<LOC Unit_Description_RND_004>Unlocks experimental units and unit research."
Description['ssr9400'] = "<LOC Unit_Description_RND_004>Unlocks experimental units and unit research."

Description['sab9101'] = "<LOC Unit_Description_RND_005>Basic research facility. Grants access to new units and higher tech levels."
Description['seb9101'] = "<LOC Unit_Description_RND_005>Basic research facility. Grants access to new units and higher tech levels."
Description['srb9101'] = "<LOC Unit_Description_RND_005>Basic research facility. Grants access to new units and higher tech levels."
Description['ssb9101'] = "<LOC Unit_Description_RND_005>Basic research facility. Grants access to new units and higher tech levels."
Description['sab9201'] = "<LOC Unit_Description_RND_006>Intermediate research facility. Has increased research speed and durability."
Description['seb9201'] = "<LOC Unit_Description_RND_006>Intermediate research facility. Has increased research speed and durability."
Description['srb9201'] = "<LOC Unit_Description_RND_006>Intermediate research facility. Has increased research speed and durability."
Description['ssb9201'] = "<LOC Unit_Description_RND_006>Intermediate research facility. Has increased research speed and durability."
Description['sab9301'] = "<LOC Unit_Description_RND_007>Advanced research facility. Has increased research speed and durability."
Description['seb9301'] = "<LOC Unit_Description_RND_007>Advanced research facility. Has increased research speed and durability."
Description['srb9301'] = "<LOC Unit_Description_RND_007>Advanced research facility. Has increased research speed and durability."
Description['ssb9301'] = "<LOC Unit_Description_RND_007>Advanced research facility. Has increased research speed and durability."

Description['sra0211'] = "<LOC Unit_Description_RND_008>Intermediate bomber aircraft."
Description['sea0211'] = "<LOC Unit_Description_RND_009>Intermediate bomber aircraft."
Description['ssa0211'] = "<LOC Unit_Description_RND_010>Intermediate bomber aircraft."

Description['sab1101'] = "<LOC Unit_Description_RND_011>Produces a variable quantity of energy."
Description['seb1101'] = "<LOC Unit_Description_RND_011>Produces a variable quantity of energy."
Description['srb1101'] = "<LOC Unit_Description_RND_011>Produces a variable quantity of energy."
Description['ssb1101'] = "<LOC Unit_Description_RND_011>Produces a variable quantity of energy."

Description['sab3301'] = "<LOC Unit_Description_RND_012>Sensor array. Capable of identifying targets through stealth and cloak and clears jammer blips."
Description['seb3301'] = "<LOC Unit_Description_RND_012>Sensor array. Capable of identifying targets through stealth and cloak and clears jammer blips."
Description['srb3301'] = "<LOC Unit_Description_RND_012>Sensor array. Capable of identifying targets through stealth and cloak and clears jammer blips."
Description['ssb3301'] = "<LOC Unit_Description_RND_012>Sensor array. Capable of identifying targets through stealth and cloak and clears jammer blips."

do
    for id, bp in __blueprints do
        if bp.Categories and table.find(bp.Categories, 'BUILTBYRESEARCH') and not Description[id] and Description[string.gsub(id, "rnd","")] then
            Description[id] = Description[string.gsub(id, "rnd","")]
        end
    end
end
