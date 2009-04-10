(defun generation (population
                   answer
                   primitives
                   %-parent-from-top
                   %-parent-random
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
    (let ((sb (* pop-size (/ %-survive-from-top 100))))
      (dotimes (i sb)
        (setf result (append result (list (nth (second (first candidates))
                                               population))))
        (setf candidates (rest candidates)))
      (incf survivors sb))
    ; Survivors that didn't die randomly
    (let ((sr (* pop-size (/ %-survive-random 100))))
      (dotimes (i sr)
        (let ((spot (find-spot candidates)))
          (setf result (append result (list (nth spot population))))
          (setf candidates (remove-if (lambda (x) (= x spot))
                                      candidates
                                      :key #'second))))
      (incf survivors sr))
    ; Total parent-pool
    ;   From top
    (dotimes (i (* pop-size (/ %-parent-from-top 100)))
      (setf parents (append parents (list (nth (second (first fitnesses))
                                               population))))
      (setf fitnesses (rest fitnesses)))
    ;   Random
    (dotimes (i (* pop-size (/ %-parent-random 100)))
      (let ((spot (find-spot fitnesses)))
        (setf parents (append parents (list (nth spot population))))
        (setf fitnesses (remove-if (lambda (x) (= x spot))
                                   fitnesses
                                   :key #'second))))
    ; Do the crossovers.
    (let ((crosses (values (floor (* (/ (- 100 %-mutation) 100)
                                     (- pop-size survivors))
                                  2))))
      (dotimes (i crosses)
        (let ((index1 (random (length parents)))
              (index2 (random (length parents)))
              (parent1 (nth index1 parents))
              (parent2 (nth index2 parents)))
          (setf result (append result (mate parent1 parent2))))))
    ; Do the mutations.
    (dotimes (i (- pop-size (length result)))
      (let* ((index (random (length parents)))
             (parent (nth index parents)))
        (setf result (append result (list (mutate parent
                                                  mutation-depth
                                                  primitives))))))
    result))
