-- MODULO: MELODIA
local M = {}
local I = require("idioma")
local H = require("heptagono")
local Eventos = require("eventos")

function M.crear()
    M.secuencias = {
        {1,2,3,4,5,6,7,7,6,5,4,3,2,1},
        {1,1,1,2,3,1,5,5,5,6,5,  5,6,5,4,3,1,2,4,3,2,1},
        {5,6,5,4,3,4,5,2,3,4,3,4,5,  5,6,5,4,3,4,5,2,5,3,1},
        {3,2,1,2,3,3,3,2,2,2,3,5,5,  3,2,1,2,3,3,3,2,2,3,2,1},
        {3,3,4,5,5,4,3,2,1,1,2,3,3,2,2,  3,3,4,5,5,4,3,2,1,1,2,3,2,1,1},
        {1,3,4,5,1,3,4,5,1,3,4,5,3,1,3,2,  3,3,2,1,3,3,5,5,4,4,3,4,5,3,1,2,1},
        {1,2,3,1,1,2,3,1,3,4,5,3,4,5,  5,6,5,4,3,1,5,6,5,4,3,1,5,6,5,4,3,1,  1,5,1,1,5,1},
        {1,1,5,5,6,6,5,4,4,3,3,2,2,1,  5,5,4,4,3,3,2,5,5,4,4,3,3,2,
         1,1,5,5,6,6,5,4,4,3,3,2,2,1},
        {3,3,3,3,3,3,3,5,1,2,3,  4,4,4,4,4,3,3,3,3,3,2,2,3,2,5,
         3,3,3,3,3,3,3,5,1,2,3,  4,4,4,4,4,3,3,3,3,5,5,4,2,1},
        {1,2,3,5,5,6,5,3,1,2,3,3,2,1,2,  1,2,3,5,5,6,5,3,1,2,3,3,2,2,1,
         4,4,6,6,6,5,5,3,1,2,  1,2,3,5,5,6,5,3,1,2,3,3,2,2,1}
    }

    M.ocultas = {
        [1] = {7, 11},
        [2] = {3, 6, 17, 22},
        [3] = {11, 12, 13, 18, 19, 20},
        [4] = {9, 10, 13, 19, 20, 22},
        [5] = {17, 19, 21, 23, 25, 27},
        [6] = {10, 11, 12, 27, 28, 29},
        [7] = {21, 22, 23, 30, 31, 32, 36, 37, 38},
        [8] = {29, 30, 31, 32, 33, 34, 35, 36, 37},
        [9] = {18, 19, 20, 21},
        [10] = {23, 24, 25, 26, 27, 38, 39, 40, 46, 47, 48, 49}
    }

    M.reveladas = {}
    M.nivelActual = 1
    M.notaEnCurso = 1
end

function M.revelar(idx)
    if not M.reveladas[M.nivelActual] then M.reveladas[M.nivelActual] = {} end
    M.reveladas[M.nivelActual][idx] = true
    Eventos:emit("nota_revelada", idx)
end

function M.estaOculta(idx)
    local o = M.ocultas[M.nivelActual]
    if not o then return false end
    for _, v in ipairs(o) do if v == idx then
        return not (M.reveladas[M.nivelActual] and M.reveladas[M.nivelActual][idx]) end
    end
    return false
end

function M.verificar(nota)
    local s = M.secuencias[M.nivelActual]
    if nota == H.getNota(s[M.notaEnCurso]) then
        local i = M.notaEnCurso
        if M.estaOculta(i) then M.revelar(i) end
        M.notaEnCurso = M.notaEnCurso + 1
        if M.notaEnCurso > #s then
            if M.nivelActual < 10 then M.nivelActual = M.nivelActual + 1; M.notaEnCurso = 1; return "avanza" end
            return "ganaste"
        end
        return "acerto"
    else M.notaEnCurso = 1; return "fallo" end
end

function M.reiniciar() M.nivelActual = 1; M.notaEnCurso = 1; M.reveladas = {} end
function M.reiniciarSecuencia() M.notaEnCurso = 1 end

function M.dibujar()
    local s = M.secuencias[M.nivelActual]
    love.graphics.setColor(1,1,1)
    love.graphics.print(I.getTexto("nivel", idioma) .. M.nivelActual, 20, 590)
    love.graphics.print(M.notaEnCurso - 1 .. "/" .. #s, 1180, 590)
    for i = 1, #s do
        local nx = 20 + (i-1)*22; local ny = 615
        local txt = M.estaOculta(i) and "?" or I.getNota(s[i], idioma)
        if i < M.notaEnCurso then love.graphics.setColor(0.5,0.5,0.5)
        elseif i == M.notaEnCurso then love.graphics.setColor(1,1,0)
        else love.graphics.setColor(1,1,1) end
        love.graphics.print(string.sub(txt,1,2), nx, ny)
    end
end

return M