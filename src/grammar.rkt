#lang racket
(require redex/reduction-semantics)
(provide (all-defined-out))

(define-language ares
  (type
   int
   bool)

  (env ([x type] env)
       ())

  (expression ::=
              true
              false
              integer
              identifier
              (assign-op expression expression)
              (oror-op expression expression)
              (andand-op expression expression)
              (xor-op expression expression)
              (and-op expression expression)
              (equal-op expression expression)
              (shift-op expression expression)
              (add-op expression expression)
              (mul-op expression expression)
              (unary-op expression expression)
              (pow-op expression expression))

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
 expression
 (term (+= a b)))

; (a || b)
(redex-match
 ares
 expression
 (term (|| a b)))

; (a && b)
(redex-match
 ares
 expression
 (term (&& a b)))

; (a ^ b)
(redex-match
 ares
 expression
 (term (^ a b)))

; (a & b)
(redex-match
 ares
 expression
 (term (& a b)))

; (a == b)
(redex-match
 ares
 expression
 (term (== a b)))

; (a << b)
(redex-match
 ares
 expression
 (term (<< a b)))

; (a + b)
(redex-match
 ares
 expression
 (term (+ a b)))

; (a * b)
(redex-match
 ares
 expression
 (term (* a b)))

; (a ^^ b)
(redex-match
 ares
 expression
 (term (^^ a b)))


(define-judgment-form ares
  #:mode (types I I O)
  #:contract (types env expression type)

  [(types env expression_1 int)
   (types env expression_2 int)
   ----------------------------
   (types env (add-op expression_1 expression_2) int)]
  [(types env expression_1 int)
   (types env expression_2 int)
   ----------------------------
   (types env (equal-op expression_1 expression_2) bool)]
  [(types env expression_1 bool)
   (types env expression_2 bool)
   ----------------------------
   (types env (equal-op expression_1 expression_2) bool)]
  [------------------------
   (types env integer int)]
  [---------------------
   (types env true bool)]
  [----------------------
   (types env false bool)])

(test-equal
 (judgment-holds
  (types ()
         (+ 1 1)
         type)
  type)
 '(int))

(test-equal
 (judgment-holds
  (types ()
         (+ true 1)
         type)
  type)
 '())

(test-equal
 (judgment-holds
  (types ()
         (== 1 1)
         type)
  type)
 '(bool))

(test-equal
 (judgment-holds
  (types ()
         (== true false)
         type)
  type)
 '(bool))
