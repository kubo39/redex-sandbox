#lang racket
(require redex/reduction-semantics)
(provide (all-defined-out))

(define-language ares
  (type
   int
   bool)

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
   true
   false
   integer
   identifier
   (expression))

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

  (identifier
   variable-not-otherwise-mentioned)
  )

;; ; (1 + (a - (b * (c / d))))
;; (redex-match
;;  ares
;;  expression
;;  (term (1 + (a - (b * (c / d))))
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

(define-judgment-form ares
  #:mode (types I O)
  #:contract (types expression type)

  [(types expression_1 int)
   (types expression_2 int)
   ----------------------------
   (types (expression_1 add-op expression_2) int)]
  [(types expression_1 int)
   (types expression_2 int)
   ----------------------------
   (types (expression_1 equal-op expression_2) bool)]
  [(types expression_1 bool)
   (types expression_2 bool)
   ----------------------------
   (types (expression_1 equal-op expression_2) bool)]
  [------------------------
   (types integer int)]
  [---------------------
   (types true bool)]
  [----------------------
   (types false bool)])

(test-equal
 (judgment-holds
  (types
   (1 + 1)
   type)
  type)
 '(int))

(test-equal
 (judgment-holds
  (types
   (true + 1)
   type)
  type)
 '())

(test-equal
 (judgment-holds
  (types
   (1 == 1)
   type)
  type)
 '(bool))

(test-equal
 (judgment-holds
  (types
   (true == false)
   type)
  type)
 '(bool))
