import 'package:flutter/material.dart';

class AppDestination {
  const AppDestination({
    required this.path,
    required this.label,
    required this.group,
    required this.description,
    required this.icon,
  });

  final String path;
  final String label;
  final String group;
  final String description;
  final IconData icon;
}

const appDestinations = <AppDestination>[
  AppDestination(
    path: '/dashboard',
    label: 'Inicio',
    group: 'Inicio',
    description: 'Resumen general del personal y la organización.',
    icon: Icons.space_dashboard_outlined,
  ),
  AppDestination(
    path: '/organizacion/organigrama',
    label: 'Organigrama',
    group: 'Estructura',
    description:
        'Estructura organizacional de Grupo GPA, desde las empresas hasta sus áreas.',
    icon: Icons.account_tree_outlined,
  ),
  AppDestination(
    path: '/organizacion/empresas',
    label: 'Empresas',
    group: 'Estructura',
    description: 'La información de las empresas que integran Grupo GPA.',
    icon: Icons.business_outlined,
  ),
  AppDestination(
    path: '/ubicaciones',
    label: 'Ubicaciones',
    group: 'Estructura',
    description: 'Plantas, oficinas y demás ubicaciones físicas de la organización.',
    icon: Icons.place_outlined,
  ),
  AppDestination(
    path: '/ubicaciones/naves',
    label: 'Naves',
    group: 'Estructura',
    description: 'Consulta las naves de cada ubicación.',
    icon: Icons.warehouse_outlined,
  ),
  AppDestination(
    path: '/ubicaciones/areas',
    label: 'Áreas',
    group: 'Estructura',
    description: 'Las áreas registradas dentro de cada nave.',
    icon: Icons.grid_view_outlined,
  ),
  AppDestination(
    path: '/personas',
    label: 'Personas',
    group: 'Personal',
    description: 'Datos personales, de contacto y médicos de cada persona registrada.',
    icon: Icons.people_outline,
  ),
  AppDestination(
    path: '/empleados',
    label: 'Empleados',
    group: 'Personal',
    description: 'Relación laboral, contrato y posición de cada empleado.',
    icon: Icons.badge_outlined,
  ),
  AppDestination(
    path: '/posiciones',
    label: 'Posiciones',
    group: 'Personal',
    description: 'Puestos ocupados y vacantes, con su línea de reporte.',
    icon: Icons.work_outline,
  ),
  AppDestination(
    path: '/posiciones/puestos',
    label: 'Puestos',
    group: 'Personal',
    description: 'El catálogo de puestos de Grupo GPA.',
    icon: Icons.assignment_ind_outlined,
  ),
  AppDestination(
    path: '/licencias-permisos',
    label: 'Licencias y permisos',
    group: 'Personal',
    description: 'Solicitudes y control de licencias, permisos y ausencias del personal.',
    icon: Icons.event_available_outlined,
  ),
  AppDestination(
    path: '/reclutamiento',
    label: 'Reclutamiento',
    group: 'Personal',
    description: 'Requisiciones de personal y descriptivos de puesto.',
    icon: Icons.person_search_outlined,
  ),
  AppDestination(
    path: '/horarios/catorcenas',
    label: 'Catorcenas',
    group: 'Jornada',
    description: 'Los periodos de catorcena que organizan la nómina y el calendario laboral.',
    icon: Icons.date_range_outlined,
  ),
  AppDestination(
    path: '/horarios/tipos',
    label: 'Tipos de horario',
    group: 'Jornada',
    description: 'Consulta las modalidades de horario de la organización.',
    icon: Icons.schedule_outlined,
  ),
  AppDestination(
    path: '/horarios/asignaciones-horario',
    label: 'Asignaciones de horario',
    group: 'Jornada',
    description: 'El horario asignado a cada empleado por catorcena.',
    icon: Icons.event_note_outlined,
  ),
  AppDestination(
    path: '/horarios/asignaciones-ubicacion',
    label: 'Asignaciones de ubicación',
    group: 'Jornada',
    description: 'La ubicación asignada a cada integrante del equipo.',
    icon: Icons.person_pin_circle_outlined,
  ),
  AppDestination(
    path: '/tiempo',
    label: 'Tiempo',
    group: 'Jornada',
    description: 'Registro y control de asistencia, horas trabajadas e incidencias.',
    icon: Icons.timelapse_outlined,
  ),
  AppDestination(
    path: '/desempeno',
    label: 'Desempeño',
    group: 'Cultura',
    description: 'Evaluaciones de desempeño y seguimiento de objetivos.',
    icon: Icons.insights_outlined,
  ),
  AppDestination(
    path: '/buzz',
    label: 'Buzz',
    group: 'Cultura',
    description: 'Comunicados y noticias internas de la organización.',
    icon: Icons.forum_outlined,
  ),
];

AppDestination destinationFor(String location) {
  final path = Uri.parse(location).path;
  for (final destination in appDestinations) {
    if (destination.path == path) return destination;
  }
  // Rutas de detalle (ej. /personas/:id) no están en appDestinations —
  // caen a la sección cuyo path es el prefijo más específico, para que la
  // barra lateral y el título sigan mostrando "Personas" en vez de
  // regresar a Inicio.
  AppDestination? best;
  for (final destination in appDestinations) {
    if (path.startsWith('${destination.path}/') &&
        (best == null || destination.path.length > best.path.length)) {
      best = destination;
    }
  }
  return best ?? appDestinations.first;
}
