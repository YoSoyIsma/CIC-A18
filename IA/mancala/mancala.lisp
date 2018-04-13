;;===============================================================
;; Tablero
;; Se representa con una lista de listas
;; cada lista representa una casilla del tablero
;; Las listas en los índices 6 y 13 representan las bases del jugador y
;; de la computadora respectivamente
;;================================================================
(defparameter *tablero* '((r a v) (r a v) (r a v) (r a v) (r a v) (r a v) () (r a v) (r a v) (r a v) (r a v) (r a v) (r a v) ()))


;;================================================================
;; Operaciones
;; Casillas que puede mover la IA
;; Son las casillas con los índices
;; 7, 8, 9, 10, 11, 12
;;================================================================
(defparameter *ops-maquina* '(7 8 9 10 11 12))

;;================================================================
;; turno
;; jugador en turno (1-humano, 2-máquina)
;;================================================================
(defparameter *turno* 1)

;;================================================================
;; Calcula puntaje
;;================================================================
(defun puntaje (lista)
  "
  Calcula el puntaje de una casilla en el tablero
  Regresa una lista con:
  first: Cadena representando número de elementos de cada tipo
  second: Puntaje total
  "
  (let ((rojo 0) (verde 0) (amarillo 0) (lista-resultado nil) )
    (loop for elem in lista do
      (case elem
        (r (incf rojo) )
        (v (incf verde) )
        (a (incf amarillo) ) )    )
    (setq lista-resultado (list (concatenate 'string "R:" (write-to-string rojo) " A:" (write-to-string amarillo) " V:" (write-to-string verde)  )
      (reduce #'+ (list (* 10 rojo) (* 5 verde)  (* 1 amarillo) )   )) )
    lista-resultado
  );let
);defun

;;================================================================
;; Despliega el tablero en la terminal
;;================================================================
(defun despliega-tablero ()
  (format t "Base-PC     Casilla-12     Casilla-11     Casilla-10     Casilla-9     Casilla-8     Casilla-7")
  (format t  "~%~a           ~a    ~a    ~a    ~a   ~a   ~a"
    (second (puntaje (nth 13 *tablero*))) (first (puntaje (nth 12 *tablero*))) (first (puntaje (nth 11 *tablero*))) (first (puntaje (nth 10 *tablero*))) (first (puntaje (nth 9 *tablero*)))
  (first (puntaje  (nth 8 *tablero*)))  (first  (puntaje (nth 7 *tablero*)))  )
  (format t "~%==================================================================================================")
  (format t  "~%~a  ~a   ~a    ~a    ~a   ~a   ~a"
    (first (puntaje (nth 0 *tablero*))) (first (puntaje (nth 1 *tablero*))) (first (puntaje (nth 2 *tablero*))) (first (puntaje (nth 3 *tablero*))) (first (puntaje (nth 4 *tablero*)))
  (first (puntaje  (nth 5 *tablero*)))  (second  (puntaje (nth 6 *tablero*)))  )
  (format t  "~%Casilla-0    Casilla-1     Casilla-2      Casilla-3      Casilla-4     Casilla-5     Base-humano")
);defun

;;================================================================
;; Aplica la jugada sobre el tablero
;;================================================================
(defun aplica-jugada (indice-casilla)
  "
  Modifica el tablero repartiendo las fichas en la casilla índice-casilla
  en las casillas vecinas
  "
  (let ((contenido nil) (aux 0)  (tablero nil))
    (setq tablero (copy-seq *tablero*))
    (setq contenido (copy-seq (nth indice-casilla tablero))) ;Copia el contenido de la casilla
    (setq aux (+ indice-casilla 1)) ;Primer casilla vecina

    ;Actualiza las  casillas vecinas
    (loop for elem in contenido do
      ;Omite casilla base del jugador humano si fue un movimiento de la máquina
      (if (and (= aux 6) (= *turno* 2)) (setq aux (mod (1+ aux) 13 )) )
      ;Omite casilla base de la máquina si fue un movimiento del humano
      (if (and (= aux 13) (= *turno* 1)) (setq aux (- (mod (1+ aux) 13 ) 1)) )

      ;Actualiza tablero
      (setf (nth aux tablero) (append (nth aux tablero) (list elem)) )
      (setq aux (mod (1+ aux) 13)) ;Próxima casilla vecina
    );loop

    ;Vacía la casilla de movimiento
    (setf (nth indice-casilla tablero) nil)
    tablero
  );let
);defun
