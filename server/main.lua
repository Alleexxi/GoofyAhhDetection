local MatrixPrint = function(...)
    print("[MATRIX]", ...)
end

local loadPattenrs = function()
    local patterns_json = LoadResourceFile(GetCurrentResourceName(), "data/whitelisted.json") or "{}"
    SetConvarReplicated("matrix_patterns", patterns_json)
end
loadPattenrs()

local addPattern = function (pattern)
    if not pattern then return MatrixPrint("Pattern is nil") end

    local patterns_json = LoadResourceFile(GetCurrentResourceName(), "data/whitelisted.json") or "{}"
    local pattenrs = json.decode(patterns_json) or {}

    pattenrs[pattern] = true

    local toSave = json.encode(pattenrs)
    SaveResourceFile(GetCurrentResourceName(), "data/whitelisted.json", toSave, #toSave)

    loadPattenrs()
end


local SubCommands = {
    ["version"] = function(args)
        MatrixPrint("Matrix", GetResourceMetadata(GetCurrentResourceName(), "version", 0))
    end,
    ["install"] = function(args)
        exports[GetCurrentResourceName()].install()
    end,
    ["uninstall"] = function(args)
        exports[GetCurrentResourceName()].uninstall()
    end,
    ["whitelist"] = function(args)
        if #args ~= 1 then return MatrixPrint("Invalid Arguments") end
        local pattern_hash = args[1]
        addPattern(pattern_hash)
    end,
}

RegisterCommand('matrix', function(source, args, rawCommand)
    if source ~= 0 then return end

    if #args == 0 then
        MatrixPrint("Available commands:")
        for command, _ in pairs(SubCommands) do
            MatrixPrint("  - " .. command)
        end
        return
    end

    local subCommand = args[1]
    if not SubCommands[subCommand] then return MatrixPrint("Invalid Sub Command") end

    table.remove(args, 1)
    SubCommands[subCommand](args)
end, true)


MatrixPrint("Loaded.")


RegisterNetEvent("Matrix_pattern", function(pattern, pattern_hash)
    if Config.OnDetection == "AddToValid" then
        addPattern(pattern_hash)
    elseif Config.OnDetection:lower() == "ban" then
        --
    elseif Config.OnDetection:lower() == "kick" then
        DropPlayer(tostring(source), "Native...")
    end

    MatrixPrint(pattern)
    MatrixPrint(pattern_hash)
    MatrixPrint("Triggered by", source,"\n")
end)

SetConvarReplicated("MatrixAggressiveDetection", tostring(Config.AggressiveDetection))