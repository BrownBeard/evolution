(defun change-subtree (tree spot goal depth primitives)
  (cond
    ((> spot goal)
     (list spot (list tree)))
    ((= spot goal)
     (let ((rand (build-tree depth primitives (get-type tree primitives))))
       (list (1+ goal) (list rand))))
    ((< spot goal)
     (if (and tree (typep tree 'list))
       (progn (let ((ans (list (first tree)))
                    (x (1+ spot))
                    (res NIL))
                (dolist (i (rest tree))
                  (setf res (change-subtree i x goal depth primitives))
                  (setf x (first res))
                  (setf ans (append ans (second res))))
                (list x (list ans))))
       (list (1+ spot) (list tree))))))

(defun mutate (tree depth primitives)
  (let* ((depths (find-depths tree 0))
         (likelihoods (mapcar #'find-hood depths))
         (spot (find-spot (map 'list
                               #'list
                               likelihoods
                               (range 0 (length likelihoods))))))
    (let ((ans (change-subtree tree 0 spot depth primitives)))
      (caadr ans))))
