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

