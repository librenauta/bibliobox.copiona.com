---
layout: post
title: ¿Bajar videos de campus hosteados en vimeo?
tags:
  - cultura libre
  - videos libres
  - descargar video
description: >
  Tuto para descargar videos de campus/cursos pagos a los cuales, al terminar el ciclo revocan claves de acceso.
 #hero: https://source.unsplash.com/collection/145103/
hero: /assets/img/biblio.box.jpg
overlay: blue
published: true
---
# Bajandole
Si ya pagaste un curso y te dan acceso a un campus para verlos, ¿Por qué luego no podrías ver ese contenido?, para poder repasar esos videos cuando quieras vamos a descargarlos. porque si tu navegador puede reproducirlos de alguna manera:
1. Se estan bajando a tu pc.
2. Podemos conseguir el link directo donde está hosteado el video.
*Para esto necesitamos navegar los siguientes pasos y llegar a la: [URL video]+[TOKEN VALIDACIÓN]

[1] Dentro del campus, hacemos Click-derecho [_Inspeccionar elementos_]
![683x741](/assets/img/vid/01.png "Large example image")

[2] Vamos a la pestaña [_Depurador_]
![683x741](/assets/img/vid/02.png "Large example image")

[3] Vamos a la pestaña [_player.vimeo.com_]
![683x741](/assets/img/vid/03.png "Large example image")

[4] Buscamos la carpeta [_video_] index
![683x741](/assets/img/vid/04.png "Large example image")

[5] Seleccionamos el contenido de index
![683x741](/assets/img/vid/05.png "Large example image")

[6] Lo pegamos en un editor de texto donde podamos buscar con ctrl+f ".mp4" y copiamos una url que contenga el link directo + token de validación
![683x741](/assets/img/vid/06.png "Large example image")

[6] y con esta url completa podemos llegar al video completo y su descarga.  *Ej:``https://gcs-vimeo.akamaized.net/exp=15++++++~acl=%2A%2F1047741295.mp4%2A~hmac=2abc71f0c50b40f5d47f722d79de74f7649508e2988934723e0568a86b4780e9/vimeo-prod-skyfire-std-us/01/4477/++++++/1047741295.mp4``
 dónde: ``https://gcs-vimeo.akamaized.net/exp=15++++++~acl=%2A%2F1047741295.mp4`` es la url y si la ingresamos nos dice "acceso denegado" pero si agregamos:`` %2A~hmac=2abc71f0c50b40f5d47f722d79de74f7649508e2988934723e0568a86b4780e9/vimeo-prod-skyfire-std-us/01/4477/10/++++++/1047741295.mp4`` podemos descargarlo.
![683x741](/assets/img/vid/07.png "Large example image")

*Luego en una terminal ponemos ``$ wget [link]`` y descargamos!
*~librenauta
