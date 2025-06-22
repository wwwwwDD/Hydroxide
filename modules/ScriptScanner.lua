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
            local script = rawget(getfenv(v), "script")

            -- Логирование для отладки
            if script then
                print("Processing script:", script, "Type:", typeof(script), "Class:", script.ClassName or "N/A", "Name:", script.Name or "N/A")
            else
                print("No script found for function:", v)
            end

            -- Проверяем, что script не nil и является LocalScript
            if script and typeof(script) == "Instance" and 
               script:IsA("LocalScript") and 
               not scripts[script] and 
               script.Name:lower():find(query)
            then
                -- Безопасный вызов getScriptClosure
                local success, closure = pcall(getScriptClosure, script)
                if success and closure then
                    -- Безопасный вызов getsenv
                    local senvSuccess = pcall(getsenv, script)
                    if senvSuccess then
                        scripts[script] = LocalScript.new(script)
                    else
                        warn("Failed to get senv for script:", script, script.Name)
                    end
                else
                    warn("Failed to get script closure for:", script, script.Name, "Error:", closure)
                end
            end
        end
    end

    return scripts
end

ScriptScanner.RequiredMethods = requiredMethods
ScriptScanner.Scan = scan
return ScriptScanner
