(defun generation (population
                   answer
                   primitives
                   %-parent-pool-from-top
                   %-parent-from-pool
                   %-mutation
                   %-survive-from-top
                   %-survive-random
                   mutation-depth)
  (let* ((pop-size (length population))
         (fitnesses (sort (map 'list
                               #'list
                               (mapcar (lambda (x) (fitness x answer))
                                       population)
                               (range 0 pop-size))
                          #'>
                          :key #'first))
         (candidates (copy-list fitnesses))
         (result NIL)
         (parents NIL)
         (survivors 0))
    ; Survivors that didn't die from the bottom
    (let ((sb (floor (* pop-size (/ %-survive-from-top 100)))))
      (dotimes (i sb)
        (setf result (append result (list (nth (second (first candidates))
                                               population))))
        (setf candidates (rest candidates)))
      (incf survivors sb))
    ; Survivors that didn't die randomly
    (let ((sr (floor (* pop-size (/ %-survive-random 100)))))
      (dotimes (i sr)
        (let ((spot (find-spot candidates)))
          (setf result (append result (list (nth spot population))))
          (setf candidates (remove-if (lambda (x) (= x spot))
                                      candidates
                                      :key #'second))))
      (incf survivors sr))
    ; Total parent-pool from top
    (setf candidates (copy-list fitnesses))
    (dotimes (i (floor (* pop-size (/ %-parent-pool-from-top 100))))
      (setf parents (append parents (list (nth (second (first candidates))
                                               population))))
      (setf candidates (rest candidates)))
    (let* ((from-pool (floor (* (- pop-size survivors) (/ %-parent-from-pool 100))))
           (crosses (floor (* (/ (- 100 %-mutation) 100) from-pool) 2))
           (mutes (- from-pool (* 2 crosses))))
      ; Do the crossovers from pool.
      (dotimes (i crosses)
        (let* ((index1 (random (length parents)))
               (index2 (random (length parents)))
               (parent1 (nth index1 parents))
               (parent2 (nth index2 parents)))
          (setf result (append result (mate parent1 parent2)))))
      ; Do the mutations from pool.
      (dotimes (i mutes)
        (let* ((index (random (length parents)))
               (parent (nth index parents)))
          (setf result (append result (list (mutate parent
                                                    mutation-depth
                                                    primitives)))))))
    ; Do randomly selected births, returning result when finished.
    (do ()
        ((>= (length result) pop-size) result)
      (if (and (>= (random 100) %-mutation) (>= (- pop-size (length result)) 2))
        ; T: Do a crossover
        (setf result (append result (mate (nth (find-spot fitnesses) population)
                                          (nth (find-spot fitnesses) population))))
        ; NIL: Do a mutation
        (setf result (append result
                             (list (mutate (nth (find-spot fitnesses) population)
                                           mutation-depth
                                           primitives))))))))
