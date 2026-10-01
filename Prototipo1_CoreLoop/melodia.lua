-- MODULO: MELODIA
local M = {}
local I = require("idioma")
local H = require("heptagono")

-- CREACION
function M.crear()
    -- Secuencias con indices de notas (1=Do, 2=Re, 3=Mi, 4=Fa, 5=Sol, 6=La, 7=Si)
    M.secuencias = {
        {1,2,3,4,5,6,7,7,6,5,4,3,2,1},
        {1,1,1,2,3,1,5,5,5,6,5,5,6,5,4,3,1,2,4,3,2,1},
        {5,6,5,4,3,4,5,2,3,4,3,4,5,5,6,5,4,3,4,5,2,5,3,1},
        {3,2,1,2,3,3,3,2,2,2,3,5,5,3,2,1,2,3,3,3,2,2,3,2,1},
        {3,3,4,5,5,4,3,2,1,1,2,3,3,2,2,3,3,4,5,5,4,3,2,1,1,2,3,2,1,1},
        {1,3,4,5,1,3,4,5,1,3,4,5,3,1,3,2,3,3,2,1,3,3,5,5,4,4,3,4,5,3,1,2,1},
        {1,2,3,1,1,2,3,1,3,4,5,3,4,5,5,6,5,4,3,1,5,6,5,4,3,1,5,6,5,4,3,1,1,5,1,1,5,1},
        {1,1,5,5,6,6,5,4,4,3,3,2,2,1,5,5,4,4,3,3,2,5,5,4,4,3,3,2,1,1,5,5,6,6,5,4,4,3,3,2,2,1},
        {3,3,3,3,3,3,3,5,1,2,3,4,4,4,4,4,3,3,3,3,3,2,2,3,2,5,3,3,3,3,3,3,3,5,1,2,3,4,4,4,4,4,3,3,3,3,5,5,4,2,1},
        {1,2,3,5,5,6,5,3,1,2,3,3,2,1,2,1,2,3,5,5,6,5,3,1,2,3,3,2,2,1,4,4,6,6,6,5,5,3,1,2,1,2,3,5,5,6,5,3,1,2,3,3,2,2,1}
    }
    M.nivelActual = 1
    M.notaEnCurso = 1
end

-- VERIFICACION
function M.verificar(notaTocada)
    local secuencia = M.secuencias[M.nivelActual]
    local notaEsperada = H.getNota(secuencia[M.notaEnCurso])
    if notaTocada == notaEsperada then
        M.notaEnCurso = M.notaEnCurso + 1
        if M.notaEnCurso > #secuencia then
            if M.nivelActual < 10 then
                M.nivelActual = M.nivelActual + 1
                M.notaEnCurso = 1
                return "avanza"
            else
                return "ganaste"
            end
        end
        return "acerto"
    else
        M.notaEnCurso = 1
        return "fallo"
    end
end

-- RESETEAR
function M.reiniciar()
    M.nivelActual = 1
    M.notaEnCurso = 1
end

-- REINICIAR SECUENCIA DEL NIVEL ACTUAL
function M.reiniciarSecuencia()
    M.notaEnCurso = 1
end

-- RENDERIZADO
function M.dibujar()
    local secuencia = M.secuencias[M.nivelActual]

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Nivel " .. M.nivelActual, 20, 590)
    love.graphics.print(M.notaEnCurso - 1 .. "/" .. #secuencia, 1180, 590)

    for i = 1, #secuencia do
        local nx = 20 + (i - 1) * 22
        local ny = 615
        local nombreNota = I.getNota(secuencia[i], idioma)
        if i < M.notaEnCurso then
            love.graphics.setColor(0.5, 0.5, 0.5)
        elseif i == M.notaEnCurso then
            love.graphics.setColor(1, 1, 0)
        else
            love.graphics.setColor(1, 1, 1)
        end
        love.graphics.print(string.sub(nombreNota, 1, 2), nx, ny)
    end
end

return M