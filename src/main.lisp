(defun print-pop (population)
  (do ((i 0 (1+ i))
       (p population (rest p)))
      ((= (length p) 0))
    (format t "~a: ~a~%" i (first p))))

(defun main ()
  (setq *random-state* (make-random-state t))
  (let* ((opts (parse-args))
         (conf (read-config (getf opts :filename)))
         (population NIL))
    (dotimes (i (getf opts :population))
      (setf population (append population
                               (list (build-tree (getf opts :initial-depth)
                                                 (getf conf :primitives)
                                                 (caadr (getf conf :parameters)))))))
    (print-pop population)
    (dotimes (g (getf opts :generations))
      (setf population (generation population
                                   (getf conf :answer)
                                   (getf conf :primitives)
                                   (getf opts :%-parent-from-top)
                                   (getf opts :%-parent-random)
                                   (getf opts :%-mutation)
                                   (getf opts :%-survive-from-top)
                                   (getf opts :%-survive-random)
                                   (getf opts :mutation-depth))))
    (print-pop population)))

(main)
