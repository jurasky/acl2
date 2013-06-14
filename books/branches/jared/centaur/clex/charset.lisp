; Centaur Lexer Library
; Copyright (C) 2013 Centaur Technology
;
; Contact:
;   Centaur Technology Formal Verification Group
;   7600-C N. Capital of Texas Highway, Suite 300, Austin, TX 78731, USA.
;   http://www.centtech.com/
;
; This program is free software; you can redistribute it and/or modify it under
; the terms of the GNU General Public License as published by the Free Software
; Foundation; either version 2 of the License, or (at your option) any later
; version.  This program is distributed in the hope that it will be useful but
; WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
; FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
; more details.  You should have received a copy of the GNU General Public
; License along with this program; if not, write to the Free Software
; Foundation, Inc., 51 Franklin Street, Suite 500, Boston, MA 02110-1335, USA.
;
; Original author: Jared Davis <jared@centtech.com>

(in-package "CLEX")
(include-book "cutil/define" :dir :system)
(include-book "cutil/deflist" :dir :system)
(include-book "xdoc/names" :dir :system)
(include-book "str/case-conversion" :dir :system)
(local (include-book "arithmetic"))


(define charset-p (x)
  :parents (clex)
  :short "A way to represent a fixed set of characters."

  :long "<p>When writing a lexer, it is often useful to introduce character
sets that recognize sets of characters such as whitespace, alphabetic
characters, digits, and so forth.</p>

<p>A @('charset-p') represents such a set of characters as a natural number.
In this representation, the character whose code is @('i') is a member of the
set @('x') exactly when the @('i')th bit of @('x') is 1.  This may as well be
thought of as a bit-array lookup.</p>

<p>To introduce new sets of characters, e.g., to recognize \"whitespace
characters,\" or \"hex digits,\" or whatever, we use the @(see defcharset)
macro.  After defining suitable character sets, functions like @(see
read-while-in-charset) and @(see read-until-in-charset) become quite
useful.</p>

<p>We generally treat character sets as opaque.  It would be quite odd to,
e.g., allow the theorem prover to expand a character set's definition into its
bit-mask form, or to reason about functions like @(see logbitp) in conjunction
with character sets.  If you find yourself doing this, something is probably
wrong.</p>"
  :returns (bool booleanp :rule-classes :type-prescription)
  (natp x))

(local (defthm charset-p-cr
         ;; Keep it local to avoid exposing the charset-p implementation.
         (implies (charset-p x)
                  (natp x))
         :rule-classes :compound-recognizer
         :hints(("Goal" :in-theory (enable charset-p)))))


(define char-in-charset-p ((char :type character)
                           (set  charset-p))
  :parents (charset-p)
  :short "@(call char-in-charset-p) determines if the character @('char') is a
member of the character set @('set')."
  :inline t
  (mbe :logic
       (and (characterp char)
            (logbitp (char-code char) set))
       :exec
       (logbitp (the (unsigned-byte 8) (char-code char)) set))
  ///
  (defthm char-in-charset-p-when-not-character
    ;; The odd form of this theorem should prevent it from firing most of the
    ;; time.  We probably don't want to target, e.g., characterp.
    (implies (not (characterp char))
             (not (char-in-charset-p char set)))))


(define code-in-charset-p ((code :type (unsigned-byte 8))
                           (set  charset-p))
  :parents (charset-p)
  :short "@(call code-in-charset-p) determines if the character whose code is
@('code') is a member of the character set @('set')."

  :long "<p>Typically there's no reason to use this.  But if you already have
the character code available for some reason, this may be slightly more
efficient than turning it back into a character and then calling @(see
char-in-charset-p).</p>"

  :inline t
  :enabled t
  (mbe :logic (char-in-charset-p (code-char code) set)
       :exec (logbitp code set))

  :guard-hints(("Goal" :in-theory (enable char-in-charset-p))))


(deflist chars-in-charset-p (x set)
  (char-in-charset-p x set)
  :parents (charset-p)
  :short "@(call chars-in-charset-p) recognizes lists of characters @('x')
where every character is a member of the @(see charset-p) @('set')."
  :guard (and (character-listp x)
              (charset-p set)))


