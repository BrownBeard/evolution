(defun read-config (filename)
  (with-open-file (fp filename)
    (read fp)))

(defun parse-args ()
  ; Set the defaults
  (let ((opts '(:filename "config.lisp"
              :initial-depth 5
              :population 20
              :mutation-depth 2
              :generations 10
              :%-parent-from-top 10
              :%-parent-random 10
              :%-survive-from-top 5
              :%-survive-random 5
              :%-mutation 100)))
    (do ((args ext:*args* (rest args)))
        ((<= (length args) 0))
      (cond
        ((string= (first args) "--initial-depth")
         (setf args (rest args))
         (setf (getf opts :initial-depth) (parse-integer (first args))))
        ((string= (first args) "--population")
         (setf args (rest args))
         (setf (getf opts :population) (parse-integer (first args))))
        ((string= (first args) "--mutation-depth")
         (setf args (rest args))
         (setf (getf opts :mutation-depth) (parse-integer (first args))))
        ((string= (first args) "--generations")
         (setf args (rest args))
         (setf (getf opts :generations) (parse-integer (first args))))
        ((string= (first args) "--%-parent-from-top")
         (setf args (rest args))
         (setf (getf opts :%-parent-from-top) (parse-integer (first args))))
        ((string= (first args) "--%-parent-random")
         (setf args (rest args))
         (setf (getf opts :%-parent-random) (parse-integer (first args))))
        ((string= (first args) "--%-survive-from-top")
         (setf args (rest args))
         (setf (getf opts :%-survive-from-top) (parse-integer (first args))))
        ((string= (first args) "--%-survive-random")
         (setf args (rest args))
         (setf (getf opts :%-survive-random) (parse-integer (first args))))
        ((string= (first args) "--%-mutation")
         (setf args (rest args))
         (setf (getf opts :%-mutation) (parse-integer (first args))))
        (t setf (getf opts :filename) (first args))))
    opts))
