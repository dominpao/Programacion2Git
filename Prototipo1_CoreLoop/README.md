# Prototipo 1: Core Loop

## Objetivos

* Crear personaje interactivo (pelota) y entidades pre programadas (lados heptágono)
* Programar animaciones y retroalimentación auditiva y visual (sonidos y colores al impactar)

## Tareas

* Programar interacción del jugador (controlar ángulo/force de la pelota)
* Codificar comportamiento del enemigo y/o elementos del juego (lados del heptágono que producen sonido)
* Gestionar condición de victoria y condición de derrota (lógica de juego)
* Programar retroalimentación visual (animaciones de rebote, efectos visuales al sonar)
* Gestionar versiones del proyecto mediante repositorio

## Detalles de implementación

* **Pelota interactiva**: Movimiento con física de rebote, posición y velocidad actualizadas cada frame
* **Lados heptágono**: 7 entidades preprogramadas que producen sonido al impactar
* **Retroalimentación sonora**: Cada lado del heptágono emite una nota musical distinta al recibir impacto
* **Retroalimentación visual**: Cambio de color de la pelota
* **Condiciones de victoria/derrota**: Si completa la secuencia avanza a la siguiente. La condición de victoria se obtiene al completar los 3 niveles.
* El juego no tiene condición de game over por derrota porque es un espacio musical experimental. El jugador puede seguir intentando indefinidamente. 
* Sin embargo, existe derrota parcial: fallar una nota reinicia la secuencia, sin expulsar al jugador del juego.

---

# Prototipo 2: Maquinas de Estado

## Objetivos

* Implementar maquinas de estado con clases formales
* Programar instanciado dinámico (spawner con timer)

## Tareas

* Programar estados (enter/update/exit)
* Gestionar el cambio de estados en tiempo de juego
* Gestionar versiones del proyecto mediante repositorios
* Spawner con timer para generación dinámica de la esfera giratoria

## Detalles de implementación

* **Maquina de estados**: Clase base State con métodos enter/update/exit, StateMachine para gestionar transiciones
* **Estados de aplicación**: Menu, Game, Win
* **Modo ultra**: Tecla U activa/desactiva esfera giratoria durante el juego
* **Spawner**: La esfera aparece (4s) y desaparece (1s) cíclicamente con posición aleatoria
* **6 niveles de melodía**: Escala de sol, arrorró, himno a la alegría + 3 melodías nuevas

---

# Prototipo 3: Eventos personalizados + Interfaz de juego

## Objetivos

* Implementar eventos personalizados (EventBus)
* Programar interfaz de juego completa

## Tareas

* Crear una interfaz de juego completa (Menu/Game/Win)
* Codificar el funcionamiento y actualización de la interfaz de usuario con eventos
* Codificar respuestas visuales y de audio en respuesta a eventos
* Comunicar objetos entre sí mediante eventos
* Gestionar versiones del proyecto mediante repositorio

## Detalles de implementación

* **EventBus**: Sistema de eventos desacoplado (listen/emit/unlistenAll)
* **Eventos implementados**: `idioma_cambiado` (reproduce escala audio), `nota_revelada` (animación flash visual)
* **Interfaz de juego**: Menu, Game, Win con botones, textos, selector de idioma inline
* **UI con eventos**: Selector de idioma inline en menú y juego, textos traducidos en tiempo real
* **Respuestas a eventos**: Audio (escala al cambiar idioma), Visual (flash al revelar nota oculta)
* **Comunicación por eventos**: EventBus conecta sonidos, pantallas, melodía, gamestate, menustate
* **Mecánica oculta**: 10 niveles con notas ocultas (`?`), revelación al acertar con sonido + flash
* **i18n ES/EN**: Notas (Do=C, Re=D, Mi=E, Fa=F, Sol=G, La=A, Si=B), UI completa, controles, mensajes
* **Selector de idioma**: Inline en menú y juego (click en texto subrayado)
* **10 niveles de melodía** con longitudes exactas y notas ocultas parseadas del spec
* **Pantalla 1500x680**, velocidad de lanzamiento 1800
* **Modo ultra**: Esfera giratoria con spawner timer (aparece 4s, desaparece 1s, posición aleatoria)

