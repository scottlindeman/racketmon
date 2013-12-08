#lang racket

(require "request.rkt" "model.rkt")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ABSTRACT UTIL FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Resource [Resource -> [Pairof String Num]] String -> [Pairof String Num] | #f
(define (resource-findf resource resource-fn name)
  (let ([down-name (string-downcase name)])
    (findf
     (lambda (p) (equal? (string-downcase (car p)) down-name))
     (resource-fn resource #:see-all #t))))

;; ResourceType Resource [Resource -> [Pairof String Num]] String -> Resource | #f
(define (resource-get resource-type resource resource-fn name)
  (let ([pair (resource-findf resource resource-fn name)])
    (if pair (get resource-type #:id (cdr pair)) pair)))

;; [Pairof String Num] | #f -> Boolean 
(define (has-helper result)
  (if result #t result))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; POKEMON FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Pokemon String -> Boolean
;; Determines whether the given pokemon can use the given move 
(define (has-move? pokemon move-name)
  (has-helper (resource-findf pokemon pokemon-moves move-name)))

;; Pokemon String -> Boolean
;; Determines whether the given pokemon can use the given ability 
(define (has-ability? pokemon ability-name)
  (has-helper (resource-findf pokemon pokemon-abilities ability-name)))

;; Pokemon String -> Boolean
;; Determines whether the given pokemon is of the given type
(define (has-type? pokemon type-name)
  (has-helper (resource-findf pokemon pokemon-types type-name)))

;; Pokemon String -> Move
;; Gets the given move if the pokemon can use the given move
(define (get-move pokemon move-name)
  (resource-get 'move pokemon pokemon-moves move-name))

;; Pokemon String -> Ability
;; Gets the given ability if the pokemon can use the given ability
(define (get-ability pokemon ability-name)
  (resource-get 'ability pokemon pokemon-abilities ability-name))

;; Pokemon String -> Type
;; Gets the given type if the pokemon can use the given type
(define (get-type pokemon type-name)
  (resource-get 'type pokemon pokemon-types type-name))