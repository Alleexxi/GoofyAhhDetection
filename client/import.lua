local patternsWhitelisted = {}

local function loadPatterns()
	patternsWhitelisted = json.decode(GetConvar("matrix_patterns", "{}"))
end
loadPatterns()
AddConvarChangeListener("matrix_patterns", loadPatterns)

local HashString = function(input)
	local hash = 2166136261
	for i = 1, #input do
		local byte = string.byte(input, i)
		hash = (hash * 33) ~ byte
	end
	return string.format("%x", hash)
end

local GetPattern = function(caller_info, func)
	local level = 1
	local info = caller_info
	local hash = ""

	local pattern = ("%s:%s:%s:%s:%s"):format(info.linedefined, info.source, info.name, func, info.currentline)

	local success, bytecode = pcall(string.dump, info.func)
	if GetConvar("MatrixAggressiveDetection", "false") == "true" then
		hash = hash .. HashString(success and bytecode or "fuck")
	end

	-- Might as well take the entire calling stack for the hash

	hash = hash .. HashString(pattern)

	return pattern, hash
end

local CheckCallerPattern = function(caller_info, func)
	local pattern, pattern_hash = GetPattern(caller_info, func)
	local is_whitelisted = patternsWhitelisted[pattern_hash]

	if not is_whitelisted then
		print(("Ban Reason: %s\nPattern: %s\nHash: %s\n"):format("Illegal Native Execution #99", pattern, pattern_hash))
		TriggerServerEvent("Matrix_pattern",
			pattern, pattern_hash
		)
	end
end

local functions_to_hook = { "CreateThread", "setmetatable" }
for _, v in pairs(functions_to_hook) do
	local old_func = _G[v]
	_G[v] = function(...)
		local caller = debug.getinfo(2, "Snlf")
		CheckCallerPattern(caller, v)
		return old_func(...)
	end
	if Citizen[v] then
		Citizen[v] = _G[v]
	end
	print("Hooked " .. v)
end
