-- MODULO: SONIDOS
local S = {}
local Eventos = require("eventos")

-- CREACION
function S.crear(notas)
    S.sounds = {}
    for i = 1, #notas do
        S.sounds[i] = love.audio.newSource("Resources/" .. notas[i] .. ".wav", "static")
    end
end

-- REPRODUCIR
function S.reproducir(indice)
    S.sounds[indice]:stop()
    S.sounds[indice]:play()
end

-- REPRODUCIR ESCALA (para cambio de idioma)
function S.reproducirEscala()
    S.escalaActiva = true
    S.escalaIndice = 1
    S.escalaTimer = 0
end

-- ACTUALIZAR (llamar desde love.update)
function S.update(dt)
    if S.escalaActiva then
        S.escalaTimer = S.escalaTimer + dt
        if S.escalaTimer >= 0.08 then
            S.sounds[S.escalaIndice]:stop()
            S.sounds[S.escalaIndice]:play()
            S.escalaIndice = S.escalaIndice + 1
            S.escalaTimer = 0
            if S.escalaIndice > 7 then
                S.escalaActiva = false
            end
        end
    end
end

-- Escuchar evento de cambio de idioma
Eventos:listen("idioma_cambiado", S, function(obj)
    obj.reproducirEscala()
end)

return S