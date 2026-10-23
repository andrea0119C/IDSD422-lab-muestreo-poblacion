# clasificacion_variables.R — Parte A: clasificación de las variables de clientes.csv.
#
# El archivo data/clientes.csv tiene 12 clientes y 7 variables (más el id).
# El objetivo: clasificar cada variable (numérica continua/discreta, categórica
# binaria/ordinal/nominal) y verificar la clasificación en código.
#
# Regla del capítulo 3: el tipo que infiere el lenguaje es una pista, no la
# clasificación — el criterio (¿tiene sentido la mitad del valor? ¿hay orden
# entre las categorías?) decide.
#
# Uso (desde la raíz del repositorio):  Rscript scripts/clasificacion_variables.R

clientes <- read.csv("C:\\Users\\USUARIO\\Desktop\\Universidad-EPN\\4 TO SEMESTRE\\Estadistica I\\Labo2\\IDSD422-lab-muestreo-poblacion\\data\\clientes.csv", stringsAsFactors = FALSE)

# ---------------------------------------------------------------------------
# 1. Estructura del archivo
# ---------------------------------------------------------------------------
cat(sprintf("Dimensiones: %d filas × %d columnas\n", nrow(clientes), ncol(clientes)))
print(clientes)

# ---------------------------------------------------------------------------
# 2. Tipos inferidos (str) — la pista que da el lenguaje
# ---------------------------------------------------------------------------
str(clientes)
# TODO 1: ¿qué columnas llegan como número (int) y cuáles como texto
#         (character)? Anótalo para el informe. Ojo con satisfaccion: llega
#         como número y es ordinal ("4 no es el doble de 2") — la justificación
#         va en el informe.
cat("\n--- TIPOS DE DATOS ---\n")
str(clientes)

# ---------------------------------------------------------------------------
# 3. Valores únicos — ¿cuántas categorías hay y cuáles son?
# ---------------------------------------------------------------------------
# TODO 2: completa el bucle para imprimir, por columna, cuántos valores únicos
#         hay y cuáles son. Pista: for (columna in names(clientes)) { ... } con
#         unique() y length(). ¿Cuántas categorías tiene genero?
# for (columna in names(clientes)) {
#   ...
# }
cat("\n--- VALORES UNICOS POR COLUMNA ---\n")

for (columna in names(clientes)) {
  valores <- unique(clientes[[columna]])

  cat("\nVariable:", columna, "\n")
  cat("Cantidad de valores unicos:", length(valores), "\n")
  print(valores)
}
# ---------------------------------------------------------------------------
# 4. Declarar el orden de las variables ordinales
# ---------------------------------------------------------------------------
# Una ordinal se guarda como texto y su orden natural se pierde: alfabéticamente
# "Posgrado" iría antes que "Primaria", que no tiene sentido. En R, eso se
# declara con el factor ordenado.
#
# TODO 3: convierte nivel_educacion con factor(..., levels = c(...), ordered = TRUE).
#         Comprueba con min(): debe devolver "Primaria".
orden_educacion <- c("Primaria", "Secundaria", "Universidad", "Posgrado")

clientes$nivel_educacion <- factor(
  clientes$nivel_educacion,
  levels = orden_educacion,
  ordered = TRUE
)

cat("\n--- NIVEL DE EDUCACION ORDENADO ---\n")
print(clientes$nivel_educacion)

cat("\nNivel minimo de educacion:\n")
print(min(clientes$nivel_educacion))
# TODO 4: haz lo mismo con satisfaccion (escala 1–5 como etiquetas ordenadas).
#         Prueba extra: ¿qué pasa si en levels escribes "Postgrado" (con t) para
#         nivel_educacion? Cuenta los faltantes con sum(is.na(...)) — la trampa
#         del typo es silenciosa.
clientes$satisfaccion <- factor(
  clientes$satisfaccion,
  levels = 1:5,
  ordered = TRUE
)

cat("\n--- SATISFACCION ORDENADA ---\n")
print(clientes$satisfaccion)

cat("\nNivel minimo de satisfaccion:\n")
print(min(clientes$satisfaccion))


# Prueba con error de escritura: Postgrado
educacion_original <- read.csv(
  "C:\\Users\\USUARIO\\Desktop\\Universidad-EPN\\4 TO SEMESTRE\\Estadistica I\\Labo2\\IDSD422-lab-muestreo-poblacion\\data\\clientes.csv",
  stringsAsFactors = FALSE
)$nivel_educacion

educacion_error <- factor(
  educacion_original,
  levels = c("Primaria", "Secundaria", "Universidad", "Postgrado"),
  ordered = TRUE
)

cat("\n--- PRUEBA CON POSTGRADO MAL ESCRITO ---\n")
cat("Cantidad de valores faltantes:",
    sum(is.na(educacion_error)), "\n")
# ---------------------------------------------------------------------------
# 5. Resumen de la clasificación (para el informe)
# ---------------------------------------------------------------------------
# TODO 5: completa el resumen con el tipo de cada variable (el criterio que
#         justifica cada clasificación va en el informe).
clasificacion <- c(
  cliente_id         = "Identificador nominal",
  edad               = "Numerica discreta",
  numero_hijos       = "Numerica discreta",
  genero             = "Categorica nominal",
  nivel_educacion    = "Categorica ordinal",
  ciudad             = "Categorica nominal",
  ingresos_mensuales = "Numerica continua",
  satisfaccion       = "Categorica ordinal"
)

cat("\n--- RESUMEN DE LA CLASIFICACION ---\n")

for (variable in names(clasificacion)) {
  cat(sprintf("  %-18s %s\n",
              variable, clasificacion[[variable]]))
}
