; Standard IO Library
; read-file-characters.lisp -- originally part of the Unicode library
; Copyright (C) 2005-2013 Kookamara LLC
;
; Contact:
;
;   Kookamara LLC
;   11410 Windermere Meadows
;   Austin, TX 78759, USA
;   http://www.kookamara.com/
;
; License: (An MIT/X11-style license)
;
;   Permission is hereby granted, free of charge, to any person obtaining a
;   copy of this software and associated documentation files (the "Software"),
;   to deal in the Software without restriction, including without limitation
;   the rights to use, copy, modify, merge, publish, distribute, sublicense,
;   and/or sell copies of the Software, and to permit persons to whom the
;   Software is furnished to do so, subject to the following conditions:
;
;   The above copyright notice and this permission notice shall be included in
;   all copies or substantial portions of the Software.
;
;   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
;   FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
;   DEALINGS IN THE SOFTWARE.
;
; Original author: Jared Davis <jared@kookamara.com>

(in-package "ACL2")
(include-book "file-measure")
(include-book "std/lists/list-defuns" :dir :system)
(include-book "std/strings/char-fix" :dir :system)
(include-book "std/strings/cat" :dir :system)
(local (include-book "base"))
(local (include-book "std/lists/rev" :dir :system))
(local (include-book "std/lists/append" :dir :system))
(local (include-book "std/lists/revappend" :dir :system))
(local (include-book "tools/mv-nth" :dir :system))
(local (include-book "std/typed-lists/character-listp" :dir :system))
(set-state-ok t)

(define tr-read-char$-all ((channel symbolp)
                           (state)
                           (acc))
  :guard (open-input-channel-p channel :character state)
  :measure (file-measure channel state)
  :parents (read-char$-all)
  (b* (((unless (mbt (state-p state)))
        (mv acc state))
       ((mv char state) (read-char$ channel state))
       ((unless char)
        (mv acc state))
       (acc (cons (mbe :logic (str::char-fix char) :exec char) acc)))
    (tr-read-char$-all channel state acc)))

(define read-char$-all ((channel symbolp) state)
  :guard (open-input-channel-p channel :character state)
  :measure (file-measure channel state)
  :parents (read-file-characters)
  :short "@(call read-char$-all) reads all remaining characters from a file."
  :long "<p>This is the main loop inside @(see read-file-characters).  It reads
everything in the file, but doesn't handle opening or closing the file.</p>"
  :verify-guards nil
  (mbe :logic
       (b* (((unless (state-p state))
             (mv nil state))
            ((mv char state) (read-char$ channel state))
            ((unless char)
             (mv nil state))
            ((mv rest state) (read-char$-all channel state)))
         (mv (cons (str::char-fix char) rest) state))
       :exec
       (b* (((mv contents state)
             (tr-read-char$-all channel state nil)))
         (mv (reverse contents) state)))
  ///
  (local (in-theory (enable tr-read-char$-all
                            read-char$-all)))

  (local (defthm lemma-decompose-impl
           (equal (tr-read-char$-all channel state acc)
                  (list (mv-nth 0 (tr-read-char$-all channel state acc))
                        (mv-nth 1 (tr-read-char$-all channel state acc))))
           :rule-classes nil))

  (local (defthm lemma-decompose-spec
           (equal (read-char$-all channel state)
                  (list (mv-nth 0 (read-char$-all channel state))
                        (mv-nth 1 (read-char$-all channel state))))
           :rule-classes nil))

  (local (defthm lemma-data-equiv
           (equal (mv-nth 0 (tr-read-char$-all channel state acc))
                  (revappend (mv-nth 0 (read-char$-all channel state)) acc))))

  (local (defthm lemma-state-equiv
           (equal (mv-nth 1 (tr-read-char$-all channel state acc))
                  (mv-nth 1 (read-char$-all channel state)))))

  (defthm true-listp-of-read-char$-all
    (true-listp (mv-nth 0 (read-char$-all channel state)))
    :rule-classes :type-prescription)

  (defthm tr-read-char$-all-removal
    (equal (tr-read-char$-all channel state nil)
           (mv (rev (mv-nth 0 (read-char$-all channel state)))
               (mv-nth 1 (read-char$-all channel state))))
    :hints(("Goal" :in-theory (disable tr-read-char$-all read-char$-all)
            :use ((:instance lemma-decompose-impl (acc nil))
                  (:instance lemma-decompose-spec)
                  (:instance lemma-data-equiv (acc nil))))))

  (verify-guards read-char$-all)

  (defthm state-p1-of-read-char$-all
    (implies (and (force (state-p1 state))
                  (force (symbolp channel))
                  (force (open-input-channel-p1 channel :character state)))
             (state-p1 (mv-nth 1 (read-char$-all channel state)))))

  (defthm open-input-channel-p1-of-read-char$-all
    (implies (and (force (state-p1 state))
                  (force (symbolp channel))
                  (force (open-input-channel-p1 channel :character state)))
             (open-input-channel-p1 channel
                                    :character
                                    (mv-nth 1 (read-char$-all channel state)))))

  (defthm character-listp-of-read-char$-all
    (character-listp (mv-nth 0 (read-char$-all channel state)))))



