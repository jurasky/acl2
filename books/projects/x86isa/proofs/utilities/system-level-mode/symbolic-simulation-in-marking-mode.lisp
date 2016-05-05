;; AUTHOR:
;; Shilpi Goel <shigoel@cs.utexas.edu>

(in-package "X86ISA")
(include-book "marking-mode-utils")

(local (include-book "centaur/bitops/ihs-extensions" :dir :system))
(local (include-book "centaur/bitops/signed-byte-p" :dir :system))

(local (in-theory (e/d* () (signed-byte-p unsigned-byte-p))))

;; ======================================================================

(defsection symbolic-simulation-in-marking-mode
  :parents (marking-mode-utils)

  :short "Reasoning in the system-level marking mode"

  :long "<p>WORK IN PROGRESS...</p>

<p>This doc topic will be updated in later commits...</p>"
  )

(local (xdoc::set-default-parents symbolic-simulation-in-marking-mode))

;; ======================================================================

;; Get-prefixes in system-level marking mode:

(defthm xr-not-mem-and-get-prefixes
  ;; I don't need this lemma in the programmer-level mode because
  ;; (mv-nth 2 (get-prefixes ... x86)) == x86 there.
  (implies (and (not (equal fld :mem))
                (not (equal fld :fault)))
           (equal (xr fld index (mv-nth 2 (get-prefixes start-rip prefixes cnt x86)))
                  (xr fld index x86)))
  :hints (("Goal"
           :induct (get-prefixes start-rip prefixes cnt x86)
           :in-theory (e/d* (get-prefixes rm08)
                            (rm08-to-rb
                             not force (force))))))

;; Opener lemmas:

(defthm get-prefixes-opener-lemma-group-1-prefix-in-marking-mode
  (implies
   (and
    (canonical-address-p (1+ start-rip))
    (not (zp cnt))
    (equal (prefixes-slice :group-1-prefix prefixes) 0)
    (let*
        ((flg (mv-nth 0 (rm08 start-rip :x x86)))
         (prefix-byte-group-code
          (get-one-byte-prefix-array-code (mv-nth 1 (rm08 start-rip :x x86)))))
      (and (not flg)
           (equal prefix-byte-group-code 1))))
   (equal (get-prefixes start-rip prefixes cnt x86)
          (get-prefixes (+ 1 start-rip)
                        (!prefixes-slice :group-1-prefix
                                         (mv-nth 1 (rm08 start-rip :x x86))
                                         prefixes)
                        (+ -1 cnt)
                        (mv-nth 2 (rm08 start-rip :x x86)))))
  :hints (("Goal"
           :induct (get-prefixes start-rip prefixes cnt x86)
           :in-theory (e/d* (get-prefixes
                             las-to-pas)
                            (acl2::ash-0
                             acl2::zip-open
                             byte-listp
                             unsigned-byte-p-of-logior
                             negative-logand-to-positive-logand-with-integerp-x
                             force (force))))))

(defthm get-prefixes-opener-lemma-group-2-prefix-in-marking-mode
  (implies (and
            (canonical-address-p (1+ start-rip))
            (not (zp cnt))
            (equal (prefixes-slice :group-2-prefix prefixes) 0)
            (let*
                ((flg (mv-nth 0 (rm08 start-rip :x x86)))
                 (prefix-byte-group-code
                  (get-one-byte-prefix-array-code (mv-nth 1 (rm08 start-rip :x x86)))))
              (and (not flg)
                   (equal prefix-byte-group-code 2))))
           (equal (get-prefixes start-rip prefixes cnt x86)
                  (get-prefixes (1+ start-rip)
                                (!prefixes-slice :group-2-prefix
                                                 (mv-nth 1 (rm08 start-rip :x x86))
                                                 prefixes)
                                (1- cnt)
                                (mv-nth 2 (rm08 start-rip :x x86)))))
  :hints (("Goal"
           :induct (get-prefixes start-rip prefixes cnt x86)
           :in-theory (e/d* (get-prefixes
                             las-to-pas)
                            (acl2::ash-0
                             acl2::zip-open
                             byte-listp
                             unsigned-byte-p-of-logior
                             negative-logand-to-positive-logand-with-integerp-x
                             force (force))))))

(defthm get-prefixes-opener-lemma-group-3-prefix-in-marking-mode
  (implies (and
            (canonical-address-p (1+ start-rip))
            (not (zp cnt))
            (equal (prefixes-slice :group-3-prefix prefixes) 0)
            (let*
                ((flg (mv-nth 0 (rm08 start-rip :x x86)))
                 (prefix-byte-group-code
                  (get-one-byte-prefix-array-code (mv-nth 1 (rm08 start-rip :x x86)))))
              (and (not flg)
                   (equal prefix-byte-group-code 3))))
           (equal (get-prefixes start-rip prefixes cnt x86)
                  (get-prefixes (1+ start-rip)
                                (!prefixes-slice :group-3-prefix
                                                 (mv-nth 1 (rm08 start-rip :x x86))
                                                 prefixes)
                                (1- cnt)
                                (mv-nth 2 (rm08 start-rip :x x86)))))
  :hints (("Goal"
           :induct (get-prefixes start-rip prefixes cnt x86)
           :in-theory (e/d* (get-prefixes
                             las-to-pas)
                            (acl2::ash-0
                             acl2::zip-open
                             byte-listp
                             unsigned-byte-p-of-logior
                             negative-logand-to-positive-logand-with-integerp-x
                             force (force))))))

(defthm get-prefixes-opener-lemma-group-4-prefix-in-marking-mode
  (implies (and
            (canonical-address-p (1+ start-rip))
            (not (zp cnt))
            (equal (prefixes-slice :group-4-prefix prefixes) 0)
            (let*
                ((flg (mv-nth 0 (rm08 start-rip :x x86)))
                 (prefix-byte-group-code
                  (get-one-byte-prefix-array-code (mv-nth 1 (rm08 start-rip :x x86)))))
              (and (not flg)
                   (equal prefix-byte-group-code 4))))
           (equal (get-prefixes start-rip prefixes cnt x86)
                  (get-prefixes (1+ start-rip)
                                (!prefixes-slice :group-4-prefix
                                                 (mv-nth 1 (rm08 start-rip :x x86))
                                                 prefixes)
                                (1- cnt)
                                (mv-nth 2 (rm08 start-rip :x x86)))))
  :hints (("Goal"
           :induct (get-prefixes start-rip prefixes cnt x86)
           :in-theory (e/d* (get-prefixes
                             las-to-pas)
                            (acl2::ash-0
                             acl2::zip-open
                             byte-listp
                             unsigned-byte-p-of-logior
                             negative-logand-to-positive-logand-with-integerp-x
                             force (force))))))

;; Get-prefixes and xlate-equiv-memory:

(local
 (defthm xlate-equiv-memory-and-mv-nth-0-rm08-cong
   (implies (xlate-equiv-memory x86-1 x86-2)
            (equal (mv-nth 0 (rm08 lin-addr r-w-x x86-1))
                   (mv-nth 0 (rm08 lin-addr r-w-x x86-2))))
   :hints
   (("Goal" :cases ((xr :programmer-level-mode 0 x86-1))
     :in-theory (e/d* (rm08 disjoint-p member-p)
                      (force (force))))
    ("Subgoal 1" :in-theory (e/d* (xlate-equiv-memory)
                                  (force (force)))))
   :rule-classes :congruence))