(defxdoc defcharset
  :parents (charset-p)
  :short "Define a recognizer for a particular set of characters."

  :long "<p>@('Defcharset') is a macro for introducing a @(see charset-p) and
proving that it recognizes the correct characters.  </p>

<h5>Example</h5>
@({
 (defcharset whitespace
   (or (eql x #\\Newline)
       (eql x #\\Space)
       (eql x #\\Tab)))
})

<p>This example introduces:</p>

<ul>

<li>@('(whitespace-char-p x)') &mdash; a \"slow\" function for recognizing
newline, space, and tab characters</li>

<li>@('(whitespace-charset)') &mdash; a @(see charset-p) that is proven to
correspond to @('whitespace-char-p'),</li>

<li>@('(whitespace-charlist-p x)') &mdash; an ordinary @(see deflist) to
recognize lists whose every character satisfies @(see whitespace-char-p).</li>

</ul>

<h5>General Form</h5>
@({
 (defcharset prefix criteria
   [:in-package-of package]
   [:parents ...]
   [:short ...]
   [:long ...]
})

<p>All functions will be introduced in @('pkg'), determined as follows:</p>

<ul>

<li>If an @(':in-package-of') argument is provided, then the corresponding
@('package') must be a symbol, and we will use its package.</li>

<li>Otherwise, the package of @('prefix') will be used.</li>

</ul>

<p>The @('prefix') is a symbol that is used for name generation.  Some common
examples would be @('whitespace'), @('alpha'), @('digit'), etc.</p>

<p>The @('criteria') is some term involving the variable @('pkg::x').  The
criteria term may assume that @('x') is a character, and is responsible for
determining whether @('x') is a member of the desired set.  Normally you should
not worry about the efficiency of @('criteria').  Although the term you write
here <i>does</i> become part of recognizers like @('whitespace-char-p') and
@('whitespace-charlist-p'), the actual character set, i.e.,
@('whitespace-charset'), is represented as a bit mask, and the speed of your
@('criteria') term will not have any bearing on how fast it is to look up its
bits.</p>

<p>The @(':parents'), @(':short'), and @(':long') options are as in @(see
defxdoc), and allow you to provide documentation to the character recognizer,
e.g., @('whitespace-char-p').  The other functions are documented
automatically.</p>")

(defmacro defcharset (prefix
                      criteria
                      &key
                      in-package-of
                      parents
                      short
                      long)
  (b* ((in-package-of (or in-package-of
                          prefix))
       (foo-char-p
        (intern-in-package-of-symbol (cat (symbol-name prefix) "-CHAR-P")
                                     in-package-of))
       (foo-charlist-p
        (intern-in-package-of-symbol (cat (symbol-name prefix) "-CHARLIST-P")
                                     in-package-of))
       (foo-chars
        (intern-in-package-of-symbol (cat (symbol-name prefix) "-CHARS")
                                     in-package-of))
       (make-foo-chars
        (intern-in-package-of-symbol (cat "MAKE-" (symbol-name prefix) "-CHARS")
                                     in-package-of))
       (foo-char-p-url
        (str::rchars-to-string (xdoc::file-name-mangle foo-char-p nil)))

       (x (intern-in-package-of-symbol "X" in-package-of)))

    `(progn
       (defsection ,foo-char-p
         ,@(and parents `(:parents ,parents))
         ,@(and short   `(:short ,short))
         ,@(and long    `(:long ,long))

         (defund ,foo-char-p (,x)
           (declare (xargs :guard t
                           :normalize nil))
           (and (characterp ,x)
                ,criteria))

         (in-theory (disable (:type-prescription ,foo-char-p)))

         (local (in-theory (enable ,foo-char-p)))

         (defthm ,(intern-in-package-of-symbol
                   (cat "BOOLEANP-OF-" (symbol-name foo-char-p))
                   in-package-of)
           (booleanp (,foo-char-p ,x))
           :rule-classes :type-prescription)

         (local (in-theory (theory 'minimal-theory)))
         (local (in-theory (enable booleanp
                                   booleanp-compound-recognizer
                                   ,foo-char-p
                                   ,(intern-in-package-of-symbol
                                     (cat "BOOLEANP-OF-" (symbol-name foo-char-p))
                                     in-package-of))))

         (defthm ,(intern-in-package-of-symbol
                   (cat "CHARACTERP-WHEN-" (symbol-name foo-char-p))
                   in-package-of)
           (implies (,foo-char-p ,x)
                    (characterp ,x))
           :rule-classes :compound-recognizer))

       (defsection ,foo-chars
         :parents (,foo-char-p)
         :short ,(cat "A character set for <see topic='" foo-char-p-url "'>"
                      (str::downcase-string (symbol-name foo-char-p)) "</see>.")

         (local (defund ,make-foo-chars (n)
                  (declare (xargs :guard (and (natp n)
                                              (< n 256))
                                  :ruler-extenders :all))
                  (logior (if (,foo-char-p (code-char n))
                              (ash 1 n)
                            0)
                          (if (zp n)
                              0
                            (,make-foo-chars (- n 1))))))

         (make-event
          (let ((foo-chars ',foo-chars)
                (charset   (,make-foo-chars 255)))
            `(defund-inline ,foo-chars ()
               (declare (xargs :guard t))
               ,charset)))

         (in-theory (disable (:e ,foo-chars)
                             (:t ,foo-chars)
                             (:e ,foo-char-p)
                             (:e char-in-charset-p)
                             (:e code-in-charset-p)
                             (:e code-char)
                             (:e char-code)
                             (:e <)))

         (defthm ,(intern-in-package-of-symbol
                   (cat "CHARSET-P-OF-" (symbol-name foo-chars))
                   in-package-of)
           (charset-p (,foo-chars))
           :hints(("Goal" :in-theory (enable ,foo-chars charset-p))))

         (local (defun defcharset-tester (n)
                  (declare (xargs :ruler-extenders :all))
                  (and (equal (code-in-charset-p n (,foo-chars))
                              (,foo-char-p (code-char n)))
                       (or (zp n)
                           (defcharset-tester (- n 1))))))

         (local (defthmd defcharset-lemma1
                  (implies (and (natp n)
                                (natp i)
                                (<= i n)
                                (defcharset-tester n))
                           (equal (code-in-charset-p i (,foo-chars))
                                  (,foo-char-p (code-char i))))
                  :hints(("Goal"
                          :induct (defcharset-tester n)))))

         (local (defthmd defcharset-lemma2
                  (implies (and (natp i)
                                (<= i 255))
                           (equal (code-in-charset-p i (,foo-chars))
                                  (,foo-char-p (code-char i))))
                  :hints(("Goal" :use ((:instance defcharset-lemma1
                                                  (i i) (n 255)))))))

         (defthm ,(intern-in-package-of-symbol
                   (cat "CHAR-IN-CHARSET-P-OF-" (symbol-name foo-chars))
                   in-package-of)
           (equal (char-in-charset-p ,x (,foo-chars))
                  (,foo-char-p ,x))
           :hints(("Goal"
                   :in-theory (enable code-in-charset-p)
                   :use ((:instance defcharset-lemma2
                                    (i (char-code x))))))))

       (deflist ,foo-charlist-p (,x)
         (,foo-char-p ,x)
         :guard t
         :parents (,foo-char-p)
         :rest ((defthm ,(intern-in-package-of-symbol
                          (cat "CHARS-IN-CHARSET-P-OF-" (symbol-name foo-chars))
                          in-package-of)
                  (equal (chars-in-charset-p ,x (,foo-chars))
                         (,foo-charlist-p ,x))
                  :hints(("Goal" :induct (len ,x)))))))))

(local (progn

;; Some unit tests

(include-book "str/digitp" :dir :system)

(defcharset whitespace
  (or (eql x #\Newline)
      (eql x #\Space)
      (eql x #\Tab)))

(defcharset nondigit (not (str::digitp x)))

(defcharset any t)

(defcharset no nil)

))
