(defun main ()
  (if (/= (length ext:*args*) 3) (exit))
  (let* ((f (with-open-file (fp (first ext:*args*)) (read fp)))
         (ans (progv (read-from-string (second ext:*args*))
                     (read-from-string (third ext:*args*))
                     (eval f))))
    (print ans)))

(main)
