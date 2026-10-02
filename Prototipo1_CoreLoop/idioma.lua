-- MODULO: IDIOMA
-- Tabla de traducciones para notas y textos de la interfaz

local I = {}

I.notas = {
    es = {"Do", "Re", "Mi", "Fa", "Sol", "La", "Si"},
    en = {"C", "D", "E", "F", "G", "A", "B"}
}

I.textos = {
    es = {
        -- Menu
        titulo = "Peque Symphonie",
        controles = "ESC: Salir | M: Menu | U: Ultra",
        botonLibre = "JUGA LIBRE",
        botonMelodia = "TOCA LA MELODIA",
        -- Juego
        nivel = "Nivel ",
        nota = "Nota: ",
        mensajeGanaste = "GANASTE!",
        clickVolver = "Hacé click para volver al menú",
        -- Mensajes
        nivelCompletado = "Nivel %d completado!",
        secuenciaReiniciada = "Secuencia reiniciada!",
    },
    en = {
        -- Menu
        titulo = "Peque Symphonie",
        controles = "ESC: Exit | M: Menu | U: Ultra",
        botonLibre = "PLAY FREE",
        botonMelodia = "PLAY MELODY",
        -- Juego
        nivel = "Level ",
        nota = "Note: ",
        mensajeGanaste = "YOU WIN!",
        clickVolver = "Click to return to menu",
        -- Mensajes
        nivelCompletado = "Level %d completed!",
        secuenciaReiniciada = "Sequence restarted!",
    }
}

-- Obtener nombre de nota segun idioma
function I.getNota(indice, lang)
    lang = lang or "es"
    return I.notas[lang][indice]
end

-- Obtener texto segun idioma
function I.getTexto(key, lang, ...)
    lang = lang or "es"
    local texto = I.textos[lang][key]
    if not texto then return key end
    if ... then
        return string.format(texto, ...)
    end
    return texto
end

return I