(defthm xlate-equiv-memory-and-xr-mem-from-rest-of-memory
  (implies
   (and (bind-free
         (find-an-xlate-equiv-x86
          'xlate-equiv-memory-and-xr-mem-from-rest-of-memory
          x86-1 'x86-2 mfc state)
         (x86-2))
        (syntaxp (not (equal x86-1 x86-2)))
        (xlate-equiv-memory (double-rewrite x86-1) x86-2)
        (disjoint-p (list j)
                    (open-qword-paddr-list
                     (gather-all-paging-structure-qword-addresses (double-rewrite x86-1))))
        (natp j)
        (< j *mem-size-in-bytes*))
   (equal (xr :mem j x86-1) (xr :mem j x86-2)))
  :hints (("Goal" :in-theory (e/d* (xlate-equiv-memory disjoint-p)
                                   ()))))

(local
 (defthm xlate-equiv-memory-and-mv-nth-1-rm08
   (implies (and (bind-free
                  (find-an-xlate-equiv-x86
                   'xlate-equiv-memory-and-mv-nth-1-rm08
                   x86-1 'x86-2 mfc state)
                  (x86-2))
                 (syntaxp (not (equal x86-1 x86-2)))
                 (xlate-equiv-memory (double-rewrite x86-1) x86-2)
                 (disjoint-p
                  (list (mv-nth 1 (ia32e-la-to-pa lin-addr r-w-x (cpl x86-1) x86-1)))
                  (open-qword-paddr-list
                   (gather-all-paging-structure-qword-addresses (double-rewrite x86-1)))))
            (equal (mv-nth 1 (rm08 lin-addr r-w-x x86-1))
                   (mv-nth 1 (rm08 lin-addr r-w-x x86-2))))
   :hints (("Goal"
            :cases ((xr :programmer-level-mode 0 x86-1))
            :in-theory (e/d* (rm08
                              disjoint-p
                              member-p)
                             (force (force))))
           ("Subgoal 2"
            :use ((:instance xlate-equiv-memory-and-xr-mem-from-rest-of-memory
                             (j (mv-nth 1 (ia32e-la-to-pa lin-addr r-w-x (cpl x86-1) x86-1)))
                             (x86-1 (mv-nth 2 (ia32e-la-to-pa lin-addr r-w-x (cpl x86-1) x86-1)))
                             (x86-2 (mv-nth 2 (ia32e-la-to-pa lin-addr r-w-x (cpl x86-2) x86-2)))))
            :in-theory (e/d* (rm08
                              disjoint-p
                              member-p)
                             (xlate-equiv-memory-and-xr-mem-from-rest-of-memory
                              force (force))))
           ("Subgoal 1" :in-theory (e/d* (xlate-equiv-memory) (force (force)))))))

(local
 (defthm xlate-equiv-memory-and-two-mv-nth-2-rm08-cong
   (implies (xlate-equiv-memory x86-1 x86-2)
            (xlate-equiv-memory (mv-nth 2 (rm08 lin-addr r-w-x x86-1))
                                (mv-nth 2 (rm08 lin-addr r-w-x x86-2))))
   :hints (("Goal" :in-theory (e/d* (rm08) (force (force)))))
   :rule-classes :congruence))

(local
 (defthm xlate-equiv-memory-and-mv-nth-2-rm08
   (xlate-equiv-memory (mv-nth 2 (rm08 lin-addr r-w-x x86)) x86)
   :hints (("Goal" :in-theory (e/d* (rm08) (force (force)))))))

(defun-nx get-prefixes-two-x86-induct-hint
  (start-rip prefixes cnt x86-1 x86-2)
  (declare (xargs :measure (nfix cnt)))
  (if (zp cnt)
      ;; Error, too many prefix bytes
      (mv nil prefixes x86-1 x86-2)

    (b* ((ctx 'get-prefixes-two-x86-induct-hint)
         ((mv flg-1 byte-1 x86-1)
          (rm08 start-rip :x x86-1))
         ((mv flg-2 byte-2 x86-2)
          (rm08 start-rip :x x86-2))
         ((when flg-1)
          (mv (cons ctx flg-1) byte-1 x86-1))
         ((when flg-2)
          (mv (cons ctx flg-2) byte-2 x86-2))
         ;; Quit if byte-1 and byte-2 aren't equal...
         ((when (not (equal byte-1 byte-2)))
          (mv nil prefixes x86-1 x86-2))
         (byte byte-1)

         (prefix-byte-group-code
          (get-one-byte-prefix-array-code byte)))

      (if (zp prefix-byte-group-code)
          (let ((prefixes
                 (!prefixes-slice :next-byte byte prefixes)))
            (mv nil (!prefixes-slice :num-prefixes (- 5 cnt) prefixes) x86-1 x86-2))

        (case prefix-byte-group-code
          (1 (let ((prefix-1?
                    (prefixes-slice :group-1-prefix prefixes)))
               (if (or (eql 0 (the (unsigned-byte 8) prefix-1?))
                       ;; Redundant Prefix Okay
                       (eql byte prefix-1?))
                   (let ((next-rip (the (signed-byte
                                         #.*max-linear-address-size+1*)
                                     (1+ start-rip))))
                     (if (mbe :logic (canonical-address-p next-rip)
                              :exec
                              (< (the (signed-byte
                                       #.*max-linear-address-size+1*)
                                   next-rip)
                                 #.*2^47*))
                         ;; Storing the group 1 prefix and going on...
                         (get-prefixes-two-x86-induct-hint
                          next-rip
                          (the (unsigned-byte 43)
                            (!prefixes-slice :group-1-prefix
                                             byte
                                             prefixes))
                          (the (integer 0 5) (1- cnt))
                          x86-1
                          x86-2)
                       (mv (cons 'non-canonical-address next-rip) prefixes x86-1 x86-2)))
                 ;; We do not tolerate more than one prefix from a prefix group.
                 (mv t prefixes x86-1 x86-2))))

          (2 (let ((prefix-2?
                    (prefixes-slice :group-2-prefix prefixes)))
               (if (or (eql 0 (the (unsigned-byte 8) prefix-2?))
                       ;; Redundant Prefixes Okay
                       (eql byte (the (unsigned-byte 8) prefix-2?)))
                   (let ((next-rip (the (signed-byte
                                         #.*max-linear-address-size+1*)
                                     (1+ start-rip))))
                     (if (mbe :logic (canonical-address-p next-rip)
                              :exec
                              (< (the (signed-byte
                                       #.*max-linear-address-size+1*)
                                   next-rip)
                                 #.*2^47*))
                         ;; Storing the group 2 prefix and going on...
                         (get-prefixes-two-x86-induct-hint
                          next-rip
                          (!prefixes-slice :group-2-prefix
                                           byte
                                           prefixes)
                          (the (integer 0 5) (1- cnt))
                          x86-1 x86-2)
                       (mv (cons 'non-canonical-address next-rip)
                           prefixes x86-1 x86-2)))
                 ;; We do not tolerate more than one prefix from a prefix group.
                 (mv t prefixes x86-1 x86-2))))

          (3 (let ((prefix-3?
                    (prefixes-slice :group-3-prefix prefixes)))
               (if (or (eql 0 (the (unsigned-byte 8) prefix-3?))
                       ;; Redundant Prefix Okay
                       (eql byte (the (unsigned-byte 8) prefix-3?)))

                   (let ((next-rip (the (signed-byte
                                         #.*max-linear-address-size+1*)
                                     (1+ start-rip))))
                     (if (mbe :logic (canonical-address-p next-rip)
                              :exec
                              (< (the (signed-byte
                                       #.*max-linear-address-size+1*)
                                   next-rip)
                                 #.*2^47*))
                         ;; Storing the group 3 prefix and going on...
                         (get-prefixes-two-x86-induct-hint
                          next-rip
                          (!prefixes-slice :group-3-prefix
                                           byte
                                           prefixes)
                          (the (integer 0 5) (1- cnt)) x86-1 x86-2)
                       (mv (cons 'non-canonical-address next-rip)
                           prefixes x86-1 x86-2)))
                 ;; We do not tolerate more than one prefix from a prefix group.
                 (mv t prefixes x86-1 x86-2))))

          (4 (let ((prefix-4?
                    (prefixes-slice :group-4-prefix prefixes)))
               (if (or (eql 0 (the (unsigned-byte 8) prefix-4?))
                       ;; Redundant Prefix Okay
                       (eql byte (the (unsigned-byte 8) prefix-4?)))
                   (let ((next-rip (the (signed-byte
                                         #.*max-linear-address-size+1*)
                                     (1+ start-rip))))
                     (if (mbe :logic (canonical-address-p next-rip)
                              :exec
                              (< (the (signed-byte
                                       #.*max-linear-address-size+1*)
                                   next-rip)
                                 #.*2^47*))
                         ;; Storing the group 4 prefix and going on...
                         (get-prefixes-two-x86-induct-hint
                          next-rip
                          (!prefixes-slice :group-4-prefix
                                           byte
                                           prefixes)
                          (the (integer 0 5) (1- cnt))
                          x86-1 x86-2)
                       (mv (cons 'non-canonical-address next-rip)
                           prefixes x86-1 x86-2)))
                 ;; We do not tolerate more than one prefix from a prefix group.
                 (mv t prefixes x86-1 x86-2))))

          (otherwise
           (mv t prefixes x86-1 x86-2)))))))

(defthm xlate-equiv-memory-and-two-get-prefixes-values
  (implies
   (and
    (bind-free
     (find-an-xlate-equiv-x86
      'xlate-equiv-memory-and-two-get-prefixes-values
      x86-1 'x86-2 mfc state)
     (x86-2))
    (syntaxp (not (equal x86-1 x86-2)))
    (xlate-equiv-memory (double-rewrite x86-1) x86-2)
    (canonical-address-p start-rip)
    (not (mv-nth 0 (las-to-pas
                    (create-canonical-address-list cnt start-rip)
                    :x (cpl x86-1) x86-1)))
    (disjoint-p
     (mv-nth 1 (las-to-pas
                (create-canonical-address-list cnt start-rip)
                :x (cpl x86-1) x86-1))
     (open-qword-paddr-list
      (gather-all-paging-structure-qword-addresses (double-rewrite x86-1)))))
   (and (equal (mv-nth 0 (get-prefixes start-rip prefixes cnt x86-1))
               (mv-nth 0 (get-prefixes start-rip prefixes cnt x86-2)))
        (equal (mv-nth 1 (get-prefixes start-rip prefixes cnt x86-1))
               (mv-nth 1 (get-prefixes start-rip prefixes cnt x86-2)))))
  :hints (("Goal"
           :induct (get-prefixes-two-x86-induct-hint start-rip prefixes cnt x86-1 x86-2)
           :in-theory (e/d* (get-prefixes disjoint-p member-p las-to-pas las-to-pas-subset-p)
                            ()))
          (if
              ;; Apply to all subgoals under a top-level induction.
              (and (consp (car id))
                   (< 1 (len (car id))))
              '(:expand ((get-prefixes start-rip prefixes cnt x86-1)
                         (get-prefixes start-rip prefixes cnt x86-2))
                        :use
                        ((:instance xlate-equiv-memory-and-mv-nth-0-rm08-cong
                                    (lin-addr start-rip)
                                    (r-w-x :x))
                         (:instance xlate-equiv-memory-and-mv-nth-1-rm08
                                    (lin-addr start-rip)
                                    (r-w-x :x)))
                        :in-theory
                        (e/d* (disjoint-p
                               member-p
                               get-prefixes
                               las-to-pas
                               las-to-pas-subset-p)
                              (xlate-equiv-memory-and-mv-nth-0-rm08-cong
                               xlate-equiv-memory-and-mv-nth-1-rm08
                               disjoint-p-of-open-qword-paddr-list-and-remove-duplicates-equal
                               disjointness-of-las-to-pas-from-las-to-pas-subset-p
                               (:rewrite disjoint-p-of-remove-duplicates-equal)
                               (:rewrite mv-nth-0-ia32e-la-to-pa-member-of-mv-nth-1-las-to-pas-if-lin-addr-member-p)
                               (:rewrite not-disjoint-p-of-open-qword-paddr-list-and-remove-duplicates-equal)
                               (:rewrite cdr-mv-nth-1-las-to-pas)
                               (:rewrite member-p-remove-duplicates-equal-iff-member-p)
                               (:rewrite not-member-p-of-open-qword-paddr-list-and-remove-duplicates-equal)
                               (:definition remove-duplicates-equal)
                               (:rewrite member-p-canonical-address-listp)
                               (:rewrite not-member-p-of-remove-duplicates-equal)
                               (:rewrite member-p-of-open-qword-paddr-list-and-remove-duplicates-equal))))
            nil)))

(defthm xlate-equiv-memory-and-mv-nth-2-get-prefixes
  (implies (and (not (programmer-level-mode (double-rewrite x86)))
                (page-structure-marking-mode (double-rewrite x86))
                (canonical-address-p start-rip)
                (not (mv-nth 0 (las-to-pas (create-canonical-address-list cnt start-rip)
                                           :x (cpl x86) (double-rewrite x86)))))
           (xlate-equiv-memory (mv-nth 2 (get-prefixes start-rip prefixes cnt x86))
                               (double-rewrite x86)))
  :hints (("Goal"
           :induct (get-prefixes start-rip prefixes cnt x86)
           :in-theory (e/d* (get-prefixes las-to-pas-subset-p subset-p)
                            (acl2::ash-0
                             acl2::zip-open
                             cdr-create-canonical-address-list
                             force (force))))
          (if
              ;; Apply to all subgoals under a top-level induction.
              (and (consp (car id))
                   (< 1 (len (car id))))
              '(:in-theory (e/d* (subset-p get-prefixes las-to-pas-subset-p)
                                 (acl2::ash-0
                                  acl2::zip-open
                                  cdr-create-canonical-address-list
                                  force (force)))
                           :use ((:instance xlate-equiv-memory-and-las-to-pas
                                            (l-addrs (create-canonical-address-list (+ -1 cnt) (+ 1 start-rip)))
                                            (r-w-x :x)
                                            (cpl (cpl x86))
                                            (x86-1 (mv-nth 2 (las-to-pas (list start-rip) :x (cpl x86) x86)))
                                            (x86-2 x86))))
            nil)))

(defthmd xlate-equiv-memory-and-two-mv-nth-2-get-prefixes
  (implies (and (xlate-equiv-memory x86-1 x86-2)
                (not (programmer-level-mode x86-2))
                (page-structure-marking-mode (double-rewrite x86-2))
                (canonical-address-p start-rip)
                (not (mv-nth 0
                             (las-to-pas (create-canonical-address-list cnt start-rip)
                                         :x (cpl x86-2) (double-rewrite x86-2)))))
           (xlate-equiv-memory (mv-nth 2 (get-prefixes start-rip prefixes cnt x86-1))
                               (mv-nth 2 (get-prefixes start-rip prefixes cnt x86-2))))
  :hints (("Goal"
           :use ((:instance xlate-equiv-memory-and-mv-nth-2-get-prefixes (x86 x86-1))
                 (:instance xlate-equiv-memory-and-mv-nth-2-get-prefixes (x86 x86-2)))
           :in-theory (e/d* ()
                            (xlate-equiv-memory-and-mv-nth-2-get-prefixes
                             acl2::ash-0
                             acl2::zip-open
                             cdr-create-canonical-address-list)))))

;; ----------------------------------------------------------------------

;; Rewriting get-prefixes to get-prefixes-alt:

;; The biggest drawback of this approach is that all the nice theorems
;; I have about get-prefixes now have to be re-proved in terms of
;; get-prefixes-alt.

(define get-prefixes-alt
  ((start-rip :type (signed-byte   #.*max-linear-address-size*))
   (prefixes  :type (unsigned-byte 43))
   (cnt       :type (integer 0 5))
   x86)
  :non-executable t
  :guard (canonical-address-p (+ cnt start-rip))
  (if (and (page-structure-marking-mode x86)
           (not (programmer-level-mode x86))
           (canonical-address-p start-rip)
           (disjoint-p
            (mv-nth 1 (las-to-pas
                       (create-canonical-address-list cnt start-rip)
                       :x (cpl x86) x86))
            (open-qword-paddr-list
             (gather-all-paging-structure-qword-addresses x86)))
           (not (mv-nth 0 (las-to-pas
                           (create-canonical-address-list cnt start-rip)
                           :x (cpl x86) x86))))

      (get-prefixes start-rip prefixes cnt x86)

    (mv nil prefixes x86))

  ///

  (defthm natp-get-prefixes-alt
    (implies (forced-and (natp prefixes)
                         (canonical-address-p start-rip)
                         (x86p x86))
             (natp (mv-nth 1 (get-prefixes-alt start-rip prefixes cnt x86))))
    :hints (("Goal"
             :cases ((and (page-structure-marking-mode x86)
                          (not (programmer-level-mode x86))
                          (not (mv-nth 0 (las-to-pas nil r-w-x (cpl x86) x86)))))
             :in-theory (e/d (las-to-pas)
                             ())))
    :rule-classes :type-prescription)

  (defthm-usb n43p-get-prefixes-alt
    :hyp (and (n43p prefixes)
              (canonical-address-p start-rip)
              (x86p x86))
    :bound 43
    :concl (mv-nth 1 (get-prefixes-alt start-rip prefixes cnt x86))
    :hints (("Goal"
             :use ((:instance n43p-get-prefixes))
             :in-theory (e/d () (n43p-get-prefixes))))
    :gen-linear t)

  (defthm x86p-get-prefixes-alt
    (implies (forced-and (x86p x86)
                         (canonical-address-p start-rip))
             (x86p (mv-nth 2 (get-prefixes-alt start-rip prefixes cnt x86)))))

  (defthm xr-not-mem-and-get-prefixes-alt
    (implies (and (not (equal fld :mem))
                  (not (equal fld :fault)))
             (equal (xr fld index (mv-nth 2 (get-prefixes-alt start-rip prefixes cnt x86)))
                    (xr fld index x86)))
    :hints (("Goal" :in-theory (e/d* () (not force (force)))))))

;; Rewrite get-prefixes to get-prefixes-alt:

(defthm rewrite-get-prefixes-to-get-prefixes-alt
  (implies (forced-and
            (disjoint-p
             (mv-nth 1 (las-to-pas
                        (create-canonical-address-list cnt start-rip)
                        :x (cpl x86) (double-rewrite x86)))
             (open-qword-paddr-list
              (gather-all-paging-structure-qword-addresses x86)))
            (not (mv-nth 0 (las-to-pas
                            (create-canonical-address-list cnt start-rip)
                            :x (cpl x86) x86)))
            (page-structure-marking-mode x86)
            (not (programmer-level-mode x86))
            (canonical-address-p start-rip))
           (equal (get-prefixes start-rip prefixes cnt x86)
                  (get-prefixes-alt start-rip prefixes cnt x86)))
  :hints (("Goal" :in-theory (e/d* (get-prefixes-alt) ()))))

;; Opener lemmas:

(defthm get-prefixes-alt-opener-lemma-zero-cnt
  (implies (and (zp cnt)
                (disjoint-p
                 (mv-nth 1 (las-to-pas
                            (create-canonical-address-list cnt start-rip)
                            :x (cpl x86) (double-rewrite x86)))
                 (open-qword-paddr-list
                  (gather-all-paging-structure-qword-addresses x86)))
                (not
                 (mv-nth
                  0
                  (las-to-pas (create-canonical-address-list cnt start-rip)
                              :x (cpl x86)
                              x86)))
                (page-structure-marking-mode x86)
                (not (programmer-level-mode x86))
                (canonical-address-p start-rip))
           (equal (get-prefixes-alt start-rip prefixes cnt x86)
                  (mv nil prefixes x86)))
  :hints (("Goal"
           :use ((:instance get-prefixes-opener-lemma-zero-cnt))
           :in-theory (e/d () (get-prefixes-opener-lemma-zero-cnt
                               force (force))))))

(defthm get-prefixes-alt-opener-lemma-no-prefix-byte
  (implies (and (let*
                    ((flg (mv-nth 0 (rm08 start-rip :x x86)))
                     (prefix-byte-group-code
                      (get-one-byte-prefix-array-code (mv-nth 1 (rm08 start-rip :x x86)))))
                  (and (not flg)
                       (zp prefix-byte-group-code)))
                (not (zp cnt))
                (page-structure-marking-mode x86)
                (not (programmer-level-mode x86))
                (canonical-address-p start-rip)
                (not
                 (mv-nth
                  0
                  (las-to-pas (create-canonical-address-list cnt start-rip)
                              :x (cpl x86)
                              x86)))
                (disjoint-p
                 (mv-nth 1 (las-to-pas
                            (create-canonical-address-list cnt start-rip)
                            :x (cpl x86) (double-rewrite x86)))
                 (open-qword-paddr-list
                  (gather-all-paging-structure-qword-addresses x86))))
           (and
            (equal (mv-nth 0 (get-prefixes-alt start-rip prefixes cnt x86))
                   nil)
            (equal (mv-nth 1 (get-prefixes-alt start-rip prefixes cnt x86))
                   (let ((prefixes
                          (!prefixes-slice :next-byte
                                           (mv-nth 1 (rm08 start-rip :x x86))
                                           prefixes)))
                     (!prefixes-slice :num-prefixes (- 5 cnt) prefixes)))))
  :hints (("Goal"
           :use ((:instance get-prefixes-opener-lemma-no-prefix-byte))
           :in-theory (e/d* () (get-prefixes-opener-lemma-no-prefix-byte)))))

(defthm get-prefixes-alt-opener-lemma-group-1-prefix-in-marking-mode
  (implies
   (and
    (canonical-address-p (1+ start-rip))
    (not (zp cnt))
    (equal (prefixes-slice :group-1-prefix prefixes) 0)
    (let*
        ((flg (mv-nth 0 (rm08 start-rip :x x86)))
         (prefix-byte-group-code
          (get-one-byte-prefix-array-code (mv-nth 1 (rm08 start-rip :x x86)))))
      (and (not flg)
           (equal prefix-byte-group-code 1)))
    (page-structure-marking-mode x86)
    (not (programmer-level-mode x86))
    (canonical-address-p start-rip)
    (disjoint-p
     (mv-nth 1 (las-to-pas
                (create-canonical-address-list cnt start-rip)
                :x (cpl x86) (double-rewrite x86)))
     (open-qword-paddr-list
      (gather-all-paging-structure-qword-addresses x86)))
    (not
     (mv-nth
      0
      (las-to-pas (create-canonical-address-list cnt start-rip)
                  :x (cpl x86)
                  x86))))
   (equal (get-prefixes-alt start-rip prefixes cnt x86)
          (get-prefixes-alt (+ 1 start-rip)
                            (!prefixes-slice :group-1-prefix
                                             (mv-nth 1 (rm08 start-rip :x x86))
                                             prefixes)
                            (+ -1 cnt)
                            (mv-nth 2 (rm08 start-rip :x x86)))))
  :hints (("Goal"
           :do-not-induct t
           :use ((:instance get-prefixes-opener-lemma-group-1-prefix-in-marking-mode)
                 (:instance rewrite-get-prefixes-to-get-prefixes-alt)
                 (:instance rewrite-get-prefixes-to-get-prefixes-alt
                            (start-rip (1+ start-rip))
                            (prefixes (!prefixes-slice :group-1-prefix
                                                       (mv-nth 1 (rm08 start-rip :x x86))
                                                       prefixes))
                            (cnt (1- cnt))
                            (x86 (mv-nth 2 (rm08 start-rip :x x86)))))
           :in-theory (e/d* (las-to-pas)
                            (get-prefixes-opener-lemma-group-1-prefix-in-marking-mode
                             rewrite-get-prefixes-to-get-prefixes-alt
                             acl2::ash-0
                             acl2::zip-open
                             byte-listp
                             unsigned-byte-p-of-logior
                             negative-logand-to-positive-logand-with-integerp-x
                             force (force))))))

(defthm get-prefixes-alt-opener-lemma-group-2-prefix-in-marking-mode
  (implies
   (and
    (canonical-address-p (1+ start-rip))
    (not (zp cnt))
    (equal (prefixes-slice :group-2-prefix prefixes) 0)
    (let*
        ((flg (mv-nth 0 (rm08 start-rip :x x86)))
         (prefix-byte-group-code
          (get-one-byte-prefix-array-code (mv-nth 1 (rm08 start-rip :x x86)))))
      (and (not flg)
           (equal prefix-byte-group-code 2)))
    (page-structure-marking-mode x86)
    (not (programmer-level-mode x86))
    (canonical-address-p start-rip)
    (disjoint-p
     (mv-nth 1 (las-to-pas
                (create-canonical-address-list cnt start-rip)
                :x (cpl x86) (double-rewrite x86)))
     (open-qword-paddr-list
      (gather-all-paging-structure-qword-addresses x86)))
    (not
     (mv-nth
      0
      (las-to-pas (create-canonical-address-list cnt start-rip)
                  :x (cpl x86)
                  x86))))
   (equal (get-prefixes-alt start-rip prefixes cnt x86)
          (get-prefixes-alt (+ 1 start-rip)
                            (!prefixes-slice :group-2-prefix
                                             (mv-nth 1 (rm08 start-rip :x x86))
                                             prefixes)
                            (+ -1 cnt)
                            (mv-nth 2 (rm08 start-rip :x x86)))))
  :hints (("Goal"
           :do-not-induct t
           :use ((:instance get-prefixes-opener-lemma-group-2-prefix-in-marking-mode)
                 (:instance rewrite-get-prefixes-to-get-prefixes-alt)
                 (:instance rewrite-get-prefixes-to-get-prefixes-alt
                            (start-rip (1+ start-rip))
                            (prefixes (!prefixes-slice :group-2-prefix
                                                       (mv-nth 1 (rm08 start-rip :x x86))
                                                       prefixes))
                            (cnt (1- cnt))
                            (x86 (mv-nth 2 (rm08 start-rip :x x86)))))
           :in-theory (e/d* (las-to-pas)
                            (get-prefixes-opener-lemma-group-2-prefix-in-marking-mode
                             rewrite-get-prefixes-to-get-prefixes-alt
                             acl2::ash-0
                             acl2::zip-open
                             byte-listp
                             unsigned-byte-p-of-logior
                             negative-logand-to-positive-logand-with-integerp-x
                             force (force))))))

(defthm get-prefixes-alt-opener-lemma-group-3-prefix-in-marking-mode
  (implies
   (and
    (canonical-address-p (1+ start-rip))
    (not (zp cnt))
    (equal (prefixes-slice :group-3-prefix prefixes) 0)
    (let*
        ((flg (mv-nth 0 (rm08 start-rip :x x86)))
         (prefix-byte-group-code
          (get-one-byte-prefix-array-code (mv-nth 1 (rm08 start-rip :x x86)))))
      (and (not flg)
           (equal prefix-byte-group-code 3)))
    (page-structure-marking-mode x86)
    (not (programmer-level-mode x86))
    (canonical-address-p start-rip)
    (disjoint-p
     (mv-nth 1 (las-to-pas
                (create-canonical-address-list cnt start-rip)
                :x (cpl x86) (double-rewrite x86)))
     (open-qword-paddr-list
      (gather-all-paging-structure-qword-addresses x86)))
    (not
     (mv-nth
      0
      (las-to-pas (create-canonical-address-list cnt start-rip)
                  :x (cpl x86)
                  x86))))
   (equal (get-prefixes-alt start-rip prefixes cnt x86)
          (get-prefixes-alt (+ 1 start-rip)
                            (!prefixes-slice :group-3-prefix
                                             (mv-nth 1 (rm08 start-rip :x x86))
                                             prefixes)
                            (+ -1 cnt)
                            (mv-nth 2 (rm08 start-rip :x x86)))))
  :hints (("Goal"
           :do-not-induct t
           :use ((:instance get-prefixes-opener-lemma-group-3-prefix-in-marking-mode)
                 (:instance rewrite-get-prefixes-to-get-prefixes-alt)
                 (:instance rewrite-get-prefixes-to-get-prefixes-alt
                            (start-rip (1+ start-rip))
                            (prefixes (!prefixes-slice :group-3-prefix
                                                       (mv-nth 1 (rm08 start-rip :x x86))
                                                       prefixes))
                            (cnt (1- cnt))
                            (x86 (mv-nth 2 (rm08 start-rip :x x86)))))
           :in-theory (e/d* (las-to-pas)
                            (get-prefixes-opener-lemma-group-3-prefix-in-marking-mode
                             rewrite-get-prefixes-to-get-prefixes-alt
                             acl2::ash-0
                             acl2::zip-open
                             byte-listp
                             unsigned-byte-p-of-logior
                             negative-logand-to-positive-logand-with-integerp-x
                             force (force))))))

(defthm get-prefixes-alt-opener-lemma-group-4-prefix-in-marking-mode
  (implies
   (and
    (canonical-address-p (1+ start-rip))
    (not (zp cnt))
    (equal (prefixes-slice :group-4-prefix prefixes) 0)
    (let*
        ((flg (mv-nth 0 (rm08 start-rip :x x86)))
         (prefix-byte-group-code
          (get-one-byte-prefix-array-code (mv-nth 1 (rm08 start-rip :x x86)))))
      (and (not flg)
           (equal prefix-byte-group-code 4)))
    (page-structure-marking-mode x86)
    (not (programmer-level-mode x86))
    (canonical-address-p start-rip)
    (disjoint-p
     (mv-nth 1 (las-to-pas
                (create-canonical-address-list cnt start-rip)
                :x (cpl x86) (double-rewrite x86)))
     (open-qword-paddr-list
      (gather-all-paging-structure-qword-addresses x86)))
    (not
     (mv-nth
      0
      (las-to-pas (create-canonical-address-list cnt start-rip)
                  :x (cpl x86)
                  x86))))
   (equal (get-prefixes-alt start-rip prefixes cnt x86)
          (get-prefixes-alt (+ 1 start-rip)
                            (!prefixes-slice :group-4-prefix
                                             (mv-nth 1 (rm08 start-rip :x x86))
                                             prefixes)
                            (+ -1 cnt)
                            (mv-nth 2 (rm08 start-rip :x x86)))))
  :hints (("Goal"
           :do-not-induct t
           :use ((:instance get-prefixes-opener-lemma-group-4-prefix-in-marking-mode)
                 (:instance rewrite-get-prefixes-to-get-prefixes-alt)
                 (:instance rewrite-get-prefixes-to-get-prefixes-alt
                            (start-rip (1+ start-rip))
                            (prefixes (!prefixes-slice :group-4-prefix
                                                       (mv-nth 1 (rm08 start-rip :x x86))
                                                       prefixes))
                            (cnt (1- cnt))
                            (x86 (mv-nth 2 (rm08 start-rip :x x86)))))
           :in-theory (e/d* (las-to-pas)
                            (get-prefixes-opener-lemma-group-4-prefix-in-marking-mode
                             rewrite-get-prefixes-to-get-prefixes-alt
                             acl2::ash-0
                             acl2::zip-open
                             byte-listp
                             unsigned-byte-p-of-logior
                             negative-logand-to-positive-logand-with-integerp-x
                             force (force))))))

(defthm xlate-equiv-memory-and-two-mv-nth-0-get-prefixes-alt-cong
  (implies
   (xlate-equiv-memory x86-1 x86-2)
   (equal (mv-nth 0 (get-prefixes-alt start-rip prefixes cnt x86-1))
          (mv-nth 0 (get-prefixes-alt start-rip prefixes cnt x86-2))))
  :hints (("Goal"
           :use ((:instance xlate-equiv-memory-and-two-get-prefixes-values))
           :in-theory (e/d* (get-prefixes-alt las-to-pas)
                            (rewrite-get-prefixes-to-get-prefixes-alt
                             xlate-equiv-memory-and-two-get-prefixes-values))))
  :rule-classes :congruence)

(defthm xlate-equiv-memory-and-two-mv-nth-1-get-prefixes-alt-cong
  (implies
   (xlate-equiv-memory x86-1 x86-2)
   (equal (mv-nth 1 (get-prefixes-alt start-rip prefixes cnt x86-1))
          (mv-nth 1 (get-prefixes-alt start-rip prefixes cnt x86-2))))
  :hints (("Goal"
           :use ((:instance xlate-equiv-memory-and-two-get-prefixes-values))
           :in-theory (e/d* (get-prefixes-alt las-to-pas)
                            (rewrite-get-prefixes-to-get-prefixes-alt
                             xlate-equiv-memory-and-two-get-prefixes-values))))
  :rule-classes :congruence)

(defthm xlate-equiv-memory-and-two-mv-nth-2-get-prefixes-alt-cong
  (implies (xlate-equiv-memory x86-1 x86-2)
           (xlate-equiv-memory (mv-nth 2 (get-prefixes-alt start-rip prefixes cnt x86-1))
                               (mv-nth 2 (get-prefixes-alt start-rip prefixes cnt x86-2))))
  :hints (("Goal"
           :use ((:instance xlate-equiv-memory-and-two-mv-nth-2-get-prefixes))
           :in-theory (e/d* (get-prefixes-alt)
                            (xlate-equiv-memory-and-mv-nth-2-get-prefixes
                             rewrite-get-prefixes-to-get-prefixes-alt))))
  :rule-classes :congruence)

(defthm xlate-equiv-memory-and-mv-nth-2-get-prefixes-alt
  ;; Why do I need both the versions?
  (and
   ;; Matt "thinks" that this one here is a rewrite rule which hangs
   ;; on iff and whose RHS is T.
   (xlate-equiv-memory x86 (mv-nth 2 (get-prefixes-alt start-rip prefixes cnt x86)))
   ;; Matt "thinks" that this one is a driver rule whose RHS is
   ;; (double-rewrite x86).
   (xlate-equiv-memory (mv-nth 2 (get-prefixes-alt start-rip prefixes cnt x86))
                       (double-rewrite x86)))
  :hints (("Goal"
           :in-theory (e/d* (get-prefixes-alt)
                            (rewrite-get-prefixes-to-get-prefixes-alt
                             force (force))))))

;; ======================================================================

;; rb and xlate-equiv-memory:

(defthm mv-nth-0-rb-and-xlate-equiv-memory-cong
  (implies (xlate-equiv-memory x86-1 x86-2)
           (equal (mv-nth 0 (rb l-addrs r-w-x x86-1))
                  (mv-nth 0 (rb l-addrs r-w-x x86-2))))
  :hints (("Goal" :in-theory (e/d* (rb) (force (force)))))
  :rule-classes :congruence)

(defthm read-from-physical-memory-and-xlate-equiv-memory-disjoint-from-paging-structures
  (implies (and (bind-free
                 (find-an-xlate-equiv-x86
                  'read-from-physical-memory-and-xlate-equiv-memory
                  x86-1 'x86-2 mfc state)
                 (x86-2))
                (syntaxp (and (not (eq x86-2 x86-1))
                              ;; x86-2 must be smaller than x86-1.
                              (term-order x86-2 x86-1)))
                (xlate-equiv-memory (double-rewrite x86-1) x86-2)
                (disjoint-p (all-translation-governing-addresses l-addrs (double-rewrite x86-1))
                            (mv-nth 1 (las-to-pas l-addrs r-w-x cpl (double-rewrite x86-1))))
                (disjoint-p (mv-nth 1 (las-to-pas l-addrs r-w-x cpl (double-rewrite x86-1)))
                            (open-qword-paddr-list
                             (gather-all-paging-structure-qword-addresses (double-rewrite x86-1))))
                (canonical-address-listp l-addrs))
           (equal (read-from-physical-memory (mv-nth 1 (las-to-pas l-addrs r-w-x cpl x86-1)) x86-1)
                  (read-from-physical-memory (mv-nth 1 (las-to-pas l-addrs r-w-x cpl x86-1)) x86-2)))
  :hints (("Goal"
           :induct (las-to-pas l-addrs r-w-x cpl x86-1)
           :in-theory (e/d* (las-to-pas
                             disjoint-p
                             xlate-equiv-memory)
                            (disjointness-of-all-translation-governing-addresses-from-all-translation-governing-addresses-subset-p
                             disjointness-of-las-to-pas-from-las-to-pas-subset-p
                             disjoint-p-of-open-qword-paddr-list-and-remove-duplicates-equal
                             not-disjoint-p-of-open-qword-paddr-list-and-remove-duplicates-equal
                             member-p-of-open-qword-paddr-list-and-remove-duplicates-equal
                             not-member-p-of-open-qword-paddr-list-and-remove-duplicates-equal
                             xlate-equiv-memory-and-xr-mem-from-rest-of-memory)))))

(local
 (defthm xlate-equiv-memory-in-programmer-level-mode-implies-equal-states
   (implies (and (xlate-equiv-memory x86-1 x86-2)
                 (programmer-level-mode x86-1))
            (equal x86-1 x86-2))
   :hints (("Goal" :in-theory (e/d* (xlate-equiv-memory) ())))
   :rule-classes nil))

(defthm mv-nth-1-rb-and-xlate-equiv-memory-disjoint-from-paging-structures
  (implies (and (bind-free
                 (find-an-xlate-equiv-x86
                  'mv-nth-1-rb-and-xlate-equiv-memory
                  x86-1 'x86-2 mfc state)
                 (x86-2))
                (syntaxp (and
                          (not (eq x86-2 x86-1))
                          ;; x86-2 must be smaller than x86-1.
                          (term-order x86-2 x86-1)))
                (xlate-equiv-memory (double-rewrite x86-1) x86-2)
                (disjoint-p (all-translation-governing-addresses l-addrs (double-rewrite x86-1))
                            (mv-nth 1 (las-to-pas l-addrs r-w-x (cpl x86-1) (double-rewrite x86-1))))
                (disjoint-p (mv-nth 1 (las-to-pas l-addrs r-w-x (cpl x86-1) (double-rewrite x86-1)))
                            (open-qword-paddr-list
                             (gather-all-paging-structure-qword-addresses (double-rewrite x86-1))))
                (canonical-address-listp l-addrs))
           (equal (mv-nth 1 (rb l-addrs r-w-x x86-1))
                  (mv-nth 1 (rb l-addrs r-w-x x86-2))))
  :hints (("Goal"
           :do-not-induct t
           :use ((:instance xlate-equiv-memory-in-programmer-level-mode-implies-equal-states)
                 (:instance read-from-physical-memory-and-xlate-equiv-memory-disjoint-from-paging-structures
                            (cpl (cpl x86-1))))
           :in-theory (e/d* (rb)
                            (read-from-physical-memory-and-xlate-equiv-memory-disjoint-from-paging-structures
                             disjoint-p-of-open-qword-paddr-list-and-remove-duplicates-equal
                             not-disjoint-p-of-open-qword-paddr-list-and-remove-duplicates-equal
                             member-p-of-open-qword-paddr-list-and-remove-duplicates-equal
                             not-member-p-of-open-qword-paddr-list-and-remove-duplicates-equal
                             force (force))))))

(defthm mv-nth-2-rb-and-xlate-equiv-memory
  (implies (and (page-structure-marking-mode (double-rewrite x86))
                (not (mv-nth 0 (las-to-pas l-addrs r-w-x (cpl x86) (double-rewrite x86))))
                (not (programmer-level-mode (double-rewrite x86))))
           (xlate-equiv-memory (mv-nth 2 (rb l-addrs r-w-x x86))
                               (double-rewrite x86)))
  :hints (("Goal" :in-theory (e/d* () (force (force))))))

(defthmd xlate-equiv-memory-and-two-mv-nth-2-rb
  (implies (and (xlate-equiv-memory x86-1 x86-2)
                (page-structure-marking-mode x86-1)
                (not (programmer-level-mode x86-1))
                (not (mv-nth 0 (las-to-pas l-addrs r-w-x (cpl x86-1) (double-rewrite x86-1)))))
           (xlate-equiv-memory (mv-nth 2 (rb l-addrs r-w-x x86-1))
                               (mv-nth 2 (rb l-addrs r-w-x x86-2))))
  :hints (("Goal" :in-theory (e/d* () (mv-nth-2-rb-and-xlate-equiv-memory))
           :use ((:instance mv-nth-2-rb-and-xlate-equiv-memory (x86 x86-1))
                 (:instance mv-nth-2-rb-and-xlate-equiv-memory (x86 x86-2))))))

;; ----------------------------------------------------------------------

;; Rewriting rb to rb-alt:

;; The biggest drawback of this approach is that all the nice theorems
;; I have about rb (in marking-mode-utils.lisp) have to be re-proved
;; in terms of rb-alt.

;; rb-alt is defined basically to read the program bytes from the
;; memory. I don't intend to use it to read paging data structures.

(define rb-alt ((l-addrs canonical-address-listp)
                (r-w-x :type (member :r :w :x))
                (x86))
  :non-executable t
  (if (and (page-structure-marking-mode x86)
           (not (programmer-level-mode x86))
           (canonical-address-listp l-addrs)
           (not (mv-nth 0 (las-to-pas l-addrs r-w-x (cpl x86) x86)))
           (disjoint-p (all-translation-governing-addresses l-addrs x86)
                       (mv-nth 1 (las-to-pas l-addrs r-w-x (cpl x86) x86)))
           (disjoint-p (mv-nth 1 (las-to-pas l-addrs r-w-x (cpl x86) x86))
                       (open-qword-paddr-list
                        (gather-all-paging-structure-qword-addresses x86))))

      (rb l-addrs r-w-x x86)

    (mv nil nil x86))

  ///

  (defthm rb-alt-returns-byte-listp
    (implies (x86p x86)
             (byte-listp (mv-nth 1 (rb-alt addresses r-w-x x86))))
    :rule-classes (:rewrite :type-prescription))

  (defthm rb-alt-returns-x86p
    (implies (x86p x86)
             (x86p (mv-nth 2 (rb-alt l-addrs r-w-x x86)))))

  (defthm rb-alt-nil-lemma
    (equal (mv-nth 1 (rb-alt nil r-w-x x86))
           nil)
    :hints (("Goal"
             :cases ((and (page-structure-marking-mode x86)
                          (not (programmer-level-mode x86))
                          (not (mv-nth 0 (las-to-pas nil r-w-x (cpl x86) x86)))))
             :in-theory (e/d* () (force (force))))))

  (defthm xr-rb-alt-state-in-system-level-mode
    (implies (and (not (equal fld :mem))
                  (not (equal fld :fault)))
             (equal (xr fld index (mv-nth 2 (rb-alt addr r-w-x x86)))
                    (xr fld index x86)))
    :hints (("Goal" :in-theory (e/d* () (force (force))))))

  (defthm mv-nth-0-rb-alt-is-nil
    (equal (mv-nth 0 (rb-alt l-addrs r-w-x x86)) nil)
    :hints (("Goal"
             :use ((:instance mv-nth-0-rb-and-mv-nth-0-las-to-pas-in-system-level-mode))
             :in-theory (e/d* ()
                              (mv-nth-0-rb-and-mv-nth-0-las-to-pas-in-system-level-mode
                               force (force)))))))

;; Rewrite rb to rb-alt:

(defthm rewrite-rb-to-rb-alt
  (implies (forced-and
            (disjoint-p (all-translation-governing-addresses l-addrs x86)
                        (mv-nth 1 (las-to-pas l-addrs r-w-x (cpl x86) x86)))
            (disjoint-p (mv-nth 1 (las-to-pas l-addrs r-w-x (cpl x86) x86))
                        (open-qword-paddr-list
                         (gather-all-paging-structure-qword-addresses x86)))
            (not (mv-nth 0 (las-to-pas l-addrs r-w-x (cpl x86) x86)))
            (canonical-address-listp l-addrs)
            (page-structure-marking-mode x86)
            (not (programmer-level-mode x86)))
           (equal (rb l-addrs r-w-x x86)
                  (rb-alt l-addrs r-w-x x86)))
  :hints (("Goal" :in-theory (e/d* (rb-alt) ()))))

;; rb-alt and xlate-equiv-memory:

(defthm mv-nth-0-rb-alt-and-xlate-equiv-memory-cong
  (implies (xlate-equiv-memory x86-1 x86-2)
           (equal (mv-nth 0 (rb-alt l-addrs r-w-x x86-1))
                  (mv-nth 0 (rb-alt l-addrs r-w-x x86-2))))
  :hints (("Goal" :in-theory (e/d* (rb-alt) (rewrite-rb-to-rb-alt force (force)))))
  :rule-classes :congruence)

(defthm mv-nth-1-rb-alt-and-xlate-equiv-memory-cong
  (implies (xlate-equiv-memory x86-1 x86-2)
           (equal (mv-nth 1 (rb-alt l-addrs r-w-x x86-1))
                  (mv-nth 1 (rb-alt l-addrs r-w-x x86-2))))
  :hints (("Goal"
           :do-not-induct t
           :use ((:instance mv-nth-1-rb-and-xlate-equiv-memory-disjoint-from-paging-structures))
           :in-theory (e/d* (rb-alt)
                            (mv-nth-1-rb-and-xlate-equiv-memory-disjoint-from-paging-structures
                             rewrite-rb-to-rb-alt
                             disjoint-p-of-open-qword-paddr-list-and-remove-duplicates-equal
                             not-disjoint-p-of-open-qword-paddr-list-and-remove-duplicates-equal
                             member-p-of-open-qword-paddr-list-and-remove-duplicates-equal
                             not-member-p-of-open-qword-paddr-list-and-remove-duplicates-equal
                             rewrite-rb-to-rb-alt
                             force (force)))))
  :rule-classes :congruence)

;; (defthm mv-nth-1-rb-alt-and-xlate-equiv-memory-disjoint-from-paging-structures
;;   (implies (and
;;             (bind-free
;;              (find-an-xlate-equiv-x86
;;               'mv-nth-1-rb-alt-and-xlate-equiv-memory-disjoint-from-paging-structures
;;               x86-1 'x86-2
;;               mfc state)
;;              (x86-2))
;;             (syntaxp (and (not (eq x86-2 x86-1))
;;                           (term-order x86-2 x86-1)))
;;             (xlate-equiv-memory (double-rewrite x86-1)
;;                                 x86-2)
;;             (disjoint-p
;;              (all-translation-governing-addresses l-addrs (double-rewrite x86-1))
;;              (mv-nth 1 (las-to-pas l-addrs r-w-x (cpl x86-1) (double-rewrite x86-1))))
;;             (disjoint-p
;;              (mv-nth 1 (las-to-pas l-addrs r-w-x (cpl x86-1) (double-rewrite x86-1)))
;;              (open-qword-paddr-list
;;               (gather-all-paging-structure-qword-addresses (double-rewrite x86-1))))
;;             (canonical-address-listp l-addrs))
;;            (equal (mv-nth 1 (rb-alt l-addrs r-w-x x86-1))
;;                   (mv-nth 1 (rb-alt l-addrs r-w-x x86-2))))
;;   :hints (("Goal"
;;            :do-not-induct t
;;            :use ((:instance mv-nth-1-rb-and-xlate-equiv-memory-disjoint-from-paging-structures))
;;            :in-theory (e/d* (rb-alt)
;;                             (mv-nth-1-rb-and-xlate-equiv-memory-disjoint-from-paging-structures
;;                              rewrite-rb-to-rb-alt
;;                              disjoint-p-of-open-qword-paddr-list-and-remove-duplicates-equal
;;                              not-disjoint-p-of-open-qword-paddr-list-and-remove-duplicates-equal
;;                              member-p-of-open-qword-paddr-list-and-remove-duplicates-equal
;;                              not-member-p-of-open-qword-paddr-list-and-remove-duplicates-equal
;;                              rewrite-rb-to-rb-alt
;;                              force (force))))))

(defthm mv-nth-2-rb-alt-and-xlate-equiv-memory
  (and (xlate-equiv-memory (mv-nth 2 (rb-alt l-addrs r-w-x x86)) (double-rewrite x86))
       (xlate-equiv-memory x86 (mv-nth 2 (rb-alt l-addrs r-w-x x86))))
  :hints (("Goal" :in-theory (e/d* (rb-alt) (rewrite-rb-to-rb-alt force (force))))))

(defthm xlate-equiv-memory-and-two-mv-nth-2-rb-alt-cong
  (implies (xlate-equiv-memory x86-1 x86-2)
           (xlate-equiv-memory (mv-nth 2 (rb-alt l-addrs r-w-x x86-1))
                               (mv-nth 2 (rb-alt l-addrs r-w-x x86-2))))
  :hints (("Goal" :in-theory (e/d* (rb-alt) (rewrite-rb-to-rb-alt))
           :use ((:instance xlate-equiv-memory-and-two-mv-nth-2-rb))))
  :rule-classes :congruence)

;; Lemmas about rb-alt that will help in symbolic simulation:

(defthm rb-alt-in-terms-of-nth-and-pos-in-system-level-mode
  (implies (and (bind-free (find-info-from-program-at-term
                            'rb-alt-in-terms-of-nth-and-pos-in-system-level-mode
                            mfc state)
                           (n prog-addr bytes))
                (program-at (create-canonical-address-list n prog-addr)
                            bytes x86)
                (syntaxp (quotep n))
                (member-p lin-addr (create-canonical-address-list n prog-addr))
                (disjoint-p
                 (all-translation-governing-addresses
                  (create-canonical-address-list n prog-addr)
                  (double-rewrite x86))
                 (mv-nth 1
                         (las-to-pas
                          (create-canonical-address-list n prog-addr) :x (cpl x86)
                          (double-rewrite x86))))
                (not (mv-nth 0
                             (las-to-pas (create-canonical-address-list n prog-addr)
                                         :x (cpl x86)
                                         (double-rewrite x86))))
                (disjoint-p
                 (mv-nth 1
                         (las-to-pas (create-canonical-address-list n prog-addr)
                                     :x (cpl x86)
                                     (double-rewrite x86)))
                 (open-qword-paddr-list
                  (gather-all-paging-structure-qword-addresses (double-rewrite x86))))
                (page-structure-marking-mode x86)
                (x86p x86))
           (equal (car (mv-nth 1 (rb-alt (list lin-addr) :x x86)))
                  (nth (pos lin-addr (create-canonical-address-list n prog-addr)) bytes)))
  :hints (("Goal"
           :do-not-induct t
           :in-theory (e/d (las-to-pas
                            subset-p
                            disjoint-p)
                           (acl2::mv-nth-cons-meta
                            member-p-of-remove-duplicates-equal
                            disjoint-p-of-remove-duplicates-equal
                            acl2::remove-duplicates-equal-under-set-equiv
                            rb-in-terms-of-nth-and-pos-in-system-level-mode
                            disjoint-p-of-open-qword-paddr-list-and-remove-duplicates-equal
                            rewrite-rb-to-rb-alt
                            disjointness-of-all-translation-governing-addresses-from-all-translation-governing-addresses-subset-p))
           :use ((:instance rewrite-rb-to-rb-alt
                            (l-addrs (list lin-addr))
                            (r-w-x :x))
                 (:instance rb-in-terms-of-nth-and-pos-in-system-level-mode)))))

(defthm rb-alt-in-terms-of-rb-alt-subset-p-in-system-level-mode
  (implies
   (and
    (bind-free (find-info-from-program-at-term
                'rb-alt-in-terms-of-rb-alt-subset-p-in-system-level-mode
                mfc state)
               (n prog-addr bytes))
    (program-at (create-canonical-address-list n prog-addr) bytes x86)
    (subset-p l-addrs (create-canonical-address-list n prog-addr))
    (disjoint-p
     (all-translation-governing-addresses
      (create-canonical-address-list n prog-addr)
      (double-rewrite x86))
     (mv-nth 1 (las-to-pas
                (create-canonical-address-list n prog-addr)
                :x (cpl x86) (double-rewrite x86))))
    (syntaxp (quotep n))
    (consp l-addrs)
    (not (mv-nth 0
                 (las-to-pas (create-canonical-address-list n prog-addr)
                             :x (cpl x86) (double-rewrite x86))))
    (disjoint-p
     (mv-nth 1
             (las-to-pas (create-canonical-address-list n prog-addr)
                         :x (cpl x86) (double-rewrite x86)))
     (open-qword-paddr-list
      (gather-all-paging-structure-qword-addresses (double-rewrite x86))))
    (page-structure-marking-mode x86)
    (x86p x86))
   (equal (mv-nth 1 (rb-alt l-addrs :x x86))
          (append (list (nth (pos
                              (car l-addrs)
                              (create-canonical-address-list n prog-addr))
                             bytes))
                  (mv-nth 1 (rb-alt (cdr l-addrs) :x x86)))))
  :hints (("Goal"
           :do-not-induct t
           :in-theory (e/d (las-to-pas
                            subset-p
                            disjoint-p)
                           (rb-in-terms-of-rb-subset-p-in-system-level-mode
                            rewrite-rb-to-rb-alt
                            acl2::mv-nth-cons-meta
                            member-p-of-remove-duplicates-equal
                            disjoint-p-of-remove-duplicates-equal
                            acl2::remove-duplicates-equal-under-set-equiv
                            disjoint-p-of-open-qword-paddr-list-and-remove-duplicates-equal
                            disjointness-of-all-translation-governing-addresses-from-all-translation-governing-addresses-subset-p))
           :use ((:instance rb-in-terms-of-rb-subset-p-in-system-level-mode)
                 (:instance rewrite-rb-to-rb-alt
                            (r-w-x :x))
                 (:instance rewrite-rb-to-rb-alt
                            (l-addrs (cdr l-addrs))
                            (r-w-x :x))))))

(defthm combine-bytes-rb-alt-in-terms-of-rb-alt-subset-p-in-system-level-mode
  (implies
   (and
    (bind-free (find-info-from-program-at-term
                'combine-bytes-rb-alt-in-terms-of-rb-alt-subset-p-in-system-level-mode
                mfc state)
               (n prog-addr bytes))
    (program-at (create-canonical-address-list n prog-addr) bytes x86)
    (subset-p l-addrs (create-canonical-address-list n prog-addr))
    (disjoint-p
     (all-translation-governing-addresses
      (create-canonical-address-list n prog-addr)
      (double-rewrite x86))
     (mv-nth 1 (las-to-pas
                (create-canonical-address-list n prog-addr)
                :x (cpl x86) (double-rewrite x86))))
    (syntaxp (quotep n))
    (consp l-addrs)
    (not (mv-nth 0
                 (las-to-pas (create-canonical-address-list n prog-addr)
                             :x (cpl x86) (double-rewrite x86))))
    (disjoint-p
     (mv-nth 1
             (las-to-pas (create-canonical-address-list n prog-addr)
                         :x (cpl x86) (double-rewrite x86)))
     (open-qword-paddr-list
      (gather-all-paging-structure-qword-addresses (double-rewrite x86))))
    (page-structure-marking-mode x86)
    (x86p x86))
   (equal (combine-bytes (mv-nth 1 (rb-alt l-addrs :x x86)))
          (combine-bytes
           (append (list (nth (pos
                               (car l-addrs)
                               (create-canonical-address-list n prog-addr))
                              bytes))
                   (mv-nth 1 (rb-alt (cdr l-addrs) :x x86))))))
  :hints (("Goal" :in-theory (union-theories
                              '()
                              (theory 'minimal-theory))
           :use ((:instance rb-alt-in-terms-of-rb-alt-subset-p-in-system-level-mode)))))

(defthm rb-alt-wb-disjoint-in-system-level-mode
  (implies (and
            (disjoint-p
             ;; The physical addresses pertaining to the read
             ;; operation are disjoint from those pertaining to the
             ;; write operation.
             (mv-nth 1 (las-to-pas l-addrs r-w-x (cpl x86) (double-rewrite x86)))
             (mv-nth 1 (las-to-pas (strip-cars addr-lst) :w (cpl x86) (double-rewrite x86))))
            (disjoint-p
             ;; The physical addresses corresponding to the read are
             ;; disjoint from the translation-governing-addresses
             ;; pertaining to the write.
             (mv-nth 1 (las-to-pas l-addrs r-w-x (cpl x86) (double-rewrite x86)))
             (all-translation-governing-addresses (strip-cars addr-lst) (double-rewrite x86)))
            (disjoint-p
             ;; The physical addresses pertaining to the read are
             ;; disjoint from the translation-governing-addresses
             ;; pertaining to the read.
             (mv-nth 1 (las-to-pas l-addrs r-w-x (cpl x86) (double-rewrite x86)))
             (all-translation-governing-addresses l-addrs (double-rewrite x86)))
            (disjoint-p
             ;; The physical addresses pertaining to the write are
             ;; disjoint from the translation-governing-addresses
             ;; pertaining to the read.
             (mv-nth 1 (las-to-pas (strip-cars addr-lst) :w (cpl x86) (double-rewrite x86)))
             (all-translation-governing-addresses l-addrs (double-rewrite x86)))
            (disjoint-p
             ;; The physical addresses pertaining to the read are
             ;; disjoint from the physical addresses of the paging
             ;; structures.
             (mv-nth 1 (las-to-pas l-addrs r-w-x (cpl x86) (double-rewrite x86)))
             (open-qword-paddr-list
              (gather-all-paging-structure-qword-addresses (double-rewrite x86))))
            (disjoint-p
             ;; The physical addresses pertaining to the write are
             ;; disjoint from the physical addresses of the paging
             ;; structures.
             (mv-nth 1 (las-to-pas (strip-cars addr-lst) :w (cpl x86) (double-rewrite x86)))
             (open-qword-paddr-list
              (gather-all-paging-structure-qword-addresses (double-rewrite x86))))

            ;; The following hyp needs to go away. See WB expression
            ;; in the x86 slot of
            ;; GATHER-ALL-PAGING-STRUCTURE-QWORD-ADDRESSES.
            (DISJOINT-P
             (OPEN-QWORD-PADDR-LIST (GATHER-ALL-PAGING-STRUCTURE-QWORD-ADDRESSES
                                     (MV-NTH 1 (WB ADDR-LST X86))))
             (MV-NTH 1
                     (LAS-TO-PAS L-ADDRS R-W-X
                                 (LOGHEAD 2 (XR :SEG-VISIBLE 1 X86))
                                 (MV-NTH 1 (WB ADDR-LST X86)))))
            ;; I need the following hypothesis for relieving the hyps
            ;; of
            ;; all-translation-governing-addresses-and-mv-nth-1-wb-disjoint. Fix
            ;; that rule if you want to look into removing this hyp
            ;; below.
            (disjoint-p (all-translation-governing-addresses l-addrs x86)
                        (all-translation-governing-addresses (strip-cars addr-lst) x86))
            (not (mv-nth 0 (las-to-pas l-addrs r-w-x (cpl x86) x86)))
            (canonical-address-listp l-addrs)
            (addr-byte-alistp addr-lst)
            (page-structure-marking-mode x86)
            (not (programmer-level-mode x86))
            (x86p x86))
           (and
            (equal (mv-nth 0 (rb-alt l-addrs r-w-x (mv-nth 1 (wb addr-lst x86))))
                   (mv-nth 0 (rb-alt l-addrs r-w-x x86)))
            (equal (mv-nth 1 (rb-alt l-addrs r-w-x (mv-nth 1 (wb addr-lst x86))))
                   (mv-nth 1 (rb-alt l-addrs r-w-x x86)))))
  :hints (("Goal" :do-not-induct t
           :use ((:instance rewrite-rb-to-rb-alt
                            (x86 (mv-nth 1 (wb addr-lst x86))))
                 (:instance rewrite-rb-to-rb-alt)
                 (:instance rb-wb-disjoint-in-system-level-mode))
           :in-theory (e/d* (disjoint-p-commutative)
                            (rewrite-rb-to-rb-alt
                             rb-wb-disjoint-in-system-level-mode
                             disjointness-of-all-translation-governing-addresses-from-all-translation-governing-addresses-subset-p
                             disjointness-of-las-to-pas-from-las-to-pas-subset-p)))))

;; (defthmd rb-alt-wb-equal-in-system-level-mode
;;   (implies (and (equal
;;                  ;; The physical addresses pertaining to the read
;;                  ;; operation are equal to those pertaining to the
;;                  ;; write operation.
;;                  (mv-nth 1 (las-to-pas l-addrs r-w-x (cpl x86) (double-rewrite x86)))
;;                  (mv-nth 1 (las-to-pas (strip-cars addr-lst) :w (cpl x86) (double-rewrite x86))))
;;                 (disjoint-p
;;                  ;; The physical addresses pertaining to the write are
;;                  ;; disjoint from the translation-governing-addresses
;;                  ;; pertaining to the read.
;;                  (mv-nth 1 (las-to-pas (strip-cars addr-lst) :w (cpl x86) (double-rewrite x86)))
;;                  (all-translation-governing-addresses l-addrs (double-rewrite x86)))
;;                 ;; The following hyp comes from
;;                 ;; LA-TO-PAS-VALUES-AND-MV-NTH-1-WB-DISJOINT-FROM-XLATION-GOV-ADDRS.
;;                 (disjoint-p
;;                  (all-translation-governing-addresses l-addrs (double-rewrite x86))
;;                  (all-translation-governing-addresses (strip-cars addr-lst) (double-rewrite x86)))

;;                 (no-duplicates-p
;;                  (mv-nth 1 (las-to-pas (strip-cars addr-lst) :w (cpl x86) x86)))
;;                 (not (mv-nth 0 (las-to-pas l-addrs r-w-x (cpl x86) x86)))
;;                 (not (mv-nth 0 (las-to-pas (strip-cars addr-lst) :w (cpl x86) x86)))
;;                 (canonical-address-listp l-addrs)
;;                 (addr-byte-alistp addr-lst)
;;                 (page-structure-marking-mode x86)
;;                 (not (programmer-level-mode x86))
;;                 (x86p x86))
;;            (equal (mv-nth 1 (rb-alt l-addrs r-w-x (mv-nth 1 (wb addr-lst x86))))
;;                   (strip-cdrs addr-lst)))
;;   :hints (("Goal" :do-not-induct t
;;            :in-theory (e/d* (las-to-pas
;;                              disjoint-p-commutative)
;;                             (rewrite-rb-to-rb-alt
;;                              disjointness-of-all-translation-governing-addresses-from-all-translation-governing-addresses-subset-p
;;                              disjointness-of-las-to-pas-from-las-to-pas-subset-p
;;                              force (force)))
;;            :use ((:instance rewrite-rb-to-rb-alt
;;                             (x86 (mv-nth 1 (wb addr-lst x86))))
;;                  (:instance rb-wb-equal-in-system-level-mode)))))

;; ======================================================================

;; program-at and xlate-equiv-memory:

(define program-at-alt ((l-addrs canonical-address-listp)
                        (bytes byte-listp)
                        (x86))
  :non-executable t
  (if (and (page-structure-marking-mode x86)
           (not (programmer-level-mode x86))
           (canonical-address-listp l-addrs)
           (not (mv-nth 0 (las-to-pas l-addrs :x (cpl x86) x86)))
           (disjoint-p (all-translation-governing-addresses l-addrs x86)
                       (mv-nth 1 (las-to-pas l-addrs :x (cpl x86) x86)))
           (disjoint-p (mv-nth 1 (las-to-pas l-addrs :x (cpl x86) x86))
                       (open-qword-paddr-list
                        (gather-all-paging-structure-qword-addresses x86))))

      (program-at l-addrs bytes x86)

    nil))

;; Rewrite program-at to program-at-alt:

(defthm rewrite-program-at-to-program-at-alt
  (implies (forced-and
            (disjoint-p (all-translation-governing-addresses l-addrs x86)
                        (mv-nth 1 (las-to-pas l-addrs :x (cpl x86) x86)))
            (disjoint-p (mv-nth 1 (las-to-pas l-addrs :x (cpl x86) x86))
                        (open-qword-paddr-list
                         (gather-all-paging-structure-qword-addresses x86)))
            (not (mv-nth 0 (las-to-pas l-addrs :x (cpl x86) x86)))
            (canonical-address-listp l-addrs)
            (page-structure-marking-mode x86)
            (not (programmer-level-mode x86)))
           (equal (program-at l-addrs bytes x86)
                  (program-at-alt l-addrs bytes x86)))
  :hints (("Goal" :in-theory (e/d* (program-at-alt) ()))))

(defthm program-at-alt-and-xlate-equiv-memory-cong
  (implies (xlate-equiv-memory x86-1 x86-2)
           (equal (program-at-alt l-addrs bytes x86-1)
                  (program-at-alt l-addrs bytes x86-2)))
  :hints (("Goal"
           :do-not-induct t
           :use ((:instance mv-nth-1-rb-and-xlate-equiv-memory-disjoint-from-paging-structures
                            (r-w-x :x)))
           :in-theory (e/d* (program-at-alt
                             program-at)
                            (rewrite-program-at-to-program-at-alt
                             mv-nth-1-rb-and-xlate-equiv-memory-disjoint-from-paging-structures
                             disjoint-p-of-open-qword-paddr-list-and-remove-duplicates-equal
                             not-disjoint-p-of-open-qword-paddr-list-and-remove-duplicates-equal
                             member-p-of-open-qword-paddr-list-and-remove-duplicates-equal
                             not-member-p-of-open-qword-paddr-list-and-remove-duplicates-equal
                             force (force)))))
  :rule-classes :congruence)

;; (defthm program-at-and-xlate-equiv-memory-disjoint-from-paging-structures
;;   (implies (and (bind-free
;;                  (find-an-xlate-equiv-x86
;;                   'program-at-and-xlate-equiv-memory-disjoint-from-paging-structures
;;                   x86-1 'x86-2 mfc state)
;;                  (x86-2))
;;                 (syntaxp (and
;;                           (not (eq x86-2 x86-1))
;;                           ;; x86-2 must be smaller than x86-1.
;;                           (term-order x86-2 x86-1)))
;;                 (xlate-equiv-memory (double-rewrite x86-1) x86-2)
;;                 (disjoint-p (all-translation-governing-addresses l-addrs (double-rewrite x86-1))
;;                             (mv-nth 1 (las-to-pas l-addrs :x (cpl x86-1) (double-rewrite x86-1))))
;;                 (disjoint-p (mv-nth 1 (las-to-pas l-addrs :x (cpl x86-1) (double-rewrite x86-1)))
;;                             (open-qword-paddr-list
;;                              (gather-all-paging-structure-qword-addresses (double-rewrite x86-1))))
;;                 (canonical-address-listp l-addrs))
;;            (equal (program-at l-addrs bytes x86-1)
;;                   (program-at l-addrs bytes x86-2)))
;;   :hints (("Goal"
;;            :do-not-induct t
;;            :use ((:instance mv-nth-1-rb-and-xlate-equiv-memory-disjoint-from-paging-structures
;;                             (r-w-x :x)))
;;            :in-theory (e/d* (program-at)
;;                             (mv-nth-1-rb-and-xlate-equiv-memory-disjoint-from-paging-structures
;;                              disjoint-p-of-open-qword-paddr-list-and-remove-duplicates-equal
;;                              not-disjoint-p-of-open-qword-paddr-list-and-remove-duplicates-equal
;;                              member-p-of-open-qword-paddr-list-and-remove-duplicates-equal
;;                              not-member-p-of-open-qword-paddr-list-and-remove-duplicates-equal
;;                              force (force))))))

;; ======================================================================

;; Step function opener lemma:

;; (defthm x86-fetch-decode-execute-opener-in-marking-mode
;;   (b* ((start-rip (rip x86))

;;        ((mv flg-get-prefixes prefixes x86-1)
;;         (get-prefixes start-rip 0 5 x86))

;;        (opcode/rex/escape-byte (prefixes-slice :next-byte prefixes))
;;        (prefix-length (prefixes-slice :num-prefixes prefixes))
;;        (temp-rip0 (if (equal prefix-length 0)
;;                       (+ 1 start-rip)
;;                     (+ prefix-length start-rip 1)))
;;        (rex-byte (if (equal (ash opcode/rex/escape-byte -4) 4)
;;                      opcode/rex/escape-byte
;;                    0))

;;        ((mv flg-opcode/escape-byte opcode/escape-byte x86-2)
;;         (if (equal rex-byte 0)
;;             (mv nil opcode/rex/escape-byte x86-1)
;;           (rm08 temp-rip0 :x (double-rewrite x86-1))))

;;        (temp-rip1 (if (equal rex-byte 0) temp-rip0 (1+ temp-rip0)))
;;        (modr/m? (x86-one-byte-opcode-modr/m-p opcode/escape-byte))

;;        ((mv flg-modr/m modr/m x86-3)
;;         (if modr/m?
;;             (rm08 temp-rip1 :x (double-rewrite x86-2))
;;           (mv nil 0 x86-2)))

;;        (temp-rip2 (if modr/m? (1+ temp-rip1) temp-rip1))
;;        (sib? (and modr/m? (x86-decode-sib-p modr/m)))

;;        ((mv flg-sib sib x86-4)
;;         (if sib?
;;             (rm08 temp-rip2 :x (double-rewrite x86-3))
;;           (mv nil 0 x86-3)))

;;        (temp-rip3 (if sib? (1+ temp-rip2) temp-rip2)))

;;     (implies (and (page-structure-marking-mode x86)
;;                   (not (programmer-level-mode x86))
;;                   (not (ms x86))
;;                   (not (fault x86))
;;                   (x86p x86)

;;                   (not flg-get-prefixes)

;;                   (canonical-address-p temp-rip0)
;;                   (if (and (equal prefix-length 0)
;;                            (equal rex-byte 0)
;;                            (not modr/m?))
;;                       ;; One byte instruction --- all we need to know is that
;;                       ;; the new RIP is canonical, not that there's no error
;;                       ;; in reading a value from that address.
;;                       t
;;                     (not flg-opcode/escape-byte))
;;                   (if (equal rex-byte 0)
;;                       t
;;                     (canonical-address-p temp-rip1))
;;                   (if modr/m?
;;                       (and (canonical-address-p temp-rip2)
;;                            (not flg-modr/m))
;;                     t)
;;                   (if sib?
;;                       (and (canonical-address-p temp-rip3)
;;                            (not flg-sib))
;;                     t))

;;              (equal (x86-fetch-decode-execute x86)
;;                     (top-level-opcode-execute
;;                      start-rip temp-rip3 prefixes rex-byte opcode/escape-byte modr/m sib x86-4))))
;;   :hints (("Goal"
;;            :in-theory (e/d (x86-fetch-decode-execute)
;;                            (xlate-equiv-memory-and-mv-nth-0-rm08-cong
;;                             xlate-equiv-memory-and-two-mv-nth-2-rm08-cong
;;                             xlate-equiv-memory-and-mv-nth-2-rm08
;;                             top-level-opcode-execute
;;                             signed-byte-p
;;                             not
;;                             member-equal)))))

(defthm x86-fetch-decode-execute-opener-in-marking-mode

  ;; If I don't put any double-rewrites in the hyps below, these are
  ;; the warnings that I get from ACL2.

  ;; (:WARNING
  ;;      "Double-rewrite"
  ;;      ((:CTX (DEFTHM .
  ;;                     X86-FETCH-DECODE-EXECUTE-OPENER-IN-MARKING-MODE))
  ;;       (:DOC DOUBLE-REWRITE)
  ;;       (:EQUIVALENCE-RELATIONS (IFF))
  ;;       (:LOCATION ("the ~n0 hypothesis" (#\0 32)))
  ;;       (:NEW-RULE X86-FETCH-DECODE-EXECUTE-OPENER-IN-MARKING-MODE)
  ;;       (:NUMBER-OF-PROBLEMATIC-OCCURRENCES 1)
  ;;       (:RULE-CLASS :REWRITE)
  ;;       (:VARIABLE FLG-GET-PREFIXES)))

  ;; (:WARNING
  ;;      "Double-rewrite"
  ;;      ((:CTX (DEFTHM .
  ;;                     X86-FETCH-DECODE-EXECUTE-OPENER-IN-MARKING-MODE))
  ;;       (:DOC DOUBLE-REWRITE)
  ;;       (:EQUIVALENCE-RELATIONS (IFF))
  ;;       (:LOCATION ("the ~n0 hypothesis" (#\0 34)))
  ;;       (:NEW-RULE X86-FETCH-DECODE-EXECUTE-OPENER-IN-MARKING-MODE)
  ;;       (:NUMBER-OF-PROBLEMATIC-OCCURRENCES 1)
  ;;       (:RULE-CLASS :REWRITE)
  ;;       (:VARIABLE FLG-OPCODE/ESCAPE-BYTE)))

  ;; (:WARNING
  ;;      "Double-rewrite"
  ;;      ((:CTX (DEFTHM .
  ;;                     X86-FETCH-DECODE-EXECUTE-OPENER-IN-MARKING-MODE))
  ;;       (:DOC DOUBLE-REWRITE)
  ;;       (:EQUIVALENCE-RELATIONS (IFF))
  ;;       (:LOCATION ("the ~n0 hypothesis" (#\0 36)))
  ;;       (:NEW-RULE X86-FETCH-DECODE-EXECUTE-OPENER-IN-MARKING-MODE)
  ;;       (:NUMBER-OF-PROBLEMATIC-OCCURRENCES 1)
  ;;       (:RULE-CLASS :REWRITE)
  ;;       (:VARIABLE FLG-MODR/M)))

  ;; (:WARNING
  ;;      "Double-rewrite"
  ;;      ((:CTX (DEFTHM .
  ;;                     X86-FETCH-DECODE-EXECUTE-OPENER-IN-MARKING-MODE))
  ;;       (:DOC DOUBLE-REWRITE)
  ;;       (:EQUIVALENCE-RELATIONS (IFF))
  ;;       (:LOCATION ("the ~n0 hypothesis" (#\0 37)))
  ;;       (:NEW-RULE X86-FETCH-DECODE-EXECUTE-OPENER-IN-MARKING-MODE)
  ;;       (:NUMBER-OF-PROBLEMATIC-OCCURRENCES 1)
  ;;       (:RULE-CLASS :REWRITE)
  ;;       (:VARIABLE FLG-SIB)))

  (implies (and
            ;; Start: binding hypotheses.
            (equal start-rip (rip x86))
            ;; get-prefixes:
            (equal three-vals-of-get-prefixes (get-prefixes start-rip 0 5 x86))
            (equal flg-get-prefixes (mv-nth 0 three-vals-of-get-prefixes))
            (equal prefixes (mv-nth 1 three-vals-of-get-prefixes))
            (equal x86-1 (mv-nth 2 three-vals-of-get-prefixes))

            (equal opcode/rex/escape-byte (prefixes-slice :next-byte prefixes))
            (equal prefix-length (prefixes-slice :num-prefixes prefixes))
            (equal temp-rip0 (if (equal prefix-length 0)
                                 (+ 1 start-rip)
                               (+ prefix-length start-rip 1)))
            (equal rex-byte (if (equal (ash opcode/rex/escape-byte -4) 4)
                                opcode/rex/escape-byte
                              0))

            ;; opcode/escape-byte:
            (equal three-vals-of-opcode/escape-byte
                   (if (equal rex-byte 0)
                       (mv nil opcode/rex/escape-byte x86-1)
                     (rm08 temp-rip0 :x x86-1)))
            (equal flg-opcode/escape-byte (mv-nth 0 three-vals-of-opcode/escape-byte))
            (equal opcode/escape-byte (mv-nth 1 three-vals-of-opcode/escape-byte))
            (equal x86-2 (mv-nth 2 three-vals-of-opcode/escape-byte))

            (equal temp-rip1 (if (equal rex-byte 0) temp-rip0 (1+ temp-rip0)))
            (equal modr/m? (x86-one-byte-opcode-modr/m-p opcode/escape-byte))

            ;; modr/m byte:
            (equal three-vals-of-modr/m
                   (if modr/m? (rm08 temp-rip1 :x x86-2) (mv nil 0 x86-2)))
            (equal flg-modr/m (mv-nth 0 three-vals-of-modr/m))
            (equal modr/m (mv-nth 1 three-vals-of-modr/m))
            (equal x86-3 (mv-nth 2 three-vals-of-modr/m))

            (equal temp-rip2 (if modr/m? (1+ temp-rip1) temp-rip1))
            (equal sib? (and modr/m? (x86-decode-sib-p modr/m)))

            ;; sib byte:
            (equal three-vals-of-sib
                   (if sib? (rm08 temp-rip2 :x x86-3) (mv nil 0 x86-3)))
            (equal flg-sib (mv-nth 0 three-vals-of-sib))
            (equal sib (mv-nth 1 three-vals-of-sib))
            (equal x86-4 (mv-nth 2 three-vals-of-sib))

            (equal temp-rip3 (if sib? (1+ temp-rip2) temp-rip2))
            ;; End: binding hypotheses.

            (page-structure-marking-mode x86)
            (not (programmer-level-mode x86))
            (not (ms x86))
            (not (fault x86))
            (x86p x86)
            (double-rewrite (not flg-get-prefixes))
            ;; !!! Add double-rewrite after monitoring this theorem...
            (double-rewrite (canonical-address-p temp-rip0))
            (double-rewrite
             (if (and (equal prefix-length 0)
                      (equal rex-byte 0)
                      (not modr/m?))
                 ;; One byte instruction --- all we need to know is that
                 ;; the new RIP is canonical, not that there's no error
                 ;; in reading a value from that address.
                 t
               (not flg-opcode/escape-byte)))
            ;; !!! Add double-rewrite after monitoring this theorem...
            (double-rewrite
             (if (equal rex-byte 0)
                 t
               (canonical-address-p temp-rip1)))
            (double-rewrite
             (if  modr/m?
                 (and (canonical-address-p temp-rip2)
                      (not flg-modr/m))
               t))
            (double-rewrite
             (if sib?
                 (and (canonical-address-p temp-rip3)
                      (not flg-sib))
               t)))
           (equal (x86-fetch-decode-execute x86)
                  (top-level-opcode-execute
                   start-rip temp-rip3 prefixes rex-byte opcode/escape-byte modr/m sib x86-4)))
  :hints (("Goal"
           :do-not '(preprocess)
           :in-theory (e/d (x86-fetch-decode-execute)
                           (top-level-opcode-execute
                            xlate-equiv-memory-and-mv-nth-0-rm08-cong
                            xlate-equiv-memory-and-two-mv-nth-2-rm08-cong
                            xlate-equiv-memory-and-mv-nth-2-rm08
                            signed-byte-p
                            not
                            member-equal
                            disjointness-of-las-to-pas-from-las-to-pas-subset-p
                            disjoint-p-of-remove-duplicates-equal
                            remove-duplicates-equal
                            disjoint-p-of-open-qword-paddr-list-and-remove-duplicates-equal
                            combine-bytes
                            byte-listp
                            acl2::ash-0
                            open-qword-paddr-list
                            cdr-mv-nth-1-las-to-pas
                            unsigned-byte-p-of-combine-bytes
                            get-prefixes-opener-lemma-no-prefix-byte
                            get-prefixes-opener-lemma-group-1-prefix-in-marking-mode
                            get-prefixes-opener-lemma-group-2-prefix-in-marking-mode
                            get-prefixes-opener-lemma-group-3-prefix-in-marking-mode
                            get-prefixes-opener-lemma-group-4-prefix-in-marking-mode
                            mv-nth-0-rb-and-mv-nth-0-las-to-pas-in-system-level-mode
                            mv-nth-2-rb-in-system-level-marking-mode
                            (force) force)))))

;; ======================================================================

;; Some misc. rules:

;; (local
;;  (in-theory (e/d (las-to-pas-subset-p member-p subset-p)
;;                  (disjoint-p-of-remove-duplicates-equal
;;                   disjoint-p-of-open-qword-paddr-list-and-remove-duplicates-equal
;;                   not-disjoint-p-of-open-qword-paddr-list-and-remove-duplicates-equal
;;                   member-p-of-open-qword-paddr-list-and-remove-duplicates-equal
;;                   not-member-p-of-open-qword-paddr-list-and-remove-duplicates-equal
;;                   disjoint-p-of-remove-duplicates-equal
;;                   disjointness-of-all-translation-governing-addresses-from-all-translation-governing-addresses-subset-p
;;                   disjoint-p-append-1
;;                   xlate-equiv-memory-and-xr-mem-from-rest-of-memory
;;                   xlate-equiv-memory-and-mv-nth-1-rm08
;;                   xlate-equiv-memory-and-two-get-prefixes-values))))

(defun find-l-addrs-from-program-at-term (thm l-addrs-var mfc state)
  (declare (xargs :stobjs (state) :mode :program)
           (ignorable thm state))
  (b* ((call (acl2::find-call-lst 'program-at (acl2::mfc-clause mfc)))
       (call (if (not call)
                 (acl2::find-call-lst 'program-at-alt (acl2::mfc-clause mfc))
               nil))
       ((when (not call)) nil)
       (addresses (cadr call))
       ((when (not (equal (car addresses) 'create-canonical-address-list)))
        nil))
    `((,l-addrs-var . ,addresses))))

(defthm disjoint-p-all-translation-governing-addresses-and-las-to-pas-subset-p
  ;; This rule helps in figuring out that each instruction's physical
  ;; address is disjoint from its translation-governing addresses,
  ;; given that the whole program's physical addresses are disjoint
  ;; from all the translation-governing addresses.
  (implies
   (and (bind-free (find-l-addrs-from-program-at-term
                    'disjoint-p-all-translation-governing-addresses-and-las-to-pas-subset-p 'l-addrs
                    mfc state)
                   (l-addrs))
        (disjoint-p (all-translation-governing-addresses l-addrs (double-rewrite x86))
                    (mv-nth 1 (las-to-pas l-addrs r-w-x cpl (double-rewrite x86))))
        (subset-p l-addrs-subset l-addrs)
        (syntaxp (not (eq l-addrs-subset l-addrs)))
        (not (mv-nth 0 (las-to-pas l-addrs r-w-x cpl (double-rewrite x86)))))
   (disjoint-p
    (all-translation-governing-addresses l-addrs-subset x86)
    (mv-nth 1 (las-to-pas l-addrs-subset r-w-x cpl x86))))
  :hints
  (("Goal"
    :use ((:instance disjointness-of-all-translation-governing-addresses-from-all-translation-governing-addresses-subset-p
                     (l-addrs l-addrs)
                     (l-addrs-subset l-addrs-subset)
                     (other-p-addrs (mv-nth 1 (las-to-pas l-addrs r-w-x cpl x86)))
                     (other-p-addrs-subset (mv-nth 1 (las-to-pas l-addrs-subset r-w-x cpl x86)))))
    :in-theory (e/d* (subset-p
                      member-p
                      disjoint-p-append-1
                      las-to-pas
                      all-translation-governing-addresses)
                     (translation-governing-addresses)))))

;; (defthm xr-fault-ia32e-la-to-pa
;;   (implies (not (mv-nth 0 (ia32e-la-to-pa lin-addr r-w-x cpl x86)))
;;            (equal (xr :fault index (mv-nth 2 (ia32e-la-to-pa lin-addr r-w-x cpl x86)))
;;                   (xr :fault index x86)))
;;   :hints (("Goal" :in-theory (e/d* (ia32e-la-to-pa
;;                                     ia32e-la-to-pa-pml4-table
;;                                     ia32e-la-to-pa-page-dir-ptr-table
;;                                     ia32e-la-to-pa-page-directory
;;                                     ia32e-la-to-pa-page-table)
;;                                    (force
;;                                     (force)
;;                                     (:definition not)
;;                                     (:meta acl2::mv-nth-cons-meta))))))

;; (defthm xr-fault-rb-alt-state-in-system-level-mode
;;   (equal (xr :fault index (mv-nth 2 (rb-alt l-addrs r-w-x x86)))
;;          (xr :fault index x86))
;;   :hints (("Goal" :in-theory (e/d* (rb-alt las-to-pas)
;;                                    (rewrite-rb-to-rb-alt
;;                                     force (force))))))

;; (defthm xr-fault-and-get-prefixes
;;   (implies (not (mv-nth 0 (las-to-pas
;;                            (create-canonical-address-list cnt start-rip)
;;                            :x (cpl x86) x86)))
;;            (equal (xr :fault index (mv-nth 2 (get-prefixes start-rip prefixes cnt x86)))
;;                   (xr :fault index x86)))
;;   :hints (("Goal"
;;            :induct (get-prefixes start-rip prefixes cnt x86)
;;            :in-theory (e/d* (get-prefixes rm08)
;;                             (rm08-to-rb
;;                              not force (force))))))

;; (defthm xr-fault-and-get-prefixes-alt
;;   (equal (xr :fault index (mv-nth 2 (get-prefixes-alt start-rip prefixes cnt x86)))
;;          (xr :fault index x86))
;;   :hints (("Goal" :in-theory (e/d* (get-prefixes-alt)
;;                                    (rewrite-get-prefixes-to-get-prefixes-alt
;;                                     not force (force))))))

;; (defthm rb-alt-xw-values-in-system-level-mode
;;   (implies (and (not (programmer-level-mode x86))
;;                 (not (equal fld :mem))
;;                 (not (equal fld :rflags))
;;                 (not (equal fld :ctr))
;;                 (not (equal fld :seg-visible))
;;                 (not (equal fld :msr))
;;                 (not (equal fld :fault))
;;                 (not (equal fld :programmer-level-mode))
;;                 (not (equal fld :page-structure-marking-mode)))
;;            (and (equal (mv-nth 0 (rb-alt addr r-w-x (xw fld index value x86)))
;;                        (mv-nth 0 (rb-alt addr r-w-x x86)))
;;                 (equal (mv-nth 1 (rb-alt addr r-w-x (xw fld index value x86)))
;;                        (mv-nth 1 (rb-alt addr r-w-x x86)))))
;;   :hints (("Goal" :in-theory (e/d* (rb-alt) (rewrite-rb-to-rb-alt force (force))))))

;; (defthm rb-alt-xw-rflags-not-ac-values-in-system-level-mode
;;   (implies (and (not (programmer-level-mode x86))
;;                 (equal (rflags-slice :ac value)
;;                        (rflags-slice :ac (rflags x86))))
;;            (and (equal (mv-nth 0 (rb-alt addr r-w-x (xw :rflags 0 value x86)))
;;                        (mv-nth 0 (rb-alt addr r-w-x x86)))
;;                 (equal (mv-nth 1 (rb-alt addr r-w-x (xw :rflags 0 value x86)))
;;                        (mv-nth 1 (rb-alt addr r-w-x x86)))))
;;   :hints (("Goal" :in-theory (e/d* (rb-alt) (force (force) rewrite-rb-to-rb-alt)))))

;; (defthm rb-alt-xw-state-in-system-level-mode
;;   (implies (and (not (programmer-level-mode x86))
;;                 (not (equal fld :mem))
;;                 (not (equal fld :rflags))
;;                 (not (equal fld :ctr))
;;                 (not (equal fld :seg-visible))
;;                 (not (equal fld :msr))
;;                 (not (equal fld :fault))
;;                 (not (equal fld :programmer-level-mode))
;;                 (not (equal fld :page-structure-marking-mode)))
;;            (equal (mv-nth 2 (rb-alt addr r-w-x (xw fld index value x86)))
;;                   (xw fld index value (mv-nth 2 (rb-alt addr r-w-x x86)))))
;;   :hints (("Goal" :in-theory (e/d* (rb-alt) (rewrite-rb-to-rb-alt force (force))))))

;; (defthm rb-alt-xw-rflags-not-ac-state-in-system-level-mode
;;   (implies (and (not (programmer-level-mode x86))
;;                 (equal (rflags-slice :ac value)
;;                        (rflags-slice :ac (rflags x86))))
;;            (equal (mv-nth 2 (rb-alt addr r-w-x (xw :rflags 0 value x86)))
;;                   (xw :rflags 0 value (mv-nth 2 (rb-alt addr r-w-x x86)))))
;;   :hints (("Goal" :in-theory (e/d* (rb-alt) (rewrite-rb-to-rb-alt force (force))))))

;; (defthm gather-all-paging-structure-qword-addresses-!flgi
;;   (equal (gather-all-paging-structure-qword-addresses (!flgi index val x86))
;;          (gather-all-paging-structure-qword-addresses (double-rewrite x86)))
;;   :hints (("Goal" :in-theory (e/d* (!flgi) (force (force))))))

;; (defthm rb-alt-values-and-!flgi-in-system-level-mode
;;   (implies (and (not (equal index *ac*))
;;                 (not (programmer-level-mode x86))
;;                 (x86p x86))
;;            (and (equal (mv-nth 0 (rb-alt l-addrs r-w-x (!flgi index value x86)))
;;                        (mv-nth 0 (rb-alt l-addrs r-w-x x86)))
;;                 (equal (mv-nth 1 (rb-alt l-addrs r-w-x (!flgi index value x86)))
;;                        (mv-nth 1 (rb-alt l-addrs r-w-x x86)))))
;;   :hints (("Goal" :do-not-induct t
;;            :in-theory (e/d* (rb-alt) (rewrite-rb-to-rb-alt force (force))))))

;; (defthm rb-and-!flgi-state-in-system-level-mode
;;   (implies (and (not (equal index *ac*))
;;                 (not (programmer-level-mode x86))
;;                 (x86p x86))
;;            (equal (mv-nth 2 (rb lin-addr r-w-x (!flgi index value x86)))
;;                   (!flgi index value (mv-nth 2 (rb lin-addr r-w-x x86)))))
;;   :hints (("Goal"
;;            :do-not-induct t
;;            :cases ((equal index *iopl*))
;;            :use ((:instance rflags-slice-ac-simplify
;;                             (index index)
;;                             (rflags (xr :rflags 0 x86)))
;;                  (:instance rb-xw-rflags-not-ac-state-in-system-level-mode
;;                             (addr lin-addr)
;;                             (value (logior (loghead 32 (ash (loghead 1 value) (nfix index)))
;;                                            (logand (xr :rflags 0 x86)
;;                                                    (loghead 32 (lognot (expt 2 (nfix index))))))))
;;                  (:instance rb-xw-rflags-not-ac-state-in-system-level-mode
;;                             (addr lin-addr)
;;                             (value (logior (ash (loghead 2 value) 12)
;;                                            (logand 4294955007 (xr :rflags 0 x86))))))
;;            :in-theory (e/d* (!flgi-open-to-xw-rflags)
;;                             (rewrite-rb-to-rb-alt force (force))))))

;; (defthm rb-alt-and-!flgi-state-in-system-level-mode
;;   (implies (and (not (equal index *ac*))
;;                 (not (programmer-level-mode x86))
;;                 (x86p x86))
;;            (equal (mv-nth 2 (rb-alt lin-addr r-w-x (!flgi index value x86)))
;;                   (!flgi index value (mv-nth 2 (rb-alt lin-addr r-w-x x86)))))
;;   :hints (("Goal"
;;            :do-not-induct t
;;            :in-theory (e/d* (rb-alt)
;;                             (rewrite-rb-to-rb-alt force (force))))))

;; (defthm get-prefixes-xw-in-system-level-mode
;;   (implies (and (not (programmer-level-mode x86))
;;                 (not (equal fld :mem))
;;                 (not (equal fld :rflags))
;;                 (not (equal fld :ctr))
;;                 (not (equal fld :seg-visible))
;;                 (not (equal fld :msr))
;;                 (not (equal fld :fault))
;;                 (not (equal fld :programmer-level-mode))
;;                 (not (equal fld :page-structure-marking-mode)))
;;            (and (equal (mv-nth 0 (get-prefixes start-rip prefixes cnt (xw fld index value x86)))
;;                        (mv-nth 0 (get-prefixes start-rip prefixes cnt x86)))
;;                 (equal (mv-nth 1 (get-prefixes start-rip prefixes cnt (xw fld index value x86)))
;;                        (mv-nth 1 (get-prefixes start-rip prefixes cnt x86)))
;;                 (equal (mv-nth 2 (get-prefixes start-rip prefixes cnt (xw fld index value x86)))
;;                        (xw fld index value (mv-nth 2 (get-prefixes start-rip prefixes cnt x86))))))
;;   :hints (("Goal"
;;            :do-not '(preprocess)
;;            :induct (get-prefixes start-rip prefixes cnt x86)
;;            :expand (get-prefixes start-rip prefixes cnt (xw fld index value x86))
;;            :in-theory (e/d* (get-prefixes)
;;                             (rewrite-get-prefixes-to-get-prefixes-alt
;;                              acl2::member-of-cons
;;                              negative-logand-to-positive-logand-with-integerp-x
;;                              bitops::logior-natp-type
;;                              (:type-prescription unsigned-byte-p)
;;                              unsigned-byte-p-of-logior
;;                              bitops::logand-with-negated-bitmask
;;                              rm08-to-rb
;;                              xlate-equiv-memory-and-mv-nth-0-rm08-cong
;;                              xlate-equiv-memory-and-mv-nth-1-rm08
;;                              xlate-equiv-memory-and-two-mv-nth-2-rm08-cong
;;                              xlate-equiv-memory-and-mv-nth-2-rm08
;;                              force (force))))))

;; (defthm get-prefixes-alt-xw-in-system-level-mode
;;   (implies (and (not (programmer-level-mode x86))
;;                 (not (equal fld :mem))
;;                 (not (equal fld :rflags))
;;                 (not (equal fld :ctr))
;;                 (not (equal fld :seg-visible))
;;                 (not (equal fld :msr))
;;                 (not (equal fld :fault))
;;                 (not (equal fld :programmer-level-mode))
;;                 (not (equal fld :page-structure-marking-mode)))
;;            (and (equal (mv-nth 0 (get-prefixes-alt start-rip prefixes cnt (xw fld index value x86)))
;;                        (mv-nth 0 (get-prefixes-alt start-rip prefixes cnt x86)))
;;                 (equal (mv-nth 1 (get-prefixes-alt start-rip prefixes cnt (xw fld index value x86)))
;;                        (mv-nth 1 (get-prefixes-alt start-rip prefixes cnt x86)))
;;                 (equal (mv-nth 2 (get-prefixes-alt start-rip prefixes cnt (xw fld index value x86)))
;;                        (xw fld index value (mv-nth 2 (get-prefixes-alt start-rip prefixes cnt x86))))))
;;   :hints (("Goal"
;;            :in-theory (e/d* (get-prefixes-alt)
;;                             (rewrite-get-prefixes-to-get-prefixes-alt
;;                              force (force))))))

;; (defthm get-prefixes-xw-rflags-not-ac-state-in-system-level-mode
;;   (implies (and (not (programmer-level-mode x86))
;;                 (equal (rflags-slice :ac value)
;;                        (rflags-slice :ac (rflags x86))))
;;            (equal (mv-nth 2 (get-prefixes start-rip prefixes cnt (xw :rflags 0 value x86)))
;;                   (xw :rflags 0 value (mv-nth 2 (get-prefixes start-rip prefixes cnt x86)))))
;;   :hints (("Goal"
;;            :induct (get-prefixes start-rip prefixes cnt x86)
;;            :expand (get-prefixes start-rip prefixes cnt (xw :rflags 0 value x86))
;;            :in-theory (e/d* (get-prefixes)
;;                             (rewrite-get-prefixes-to-get-prefixes-alt
;;                              force (force))))))

;; (defthm get-prefixes-and-!flgi-state-in-system-level-mode
;;   (implies (and (not (equal index *ac*))
;;                 (not (programmer-level-mode x86))
;;                 (x86p x86))
;;            (equal (mv-nth 2 (get-prefixes start-rip prefixes cnt (!flgi index value x86)))
;;                   (!flgi index value (mv-nth 2 (get-prefixes start-rip prefixes cnt x86)))))
;;   :hints (("Goal"
;;            :do-not-induct t
;;            :cases ((equal index *iopl*))
;;            :use ((:instance rflags-slice-ac-simplify
;;                             (index index)
;;                             (rflags (xr :rflags 0 x86)))
;;                  (:instance get-prefixes-xw-rflags-not-ac-state-in-system-level-mode
;;                             (value (logior (loghead 32 (ash (loghead 1 value) (nfix index)))
;;                                            (logand (xr :rflags 0 x86)
;;                                                    (loghead 32 (lognot (expt 2 (nfix index))))))))
;;                  (:instance get-prefixes-xw-rflags-not-ac-state-in-system-level-mode
;;                             (value (logior (ash (loghead 2 value) 12)
;;                                            (logand 4294955007 (xr :rflags 0 x86))))))
;;            :in-theory (e/d* (!flgi-open-to-xw-rflags
;;                              !flgi)
;;                             (rewrite-get-prefixes-to-get-prefixes-alt force (force))))))

;; (defthm get-prefixes-xw-rflags-not-ac-values-in-system-level-mode
;;   (implies (and (not (programmer-level-mode x86))
;;                 (equal (rflags-slice :ac value)
;;                        (rflags-slice :ac (rflags x86))))
;;            (and
;;             (equal (mv-nth 0 (get-prefixes start-rip prefixes cnt (xw :rflags 0 value x86)))
;;                    (mv-nth 0 (get-prefixes start-rip prefixes cnt x86)))
;;             (equal (mv-nth 1 (get-prefixes start-rip prefixes cnt (xw :rflags 0 value x86)))
;;                    (mv-nth 1 (get-prefixes start-rip prefixes cnt x86)))))
;;   :hints (("Goal"
;;            :induct (get-prefixes start-rip prefixes cnt x86)
;;            :expand (get-prefixes start-rip prefixes cnt (xw :rflags 0 value x86))
;;            :in-theory (e/d* (get-prefixes)
;;                             (rewrite-get-prefixes-to-get-prefixes-alt
;;                              force (force))))))

;; (defthm get-prefixes-values-and-!flgi-in-system-level-mode
;;   (implies (and (not (equal index *ac*))
;;                 (not (programmer-level-mode x86))
;;                 (x86p x86))
;;            (and (equal (mv-nth 0 (get-prefixes start-rip prefixes cnt (!flgi index value x86)))
;;                        (mv-nth 0 (get-prefixes start-rip prefixes cnt x86)))
;;                 (equal (mv-nth 1 (get-prefixes start-rip prefixes cnt (!flgi index value x86)))
;;                        (mv-nth 1 (get-prefixes start-rip prefixes cnt x86)))))
;;   :hints (("Goal"
;;            :do-not-induct t
;;            :cases ((equal index *iopl*))
;;            :use ((:instance rflags-slice-ac-simplify
;;                             (index index)
;;                             (rflags (xr :rflags 0 x86)))
;;                  (:instance get-prefixes-xw-rflags-not-ac-values-in-system-level-mode
;;                             (value (logior (loghead 32 (ash (loghead 1 value) (nfix index)))
;;                                            (logand (xr :rflags 0 x86)
;;                                                    (loghead 32 (lognot (expt 2 (nfix index))))))))
;;                  (:instance get-prefixes-xw-rflags-not-ac-values-in-system-level-mode
;;                             (value (logior (ash (loghead 2 value) 12)
;;                                            (logand 4294955007 (xr :rflags 0 x86))))))
;;            :in-theory (e/d* (!flgi-open-to-xw-rflags
;;                              !flgi)
;;                             (get-prefixes-xw-rflags-not-ac-values-in-system-level-mode
;;                              rewrite-get-prefixes-to-get-prefixes-alt
;;                              force (force))))))

;; (defthm get-prefixes-alt-values-and-!flgi-in-system-level-mode
;;   (implies (and (not (equal index *ac*))
;;                 (x86p x86))
;;            (and (equal (mv-nth 0 (get-prefixes-alt start-rip prefixes cnt (!flgi index value x86)))
;;                        (mv-nth 0 (get-prefixes-alt start-rip prefixes cnt x86)))
;;                 (equal (mv-nth 1 (get-prefixes-alt start-rip prefixes cnt (!flgi index value x86)))
;;                        (mv-nth 1 (get-prefixes-alt start-rip prefixes cnt x86)))))
;;   :hints (("Goal"
;;            :do-not-induct t
;;            :in-theory (e/d* (get-prefixes-alt)
;;                             (rewrite-get-prefixes-to-get-prefixes-alt
;;                              force (force))))))

;; (defthm get-prefixes-alt-and-!flgi-state-in-system-level-mode
;;   (implies (and (not (equal index *ac*))
;;                 (not (programmer-level-mode x86))
;;                 (x86p x86))
;;            (equal (mv-nth 2 (get-prefixes-alt start-rip prefixes cnt (!flgi index value x86)))
;;                   (!flgi index value (mv-nth 2 (get-prefixes-alt start-rip prefixes cnt x86)))))
;;   :hints (("Goal"
;;            :do-not-induct t
;;            :in-theory (e/d* (get-prefixes-alt)
;;                             (rewrite-get-prefixes-to-get-prefixes-alt
;;                              force (force))))))

;; (defthm flgi-and-mv-nth-2-rb-alt
;;   (equal (flgi index (mv-nth 2 (rb-alt l-addrs r-w-x x86)))
;;          (flgi index x86))
;;   :hints (("Goal" :in-theory (e/d* (flgi) ()))))

;; (defthm alignment-checking-enabled-p-and-mv-nth-2-rb-alt
;;   (equal (alignment-checking-enabled-p (mv-nth 2 (rb-alt l-addrs r-w-x x86)))
;;          (alignment-checking-enabled-p x86))
;;   :hints (("Goal" :in-theory (e/d* (alignment-checking-enabled-p) ()))))

;; (defthm flgi-and-mv-nth-2-get-prefixes-alt
;;   (equal (flgi index (mv-nth 2 (get-prefixes-alt start-rip prefixes cnt x86)))
;;          (flgi index x86))
;;   :hints (("Goal" :in-theory (e/d* (flgi) ()))))

;; (defthm alignment-checking-enabled-p-and-mv-nth-2-get-prefixes-alt
;;   (equal (alignment-checking-enabled-p (mv-nth 2 (get-prefixes-alt start-rip prefixes cnt x86)))
;;          (alignment-checking-enabled-p x86))
;;   :hints (("Goal" :in-theory (e/d* (alignment-checking-enabled-p) ()))))

;; (defthm mv-nth-1-wb-and-!flgi-commute-in-marking-mode
;;   ;; Subsumes MV-NTH-1-WB-AND-!FLGI-COMMUTE
;;   (implies (not (equal index *ac*))
;;            (equal (mv-nth 1 (wb addr-lst (!flgi index val x86)))
;;                   (!flgi index val (mv-nth 1 (wb addr-lst x86)))))
;;   :hints (("Goal" :in-theory (e/d* (!flgi rflags-slice-ac-simplify
;;                                           !flgi-open-to-xw-rflags)
;;                                    (force (force))))))

;; (defthm xr-fault-las-to-pas
;;   (implies (not (mv-nth 0 (las-to-pas l-addrs r-w-x cpl (double-rewrite x86))))
;;            (equal (xr :fault 0
;;                       (mv-nth 2 (las-to-pas l-addrs r-w-x cpl x86)))
;;                   (xr :fault 0 x86)))
;;   :hints (("Goal" :in-theory (e/d* (las-to-pas) (force (force))))))

;; (defthm xr-fault-wb-in-system-level-marking-mode
;;   (implies
;;    (not (mv-nth 0 (las-to-pas (strip-cars addr-lst)
;;                               :w (loghead 2 (xr :seg-visible 1 x86))
;;                               (double-rewrite x86))))
;;    (equal (xr :fault 0 (mv-nth 1 (wb addr-lst x86)))
;;           (xr :fault 0 x86)))
;;   :hints
;;   (("Goal" :do-not-induct t
;;     :in-theory (e/d* (wb)
;;                      (member-p-strip-cars-of-remove-duplicate-keys
;;                       (:meta acl2::mv-nth-cons-meta)
;;                       force (force))))))

;; (defthm mv-nth-0-rb-and-xw-mem-in-system-level-mode
;;   (implies (and (disjoint-p
;;                  (list index)
;;                  (all-translation-governing-addresses l-addrs (double-rewrite x86)))
;;                 (canonical-address-listp l-addrs)
;;                 (physical-address-p index))
;;            (equal (mv-nth 0 (rb l-addrs r-w-x (xw :mem index value x86)))
;;                   (mv-nth 0 (rb l-addrs r-w-x x86))))
;;   :hints (("Goal" :in-theory (e/d* (rb
;;                                     disjoint-p
;;                                     las-to-pas)
;;                                    (rewrite-rb-to-rb-alt
;;                                     force (force))))))

;; (defthm read-from-physical-memory-xw-mem
;;   (implies (disjoint-p (list index) p-addrs)
;;            (equal (read-from-physical-memory p-addrs (xw :mem index value x86))
;;                   (read-from-physical-memory p-addrs x86)))
;;   :hints (("Goal" :in-theory (e/d* (read-from-physical-memory
;;                                     disjoint-p)
;;                                    ()))))

;; (defthm mv-nth-1-rb-and-xw-mem-in-system-level-mode
;;   (implies (and
;;             (disjoint-p
;;              (list index)
;;              (all-translation-governing-addresses l-addrs (double-rewrite x86)))
;;             (disjoint-p
;;              (list index)
;;              (mv-nth 1 (las-to-pas l-addrs r-w-x (cpl x86) (double-rewrite x86))))
;;             (disjoint-p
;;              (all-translation-governing-addresses l-addrs (double-rewrite x86))
;;              (mv-nth 1 (las-to-pas l-addrs r-w-x (cpl x86) (double-rewrite x86))))
;;             (canonical-address-listp l-addrs)
;;             (physical-address-p index)
;;             (not (programmer-level-mode x86)))
;;            (equal (mv-nth 1 (rb l-addrs r-w-x (xw :mem index value x86)))
;;                   (mv-nth 1 (rb l-addrs r-w-x x86))))
;;   :hints (("Goal" :in-theory (e/d* (rb
;;                                     disjoint-p
;;                                     las-to-pas)
;;                                    (rewrite-rb-to-rb-alt
;;                                     xlate-equiv-memory-and-xr-mem-from-rest-of-memory
;;                                     force (force))))))

;; (in-theory (e/d ()
;;                 (disjoint-p-of-remove-duplicates-equal
;;                  disjointness-of-all-translation-governing-addresses-from-all-translation-governing-addresses-subset-p
;;                  disjoint-p-append-1)))

;; (defthm get-prefixes-xw-mem-values-in-system-level-mode
;;   (implies
;;    (and (disjoint-p
;;          (mv-nth 1 (las-to-pas
;;                     (create-canonical-address-list cnt start-rip)
;;                     :x (cpl x86) x86))
;;          (open-qword-paddr-list
;;           (gather-all-paging-structure-qword-addresses x86)))
;;         (disjoint-p
;;          (all-translation-governing-addresses (create-canonical-address-list cnt start-rip) (double-rewrite x86))
;;          (mv-nth 1 (las-to-pas l-addrs :x (cpl x86) (double-rewrite x86))))
;;         (disjoint-p
;;          (list index)
;;          (mv-nth 1 (las-to-pas (create-canonical-address-list cnt start-rip) :x (cpl x86) x86)))
;;         (disjoint-p
;;          (list index)
;;          (all-translation-governing-addresses (create-canonical-address-list cnt start-rip) x86))
;;         (not (mv-nth 0 (las-to-pas (create-canonical-address-list cnt start-rip) :x (cpl x86) x86)))
;;         (posp cnt)
;;         (canonical-address-p start-rip)
;;         (canonical-address-p (+ cnt start-rip))
;;         (physical-address-p index)
;;         (unsigned-byte-p 8 value)
;;         (not (programmer-level-mode x86))
;;         (page-structure-marking-mode x86)
;;         (x86p x86))
;;    (equal (mv-nth 0 (get-prefixes start-rip prefixes cnt (xw :mem index value x86)))
;;           (mv-nth 0 (get-prefixes start-rip prefixes cnt x86))))
;;   :hints
;;   (("Goal"
;;     :induct (cons (get-prefixes start-rip prefixes cnt x86)
;;                   (create-canonical-address-list cnt start-rip))
;;     ;; :expand (get-prefixes start-rip prefixes cnt (xw :mem index value x86))
;;     :in-theory (e/d* (get-prefixes
;;                       las-to-pas
;;                       las-to-pas-subset-p
;;                       canonical-address-p
;;                       signed-byte-p
;;                       disjoint-p-commutative)
;;                      (rewrite-get-prefixes-to-get-prefixes-alt
;;                       xlate-equiv-memory-and-two-get-prefixes-values
;;                       xlate-equiv-memory-and-mv-nth-1-rm08
;;                       xlate-equiv-memory-and-xr-mem-from-rest-of-memory
;;                       force (force))))))

;; (defthm get-prefixes-and-write-to-physical-memory
;;   (implies (and
;;             (disjoint-p
;;              (mv-nth 1 (las-to-pas
;;                         (create-canonical-address-list cnt start-rip)
;;                         :x (cpl x86) x86))
;;              (open-qword-paddr-list
;;               (gather-all-paging-structure-qword-addresses x86)))
;;             (not (mv-nth 0
;;                          (las-to-pas
;;                           (create-canonical-address-list cnt start-rip)
;;                           :x (cpl x86) x86)))
;;             (disjoint-p
;;              (mv-nth 1 (las-to-pas
;;                         (create-canonical-address-list cnt start-rip)
;;                         :x (cpl x86) x86))
;;              p-addrs)
;;             (canonical-address-p start-rip)
;;             (physical-address-listp p-addrs)
;;             (byte-listp bytes)
;;             (equal (len p-addrs) (len bytes))
;;             (not (programmer-level-mode x86))
;;             (page-structure-marking-mode x86)
;;             (x86p x86))
;;            (equal (mv-nth 0 (get-prefixes start-rip prefixes cnt
;;                                           (write-to-physical-memory p-addrs bytes x86)))
;;                   (mv-nth 0 (get-prefixes start-rip prefixes cnt x86))))
;;   :hints (("Goal" :in-theory (e/d* (las-to-pas
;;                                     get-prefixes
;;                                     write-to-physical-memory
;;                                     byte-listp)
;;                                    (rewrite-get-prefixes-to-get-prefixes-alt
;;                                     xlate-equiv-memory-and-two-get-prefixes-values)))))


;; (defthm get-prefixes-and-wb-in-system-level-marking-mode
;;   (implies (and
;;             (disjoint-p
;;              (mv-nth 1 (las-to-pas
;;                         (create-canonical-address-list cnt start-rip)
;;                         :x (cpl x86) x86))
;;              (open-qword-paddr-list
;;               (gather-all-paging-structure-qword-addresses x86)))
;;             (not (mv-nth 0
;;                          (las-to-pas
;;                           (create-canonical-address-list cnt start-rip)
;;                           :x (cpl x86) x86)))
;;             (disjoint-p
;;              (mv-nth 1 (las-to-pas
;;                         (create-canonical-address-list cnt start-rip)
;;                         :x (cpl x86) x86))
;;              (mv-nth 1 (las-to-pas (strip-cars addr-lst) :w (cpl x86) x86)))
;;             (not (mv-nth 0 (las-to-pas (strip-cars addr-lst) :w (cpl x86) x86)))
;;             (canonical-address-p start-rip)
;;             (not (programmer-level-mode x86))
;;             (page-structure-marking-mode x86)
;;             (x86p x86))
;;            (equal (mv-nth 0 (get-prefixes start-rip prefixes cnt
;;                                           (mv-nth 1 (wb addr-lst x86))))
;;                   (mv-nth 0 (get-prefixes start-rip prefixes cnt x86))))
;;   :hints (("Goal" :in-theory (e/d* (las-to-pas
;;                                     get-prefixes
;;                                     wb)
;;                                    (rewrite-get-prefixes-to-get-prefixes-alt
;;                                     xlate-equiv-memory-and-two-get-prefixes-values
;;                                     xlate-equiv-memory-and-mv-nth-1-rm08
;;                                     xlate-equiv-memory-and-xr-mem-from-rest-of-memory)))))
