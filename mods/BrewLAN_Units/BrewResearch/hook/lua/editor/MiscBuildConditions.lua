function RNDResearchIsNotComplete(aiBrain)
    return not aiBrain.BrewResearchIsComplete
end

function RNDResearchIsComplete(aiBrain)
    return aiBrain.BrewResearchIsComplete
end
