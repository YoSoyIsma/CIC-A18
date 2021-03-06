;David R. Montalván Hernández
;Agrupamiento jerárquico aglomerativo

;USO
;(defvar list (main-aglomerativo ruta-archivo-de-datos))

;Algoritmo
;1.Leer los datos (arreglo)
;2.Calcular la matriz de distancias inicial
;3.Agregar etiquetas iniciales a la tabla de datos
;4.Encontrar mínimo
;5.Actualizar dendrograma y las etiquetas de la tabla datos
;6.Actualizar matriz de distancias
;7.Revisar condición de paro
;8.Ir al paso 4
;Repetir hasta condición de paro

(load "lee-separado.lisp")

;Distancia para atributos buying y maint
(defun dist-buy(atr1 atr2)
  "Calcula la distancia para los atributos
  buying price y maintenance price
  Los valores que pueden tomar estos atributos son:
  v-high,high,med,low
  "
  (cond
    ((or (and (equal atr1 "vhigh") (equal atr2 "high"))
        (and (equal atr2 "vhigh") (equal atr1 "high"))) 0.5)
    ((or (and (equal atr1 "vhigh") (equal atr2 "med"))
        (and (equal atr2 "vhigh") (equal atr1 "med"))) 2.5)
    ((or (and (equal atr1 "med") (equal atr2 "low"))
        (and (equal atr2 "med") (equal atr1 "low"))) 2.5)
    ((or (and (equal atr1 "vhigh") (equal atr2 "low"))
        (and (equal atr2 "vhigh") (equal atr1 "low"))) 10.5)
    ((or (and (equal atr1 "high") (equal atr2 "med"))
        (and (equal atr2 "high") (equal atr1 "med"))) 2.5)
    ((or (and (equal atr1 "high") (equal atr2 "low"))
        (and (equal atr2 "high") (equal atr1 "low"))) 5.5)
    (t 0)));defun

;Distancia para el atributo doors
(defun dist-doors(atr1 atr2)
  (cond
    ((or (and (equal atr1 2) (equal atr2 3))
        (and (equal atr2 2) (equal atr1 3))) 1.5)
    ((or (and (equal atr1 2) (equal atr2 4))
        (and (equal atr2 2) (equal atr1 4))) 2.5)
    ((or (and (equal atr1 2) (equal atr2 "5more"))
        (and (equal atr2 2) (equal atr1 "5more"))) 5.5)
    ((or (and (equal atr1 3) (equal atr2 4))
        (and (equal atr2 3) (equal atr1 4))) 1.5)
    ((or (and (equal atr1 3) (equal atr2 "5more"))
        (and (equal atr2 3) (equal atr1 "5more"))) 5.5)
    ((or (and (equal atr1 4) (equal atr2 "5more"))
        (and (equal atr2 4) (equal atr1 "5more"))) 1.5)
    (t 0)));defun

;Distancia para el atributo persons
(defun dist-pers(atr1 atr2)
  (cond
    ((or (and (equal atr1 2) (equal atr2 4))
        (and (equal atr2 2) (equal atr1 4))) 2.5)
    ((or (and (equal atr1 2) (equal atr2 "more"))
        (and (equal atr2 2) (equal atr1 "more"))) 5.5)
    ((or (and (equal atr1 4) (equal atr2 "more"))
        (and (equal atr2 4) (equal atr1 "more"))) 2.5)
    (t 0)));defun

;Distancia para el atributo lug_boot
(defun dist-lug(atr1 atr2)
  (cond
    ((or (and (equal atr1 "small") (equal atr2 "med"))
        (and (equal atr2 "small") (equal atr1 "med"))) 2.5)
    ((or (and (equal atr1 "small") (equal atr2 "big"))
        (and (equal atr2 "small") (equal atr1 "big"))) 5.5)
    ((or (and (equal atr1 "med") (equal atr2 "big"))
        (and (equal atr2 "med") (equal atr1 "big"))) 2.5)
    (t 0)));defun

;Distancia para el atributo safety
(defun dist-safe(atr1 atr2)
  (cond
    ((or (and (equal atr1 "low") (equal atr2 "med"))
        (and (equal atr2 "low") (equal atr1 "med"))) 2.5)
    ((or (and (equal atr1 "low") (equal atr2 "high"))
        (and (equal atr2 "low") (equal atr1 "high"))) 5.5)
    ((or (and (equal atr1 "med") (equal atr2 "high"))
        (and (equal atr2 "med") (equal atr1 "high"))) 2.5)
    (t 0)));defun

