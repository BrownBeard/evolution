(defun safe/ (lhs rhs)
  (if (/= rhs 0) (/ lhs rhs) 1))

(defun safesqrt (rhs)
  (if (>= rhs 0) (sqrt rhs) 1))

(defun safeexpt (lhs rhs)
  (let ((ans (expt lhs rhs)))
    (if (realp ans) ans 1)))
