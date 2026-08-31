-- MODULO: SONIDOS
local S = {}

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

return S