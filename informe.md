
# Informe — Clasificación de variables y población vs. muestra

**Para:** Gerencia de RetailAndina S. A. · **De:** Equipo de Business Intelligence  
**Fecha:** 23/10/2026 · **Asunto:** Base de fidelización: tipos de variables y estimación por muestreo

---

## Resumen ejecutivo

En esta práctica analicé la base de fidelización de RetailAndina S. A. para clasificar las variables de sus clientes y estimar su ingreso mensual promedio. Para ello, utilicé Python y R, y comparé tres métodos de muestreo: conveniencia, aleatorio simple y estratificado, seleccionando 20 clientes de una población de 400. El muestreo aleatorio simple obtuvo la estimación más cercana al parámetro poblacional de 1.330,72 USD, mientras que el estratificado garantizó la representación proporcional de las tres ciudades. Por ello, recomiendo considerar tanto el procedimiento de selección como la composición y variabilidad de las muestras antes de tomar decisiones gerenciales.

## Parte A — Clasificación de las variables

Para clasificar las variables del archivo `clientes.csv`, que contiene 12 registros y 8 columnas, revisé los tipos de datos identificados por Python y R y la cantidad de valores únicos de cada variable. También consideré si representaban cantidades, conteos o categorías, y si existía un orden entre estas últimas.

| Variable | Tipo | Justificación (criterio) | Verificación en código |
|---|---|---|---|
| `cliente_id` | Identificador nominal | Es un código que identifica a cada cliente. Aunque contiene números, no representa una cantidad medible ni tiene sentido calcular su promedio. | Python: `str`; R: `chr`. Se identificaron 12 valores únicos. |
| `edad` | Numérica discreta | En esta base se registra en años cumplidos, es decir, mediante valores enteros. | Python: `int64`; R: `int`. Se encontraron 12 valores únicos. |
| `numero_hijos` | Numérica discreta | Representa un conteo de hijos y solo admite cantidades enteras. No tendría sentido registrar medio hijo. | Python: `int64`; R: `int`. Se identificaron 5 valores únicos: 0, 1, 2, 3 y 4. |
| `genero` | Categórica nominal | Sus categorías no tienen un orden natural ni representan cantidades numéricas. | Python: `str`; R: `chr`. Se encontraron 3 categorías: Femenino, Masculino y Otro. |
| `nivel_educacion` | Categórica ordinal | Los niveles educativos tienen un orden jerárquico, pero no se pueden interpretar como cantidades proporcionales. | Python: `str`; R: `chr`. Se identificaron 4 niveles y, después de ordenarlos, `min()` devolvió Primaria. |
| `ciudad` | Categórica nominal | Permite agrupar clientes según su ubicación geográfica, sin establecer jerarquías entre ciudades. | Python: `str`; R: `chr`. Se encontraron 3 categorías: Quito, Guayaquil y Cuenca. |
| `ingresos_mensuales` | Numérica continua | Representa una cantidad monetaria que puede admitir decimales, aunque en el archivo los valores se registraron como enteros. | Python: `int64`; R: `int`. Se identificaron 12 valores únicos. |
| `satisfaccion` | Categórica ordinal | Representa niveles de satisfacción del 1 al 5. Existe un orden, pero no una relación proporcional entre las categorías. | Python: `int64`; R: `int`. Se observaron 4 valores únicos: 2, 3, 4 y 5. El mínimo observado fue 2. |

### P1. ¿Qué te dijo el dtype de `satisfaccion` y por qué no basta para clasificarla? ¿Qué pasa si una ordinal queda como texto sin declarar el orden?

Al revisar la variable `satisfaccion`, observé que Python la identificó como `int64` y R como `int`. Sin embargo, esto no significa que sea cuantitativa desde el punto de vista estadístico, ya que sus valores representan niveles ordenados de satisfacción. Por ejemplo, un cliente con satisfacción 4 no necesariamente está el doble de satisfecho que otro con satisfacción 2.

También comprobé que, aunque la escala permite valores del 1 al 5, en los 12 registros únicamente aparecieron cuatro categorías: 2, 3, 4 y 5. Después de declarar el orden, el mínimo observado fue 2.

Si una variable ordinal se almacena como texto sin establecer su orden, el programa puede organizar las categorías alfabéticamente en lugar de respetar su jerarquía. Por ejemplo, Posgrado podría aparecer antes que Primaria. Para evitarlo, utilicé `CategoricalDtype()` en Python y `factor(ordered = TRUE)` en R, estableciendo el orden Primaria < Secundaria < Universidad < Posgrado.