;Calcula la distanacia sintáctica
(defun dist-sint(obs1 obs2)
  "Calcula la distancia sintáctica entre dos observaciones
  Cada observación (obs1 y obs2) es un arreglo unidimensional
  las observaciones ya no incluyen la columna de la etiqueta
  "
  (let((lista-dist (list)) (dist 0) (atr1 nil) (atr2 nil))
    ;Calcula la distancia atributo por atributo
    (loop for i from 0 to (- (array-dimension obs1 0) 1) do
      (setq atr1 (aref obs1 i))
      (setq atr2 (aref obs2 i))
      (cond
        ((equal i 0) (setq lista-dist (append lista-dist (list (dist-buy atr1 atr2)))))
        ((equal i 1) (setq lista-dist (append lista-dist (list (dist-buy atr1 atr2)))))
        ((equal i 2) (setq lista-dist (append lista-dist (list (dist-doors atr1 atr2)))))
        ((equal i 3) (setq lista-dist (append lista-dist (list (dist-pers atr1 atr2)))))
        ((equal i 4) (setq lista-dist (append lista-dist (list (dist-lug atr1 atr2)))))
        ((equal i 5) (setq lista-dist (append lista-dist (list (dist-safe atr1 atr2)))))
      ));loop
    ;(format t "~a~%~a~%" obs1 obs2)
    (setq dist (reduce #'+ lista-dist))
    dist
  ));defun

;Crea la matriz de distancias
;Sólo se crea la matriz triangular inferior
(defun matriz-distancias-inicial(datos)
  "Crea la matriz de distancias
  Sólo se crea la matriz triangular inferior
  ENTRADA:
  datos: Arreglo creado con la función lee-separado
  SALIDA:
  mat-dist: Arreglo con las distancias entre cada observación
  sólo se crea la parte inferior de la matriz de distancias.
  "
  (let ((obs1 nil) (obs2 nil) (mat-dist nil) (ncol 0) (nreng 0))
    (setq nreng (array-dimension datos 0)) ;número de renglones
    (setq ncol (array-dimension datos 1));número de columnas
    (setq ncol (1- ncol)) ;este 1- es para no contar la última columna
    (setq mat-dist (make-array (list nreng nreng) :initial-element 0 :adjustable t)) ;dimensiona matriz de distancias

    (loop for i from 1 to (1- nreng) do
      (setq obs1 (make-array ncol))
      ;extrae observación en el renglón i
      (loop for k from 0 to (1- ncol) do
        (setf (aref obs1 k) (aref datos i k)));loop

      (loop for j from 0 to (1- i) do
        (setq obs2 (make-array ncol))
        ;extrae la observación del renglón j
        (loop for k from 0 to (1- ncol) do
          (setf (aref obs2 k) (aref datos j k)));loop
        ;calcula la distancia sintáctica
        (setf (aref mat-dist i j) (dist-sint obs1 obs2))
      );loop
    );loop
    mat-dist
  );let
);defun

(defun agrega-etiquetas-inicial(datos)
  "Agrega una etiqueta en la tabla de datos
  con el fin de identificar los grupos
  esta etiquieta se agrega en la última columna de tabla.
  (Sobreescribe las etiquetas que no se utilizan)
  "
  (loop for i from 0 to (1- (array-dimension datos 0)) do
    (setf (aref datos i (1- (array-dimension datos 1)))
    (list i)));loop
  datos
);defun

(defun unicos(lista)
  "Elimina elementos repetidos de una lista"
  (let ((nueva-lista '()))
    (loop for elem in lista do
      (when (not (find elem nueva-lista))
        (setq nueva-lista (append nueva-lista (list elem))));when
    );loop
  nueva-lista
  );let
);defun


(defun encuentra-min(matriz)
  "Encuentra el valor de la distancia mínima en la matriz de
  distancias así como las observaciones que se deben de agrupar
  ENTRADA:
  matriz: matriz de distancias (triangular inferior)
  SALIDA:
  una lista con first = distancia mínima
  rest = una lista con los índices de las observaciones que se deben agrupar
  "
  (let ((n-reng 0) (dist-min 0) (cluster '()) (curr-min 10000000))
    (setq n-reng (array-dimension matriz 0));renglones (y columnas)

    (loop for i from 1 to (1- n-reng) do
      (loop for j from 0 to (1- i) do
        ;(when (/= (aref matriz i 0) 0) ;cuando no es un renglón cancelado
          (when (and (< (aref matriz i j) curr-min) (/= (aref matriz i j) 0))
            ;Si es un nuevo mínimo
            ;reinicia el cluster
              (setq dist-min (aref matriz i j))
              (setq curr-min dist-min)
              (setq cluster (list i j))
          );when
          (when (= (aref matriz i j) dist-min)
            ;Si es el mismo mínimo agrega al cluster
            (setq cluster (append cluster (list i j))));when
        ;);when
      );loop
    );loop
    (setq cluster (unicos cluster))
  (list dist-min cluster)
  );let
);defun

(defun actualiza-dendro(dendro lista)
  "Actualiza el dendrograma
  La representación es utilizando una lista de listas de la forma
  ((dist1 (Obs1-Obs2)) (dist2 (Obs3-Obs4))...)
  Cada elemento de la lista se obtiene con la función encuentra-min
  "
  (append  dendro (list (unicos lista)))
)


(defun actualiza-etiquetas(datos cluster)
  "Actualiza las etiquetas de la tabla de datos
  ENTRADA
  datos:tabla de datos (creada con lee-separado)
  cluster: rest de la función encuentra-min
  "
  (let ((aux '()) (col-aux 0) )
    (setq col-aux (1- (array-dimension datos 1)))
    (loop for i in (first cluster) do
      (setq aux (append (aref datos i col-aux) (first cluster)))
      (setq aux (unicos aux))
      (setf (aref datos i col-aux) aux)
    );loop
  datos
  );let
);defun

(defun linkage(datos ind-obs1 ind-obs2)
  "Calcula la función de distancia promedio entre grupos
  ENTRADA:
  datos:tabla de datos (arreglo)
  ind-obs1-2: Listas con los índices en la tabla de datos
  de las observaciones del cluster 1-2.
  SALIDA:
  dist-prom: distancia promedio entre los grupos
  "
  (let ((card1 0) (card2 0) (obs1 '()) (obs2 '()) (ncol-dat 0) (suma 0) (promedio 0))
    (setq ncol-dat (1- (array-dimension datos 1))) ;Número de atributos
    (setq card1 (length ind-obs1)) ;Cardinalidad conjunto 1
    (setq card2 (length ind-obs2)) ;Cardinalidad conjunto 2

    (loop for i in ind-obs1 do
      (setq obs1 (make-array ncol-dat))
      ;extrae observación i de los datos
        (loop for k from 0 to (1- ncol-dat) do
          (setf (aref obs1 k) (aref datos i k)));loop

      (loop for j in ind-obs2 do
        (setq obs2 (make-array ncol-dat))
        ;extrae observación j
        (loop for k from 0 to (1- ncol-dat) do
          (setf (aref obs2 k) (aref datos j k)));loop
        ;calcula distancia
        (setq suma (+ suma (dist-sint obs1 obs2)))
      );loop
    );loop
    (setq promedio (/ suma (* card1 card2)))
    (setq promedio (float promedio))
    promedio
  );let
);defun

(defun actualiza-distancias(datos mat-dist indices)
  "Actualiza la matriz de distancias
  ENTRADA:
  datos: Tabla de datos después de actualizar las etiquetas
  mat-dist: Matriz de distancias
  indices: indices a modificar
  SALIDA:
  mat-dist:Matriz de distancias utilizando la función de distancias
  entre grupos (sólo la porción triangular inferior)
  "
  (let((ind-obs1 '()) (ind-obs2 '()) (nreng 0) (ncol 0) (ind-min 0) (aux 0)
    (memoria '()))
    (setq nreng (array-dimension datos 0));número renglones
    (setq ncol (array-dimension datos 1)) ;número columnas
    (setq ind-min (reduce #'min indices));Este renglón contendrá la información del grupo
    ;Cancela los renglones distintos a ind-main
    ;pone un cero para que la función encuentra-min no lo considere
    (loop for i in indices do
      (when (/= i ind-min)
        (loop for j from 0 to (1- i) do
          (setf (aref mat-dist i j) 0))
      );when
    ) ;loop

    ;(loop for i in indices do
      (setq ind-obs1 (aref datos ind-min (1- ncol))) ;Grupo del renglón i
      (loop for j from 1 to (1- nreng) do
        (setq aux (reduce #'min (aref datos j (1- ncol))))
        (push aux memoria)
        (when (not (member aux memoria :test 'equal)) ;cuando no se a revisado
          (setq ind-obs2 (aref datos aux (1- ncol)));Grupo del renglón j
            (when
              ;cuando no son del mismo grupo
              (not (or (subsetp ind-obs1 ind-obs2) (subsetp ind-obs2 ind-obs1)))
              (setf (aref mat-dist ind-min j) (linkage datos ind-obs1 ind-obs2))
            );when
        );when
      );loop
    ;);loop
  mat-dist
  );let
);defun

(defun aux-paro(datos)
  "Función auxiliar para la condición de paro
  Sólamente crea una lista con los índices
  de la tabla de datos (renglones)
  "
  (let ((lista nil))
    (loop for i from 0 to (1- (array-dimension datos 0)) do
      (setq lista (append lista (list i)))
    );loop
    lista
  );let
);defun

(defun condicion-paro?(datos lista)
  "La condición de para es cuando algún renglón de la última
  columna de la tabla de datos contiene una lista igual a la
  lista de paro
  "
  (let ((renglon nil) (nreng 0) (ncol 0))
      (setq nreng (array-dimension datos 0))
      (setq ncol (array-dimension datos 1))
      (loop for i from 0 to (1- nreng) do
        (setq renglon (aref datos i (1- ncol)))
        (when
          ;subsetp por que no tienen el mismo orden de elementos
          (and (subsetp renglon lista) (subsetp lista renglon))
            (return-from condicion-paro? t)
        );when
      );loop
    nil
  );let
);defun

(defun limpia-dendro(dendro)
  "Función auxiliar para limpiar el dendrograma
  agrupa por distancias
  "
  (let((list-dist nil) (list-aux nil) (n 0) (nuevo-den nil))
    (setq n (length dendro))
    ;Primer colecta las distancias de agrupamiento
    (loop for i from 0 to (1- n) do
      (setq list-dist (append list-dist (list (first (nth i dendro)))))
    );loop

    ;Después para cada distancia agrupa las observaciones en esa
    ;distancia
    (setq list-dist (unicos list-dist))
    (loop for dist in list-dist do
      (loop for i from 0 to (1- n) do
        ;agrupa las observaciones en la misma distancia
        (if (= dist (first (nth i dendro)))
          (setq list-aux (append list-aux (second (nth i dendro)))));if
      );loop
      (push (list (list dist list-aux)) nuevo-den)
    );loop
    nuevo-den
  );let
);defun

(defun aglomerativo(ruta-datos)
  "Función principal para ejectuar el algoritmo de
  jerarquización aglomerativa
  ENTRADA
  ruta-datos:cadena con la ruta del archivo con los datos de UCI
  SALIDA
  dendrograma:lista que representa el dendrograma
  "
  (let ((datos nil) ;tabla de datos
       (mat-dist nil) ;matriz de distancias
       (lista-min nil);lista que contiene la distancia mínima
       (dendrograma nil) ;lista que representa al dendrograma
        (lista-paro nil)) ;auxiliar para la condición de paro

    (setq datos (lee-separado ruta-datos));lee datos
    ;matriz de distancias (inicial)
    (setq mat-dist (matriz-distancias-inicial datos))
    ;agrega etiquetas iniciales
    (setq datos (agrega-etiquetas-inicial datos))
    ;auxiliar para la condición de paro
    (setq lista-paro (aux-paro datos))
    (loop
      ;encuentra mínimo
      (setq lista-min (encuentra-min mat-dist))
      ;actualiza dendrograma
      (setq dendrograma (actualiza-dendro dendrograma lista-min))
      ;actualiza etiquetas
      (setq datos (actualiza-etiquetas datos (rest lista-min)))
      ;revisa condición de paro
      (when (condicion-paro? datos lista-paro) (return-from aglomerativo dendrograma))
      ;(format t "~a~%" (write-to-string datos))
      ;actualiza matriz de distancias
      (setq mat-dist (actualiza-distancias datos mat-dist (first (rest lista-min))))
    );loop
  );let
);defun

(defun obten-corte(dendro dist-corte)
  "Función para obtener los cortes del dendrograma
  ENTRADA:
  dendro:dendrograma (después de limpia-dendro)
  dist-corte:distancia de corte
  (second (first (nth i dendro))) para la lista de observaciones
  (first (first (nth i dendro))) para la distancia
  "
  (let ((corte nil) (n 0) (dist-aux 0))
    (setq n (length dendro))
    (loop for i from 0 to (1- n) do
      (setq dist-aux (first (first (nth i dendro))))
      (when (<= dist-aux dist-corte)
        (setq corte (append corte (second (first (nth i dendro)))))
      );when
    );loop
    corte
  );let
);defun

(defun main-aglomerativo(ruta-datos)
  "
  ENTRADA
  ruta-datos: ruta del archivo con los datos de UCI
  SALIDA
  una lista con first = dendrograma
  rest = corte en la distancia corte
  "
  (let ((dendro nil) (dist-corte) (corte nil))
    (setq dendro (aglomerativo ruta-datos))
    (setq dendro (limpia-dendro dendro))
    ;Usuario pide la distancia de corte
    (format t "Dame la distancia de corte~%")
    (setq dist-corte (read))
    (setq corte (unicos (obten-corte dendro dist-corte)))
    (list dendro corte)
  );let
);defun
