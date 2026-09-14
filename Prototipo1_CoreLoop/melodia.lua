-- MODULO: MELODIA
local M = {}

-- CREACION
function M.crear()
    M.secuencias = {
        {"Do","Re","Mi","Fa","Sol","La","Si","Si","La","Sol","Fa","Mi","Re","Do"},
        {"Do","Do","Do","Re","Mi","Do","Sol","Sol","Sol","La","Sol","Sol","La","Sol","Fa","Mi","Do","Re","Fa","Mi","Re","Do"},
        {"Mi","Mi","Fa","Sol","Sol","Fa","Mi","Re","Do","Do","Re","Mi","Mi","Re","Re","Mi","Mi","Fa","Sol","Sol","Fa","Mi","Re","Do","Do","Re","Mi","Re","Do","Do"}
    }
    M.nivelActual = 1
    M.notaEnCurso = 1
end

-- VERIFICACION
function M.verificar(notaTocada)
    local secuencia = M.secuencias[M.nivelActual]
    if notaTocada == secuencia[M.notaEnCurso] then
        M.notaEnCurso = M.notaEnCurso + 1
        if M.notaEnCurso > #secuencia then
            if M.nivelActual < 3 then
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
    love.graphics.print("Nivel " .. M.nivelActual, 20, 530)
    love.graphics.print(M.notaEnCurso - 1 .. "/" .. #secuencia, 700, 530)

    for i = 1, #secuencia do
        local nx = 20 + (i - 1) * 25
        local ny = 555
        if i < M.notaEnCurso then
            love.graphics.setColor(0.5, 0.5, 0.5)
        elseif i == M.notaEnCurso then
            love.graphics.setColor(1, 1, 0)
        else
            love.graphics.setColor(1, 1, 1)
        end
        love.graphics.print(string.sub(secuencia[i], 1, 2), nx, ny)
    end
end

return M