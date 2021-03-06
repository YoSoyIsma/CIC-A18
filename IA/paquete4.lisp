;PAQUETE 4
;DAVID RICARDO MONTALVÁN HERNÁNDEZ


;EJERCICIO 1
(defun collect(pred lista)
  "Toma un predicado (símbolo con el nombre de una función)
  y una lista.
  Regresa una lista conteniendo sólomante los elementos en los cuales
  el predicado evalua T
  "
  ;Valida argumentos
  (if (not (and (eq (type-of pred) 'SYMBOL) (listp lista)))
    (return-from collect (format t "Parámetros inválidos"))
  )
  (let ((lista-resultado (list)))
    (cond
      ((null lista) nil);caso base
      ((funcall pred (first lista)) (setq lista-resultado
        (append lista-resultado (cons (first lista) (collect pred (rest lista))))))
      (t (collect pred (rest lista))))));

;EJERCICIO 2

(defun palíndromo(lista &optional (pos 0))
  "En esta función se realiza la recursión
  Se compara la lista original y su versión en reversa posición
  por posición
  "
  ;Valida argumentos
  (if (not (listp lista))
    (return-from palíndromo (format t "Parámetros inválidos")))

  (let ((lista-rev (list)) (flag t))
    (setq lista-rev (reverse lista)) ;Lista original en reversa
    (cond
      ((= pos (length lista)) (setq flag t));caso base (una lista vacía es palíndromo)
      ((equal (nth pos lista) (nth pos lista-rev)) (palíndromo lista (1+ pos)))
      (t (setq flag nil)))
      flag));defun

;EJERCICIO 3
;2Palindrome

;EJERCICIO 4
(defun iterativepalindrome(cadena)

  ;Valida argumentos
  (if (not (stringp cadena))
    (return-from iterativepalindrome (format t "Argumento inválido")))

  (let ((cadena-rev) (palindromo))
    (setq cadena-rev (reverse cadena)) ;cadena en reversa
    (setq palindromo (copy-seq cadena)) ;Copia la cadena de entrada
    (setq palindromo (concatenate 'string palindromo " ")) ;Fines estéticos
    (loop for char across cadena-rev do
      ;Concatena utilizando la cadena en reversa
      ;OJO CON (list char), CONCATENATE es para secuencias
      (setq palindromo (concatenate 'string palindromo (list char)))
    );loop
  palindromo
  );let
);defun

;EJERCICIO 5
(defun listrotate(cadena n  &key (right nil) (left nil))

  (let ((resultado nil) (long 0))
    (setq long (length cadena))
    (cond
      ((and right left) (format t "Utiliza sólo una llave"))
      ((= (/ long 2) n) (setq resultado (concatenate 'string (subseq cadena n long)
        (subseq cadena 0 n)))) ;Cadenas de longitud par y se corta en el punto medio
      ((not left) (setq resultado (concatenate 'string (subseq cadena n long)
        (subseq cadena 0 n))));Derecha
      ((not right) (setq resultado (concatenate 'string (subseq cadena (- long n) long)
        (subseq  cadena 0 (- long n) )))) ;izquierda
      (t nil)
    );cond
    resultado
  );let
);defun


;EJERCICIO 6
(defun max&pos(matriz)

  ;Valida argumentos
  (if (not (arrayp matriz))
    (return-from max&pos (format t "Argumentos inválidos")))

  (let ((num-col 0) (num-reng 0) (maximo 0) (reng-max 0) (lista (list)))
    ;Obtiene las dimensiones de la matriz
    (setq num-col (second (array-dimensions matriz))) ;Columnas
    (setq num-reng (first (array-dimensions matriz))) ;renglones

    ;Itera sobre la matriz
    (loop for col from 0 to (1- num-col) do ;fija columna
      (setq maximo (aref matriz 0 col)) ;Valor arbritario (lo utilicé para considerar positivos y negativos)
      (loop for reng from 0 to (1- num-reng) do
        (when (>= (aref matriz reng col) maximo)
            (setq maximo (aref matriz reng col))
            (setq reng-max reng)
        );when
      );loop reng
      (setq lista (append lista (list (cons col reng-max))))
    );loop col
  lista
  );let
);defun


;EJERCICIO 7
(defun combine(funcion lista)
  "Simula la función reduce
  -> funcion es un símbolo indicando el nombre de una función
  esta función debe de recibir al menos dos argumentos.
  lista es una lista
  "
  ;Valida argumentos
  (if (not (and (eq (type-of funcion) 'SYMBOL) (listp lista)))
    (return-from combine (format t "Argumentos inválidos")))

  (cond
    ;Si la lista es vacía
    ((null lista) nil)
    ;Si la lista tiene dos elementos
    ((= (length lista) 2) (funcall funcion (first lista) (second lista)))
    ;Si la lista sólo tiene un elemento
    ((= (length lista) 1) (first lista))
    ;Si la lista tiene tres o más elementos
    (t (funcall funcion (first lista) (combine funcion (rest lista))))
  );cond
);defun

;EJERCICIO 8
;EJERCICIO 9

;EJERCICIO 10
(defun strcypher(cadena &optional (code "abcdefghijklmnñopqrstuvwxyz"))
"Devuelve una cadena en la que cada caracter del agumento original
fue sustituido por el indicado en la posición correspondiente en la
cadena code
"
  ;Valida argumentos
  (if (not (stringp cadena))
  (return-from strcypher (format t "Argumento inválido")))

  (let ((lista-letras (list)) (pos-aux 0) (resultado ""))
    ;Primero guardo las letras del abecedario en una lista
    (loop for char across code do
      (setq lista-letras (append lista-letras (list char))));loop
    ;Itera sobre cadena y va cambiando de acuerdo a la posición
    (loop for i from 0 to (1- (length cadena)) do
      (setq resultado (concatenate 'string resultado (list (nth pos-aux lista-letras))))
      (setq pos-aux (1+ pos-aux))
    );loop
  resultado
  );let
);defun

;EJERCICIO 11
(defun matmult(m1 m2)

  ;Valida Argumentos
  (if (not (and (arrayp m1) (arrayp m2)))
    (return-from matmult (format t "Argumentos inválidos")))

  (let((m3) (col-m1 0) (col-m2 0) (reng-m1 0) (suma-aux 0))
    ;Primero revisa si es posible realizar la multiplicación
    (when (/= (second (array-dimensions m1)) (first (array-dimensions m2)))
      (return-from matmult nil));when
    ;Obtiene las dimensiones de cada matriz
    (setq col-m1 (array-dimension m1 1)) ;columnas m1
    (setq col-m2 (array-dimension m2 1)) ;columnas m2
    (setq reng-m1 (array-dimension m1 0));renglones m1
    ;Dimensiona la matriz del producto (m3)
    (setq m3 (make-array (list reng-m1 col-m2)))

    ;Llena la matriz entrada por entrada
    (loop for i from 0 to (1- reng-m1) do ;renglones
      (loop for j from 0 to (1- col-m2) do  ;columnas
        (setq suma-aux 0)
        (loop for h from 0 to (1- col-m1) do
          ;Producto punto renglón i de m1 con columna j de m2
          (setq suma-aux (+ suma-aux (* (aref m1 i h) (aref m2 h j))))
        );loop
        ;Actualiza entrada (i,j) de m3
        (setf (aref m3 i j) suma-aux)
      );loop
    );loop
  m3
  );let
);defun

;EJERCICIO 12
(defun make-nodo(elemento)
  "Agrega un nodo al árbol (método visto en clase)"
  (cons (cons elemento nil) nil))

(defun elemento(nodo)
  "Regresa el elemento del nodo"
  (first (first nodo)))

(defun siguiente(nodo)
  "Regresa los hermanos del nodo"
  (rest nodo))

(defun descendientes(nodo)
  "Regresa los descendientes del nodo"
  (rest (first nodo)))

(defun está-elemento?(nodo elem)
  "Busca un elemento en el árbol.
  (Búsqueda en profundidad)
  Si el elemento está presente regresa t
  Si el elemento no está presente regresa nil
  "
  (cond
    ((null nodo) nil)
    ((equal (elemento nodo) elem) t) ;Si encuentra el elemento
    (t (or (está-elemento? (descendientes nodo) elem) ;Busca en los hijo y hermanos
      (está-elemento? (siguiente nodo) elem)))));defun

(defun nivel-elemento(nodo elem &optional (nivel 0))
  "Busca el nivel de un elemento en el árbol.
  (Búsqueda en profundidad)
  "
  (cond
    ((null nodo) nil)
    ((equal (elemento nodo) elem) nivel) ;Si encuentra el elemento
    (t (or (nivel-elemento (descendientes nodo) elem (1+ nivel)) ;Busca en los hijo y hermanos
    (nivel-elemento (siguiente nodo) elem nivel)))));defun

(defun inserta-nodo(padre elem)
  "Inserta un nodo en un árbol binario
  buscando recursivamente el padre en el cual pueda ser insertado
  (el padre que tenga lugar para un hijo)
  La búsqueda se hace por profundidad

  Si no se pudo insertar regresa nil
  "
  (let ((hijo))
    (cond
      ((null padre) (return-from inserta-nodo nil)) ;El nodo es nil
      ((null elem) (return-from inserta-nodo nil))) ;El elemento es nil
    ;primero añade el nodo (si es posible)
      (setq hijo (make-nodo elem))
      (cond
        ;El orden de las siguientes dos líneas tiene que ver
        ;con la búsqueda por profundidad
        ;Si intercambio el orden estaría realizando búsqueda por amplitud
        ((eq (rest (first padre)) nil) (nconc (first padre) hijo));"Hijo"
        ((eq (rest (rest (first padre))) nil) (nconc (rest (first padre)) hijo)) ;"Hermano"
        (t (inserta-nodo (descendientes padre) elem)))));defun

(defun btree(elem tree)
  "Inserta un elemento en un árbol binario y regresa el nivel de
  profundidad en el cual fue insertado

  EJEMPLO DE USO
  Primero crear la raíz
  (defvar tree (make-nodo 'A))
  Después añadir los elementos
  (btree 'B tree)
  (btree 'C tree)
  (btree 'D tree) etc
  "

  ;Valida argumentos
  (if (not (consp tree))
    (return-from btree (format t "Argumento tree inválido")))

  (let ((flag-repetido nil) (flag-insert t) (nivel 0))
    ;Revisa que el elemento no esté repetido
    (setq flag-repetido (está-elemento? tree elem))
    (when flag-repetido (format t "El elemento ya se encuentra")
      (return-from btree nil))
    ;Inserta el elemento
    (setq flag-insert (inserta-nodo tree elem))
    (when (not flag-insert)
      (format t "No se pudo insertar el elemento, revisa que el padre o el elemento no sean nil")
      (return-from btree nil))
    ;Calcula el nivel
    (setq nivel (nivel-elemento tree elem))
    (format t "El elemento ~a se añadió en el nivel ~a~%" elem nivel)
    nivel
  );let
);defun

;EJERCICIO 13
;EJERCICIO 14

;EJERCICIO 15
(defmacro if-positive(expresion &key then-do else-do)
  `(cond
    ((not (numberp (eval ,expresion))) (format t "Necesitas expresión numérica"))
    (t (if (> (eval ,expresion) 0)
      (eval ,then-do)
      (eval ,else-do)))))
