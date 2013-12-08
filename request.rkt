#lang racket

(require net/url json)
(require "model.rkt")

(provide get)

; http://www.pokeapi.co/api/v1/
;
; pokemon/NUMPOKEMON
; Where NUMPOKEMON is a Num and 1 <= NUMPOKEMON <= 718
; -OR-
; pokemon/NAMEPOKEMON
; Where NAMEPOKEMON is the name of a pokemon
;
; ability/NUMABILITY
; Where NUMABILITY is a Num and 1 <= NUMBAILITY <= 248
;
; type/NUMTYPE
; Where NUMTYPE is a Num and 1 <= NUMTYPE <= 18
;
; move/NUMMOVE
; Where NUMMOVE is a Num and 1 <= NUMMOVE <= 650
;
; egg/NUMEGG
; Where NUMEGG is a Num and 1 <= NUMEGG <= 15
;
; pokedex/NUMPOKEDEX
; Where NUMPOKEDEX is a Num and 1 == NUMPOKEDEX
;
; sprite/NUMSPRITE
; Where NUMSPRITE is a Num and 1 <= NUMSPRITE <= 719
;
; game/NUMGAME
; Where NUMGAME is a Num and 1 <= NUMGAME <= 25
;
; description/NUMDESCRIPTION
; Where NUMDESCRIPTION is a Num and 1 == NUMDESCRIPTION (for now)

; A POKENUM is one of:
; - NUMPOKEMON
; - NUMABILITY
; - NUMTYPE 
; - NUMMOVE
; - NUMEGG
; - NUMPOKEDEX
; - NUMSPRITE
; - NUMGAME
; - NUMDESCRIPTION

; A ResourceType is one of:
; - 'pokemon
; - 'ability
; - 'type
; - 'move
; - 'egg
; - 'pokedex
; - 'sprite
; - 'game
; - 'description

(define BASE-URL "http://www.pokeapi.co/api/v1/")

