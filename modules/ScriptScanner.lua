local ModuleScript = {}

function ModuleScript.new(instance)
    local moduleScript = {}

    -- Проверяем, что instance не nil и является ModuleScript
    if not instance or typeof(instance) ~= "Instance" or not instance:IsA("ModuleScript") then
        warn("Invalid ModuleScript instance:", instance)
        return moduleScript -- Возвращаем пустой объект, чтобы избежать ошибок
    end

    -- Безопасный вызов getScriptClosure
    local success, closure = pcall(getScriptClosure, instance)
    if not success then
        warn("Failed to get script closure for", instance, ":", closure)
        return moduleScript -- Возвращаем пустой объект
    end

    moduleScript.Instance = instance
    moduleScript.Constants = getConstants(closure) or {}
    moduleScript.Protos = getProtos(closure) or {}
    --moduleScript.ReturnValue = require(instance) // causes detection

    return moduleScript
end

return ModuleScript
