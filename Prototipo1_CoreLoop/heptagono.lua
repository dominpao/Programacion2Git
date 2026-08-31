-- MODULO: HEPTAGONO
local H = {}

-- CREACION
function H.crear(cx, cy, radio)
    H.cx = cx
    H.cy = cy
    H.radio = radio

    -- Notas musicales y colores de cada lado
    H.notas = {"Do", "Re", "Mi", "Fa", "Sol", "La", "Si"}
    H.colores = {
        {1,0,0}, {1,0.5,0}, {1,1,0}, {0,1,0},
        {0,0,1}, {0,1,1}, {0.5,0,1}
    }

    -- Vertices del heptagono
    H.verts = {}
    for i = 1, 7 do
        local a = (i - 1) * (2 * math.pi / 7) - math.pi / 2
        H.verts[i] = {
            x = cx + radio * math.cos(a),
            y = cy + radio * math.sin(a)
        }
    end
end

-- RENDERIZADO
function H.dibujar()
    for i = 1, 7 do
        local v1 = H.verts[i]
        local v2 = H.verts[i % 7 + 1]
        love.graphics.setColor(H.colores[i])
        love.graphics.setLineWidth(4)
        love.graphics.line(v1.x, v1.y, v2.x, v2.y)
    end
end

-- ACCESO A DATOS
function H.getColor(indice)
    return H.colores[indice]
end

function H.getNota(indice)
    return H.notas[indice]
end

return H