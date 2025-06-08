```plantuml
@startuml
left to right direction
skinparam packageStyle rectangle

'los dos usuarios'
actor Admin as "Administrador"
actor Trabajador as "Trabajador"

rectangle {

  usecase "Crear tarea, reunión o pedido"
  usecase "Modificar tarea, reunión o pedido"
  usecase "Eliminar tarea, reunión o pedido"
  usecase "Consultar tareas, reuniones o pedidos asignados"

}

'sin las flechitas'
Admin -- "Crear tarea, reunión o pedido"
Admin -- "Modificar tarea, reunión o pedido"
Admin -- "Eliminar tarea, reunión o pedido"
Admin -- "Consultar tareas, reuniones o pedidos asignados"

Trabajador -- "Consultar tareas, reuniones o pedidos asignados"

@enduml