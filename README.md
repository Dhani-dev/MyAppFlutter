# APP DE USUARIOS EN FLUTTER - CRUD

Este proyecto implementa las funcionalidades de un CRUD (Crear, Leer, Actualizar, Eliminar) utilizando Flutter, la gestión de estado con Provider y una API REST simulada. 

## API Utilizada
Este proyecto utiliza la API pública de [DummyJSON](https://dummyjson.com/) para simular las operaciones de lectura, creación y actualización de usuarios.
- **Recurso Principal:** Se usa la [/users](https://dummyjson.com/users).
- **Nota sobre CRUD:** La API de DummyJSON simula las respuestas de POST, PUT y DELETE con códigos de éxito, pero no persiste los cambios en la base de datos. El *UserProvider* maneja la persistencia y la generación de IDs únicos de forma local para los registros creados por el usuario (IDs mayores a 100).

## Funcionalidades

- **Lista de Usuarios (GET):** Muestra los usuarios obtenidos de la API.
- **Creación (POST):** Permite añadir nuevos usuarios.
- **Actualización (PUT):** Permite editar usuarios existentes (usuarios tanto de la API como también creados localmente).
- **Eliminación (DELETE):** Implementa soft-delete simulado para usuarios de la API.
- **Gestión de Estado:** Uso de Provider para la actualización automática de la lista.
- **Scroll Infinito:** Carga de datos optimizada en la lista.

## Guía de instalación

Para ejecutar la app es necesario tener un entorno de desarrollo de Flutter.

- **Instalar Android Studio:** Descárgalo desde el sitio oficial de Google.
- **Instalar Flutter SDK:** Descárgalo desde el sitio oficial de Flutter y descomprime la carpeta.
- **Configura la Variable de Entorno:** Agrega la ruta de la carpeta bin de Flutter a la variable PATH de tu sistema operativo.
- **Ejecuta flutter doctor:** Abre la terminal o Command Prompt y ejecuta:

`flutter doctor`

## Ejecución del proyecto

- **1. Clonar el repositorio desde la terminal:**

`git clone https://github.com/Dhani-dev/MyAppFlutter.git`

`cd <NOMBRE_DEL_PROYECTO>`

- **2. Obtener Dependencias dentro de la carpeta del proyecto:**

`flutter pub get`

- **3. Iniciar un Emulador:** Puede ser un emulador mobile, chrome, etc.

- **4. Ejecutar la App:**

`flutter run`