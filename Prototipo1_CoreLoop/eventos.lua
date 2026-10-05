-- MODULO: EVENTOS
-- Sistema de eventos con callbacks por instancia

local Eventos = {}
Eventos.__index = Eventos

function Eventos:new()
    local self = setmetatable({}, Eventos)
    self.listeners = {}  -- eventName -> { {obj, callback}, ... }
    return self
end

-- Registrar callback para un evento
-- obj: la instancia que escucha (para metodo de respuesta)
-- eventName: nombre del evento
-- callback: funcion(obj, ...) que se llama al emitir
function Eventos:listen(eventName, obj, callback)
    if not self.listeners[eventName] then
        self.listeners[eventName] = {}
    end
    table.insert(self.listeners[eventName], {obj = obj, callback = callback})
end

-- Emitir evento a todos los listeners
function Eventos:emit(eventName, ...)
    local list = self.listeners[eventName]
    if list then
        for _, listener in ipairs(list) do
            listener.callback(listener.obj, ...)
        end
    end
end

-- Desregistrar todos los callbacks de un objeto
function Eventos:unlistenAll(obj)
    for eventName, list in pairs(self.listeners) do
        for i = #list, 1, -1 do
            if list[i].obj == obj then
                table.remove(list, i)
            end
        end
    end
end

-- Instancia global
return Eventos:new()