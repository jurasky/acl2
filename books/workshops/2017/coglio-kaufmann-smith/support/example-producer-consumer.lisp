(in-package "ACL2")

(include-book "simplify-defun")
;; To keep dependencies, small we manually do below what these transformations
;; would do:
;; (include-book "../../../transformations/wrap-output")
;; (include-book "../../../transformations/producer-consumer")

;; This example shows how simplify-defun is used to apply rewrite rules,
;; to clean up the results of other transformations, and to chain together
;; previous transformation steps.  The function F below produces all
;; pairs of items from X and Y and then filters the result to keep only the
;; "good" pairs:

(defun pair-with-all (item lst) ;; pair ITEM with all elements of LST
  (if (endp lst)
      nil
    (cons (cons item (car lst))
          (pair-with-all item (cdr lst)))))

(defun all-pairs (x y) ;; make all pairs of items from X and Y
  (if (endp x)
      nil
    (append (pair-with-all (car x) y)
            (all-pairs (cdr x) y))))

(defstub good-pair-p (pair) t) ;; just a place holder

(defun keep-good-pairs (pairs)
  (if (endp pairs)
      nil
    (if (good-pair-p (car pairs))
        (cons (car pairs) (keep-good-pairs (cdr pairs)))
      (keep-good-pairs (cdr pairs)))))

(defun f (x y) (keep-good-pairs (all-pairs x y)))

;; We wish to make F more efficient in the obvious way: refrain from ever
;; adding non-good pairs to the result, rather than filtering them out later.
;; F's body is the term (keep-good-pairs (all-pairs x y)), which we can
;; improve by "pushing" KEEP-GOOD-PAIRS into the if-branches of ALL-PAIRS,
;; using the wrap-output transformation (not described here). Wrap-output
;; produces a new function and a theorem:

;; (wrap-output all-pairs keep-good-pairs :new-name all-good-pairs)

(DEFUN ALL-GOOD-PAIRS (X Y)
  (IF (ENDP X)
      (KEEP-GOOD-PAIRS NIL)
      (KEEP-GOOD-PAIRS (APPEND (PAIR-WITH-ALL (CAR X) Y)
                               (ALL-PAIRS (CDR X) Y)))))

(DEFTHM RULE1
  (EQUAL (KEEP-GOOD-PAIRS (ALL-PAIRS X Y))
         (ALL-GOOD-PAIRS X Y)))

;; Below, we will apply RULE1 to simplify F's body.  But
;; first we will further transform ALL-GOOD-PAIRS. It can be simplified in three ways.  First,
;; (KEEP-GOOD-PAIRS NIL) can be evaluated.  Second, we can push the call to
;; KEEP-GOOD-PAIRS over the APPEND using this theorem:

(defthm keep-good-pairs-of-append
  (equal (keep-good-pairs (append x y))
         (append (keep-good-pairs x)
                 (keep-good-pairs y))))

;; Third, note that ALL-GOOD-PAIRS, despite being a transformed version of
;; ALL-PAIRS, is not recursive (it calls the old function ALL-PAIRS), but we
;; want it to be recursive.  Happily, after the call of KEEP-GOOD-PAIRS is
;; pushed over the APPEND, it will be composed with the call of ALL-PAIRS,
;; which is the exact pattern that RULE1 (generated by
;; wrap-output) can rewrite to a call to ALL-GOOD-PAIRS.  Simplify-defun
;; applies these three simplifications:

(simplify-defun all-good-pairs)

;; giving:

;; (DEFUN ALL-GOOD-PAIRS{1} (X Y)
;;   (IF (ENDP X)
;;       NIL
;;       (APPEND (KEEP-GOOD-PAIRS (PAIR-WITH-ALL (CAR X) Y))
;;               (ALL-GOOD-PAIRS{1} (CDR X) Y))))

;; Note that the function is recursive.  This is because
;; RULE1 introduced a call to ALL-GOOD-PAIRS, which
;; simplify-defun then renamed to ALL-GOOD-PAIRS{1} (it always renames
;; recursive calls). We have made some progress pushing KEEP-GOOD-PAIRS closer
;; to where the pairs are created. Now, ALL-GOOD-PAIRS{1} can be further
;; simplified.  Observe that its body contains composed calls of
;; KEEP-GOOD-PAIRS and PAIR-WITH-ALL.  We can optimize this term using the
;; producer-consumer transformation (not described here) to combine the
;; creation of the pairs with the filtering of good pairs.  As usual, a new
;; function and a theorem are produced:

;; (producer-consumer pair-with-all keep-good-pairs :new-name pair-with-all-and-filter)

(DEFUN PAIR-WITH-ALL-AND-FILTER (ITEM LST)
  (DECLARE (XARGS :MEASURE (ACL2-COUNT LST)))
  (IF (ENDP LST)
      NIL
      (IF (GOOD-PAIR-P (CONS ITEM (CAR LST)))
          (CONS (CONS ITEM (CAR LST))
                (PAIR-WITH-ALL-AND-FILTER ITEM (CDR LST)))
          (PAIR-WITH-ALL-AND-FILTER ITEM (CDR LST)))))

(DEFTHM RULE2
  (EQUAL (KEEP-GOOD-PAIRS (PAIR-WITH-ALL ITEM LST))
         (PAIR-WITH-ALL-AND-FILTER ITEM LST)))

;; Note that PAIR-WITH-ALL-AND-FILTER only returns good pairs, potentially
;; saving a lot of consing (which is the point of this example).  Now we can
;; use simplify-defun to change all-good-pairs{1} by applying the rewrite rule
;; just introduced:

(simplify-defun all-good-pairs{1})

;; This yields:

;; (DEFUN ALL-GOOD-PAIRS{2} (X Y)
;;   (IF (ENDP X)
;;       NIL
;;       (APPEND (PAIR-WITH-ALL-AND-FILTER (CAR X) Y)
;;               (ALL-GOOD-PAIRS{2} (CDR X) Y))))

;; Finally, we apply simplify-defun again to transform F by applying all of the
;; preceding rewrites in succession (introducing ALL-GOOD-PAIRS, which is in
;; turn replaced with ALL-GOOD-PAIRS{1} and then ALL-GOOD-PAIRS{2}):

(simplify-defun f :new-name f-fast)

;; This builds a fast version of F and a theorem proving it equal to F.

;; (DEFUN F-FAST (X Y)
;;   (DECLARE ...)
;;   (ALL-GOOD-PAIRS{2} X Y))

;; (DEFTHM F-BECOMES-F-FAST
;;   (EQUAL (F X Y)
;;          (F-FAST X Y)))
