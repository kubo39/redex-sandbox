#lang racket
(require redex/reduction-semantics)
(provide (all-defined-out))

(define-language ares
  (e
   (+ e ...)
   (- e ...)
   (* e ...)
   (/ e ...)
   number
   x
   )
  (x variable-not-otherwise-mentioned)
  )

; (1 + (a - (b * (c / d))))
(redex-match
 ares
 e
 (term (+ 1 (- a (* b (/ c d)))))
 )
