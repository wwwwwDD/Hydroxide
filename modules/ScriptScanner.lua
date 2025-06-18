local ScriptScanner = {}
local LocalScript = import("objects/LocalScript")

local requiredMethods = {
    ["getGc"] = true,
    ["getSenv"] = true,
    ["getProtos"] = true,
    ["getConstants"] = true,
    ["getScriptClosure"] = true,
    ["isXClosure"] = true
}

local function isValidScriptInstance(inst)
    return typeof(inst) == "Instance"
        and inst:IsA("LocalScript") -- 💥 ВАЖНО: только LocalScript
        and inst.Parent ~= nil
end

local function scan(query)
    local scripts = {}
    query = query or ""

    for _i, v in pairs(getGc()) do
        if type(v) == "function" and not isXClosure(v) then
            local env = getfenv(v)
            local script = rawget(env, "script")

            if isValidScriptInstance(script)
                and not scripts[script]
                and script.Name:lower():find(query)
                and getScriptClosure(script)
            then
                local success = pcall(function()
                    getsenv(script)
                end)

                if success then
                    scripts[script] = LocalScript.new(script)
                end
            end
        end
    end

    return scripts
end

ScriptScanner.RequiredMethods = requiredMethods
ScriptScanner.Scan = scan
return ScriptScanner
