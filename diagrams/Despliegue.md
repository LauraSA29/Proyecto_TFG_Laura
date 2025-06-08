```plantuml
@startuml
node "Tasknelia\nAplicación Flutter\n<<device>>" as flutter

node "Docker" as docker {

  node "NGINX\n<<container>>\n(Puerto 8080)" as nginx {
    [Proxy inverso\nHTTP → contenedor Odoo]
  }

  node "Odoo\n<<container>>\n(Puerto 8069)" as odoo {
    [Servidor ERP con API JSON-RPC]
  }

  database "PostgreSQL\n<<database>>\n(Puerto 5432)" as postgres
}

flutter -- nginx : HTTP:8080 / JSON-RPC
nginx -- odoo : HTTP:8069 / JSON-RPC
odoo -- postgres : TCP:5432

note right of odoo
Módulos activados:
- Contactos
- Inventario
- Ventas
- Proyectos
- Calendario
end note
@enduml