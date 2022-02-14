#lang racket
(require redex/reduction-semantics)
(provide (all-defined-out))

(define-language ares
  (expression
   assign-expression)

  (assign-expression
   (conditional-expression assign-op assign-expression)
   conditional-expression)

  (conditional-expression
   oror-expression)

  (oror-expression
   andand-expression
   (oror-expression oror-op andand-expression))

  (andand-expression
   or-expression
   (andand-expression andand-op or-expression))

  ; currently or-expression is not implemented.
  (or-expression
   xor-expression)
   ;; (| or-expression xor-expression))

  (xor-expression
   and-expression
   (xor-expression xor-op and-expression))

  (and-expression
   cmp-expression
   (and-expression and-op cmp-expression))

  (cmp-expression
   equal-expression
   shift-expression)

  (equal-expression
   (shift-expression equal-op shift-expression))

  (shift-expression
   add-expression
   (shift-expression shift-op add-expression))

  (add-expression
   mul-expression
   (add-expression add-op mul-expression))

  (mul-expression
   unary-expression
   (mul-expression mul-op unary-expression))

  (unary-expression
   (unary-op unary-expression)
   pow-expression)

  (pow-expression
   postfix-expression
   (postfix-expression pow-op unary-expression))

  (postfix-expression
   primary-expression)

  (primary-expression
   constant
   identifier)

  (assign-op = +=)
  (oror-op ||)
  (andand-op &&)
  (xor-op ^)
  (and-op &)
  (equal-op == !=)
  (shift-op << >>)
  (add-op + -)
  (mul-op * / &)
  (unary-op & ++ -- * - + !)
  (pow-op ^^)

  (constant number)

  (identifier
   variable-not-otherwise-mentioned)
  )

;; ; (1 + (a - (b * (c / d))))
;; (redex-match
;;  ares
;;  add-expression
;;  (term (+ 1 (- a (* b (/ c d)))))
;;  )

; (a += b)
(redex-match
 ares
 assign-expression
 (term (a += b))
 )

; (a || b)
(redex-match
 ares
 oror-expression
 (term (a || b))
 )

; (a && b)
(redex-match
 ares
 andand-expression
 (term (a && b))
 )

; (a ^ b)
(redex-match
 ares
 xor-expression
 (term (a ^ b))
 )

; (a & b)
(redex-match
 ares
 and-expression
 (term (a & b))
 )

; (a == b)
(redex-match
 ares
 equal-expression
 (term (a == b))
 )

; (a << b)
(redex-match
 ares
 shift-expression
 (term (a << b)))

; (a + b)
(redex-match
 ares
 add-expression
 (term (a + b))
 )

; (a * b)
(redex-match
 ares
 mul-expression
 (term (a * b))
 )

; (a ^^ b)
(redex-match
 ares
 pow-expression
 (term (a ^^ b))
 )
