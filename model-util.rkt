#lang racket

(require "request.rkt" "model.rkt")

(provide (except-out (all-defined-out)
                     resource-findf
                     resource-get
                     has-helper)
         (all-from-out "request.rkt" "model.rkt"))

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

;; HAS
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

;; Pokemon String -> Boolean
;; Determines whether the given pokemon is in the given egg group
(define (has-egg-group? pokemon egg-name)
  (has-helper (resource-findf pokemon pokemon-egg-groups egg-name)))

;; Pokemon String -> Boolean
;; Determines whether the given pokemon is connected to the given sprite name
(define (has-sprite? pokemon sprite-name #:id [id 0])
  (has-helper 
   (if (> id 0)
       (findf (lambda (p) (equal? (cdr p) id))
              (pokemon-sprites pokemon #:see-all #t))
       (resource-findf pokemon pokemon-sprites sprite-name))))

;; GET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Pokemon String -> Move | #f
;; Gets the given move if the pokemon can use the given move
(define (get-move pokemon move-name)
  (resource-get 'move pokemon pokemon-moves move-name))

;; Pokemon String -> Ability | #f
;; Gets the given ability if the pokemon can use the given ability
(define (get-ability pokemon ability-name)
  (resource-get 'ability pokemon pokemon-abilities ability-name))

;; Pokemon String -> Type | #f
;; Gets the given type if the pokemon can use the given type
(define (get-type pokemon type-name)
  (resource-get 'type pokemon pokemon-types type-name))

;; Pokemon String -> Egg | #f
;; Gets the given type if the pokemon is in the given egg group
(define (get-egg-group pokemon egg-name)
  (resource-get 'egg pokemon pokemon-egg-groups egg-name))

;; Pokemon String -> Sprite | #f
;; Gets the given type if the pokemon is associated with the given sprite
(define (get-sprite pokemon sprite-name #:id [id 0])
  (if (> id 0)
      (get 'sprite #:id id)
      (resource-get 'sprite pokemon pokemon-sprites sprite-name)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; TYPE FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; HAS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Type String -> Boolean
;; Determines whether the given type is ineffective against the type name 
(define (has-ineffective? type type-name)
  (has-helper (resource-findf type type-ineffective type-name)))

;; Type String -> Boolean
;; Determines whether the given type no-effect against the type name 
(define (has-no-effect? type type-name)
  (has-helper (resource-findf type type-no-effect type-name)))

;; Type String -> Boolean
;; Determines whether the given type is super-effective against the type name 
(define (has-super-effective? type type-name)
  (has-helper (resource-findf type type-super-effective type-name)))

;; Type String -> Boolean
;; Determines whether the given type is weak against the type name 
(define (has-weakness? type type-name)
  (has-helper (resource-findf type type-weakness type-name)))

;; GET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Type String -> Type | #f
;; Gets the given move if the type is ineffective against the given type name
(define (get-ineffective type type-name)
  (resource-get 'type type type-ineffective type-name))

;; Type String -> Type | #f
;; Gets the given move if the type has no-effect against the given type name
(define (get-no-effect type type-name)
  (resource-get 'type type type-no-effect type-name))

;; Type String -> Type | #f
;; Gets the given move if the type is super-effective against the given type name
(define (get-super-effective type type-name)
  (resource-get 'type type type-super-effective type-name))

;; Type String -> Type | #f
;; Gets the given move if the type is weak against the given type name
(define (get-weakness type type-name)
  (resource-get 'type type type-weakness type-name))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EGG & POKEDEX FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; HAS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (Egg | Pokedex) String -> Boolean
;; Determines whether the given egg group has the given pokemon name 
(define (has-pokemon? resource pokemon-name)
  (let ([fn (if (egg? resource) egg-pokemon pokedex-pokemon)])
    (has-helper (resource-findf resource fn pokemon-name))))
;; GET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (Egg | Pokedex) String -> Pokemon | #f
;; Gets the given move if the type is ineffective against the given type name
(define (get-pokemon resource pokemon-name)
  (let* ([fn (if (egg? resource) egg-pokemon pokedex-pokemon)]
         [pair (resource-findf resource fn pokemon-name)])
    (has-helper
     (if (pair)
         (get 'pokemon #:name pokemon-name)
         #f))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DESCRIPTION FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; HAS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Description String -> Boolean
;; Determines whether the given description is from the given game name 
(define (has-game? description game-name)
  (has-helper (resource-findf description description-games game-name)))
;; GET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Description String -> Game | #f
;; Gets the given move if the type is ineffective against the given type name
(define (get-game description game-name)
  (resource-get 'game description description-games game-name))
