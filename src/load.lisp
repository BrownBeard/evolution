(defun read-config (filename)
  (with-open-file (fp filename)
    (read fp)))
