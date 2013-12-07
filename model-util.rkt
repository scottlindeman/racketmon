#lang racket

(require "request.rkt" "model.rkt")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; POKEMON FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Pokemon String -> Boolean
;; Determines whether the given pokemon can use the given move 
(define (has-move? pokemon move-name)
  (let ([mv-name (string-downcase move-name)])
  (findf 
   (lambda (m) (equal? (string-downcase (car m)) mv-name))
   (pokemon-moves pokemon))))

;; Pokemon String -> Move
;; Gets the given move
(define (get-move pokemon move-name)
  (let ([poke-move (has-move? pokemon move-name)])
    (if poke-move
        (get 'move #:id (cdr poke-move))
        poke-move)))