Además, realicé una prueba escribiendo intencionalmente `Postgrado` en lugar de `Posgrado`. Como resultado, se generaron dos valores faltantes, tanto en Python como en R. Esto me permitió comprobar que los errores de escritura en las categorías pueden afectar la calidad de los datos durante su transformación.

## Parte B — Población vs. muestra

### La población y su parámetro

Para esta parte utilicé el archivo `clientes_400.csv`, que contiene la base completa de fidelización de RetailAndina S. A. El objetivo fue estimar el ingreso mensual promedio de los clientes mediante distintos métodos de muestreo.

| Concepto | Valor |
|---|---|
| Población (N) | 400 clientes |
| Variable de interés | `ingresos_mensuales` |
| Parámetro poblacional (media) | 1.330,72 USD |

La población estaba distribuida entre tres ciudades: Quito, con 200 clientes (50 %); Guayaquil, con 120 clientes (30 %); y Cuenca, con 80 clientes (20 %).

**¿Por qué se muestrea si aquí el parámetro existe y se calculó?**

En esta práctica pude calcular el promedio poblacional porque tenía acceso a los 400 clientes. Sin embargo, en situaciones reales puede resultar difícil analizar a toda la población debido al tiempo, los recursos y los costos necesarios.

Por esta razón, el muestreo permite seleccionar una parte de los clientes para estimar características de toda la población. En este ejercicio, conocer el parámetro real fue útil porque me permitió comparar las estimaciones obtenidas y comprender qué tan cerca estuvieron del promedio poblacional.

### Los tres diseños

Seleccioné muestras de 20 clientes utilizando tres métodos: conveniencia, aleatorio simple y estratificado proporcional. Posteriormente, calculé el ingreso mensual promedio de cada muestra, revisé su composición por ciudad y comparé las estimaciones con el parámetro poblacional.

| Diseño | n | Media estimada | Composición por ciudad | Diferencia vs. parámetro |
|---|---:|---:|---|---:|
| Conveniencia (`head`) | 20 | 1.348,50 USD | Quito: 20 | +17,78 USD |
| Aleatorio simple (`sample`) | 20 | 1.318,00 USD | Quito: 8, Guayaquil: 7, Cuenca: 5 | -12,72 USD |
| Estratificado (`groupby` + 5 %) | 20 | 1.226,00 USD | Quito: 10, Guayaquil: 6, Cuenca: 4 | -104,72 USD |

También repetí el muestreo aleatorio simple con cinco semillas distintas en R, manteniendo el tamaño de 20 clientes para observar cómo cambiaban las estimaciones.

| Semilla | 1 | 2 | 3 | 4 | 5 |
|---|---:|---:|---:|---:|---:|
| Media (USD) | 1.318,00 | 1.287,50 | 1.233,00 | 1.385,50 | 1.283,00 |

### P2. ¿Cuánto vale el parámetro poblacional y cuánto estimó cada diseño? ¿Cuál quedó más cerca y por qué eso no alcanza para declarar un ganador?

El parámetro poblacional fue de 1.330,72 USD. La muestra por conveniencia obtuvo una media de 1.348,50 USD, con una diferencia de +17,78 USD. Por su parte, el muestreo aleatorio simple estimó 1.318,00 USD, con una diferencia de -12,72 USD, mientras que el estratificado obtuvo 1.226,00 USD, con una diferencia de -104,72 USD.

En esta ejecución, el muestreo aleatorio simple fue el que más se acercó al parámetro poblacional. Sin embargo, considero que esto no significa que siempre sea el mejor método, porque las estimaciones pueden variar dependiendo de los clientes seleccionados.

Por ejemplo, el muestreo estratificado presentó la mayor diferencia, pero garantizó que las tres ciudades estuvieran representadas de acuerdo con su proporción poblacional. Por lo tanto, para evaluar un diseño no basta con observar una sola estimación; también es necesario considerar cómo se seleccionaron los registros y qué características de la población se conservaron.

### P3. La muestra por conveniencia también tiene 20 filas. ¿Qué defecto tiene y cómo lo delatas en la composición por ciudad? ¿Se corrige tomando más filas?

