#lang racket
(require redex/reduction-semantics)
(provide (all-defined-out))

(define-language ares
  (expression
   (assign-op expression ...)
   (binary-op expression ...)
   constant
   identifier)

  (assign-op = +=)

  (binary-op + - * /)

  (constant number)

  (identifier
   variable-not-otherwise-mentioned)
  )

; (1 + (a - (b * (c / d))))
(redex-match
 ares
 expression
 (term (+ 1 (- a (* b (/ c d)))))
 )

; (+= a b)
(redex-match
 ares
 expression
 (term (+= a b))
 )
