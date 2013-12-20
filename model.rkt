#lang racket

(provide (all-defined-out))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  RESOURCES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; The follow structure definitions represent the resources available to get from
; the pokeapi API. They are as follows:
; - Pokemon
; - Move
; - Ability
; - Type
; - Egg
; - Pokedex
; - Sprite
; - Game
; - Description

;; A Pokemon is a (pokemon arg arg ...)
;; Represents a pokemon
(define-struct pokemon (national-id        ;; Num
                        pokedex-id         ;; Num
                        name               ;; String
                        modified           ;; Date
                        created            ;; Date
                        exp                ;; Num
                        height             ;; String
                        types              ;; [Listof [Pairof String Num]]
                        abilities          ;; [Listof [Pairof String Num]]
                        attack             ;; Num
                        defense            ;; Num
                        sp-attack          ;; Num
                        sp-defense         ;; Num
                        catch-rate         ;; Num
                        egg-cycles         ;; Num
                        egg-groups         ;; [Listof [Pairof String Num]]
                        ev-yield           ;; String
                        evolutions         ;; [Listof Evloution]
                        growth-rate        ;; String
                        happiness          ;; Num
                        hp                 ;; Num
                        male-female-ratio  ;; String
                        moves              ;; [Listof [Pairof String Num]]
                        species            ;; String
                        speed              ;; Num
                        sprites            ;; [Listof [Pairof String Num]] Not necessarily unique string
                        total              ;; Num
                        weight))           ;; String

;; A Move is a (move Num String Date Date Num String String Num Num)
;; Represents a pokemon move
(define-struct move (id
                     name
                     modified
                     created
                     accuracy
                     category
                     description
                     power
                     pp))

;; An Ability is a (ability Num String Date Date String)
;; Represents a pokemon ability
(define-struct ability (id
                        name
                        modified
                        created
                        description))

;; A Type is a (type Num String Date Date
;;                   [Listof String] [Listof String] [Listof String] [Listof String])
;; Represents a pokemon type
(define-struct type (id
                     name
                     modified
                     created
                     ineffective
                     no-effect
                     super-effective
                     weakness))

;; An Egg is a (egg Num String Date Date [Listof [Pairof String Num]])
;; Represents a pokemon egg group
(define-struct egg (id
                    name
                    modified
                    created
                    pokemon))

;; A Pokedex is a (Pokedex String Date Date [Listof [Pairof String Num]])
;; Represents the pokedex, listing of all pokemon
(define-struct pokedex (name
                        modified
                        created
                        pokemon))

;; A Sprite is a (sprite Num String Date Date String)
;; Contains the uri to the image for the pokemon
(define-struct sprite (id
                       name
                       modified
                       created
                       pokemon
                       image))

;; A Game is a (game Num String Date Date)
;; Represents a pokemon game
(define-struct game (id
                     name
                     modified
                     created))

;; A Description is a (description Num String Date Date [Listof [Pairof String Num]] String)
;; Represents a pokemon description
(define-struct description (id
                            name
                            modified
                            created
                            games
                            pokemon))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; NON-RESOURCES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; An Evolution is a (evolution String Num String)
;; Represents the evolution of a pokemon
(define-struct evolution (method level to))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; OVERLOADING
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; The next definitions override automatically created structure functions to
;; hide implementation details

;; [Resource -> [Listof [Pair String Num]]] Boolean -> [Listof [Pairof String Num]] | [Listof String]
;; Determines whether to show the id's next to the resource names or not
(define (pair-overload fn)
  (lambda (r #:see-all [see-all #f])
    (if see-all (fn r) (map car (fn r)))))

;; Macro that defines a function that is the original of the function name passed in
(define-syntax (hide-pair stx)
  (syntax-case stx ()
    [(hide-pair name)
     (let ([make-id 
            (lambda (template . ids)
              (let ([str (apply format template (map syntax->datum ids))])
                (datum->syntax stx (string->symbol str))))])
       (with-syntax ([o-name (make-id "o-~a" #'name)]
                     [name (make-id "~a" #'name)])
         #'(begin
             (define o-name name))))]))

;; POKEMON
(hide-pair "pokemon-moves")
(set! pokemon-moves (pair-overload o-pokemon-moves))

(hide-pair "pokemon-types")
(set! pokemon-types (pair-overload o-pokemon-types))

(hide-pair "pokemon-abilities")
(set! pokemon-abilities (pair-overload o-pokemon-abilities))

(hide-pair "pokemon-egg-groups")
(set! pokemon-egg-groups (pair-overload o-pokemon-egg-groups))

(hide-pair "pokemon-sprites")
(set! pokemon-sprites (pair-overload o-pokemon-sprites))

;; TYPE
(hide-pair "type-ineffective")
(set! type-ineffective (pair-overload o-type-ineffective))

(hide-pair "type-no-effect")
(set! type-no-effect (pair-overload o-type-no-effect))

(hide-pair "type-super-effective")
(set! type-super-effective (pair-overload o-type-super-effective))

(hide-pair "type-weakness")
(set! type-weakness (pair-overload o-type-weakness))

;; EGG
(hide-pair "egg-pokemon")
(set! egg-pokemon (pair-overload o-egg-pokemon))

;; POKEDEX
(hide-pair "pokedex-pokemon")
(set! pokedex-pokemon (pair-overload o-pokedex-pokemon))

;; DESCRIPTION
(hide-pair "description-games")
(set! description-games (pair-overload o-description-games))