El principal problema de la muestra por conveniencia es que seleccioné los primeros 20 registros del archivo sin realizar ningún sorteo. Al revisar su composición, observé que los 20 clientes pertenecían a Quito, mientras que Guayaquil y Cuenca quedaron completamente excluidas.

Esto demuestra que la selección dependió del orden de los datos y que la muestra no representó adecuadamente a toda la población. Aunque Quito concentra el 50 % de los clientes, en la muestra por conveniencia representó el 100 %.

Además, aunque su media estuvo relativamente cerca del parámetro poblacional, esto no demuestra que el método sea confiable, ya que la cercanía podría haberse producido por casualidad.

Considero que seleccionar más registros no garantiza corregir este problema, porque el sesgo se encuentra en el procedimiento de selección. Una muestra más grande podría seguir excluyendo ciertos grupos si se continúa utilizando el mismo criterio.

### P4. El sorteo aleatorio dio un número distinto en cada semilla. ¿Qué implica esa variabilidad para una empresa que va a decidir con un solo estudio?

Al repetir el muestreo aleatorio simple con cinco semillas distintas, obtuve medias entre 1.233,00 y 1.385,50 USD. Aunque todas las muestras tenían 20 clientes, los resultados cambiaron porque cada sorteo seleccionó registros diferentes.

Esta variabilidad demuestra que una estimación muestral no necesariamente coincide con el parámetro poblacional. Por ejemplo, la semilla 1 produjo una media de 1.318,00 USD, mientras que la semilla 4 obtuvo 1.385,50 USD, lo que representa una diferencia de 67,50 USD entre ambas estimaciones.

Para una empresa, esto significa que basarse únicamente en el promedio de una muestra podría generar incertidumbre en sus decisiones. Por ello, recomendaría utilizar diseños probabilísticos adecuados, evaluar el tamaño de la muestra y acompañar las estimaciones con medidas de incertidumbre, como intervalos de confianza.

### P5. ¿Cuándo usarías cada diseño en la práctica? Relaciona cada uno con un uso real (piloto, subgrupos que deben aparecer, conclusión sobre toda la población).

**Muestreo por conveniencia:** Lo utilizaría para realizar una prueba piloto, por ejemplo, comprobar si una encuesta de satisfacción funciona correctamente con los primeros clientes disponibles. Sin embargo, no lo utilizaría para sacar conclusiones sobre toda la población debido al riesgo de sesgo de selección.

**Muestreo aleatorio simple:** Lo utilizaría cuando necesite estimar una característica general de los clientes, como su ingreso mensual promedio, siempre que tenga acceso a una lista completa de la población. Este método permite que todos los clientes tengan la misma probabilidad de ser seleccionados y facilita la inferencia estadística bajo los supuestos correspondientes.

**Muestreo estratificado:** Lo utilizaría cuando sea importante asegurar la participación de subgrupos específicos. En RetailAndina S. A., este diseño permitió seleccionar 10 clientes de Quito, 6 de Guayaquil y 4 de Cuenca, manteniendo las proporciones poblacionales. Considero que sería especialmente útil cuando la gerencia necesite garantizar la representación de las tres ciudades.

## Conclusiones

1. La clasificación de variables me permitió comprender que los tipos de datos identificados por Python y R no determinan automáticamente su clasificación estadística. Por ejemplo, `satisfaccion` se almacenó como una variable numérica, pero representó niveles ordinales. También comprobé que un error al escribir una categoría puede generar valores faltantes, como ocurrió con los dos registros afectados por la diferencia entre Posgrado y Postgrado.

2. El análisis de muestreo me permitió observar que una muestra de 20 clientes puede producir estimaciones distintas según el método de selección. En esta ejecución, el muestreo aleatorio simple obtuvo la media más cercana al parámetro poblacional de 1.330,72 USD, con una diferencia absoluta de 12,72 USD. Sin embargo, comprendí que un resultado cercano no garantiza que un método sea superior en todas las situaciones, debido a la variabilidad muestral.

3. Recomendaría a la gerencia utilizar métodos probabilísticos cuando necesite obtener conclusiones sobre toda la población. El muestreo estratificado proporcional resulta útil cuando se requiere garantizar la representación de las tres ciudades, mientras que el aleatorio simple puede servir para estimaciones generales. Antes de tomar decisiones basadas en muestras, considero necesario evaluar el procedimiento de selección, la composición de los participantes y la incertidumbre de los resultados, ya que aumentar el número de registros no corrige automáticamente los sesgos de selección.
