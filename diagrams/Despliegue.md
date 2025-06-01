```plantuml
@startuml

node "Tasknelia\nAplicación Flutter\n<<device>>" as flutter

node "Servidor Docker Host" as docker {

  node "NGINX\n<<container>>\n(Puertos 80, 443)" as nginx {
    [Proxy inverso\nHTTPS → HTTP interno]
  }

  node "Odoo\n<<container>>\n(Puerto 8069)" as odoo {
    [Servidor ERP]
  }

  database "PostgreSQL\n<<database>>\n(Puerto 5432)" as postgres
}

flutter --> nginx : HTTPS :443
nginx --> odoo : HTTP :8069
odoo --> postgres : TCP :5432

note right of odoo
Módulos activados:
- Contactos
- Productos
- Pedidos
- Proyectos / Tareas
- Calendario
end note
@enduml