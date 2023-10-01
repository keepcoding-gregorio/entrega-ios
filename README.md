# [Keep Coding] - Entrega modulo iOS Fundamentals - Gonzalo Gregorio

## Dragon Ball Heroes
Descripción: Desarrollo de una aplicación iOS que consuma la API Rest Dragon Ball de
KeepCoding presentada en clase.
## Requisitos Obligatorios:
1. La aplicación será desarrollada siguiendo la arquitectura MVC.
2. El diseño de interfaces se utilizará .xibs (No storyboards)
3. La aplicación contará con las siguientes pantallas:
- Login, que permita identificar a un usuario (usando el endpoint: /api/auth/login)
- Listado de heroes, que liste todos los heroes (usando el endpoint: /api/heros/all). Se
  podrá escoger entre UITableViewController y UICollectionViewController.
- Detalle de héroe, que represente algunas de las propiedades del héroe (imaen,
  nombre, descripción…) y que contenga un botón para mostrar el listado de
  transformaciones.
- Lista de transformaciones del héroe, que liste todas las transformaciones
  disponibles para ese héroe (usando el endpoint: /api/heros/trasfromations)
4. El proyecto debe incluir Unit Test para la capa de modelo.
## Requisitos Opcionales:
5. Mostrar/ esconder el botón de transformaciones en el detalle de héroe. Si el héroe
cuenta con transformaciones, el botón será mostrado. Si el héroe no cuenta con
transformaciones, debemos esconder el botón.
6. Detalle de transformación, que represente algunas de las
