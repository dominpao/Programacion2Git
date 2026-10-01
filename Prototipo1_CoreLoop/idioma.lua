-- MODULO: IDIOMA
-- Tabla de traducciones para notas musicales

local I = {}

I.notas = {
    es = {"Do", "Re", "Mi", "Fa", "Sol", "La", "Si"},
    en = {"C", "D", "E", "F", "G", "A", "B"}
}

-- Obtener nombre de nota segun idioma
function I.getNota(indice, lang)
    lang = lang or "es"
    return I.notas[lang][indice]
end

return I