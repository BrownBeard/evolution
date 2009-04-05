(defun parse-args ()
  ; Set the defaults
  (setf opts '(:filename "config.lisp"
               :initial-depth 5
               :initial-pop 10))
  ; Read from ext:*args*
  (do ((args ext:*args* (rest args)))
      ((<= (length args) 0))
    (cond
      ((string= (first args) "--initial-depth")
       (setf args (rest args))
       (setf (getf opts :initial-depth) (parse-integer (first args))))
      ((string= (first args) "--initial-pop")
       (setf args (rest args))
       (setf (getf opts :initial-pop) (parse-integer (first args))))
      (t setf (getf opts :filename) (first args))))
  opts)

(defun main ()
  (setq *random-state* (make-random-state t))
  (setf opts (parse-args))
  (setf conf (read-config (getf opts :filename)))
  (setf population (make-array (getf opts :initial-pop)))
  (dotimes (i (getf opts :initial-pop))
    (setf (elt population i) (build-tree (getf opts :initial-depth)
                                         (getf conf :primitives)
                                         :number)))
  (dotimes (i (getf opts :initial-pop))
    (format t "~a: ~a~%" i (elt population i))))

(main)
