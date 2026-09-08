-- MAQUINA DE ESTADOS: GESTOR
-- Administra los estados y las transiciones entre ellos

local StateMachine = {}
StateMachine.__index = StateMachine

-- CREAR MAQUINA DE ESTADOS
function StateMachine:new()
    local self = setmetatable({}, StateMachine)
    self.states = {}
    self.currentState = nil
    return self
end

-- REGISTRAR ESTADO
function StateMachine:addState(state)
    self.states[state.name] = state
end

-- CAMBIAR DE ESTADO
function StateMachine:changeState(name)
    if self.currentState then
        self.currentState:exit()
    end
    self.currentState = self.states[name]
    if self.currentState then
        self.currentState:enter()
    end
end

-- ACTUALIZAR ESTADO ACTUAL
function StateMachine:update(dt)
    if self.currentState then
        self.currentState:update(dt)
    end
end

-- OBTENER ESTADO ACTUAL
function StateMachine:getState()
    if self.currentState then
        return self.currentState.name
    end
    return nil
end

return StateMachine