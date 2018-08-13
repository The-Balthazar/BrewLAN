do
    local ResearchLocations = {
        {'T1ResearchCentre'},
		{-10, 26 }, -- outer ring 8
		{ 10, 26 },
		{-10,-26 },
		{ 10,-26 },
		{ 26, 10 },
		{ 26,-10 },
		{-26, 10 },
		{-26,-10 },
		{-32, 24 }, -- additional corner 4
		{ 32, 24 },
		{ 32,-24 },
		{-32,-24 },
    }
    ResearchLayout = {{},{},{},{}}
    for i = 1, 4 do
        table.insert(ResearchLayout[i], ResearchLocations)
    end
end
