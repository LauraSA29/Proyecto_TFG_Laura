```plantuml
@startuml
skinparam dpi 150
skinparam shadowing false
skinparam linetype ortho
skinparam rectangle {
    BackgroundColor white
    BorderColor black
    RoundCorner 5
}

actor Usuario as U
rectangle "Usuario\n(Dispositivo móvil / escritorio)" {
    [Aplicación Flutter]
}

rectangle "Servidor NGINX" {
    [Proxy inverso\nHTTPS]
}

rectangle "Servidor Backend\n(Odoo)" {
    [Odoo ERP]
    rectangle "Módulos Activados:\n- Tareas\n- Pedidos\n- Productos\n- Empleados" as Modulos
}

rectangle "Servidor de Base de Datos" {
    [PostgreSQL]
}

U --> [Aplicación Flutter]
[Aplicación Flutter] -[#green,dashed]> [Proxy inverso\nHTTPS] : HTTPS
[Proxy inverso\nHTTPS] -[#green,dashed]> [Odoo ERP] : HTTP interno
[Odoo ERP] --> Modulos
[Odoo ERP] -[#blue,dashed]> [PostgreSQL] : Conexión directa\ninternamente

@enduml
