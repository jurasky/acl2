
(in-package "GL")

(include-book "centaur/gl/gl-doc-string" :dir :system)


(defun gl-mbe (spec impl)
  ":doc-section ACL2::GL
Assert that a particular symbolic object is equivalent to a second form, and
use the second in place of the first.~/

GL-MBE is defined to simply check whether its two arguments SPEC and IMPL are
equal, throwing an error if not, and return SPEC.

However, when GL-MBE is symbolically executed, the equality of the two
arguments is checked symbolically.  If it can be proved that they are always
equal, then IMPL is returned instead of SPEC, otherwise an error is produced.~/

This is most useful when symbolically executing in AIG mode.  For example,
suppose that through a series of shifting operations, the symbolic
representation of some numeric operand X is expanded to thousands of bits.
However, the user knows that only the bottom 25 bits may be non-zero.  Then the
following form may speed up the rest of the computation involving X by cutting
off all the upper bits, which are known to be zero:
~bv[]
 (let ((x (gl-mbe x (logand (1- (ash 1 25)) x))))
    ...)
~ev[]

Here GL-MBE tries to prove that X and the LOGAND expression are equivalent,
that is, their symbolic representations evaluate to the same concrete values
under all environments.  If this can be proved, X is bound to the LOGAND
result, which cuts off the upper bits of X, improving symbolic execution
performance.  However, because logically GL-MBE just returns X, the meaning of
the specification is unaffected.~/
"
  (declare (xargs :guard t))
  (prog2$ (or (equal spec impl)
              (er hard? 'gl-mbe "GL-MBE assertion failed: ~x0 not equal to ~x1~%"
                  spec impl))
          spec))