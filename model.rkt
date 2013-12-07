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
                        sprites            ;; [Listof ???]
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

;; An Egg is a (egg Num String Date Date [Listof String])
;; Represents a pokemon egg group
(define-struct egg (id
                    name
                    modified
                    created
                    pokemon))

;; A Pokedex is a (Pokedex String Date Date [Listof String])
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

;; A Description is a (description Num String Date Date [Listof String] String)
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