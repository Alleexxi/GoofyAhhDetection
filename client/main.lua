local patternsExecuted = {}

function addPatternToList(pattern)
  patternsExecuted[pattern] = true
end

exports("addPatternToList", addPatternToList)

RegisterCommand('printpatterns', function(args)
    print(json.encode(patternsExecuted))
end, false)