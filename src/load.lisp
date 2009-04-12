(defun read-config (filename)
  (with-open-file (fp filename)
    (read fp)))

(defun parse-args ()
  ; Set the defaults
  (let ((opts '(:filename "config.lisp"
                :population 100
                :generations 10
                :initial-depth 5
                :mutation-depth 2
                :%-parent-pool-from-top 10
                :%-parent-from-pool 10
                :%-mutation 100
                :%-survive-from-top 2
                :%-survive-random 6)))
    (do ((args ext:*args* (rest args)))
        ((<= (length args) 0))
      (cond
        ((string= (first args) "--population")
         (setf args (rest args))
         (setf (getf opts :population) (parse-integer (first args))))
        ((string= (first args) "--generations")
         (setf args (rest args))
         (setf (getf opts :generations) (parse-integer (first args))))
        ((string= (first args) "--initial-depth")
         (setf args (rest args))
         (setf (getf opts :initial-depth) (parse-integer (first args))))
        ((string= (first args) "--mutation-depth")
         (setf args (rest args))
         (setf (getf opts :mutation-depth) (parse-integer (first args))))
        ((string= (first args) "--%-parent-pool-from-top")
         (setf args (rest args))
         (setf (getf opts :%-parent-pool-from-top) (parse-integer (first args))))
        ((string= (first args) "--%-parent-from-pool")
         (setf args (rest args))
         (setf (getf opts :%-parent-from-pool) (parse-integer (first args))))
        ((string= (first args) "--%-mutation")
         (setf args (rest args))
         (setf (getf opts :%-mutation) (parse-integer (first args))))
        ((string= (first args) "--%-survive-from-top")
         (setf args (rest args))
         (setf (getf opts :%-survive-from-top) (parse-integer (first args))))
        ((string= (first args) "--%-survive-random")
         (setf args (rest args))
         (setf (getf opts :%-survive-random) (parse-integer (first args))))
        (t setf (getf opts :filename) (first args))))
    opts))
