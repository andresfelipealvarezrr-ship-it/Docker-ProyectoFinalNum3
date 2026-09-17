# Proyecto 3 - API de usuarios con PostgreSQL y pgAdmin

## Descripcion
API REST de usuarios (Node.js + Express) con persistencia en PostgreSQL, administrable desde pgAdmin. Todo el stack corre con Docker Compose: la migracion inicial de la base de datos se ejecuta automaticamente al crear el volumen, y la API valida los datos de entrada.

## Requisitos
- Docker y Docker Compose
- Puerto 4000 (API), 5050 (pgAdmin) y 5432 (Postgres) libres

## Ejecucion
cp .env.example .env
docker compose up -d
docker compose ps

La API queda disponible en http://localhost:4000 y pgAdmin en http://localhost:5050

## Endpoints
| Metodo | Ruta           | Descripcion         |
|--------|----------------|----------------------|
| GET    | /health        | Estado del servicio  |
| GET    | /api/users     | Listar usuarios      |
| GET    | /api/users/:id | Obtener un usuario   |
| POST   | /api/users     | Crear usuario        |
| PUT    | /api/users/:id | Actualizar usuario   |
| DELETE | /api/users/:id | Eliminar usuario     |

Validacion: name y email obligatorios, email con formato valido.
Respuestas: 400 datos invalidos, 404 no encontrado.

## pgAdmin
1. Entrar a http://localhost:5050 con las credenciales del .env
2. Add New Server, pestana Connection:
   - Host: db (nombre del servicio, no localhost)
   - Port: 5432
   - Usuario/contrasena: los del .env

## Comandos utiles
make up      # levantar
make down    # detener
make logs    # ver logs
make ps      # ver estado
make test    # probar health + listar usuarios

## Preguntas de reflexion

**Por que el script de migracion solo se ejecuta la primera vez que se crea el volumen?**
Porque Postgres solo revisa la carpeta docker-entrypoint-initdb.d cuando el volumen de datos esta vacio (primera inicializacion). Si ya existe data en el volumen, asume que la base ya fue inicializada y no vuelve a ejecutar esos scripts. Para volver a ejecutarlo hay que borrar el volumen con docker compose down -v y levantar de nuevo.

**Por que en pgAdmin el host de conexion es el nombre del servicio y no localhost?**
Porque cada servicio de Docker Compose corre en su propio contenedor con su propia red interna. localhost dentro de un contenedor se refiere al propio contenedor, no a otro. Compose crea una red donde los servicios se resuelven por su nombre (DNS interno), por eso pgAdmin y la API usan db.

**Que ocurre si la API arranca antes de que la base de datos este lista, y como lo previene el compose?**
La API fallaria al intentar conectarse porque Postgres aun no acepta conexiones. Se previene con el healthcheck de la db (pg_isready) combinado con depends_on: condition: service_healthy en el servicio api, que hace que Docker espere a que el healthcheck pase antes de arrancar la API.

## Evidencias
- docker compose ps: 3 servicios corriendo (db healthy, api, pgadmin)
- CRUD completo probado con curl (GET, POST, PUT, DELETE, 400, 404)
- pgAdmin conectado mostrando la tabla users
- Persistencia verificada: los datos sobreviven a docker compose down / up -d
