local function scan(query)
    local scripts = {}
    query = query or ""

    for _i, v in pairs(getGc()) do
        if type(v) == "function" and not isXClosure(v) then
            local script = rawget(getfenv(v), "script")

            -- Проверяем, что script не nil и является Instance
            if script and typeof(script) == "Instance" and 
               (script:IsA("LocalScript") or script:IsA("ModuleScript") or script:IsA("Script")) and 
               not scripts[script] and 
               script.Name:lower():find(query)
            then
                -- Используем pcall для безопасного вызова getScriptClosure и getsenv
                local success, closure = pcall(getScriptClosure, script)
                if success and closure then
                    local senvSuccess = pcall(function() getsenv(script) end)
                    if senvSuccess then
                        scripts[script] = LocalScript.new(script)
                    end
                end
            end
        end
    end

    return scripts
end