;; An APIURI is one of:
(define POKE-URL "pokemon/")
(define ABIL-URL "ability/")
(define TYPE-URL "type/")
(define MOVE-URL "move/")
(define EGGG-URL  "egg/")
(define PKDX-URL "pokedex/")
(define SPRT-URL "sprite/")
(define GAME-URL "game/")
(define DESC-URL "description/")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; URL CREATION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; APIURI (POKENUM | NAMEPOKEMON) -> URL
;; Creates a URL for the specified api call
(define (create-api-url uri id)
  (string->url (string-append BASE-URL uri 
                              (cond [(number? id) (number->string id)]
                                    [(string? id) id]
                                    [else "0"])
                              "/")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAKING REQUESTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; input-port -> JsExpr | #f
;; Given a port, if the port can be read into a json then the json is returned
(define (port-handler port)
  (let ([data (read-json port)])
    (if (jsexpr? data)
        data
        #f)))

;; APIURL (POKENUM | NAMEPOKEMON) -> JsExpr | #f
;; Makes the request to the server
(define (call/resource r-url id)
  (let ([url (create-api-url r-url id)])
    (call/input-url url
                    get-pure-port
                    port-handler)))

;; APIURL (POKENUM | NAMEPOKEMON) [JsExpr -> Resource] -> Resource | #f
;; Handles the result of the request to the server and turns it into the proper
;; Resource
(define (make-call r-url num create-fn)
  (let ([result (call/resource r-url num)])
    (if result (create-fn result) result)))

;; ResourceType POKENUM -> Resource | #f
(define (get-by-id resource-type id)
  (cond
    [(symbol=? resource-type 'pokemon) (make-call POKE-URL id create-pokemon)]
    [(symbol=? resource-type 'move)    (make-call MOVE-URL id create-move)]
    [(symbol=? resource-type 'ability) (make-call ABIL-URL id create-ability)]
    [(symbol=? resource-type 'type)    (make-call TYPE-URL id create-type)]
    [(symbol=? resource-type 'egg)     (make-call EGGG-URL id create-egg)]
    [(symbol=? resource-type 'pokedex) (make-call PKDX-URL id create-pokedex)]
    [else #f]))

;; ResourceType ?POKENUM? ?NAMEPOKEMON? -> Resource | #f
(define (get resource-type #:id [id #f] #:name [name #f])
  (cond [id (get-by-id resource-type id)]
        [name (make-call POKE-URL name create-pokemon)]
        [else #f]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CONVERSION FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (jsexpr-name h)
  (hash-ref h 'name))

(define (name-pair h)
  (cons (jsexpr-name h)
        (string->number (last (string-split (hash-ref h 'resource_uri ) "/")))))

(define (create-pokemon jsexpr)
  (pokemon (hash-ref jsexpr 'national_id)
           (hash-ref jsexpr 'pkdx_id)
           (hash-ref jsexpr 'name)
           (hash-ref jsexpr 'modified)
           (hash-ref jsexpr 'created)
           (hash-ref jsexpr 'exp)
           (hash-ref jsexpr 'height)
           (map name-pair (hash-ref jsexpr 'types))
           (map name-pair (hash-ref jsexpr 'abilities))
           (hash-ref jsexpr 'attack)
           (hash-ref jsexpr 'defense)
           (hash-ref jsexpr 'sp_atk)
           (hash-ref jsexpr 'sp_def)
           (hash-ref jsexpr 'catch_rate)
           (hash-ref jsexpr 'egg_cycles)
           (map name-pair (hash-ref jsexpr 'egg_groups))
           (hash-ref jsexpr 'ev_yield)
           (map create-evolution (hash-ref jsexpr 'evolutions))
           (hash-ref jsexpr 'growth_rate)
           (hash-ref jsexpr 'happiness)
           (hash-ref jsexpr 'hp)
           (hash-ref jsexpr 'male_female_ratio)
           (map name-pair (hash-ref jsexpr 'moves))
           (hash-ref jsexpr 'species)
           (hash-ref jsexpr 'speed)
           (hash-ref jsexpr 'sprites) ;; Not sure what to do for sprites
           (hash-ref jsexpr 'total)
           (hash-ref jsexpr 'weight)))

(define (create-move jsexpr)
  (move (hash-ref jsexpr 'id)
        (hash-ref jsexpr 'name)
        (hash-ref jsexpr 'modified)
        (hash-ref jsexpr 'created)
        (hash-ref jsexpr 'accuracy)
        (hash-ref jsexpr 'category)
        (hash-ref jsexpr 'description)
        (hash-ref jsexpr 'power)
        (hash-ref jsexpr 'pp)))

(define (create-ability jsexpr)
  (ability (hash-ref jsexpr 'id)
           (hash-ref jsexpr 'name)
           (hash-ref jsexpr 'modified)
           (hash-ref jsexpr 'created)
           (hash-ref jsexpr 'description)))

(define (create-type jsexpr)
  (type (hash-ref jsexpr 'id)
        (hash-ref jsexpr 'name)
        (hash-ref jsexpr 'modified)
        (hash-ref jsexpr 'created)
        (map name-pair (hash-ref jsexpr 'ineffective))
        (map name-pair (hash-ref jsexpr 'no_effect))
        (map name-pair (hash-ref jsexpr 'super_effective))
        (map name-pair (hash-ref jsexpr 'weakness))))

(define (create-egg jsexpr)
  (egg (hash-ref jsexpr 'id)
       (hash-ref jsexpr 'name)
       (hash-ref jsexpr 'modified)
       (hash-ref jsexpr 'created)
       (map jsexpr-name (hash-ref jsexpr 'pokemon))))

(define (create-pokedex jsexpr)
  (pokedex (hash-ref jsexpr 'name)
           (hash-ref jsexpr 'modified)
           (hash-ref jsexpr 'created)
           (map jsexpr-name (hash-ref jsexpr 'pokemon))))

(define (create-sprite jsexpr)
  (sprite (hash-ref jsexpr 'id)
          (hash-ref jsexpr 'name)
          (hash-ref jsexpr 'modified)
          (hash-ref jsexpr 'created)
          (jsexpr-name (hash-ref jsexpr 'pokemon))
          (hash-ref jsexpr 'image)))

(define (create-game jsexpr)
  (game (hash-ref jsexpr 'id)
        (hash-ref jsexpr 'name)
        (hash-ref jsexpr 'modified)
        (hash-ref jsexpr 'created)))

(define (create-description jsexpr)
  (description (hash-ref jsexpr 'id)
               (hash-ref jsexpr 'name)
               (hash-ref jsexpr 'modified)
               (hash-ref jsexpr 'created)
               (hash-ref jsexpr 'games)
               (hash-ref jsexpr 'pokemon)))

(define (create-evolution jsexpr)
  (evolution (hash-ref jsexpr 'method)
             (hash-ref jsexpr 'level)
             (hash-ref jsexpr 'to)))