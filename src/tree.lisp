(defun get-type (tree primitives)
  (let ((prim (if (typep tree 'list) (first tree) tree))
        (key NIL))
    (dolist (i primitives)
      (if (typep i 'keyword)
        (setf key i)
        (dolist (j i)
          (when (or (equalp prim (first j))
                    (and (typep prim 'number) (typep (first j) 'array)))
            (return-from get-type key)))))))

(defun build-tree (depth primitives result-type)
  (let ((appropriate (getf primitives result-type))
        (prim NIL))
    (when (= (length appropriate) 0)
      (format t "No way to get a ~a.~%" result-type)
      (exit))

    (if (> depth 0)
      (setf prim (nth (random (length appropriate)) appropriate))
      (let ((terminals (remove-if-not (lambda (x) (= (length (second x)) 0))
                                      appropriate)))
        (if (> (length terminals) 0)
          (setf prim (nth (random (length terminals)) terminals))
          (setf prim (nth (random (length appropriate)) appropriate)))))

    (if (= (length (second prim)) 0)
      (if (typep (first prim) 'array)
        (+ (elt (first prim) 0)
           (random (float (- (elt (first prim) 1) (elt (first prim) 0)))))
        (first prim))
      (append (list (first prim))
              (mapcar (lambda (r) (build-tree (1- depth) primitives r))
                      (second prim))))))
