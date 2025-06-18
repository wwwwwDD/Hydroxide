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

local function scan(query)
    local scripts = {}
    query = query or ""

    for _i, v in pairs(getGc()) do
        if type(v) == "function" and not isXClosure(v) then
            local env = getfenv(v)
            local script = rawget(env, "script")

            if typeof(script) == "Instance"
                and not scripts[script]
                and (script:IsA("LocalScript") or script:IsA("ModuleScript") or script:IsA("Script"))
                and script.Name:lower():find(query)
                and getScriptClosure(script)
                and script.Parent ~= nil -- не уничтожен
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
