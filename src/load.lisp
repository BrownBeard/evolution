(defun read-config (filename)
  (with-open-file (fp filename)
    (read fp)))

(defun parse-args ()
  ; Set the defaults
  (let ((opts '(:filename "config.lisp"
              :initial-depth 5
              :initial-pop 10
              :mutation-depth 2)))
    (do ((args ext:*args* (rest args)))
        ((<= (length args) 0))
      (cond
        ((string= (first args) "--initial-depth")
         (setf args (rest args))
         (setf (getf opts :initial-depth) (parse-integer (first args))))
        ((string= (first args) "--initial-pop")
         (setf args (rest args))
         (setf (getf opts :initial-pop) (parse-integer (first args))))
        ((string= (first args) "--mutation-depth")
         (setf args (rest args))
         (setf (getf opts :mutation-depth) (parse-integer (first args))))
        (t setf (getf opts :filename) (first args))))
    opts))
