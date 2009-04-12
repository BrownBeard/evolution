(:primitives (:number ((x ())
                       (y ())
                       (#(-5 5) ())
                       (+ (:number :number))
                       (- (:number :number))
                       (* (:number :number))
                       (/ (:number :number))
                       (sqrt (:number))
                       (expt (:number :number))
                       (if (:bool :number :number)))
              :bool ((or (:bool :bool))
                     (and (:bool :bool))
                     (not (:bool))
                     (= (:number :number))
                     (/= (:number :number))
                     (>= (:number :number))
                     (> (:number :number))
                     (<= (:number :number))
                     (< (:number :number))))
                     ;(t ())))  ; Use this to ensure shorter trees in startup.
                                ; But, then the resulting expressions look
                                ; stupid.
                     ;(NIL ())  Don't be putting NIL in there, it will break.
 :parameters ((x y) (:number))
 :answer (sqrt (+ (* x x) (* y y))))