(define read-file-characters ((filename stringp) (state))
  :returns (mv (errmsg/contents
                "On success: a @(see character-listp) that contains all the
                 characters in the file.  On failure, e.g., perhaps
                 @('filename') does not exist, a @(see stringp) saying that we
                 failed to open the file.")
               state)
  :parents (std/io)
  :short "Read an entire file into a @(see character-listp)."

  (b* ((filename (mbe :logic (if (stringp filename) filename "")
                      :exec filename))
       ((mv channel state)
        (open-input-channel filename :character state))
       ((unless channel)
        (mv (concatenate 'string "Error opening file " filename) state))
       ((mv contents state)
        (read-char$-all channel state))
       (state (close-input-channel channel state)))
    (mv contents state))
  ///
  (local (in-theory (enable read-file-characters)))

  (defthm state-p1-of-read-file-characters
    (implies (force (state-p1 state))
             (state-p1 (mv-nth 1 (read-file-characters filename state)))))

  (defthm character-listp-of-read-file-characters
    (let ((contents (mv-nth 0 (read-file-characters filename state))))
      (equal (character-listp contents)
             (not (stringp contents)))))

  (defthm type-of-read-file-characters
    (or (true-listp (mv-nth 0 (read-file-characters filename state)))
        (stringp (mv-nth 0 (read-file-characters filename state))))
    :rule-classes :type-prescription))


(define read-file-characters-rev ((filename stringp)
                                  (state))
  :returns (mv errmsg/contents state)
  :parents (std/io)
  :short "Read an entire file into a @(see character-listp), but in reverse
order!"

  :long "<p>This goofy function is just like @(see read-file-characters) except
that the characters are returned in reverse.</p>

<p>This is faster than @('read-file-characters') because we avoid the cost of
reversing the accumulator, and thus require half as many conses.</p>

<p>Note: that we just leave this function enabled.  Logically it's just the
reverse of @(see read-file-characters).</p>"
  :enabled t
  :prepwork ((local (in-theory (enable read-file-characters))))

  (mbe :logic
       (b* (((mv contents state)
             (read-file-characters filename state)))
         (if (stringp contents)
             ;; Error reading file
             (mv contents state)
           (mv (rev contents) state)))
       :exec
       (b* (((mv channel state)
             (open-input-channel filename :character state))
            ((unless channel)
             (mv (concatenate 'string "Error opening file " filename) state))
            ((mv contents state)
             (tr-read-char$-all channel state nil))
            (state (close-input-channel channel state)))
         (mv contents state))))


(define read-file-as-string ((filename stringp)
                             (state))
  :returns (mv (contents/nil (or (stringp contents/nil) (not contents/nil))
                             :rule-classes :type-prescription
                             "On success: the entire contents of the file as
                              an ordinary string.  On failure, e.g., because
                              @('filename') does not exist: @('nil').")
               (state))
  :parents (std/io)
  :long "<p>This is just a wrapper around @(see read-file-characters).  We
leave it enabled.</p>"
  :enabled t
  (mbe :logic
       (b* (((mv chars state) (read-file-characters filename state)))
         (mv (and (not (stringp chars))
                  (implode chars))
             state))
       :exec
       (b* (((mv rchars state) (read-file-characters-rev filename state)))
         (mv (and (not (stringp rchars))
                  (str::rchars-to-string rchars))
             state))))
