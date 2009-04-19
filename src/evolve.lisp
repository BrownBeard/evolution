;(defun print-pop (population)
;  (do ((i 0 (1+ i))
;       (p population (rest p)))
;      ((= (length p) 0))
;    (format t "~a: ~a~%" i (first p))))

(defun main ()
  (setq *random-state* (make-random-state t))
  (let* ((opts (first (parse-args)))
         (conf (read-config (getf opts :filename)))
         (population NIL))
    (dotimes (i (getf opts :population))
      (setf population (append population
                               (list (build-tree (getf opts :initial-depth)
                                                 (getf conf :primitives)
                                                 (caadr (getf conf :parameters)))))))
    ;(print-pop population)
    (dotimes (g (getf opts :generations))
      (new-suite (first (getf conf :parameters))
                 (first (getf conf :range))
                 (second (getf conf :range))
                 (getf opts :sample-pts))
      (setf population (generation population
                                   (getf conf :answer)
                                   (first (getf conf :parameters))
                                   (getf conf :primitives)
                                   (getf opts :%-parent-pool-from-top)
                                   (getf opts :%-parent-from-pool)
                                   (getf opts :%-mutation)
                                   (getf opts :%-survive-from-top)
                                   (getf opts :%-survive-random)
                                   (getf opts :mutation-depth))))
    (new-suite (first (getf conf :parameters))
               (first (getf conf :range))
               (second (getf conf :range))
               (getf opts :sample-pts))
    (let ((best (first (sort population
                             #'<
                             :key (lambda (x) (fitness x
                                                       (getf conf :answer)
                                                       (first
                                                         (getf conf :parameters))))))))
      (print best))))

;(defun test-main ()
;  (setq *random-state* (make-random-state t))
;  (let* ((opts (parse-args))
;         (conf (read-config (getf opts :filename)))
;         (population NIL))
;    (dotimes (i 2)
;      (setf population (append population (list (build-tree 3
;                                                            (getf conf :primitives)
;                                                            :number)))))
;    (print-pop population)
;    (print-pop (mate (first population) (second population) (getf conf :primitives)))))

;(test-main)
(main)