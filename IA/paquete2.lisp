;Paquete 2
;David Ricardo Montalván  Hernández

;EJERCICIO 1
(defun eleminpos (elem lista pos)
 (let ((contador-pos 0) (flag nil))
   (loop for elemento-lista in lista
     do
      (setq contador-pos (+ contador-pos 1))
      (when (and (equal elemento-lista elem) (= contador-pos pos))
        (format t "El elemento ~a si está en la lista en la posición ~a" elem pos)
        (setq flag t)
        )
     )
    flag
  )
)

;EJERCICIO 2

;EJERCICIO 3

;EJERCICIO 4
(defun primer-impar(lista)
  (let ((nueva-lista (list)) (indice 0) (flag t))
    (loop for elemento in lista
      do
        (when (and (not (equal (mod elemento 2) 0)) flag)
          (setq nueva-lista (list elemento indice))
          (setq flag nil)
          )
        (setq indice (+ indice 1))
      )
      nueva-lista
    )
  )

;EJERCICIO 5

(defun ultimo-elemento(lista)
  (let ((nueva-lista (list)) (conteo 0) (inicio nil) (numero nil) (flag t))
  (setq inicio (- (length lista) 1))
  ;Empieza a iterar desde el final de la lista
  (loop for i downfrom inicio to 0 do
    (setq numero (nth i lista))
    ;Encuentra el primer número que cumple las condiciones
    (when (and (realp numero) (>= numero 0) flag)
        (loop for elemento in lista do
          (when (= elemento numero)
            (setq conteo (+ conteo 1))
            )
          )
          (setq nueva-lista (list numero conteo))
          (setq flag nil)
      )
    )
    nueva-lista
  )
)

;EJERCICIO 6
(defun conteo(lista)
  (let ((conteo-numeros 0))
    (loop for elemento in lista do
      (when (numberp elemento)
        (setq conteo-numeros (1+ conteo-numeros))
        )
      )
      (cons conteo-numeros (- (length lista) conteo-numeros))
    )
  )

;EJERCICIO 7

;EJERCICIO 8
(defun diagonal(lista)
  (let ((m 0) (n 0) (diag (list)) (renglon nil))
    ;número de renglones
    (setq m (length lista))
    ;número de columnas
    (setq n (length (first lista)))
    (do ((i 0 (+ i 1)))
      ;La condición de paro es hasta que ya no haya renglones o columnas
      ((or (> i (- n 1)) (> i (- m 1))) diag)

      (setq renglon (nth i lista))
      (setq diag (append diag (list (nth i renglon))))
    );do

  );let
);defun

;EJERCICIO 9
(defun tipo-dato(lista)
  (let ((lista-resultado (list)))
    (loop for elemento in lista do
      (typecase elemento
        ;El orden en que se ponen los elementos importa
        ;Por eso puse primero null, ya que si no '() evalua a atom
        (null (setq lista-resultado (append lista-resultado (list 'N))))
        (atom (setq lista-resultado (append lista-resultado (list 'A))))
        (list (setq lista-resultado (append lista-resultado (list 'L))))
        (t (setq lista-resultado (append lista-resultado (list "Otro Tipo"))))
        );typecase
      );loop
    lista-resultado
    );let
);defun

;EJERCICIO 10
(defun suma-numérica(lista)
  (let ((suma 0))
    (loop for elemento in lista do
      (when (numberp elemento)
        (setq suma (+ suma elemento))
        );when
      );loop
    suma
    );let
  );defun
