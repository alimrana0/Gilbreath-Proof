; ****************** BEGIN INITIALIZATION FOR ACL2s MODE ****************** ;
; (Nothing to see here!  Your actual file is after this initialization code);
(make-event
 (er-progn
  (set-deferred-ttag-notes t state)
  (value '(value-triple :invisible))))

#+acl2s-startup (er-progn (assign fmt-error-msg "Problem loading the CCG book.~%Please choose \"Recertify ACL2s system books\" under the ACL2s menu and retry after successful recertification.") (value :invisible))
(include-book "acl2s/ccg/ccg" :uncertified-okp nil :dir :system :ttags ((:ccg)) :load-compiled-file nil);v4.0 change

;Common base theory for all modes.
#+acl2s-startup (er-progn (assign fmt-error-msg "Problem loading ACL2s base theory book.~%Please choose \"Recertify ACL2s system books\" under the ACL2s menu and retry after successful recertification.") (value :invisible))
(include-book "acl2s/base-theory" :dir :system :ttags :all)


#+acl2s-startup (er-progn (assign fmt-error-msg "Problem loading ACL2s customizations book.~%Please choose \"Recertify ACL2s system books\" under the ACL2s menu and retry after successful recertification.") (value :invisible))
(include-book "acl2s/custom" :dir :system :ttags :all)

;; guard-checking-on is in *protected-system-state-globals* so any
;; changes are reverted back to what they were if you try setting this
;; with make-event. So, in order to avoid the use of progn! and trust
;; tags (which would not have been a big deal) in custom.lisp, I
;; decided to add this here.
;; 
;; How to check (f-get-global 'guard-checking-on state)
;; (acl2::set-guard-checking :nowarn)
(acl2::set-guard-checking :all)

;Settings common to all ACL2s modes
(acl2s-common-settings)
;(acl2::xdoc acl2s::defunc) ;; 3 seconds is too much time to spare -- commenting out [2015-02-01 Sun]

#+acl2s-startup (er-progn (assign fmt-error-msg "Problem loading ACL2s customizations book.~%Please choose \"Recertify ACL2s system books\" under the ACL2s menu and retry after successful recertification.") (value :invisible))
(include-book "acl2s/acl2s-sigs" :dir :system :ttags :all)

#+acl2s-startup (er-progn (assign fmt-error-msg "Problem setting up ACL2s mode.") (value :invisible))

(acl2::xdoc acl2s::defunc) ; almost 3 seconds

; Non-events:
;(set-guard-checking :none)

(set-inhibit-warnings! "Invariant-risk" "theory")

(in-package "ACL2")
(redef+)
(defun print-ttag-note (val active-book-name include-bookp deferred-p state)
  (declare (xargs :stobjs state)
	   (ignore val active-book-name include-bookp deferred-p))
  state)

(defun print-deferred-ttag-notes-summary (state)
  (declare (xargs :stobjs state))
  state)

(defun notify-on-defttag (val active-book-name include-bookp state)
  (declare (xargs :stobjs state)
	   (ignore val active-book-name include-bookp))
  state)
(redef-)

(acl2::in-package "ACL2S")

; ******************* END INITIALIZATION FOR ACL2s MODE ******************* ;
;$ACL2s-SMode$;ACL2s
(defdata lon (listof nat))
(defdata los (listof symbol))
(defdata n-or-s (oneof nat symbol))
(defdata lo-n-or-s (listof n-or-s))


(definec len2 (x :tl) :nat
  (if (endp x)
      0
    (+ 1 (len2 (rest x)))))

(definec app2 (a :tl b :tl) :tl
  (if (endp a)
      b
    (cons (first a) (app2 (rest a) b))))

(definec rev2 (x :tl) :tl
  (if (endp x)
      nil
    (app2 (rev2 (rest x)) (list (first x)))))

(definec interleave (x :tl y :tl) :tl
  (cond ((endp x) y)
        ((endp y) nil)
        (t (cons (car x) (cons (car y) (interleave (cdr x) (cdr y)))))))

(check= (interleave (list 1 1) (list 0 0))
        (list 1 0 1 0))



(definec everyotherp (ls :all symb :bool) :bool
  (if (tlp ls)
    (cond
     ((endp ls) t)
     (symb (and (symbolp (car ls)) (everyotherp (cdr ls) nil)))
     ((not symb) (and (rationalp (car ls)) (everyotherp (cdr ls) t))))
    nil))
   


(check= (everyotherp (interleave '(A B C D E) '(1 2 3 4 5)) t)  t)


(defthm lemma-1
  (implies (losp ls)
           (losp (rev2 ls))))


(defthm conjecture-1-simp
  (implies (and (lonp x)
                (losp y)
                (equal (len2 x) (len2 y)))
           (everyotherp (interleave x y) nil)))

(defthm y-rev2-y-equivalence
  (implies (and (lonp x)
                (losp y)
                (losp (rev2 y))
                (equal (len2 x) (len2 y)))
           (equal (everyotherp (interleave x y) nil)
                  (everyotherp (interleave x (rev2 y)) nil)))
  :hints (("Goal"
           :use (:instance conjecture-1-simp (x x) (y (rev2 y))))))




(defthm conjecture-1
  (implies (and 
            (lonp x) 
            (losp y)
            (equal (len2 x) (len2 y)))
           (everyotherp (interleave x y) nil))
  :rule-classes ((:rewrite))
  :hints (("Goal"
           :in-theory (disable conjecture-1-simp)
           :use (:instance conjecture-1-simp (x x) (y y))
           )))#|ACL2s-ToDo-Line|#

  


