(defun type-in-tree (tree goal spot primitives)
  (cond
    ((= goal spot)  ; The one that we want (get-type in mutate.lisp)
     (list (1+ spot) (get-type tree primitives)))
    ((or (not (and (typep tree 'list) tree))  ; A leaf
         (> spot goal))                       ; Or, after the goal.
     (list (1+ spot) NIL))
    (t  ; An interior node
      (let ((ans NIL)
            (x (1+ spot))
            (res NIL))
        (dolist (i (rest tree))
          (setf res (type-in-tree i goal x primitives))
          (setf x (first res))
          (setf ans (append ans (list (second res)))))
        (list x (first (remove-if-not (lambda (x) x) ans)))))))

(defun find-trait (tree goal spot)
  (cond
    ((= goal spot)  ; The one that we want
     (list (1+ spot) tree))
    ((or (not (and (typep tree 'list) tree))  ; A leaf
         (> spot goal))
     (list (1+ spot) NIL))
    (t  ; An interior node
      (let ((ans NIL)
            (x (1+ spot))
            (res NIL))
        (dolist (i (rest tree))
          (setf res (find-trait i goal x))
          (setf x (first res))
          (setf ans (append ans (list (second res)))))
        (list x (first (remove-if-not (lambda (x) x) ans)))))))

(defun insert-trait (tree trait goal spot)
  (cond
    ((> spot goal)
     (list spot (list tree)))
    ((= spot goal)
     (list (1+ goal) (list trait)))
    ((< spot goal)
     (if (and tree (typep tree 'list))
       (progn (let ((ans (list (first tree)))
                    (x (1+ spot))
                    (res NIL))
                (dolist (i (rest tree))
                  (setf res (insert-trait i trait goal x))
                  (setf x (first res))
                  (setf ans (append ans (second res))))
                (list x (list ans))))
       (list (1+ spot) (list tree))))))

(defun mate (left right primitives)
  (let* ((depths-L (find-depths left 0))
         (depths-R (find-depths right 0))
         (likelihoods-L (mapcar #'find-hood depths-L))
         (likelihoods-R (mapcar #'find-hood depths-R))
         (spot-L (find-spot (map 'list
                                 #'list
                                 likelihoods-L
                                 (range 0 (length likelihoods-L)))))
         (spot-R (find-spot (map 'list
                                 #'list
                                 likelihoods-R
                                 (range 0 (length likelihoods-R)))))
         (trait-L NIL)
         (trait-R NIL)
         (new-L NIL)
         (new-R NIL))
    (do () ((equal (second (type-in-tree left spot-L 0 primitives))
                   (second (type-in-tree right spot-R 0 primitives))))
      (setf spot-L (find-spot (map 'list
                                   #'list
                                   likelihoods-L
                                   (range 0 (length likelihoods-L)))))
      (setf spot-R (find-spot (map 'list
                                   #'list
                                   likelihoods-R
                                   (range 0 (length likelihoods-R))))))
    (setf trait-L (second (find-trait left spot-L 0)))
    (setf trait-R (second (find-trait right spot-R 0)))
    (setf new-L (caadr (insert-trait left trait-R spot-L 0)))
    (setf new-R (caadr (insert-trait right trait-L spot-R 0)))
    (list new-L new-R)))
