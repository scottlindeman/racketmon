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
(define DESC-URL "description")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; URL CREATION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; APIURI POKENUM -> URL
;; Creates a URL for the specified api call
(define (create-api-url uri num)
  (string->url (string-append BASE-URL uri (number->string num) "/")))

;; NUMPOKEMON -> URL
;; Creates a URL structure for the given NUMPOKEMON
(define (pokemon-url num) (create-api-url POKE-URL num))

;; NUMABILITY -> URL
;; Creates a URL structure for the given NUMABILITY
(define (ability-url num) (create-api-url ABIL-URL num))

;; NUMTYPE -> URL
;; Creates a URL structure for the given NUMTYPE
(define (type-url num) (create-api-url TYPE-URL num))

;; NUMMOVE -> URL
;; Creates a URL structure for the given NUMMOVE
(define (move-url num) (create-api-url MOVE-URL num))

;; NUMEGG -> URL
;; Creates a URL structure for the given NUMEGG
(define (egg-url num) (create-api-url EGGG-URL num))

;; NUMPOKEDEX -> URL
;; Creates a URL structure for the given NUMPOKEDEX
(define (pokedex-url num) (create-api-url PKDX-URL num))

;; NUMSPRITE -> URL
;; Creates a URL structure for the given NUMSPRITE
(define (sprite-url num) (create-api-url SPRT-URL num))

;; NUMGAME -> URL
;; Creates a URL structure for the given NUMGAME
(define (game-url num) (create-api-url GAME-URL num))

;; NUMDESCRIPTION -> URL
;; Creates a URL structure for the given NUMDESCRIPTION
(define (description-url num) (create-api-url DESC-URL num))

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

;; [POKENUM -> JsExpr] POKENUM -> JsExpr
;; Applies the given url function
(define (make-call url-fn num)
  (let ([url (url-fn num)])
    (call/input-url url
                    get-pure-port
                    port-handler)))

;; NUMPOKEMON -> JsExpr
;; Retrieves the JSON data from the rest call for pokemon data
(define (call/pokemon num) (make-call pokemon-url num))

;; NUMABILITY -> JsExpr
;; Retrieves the JSON data from the rest call for ability data
(define (call/ability num) (make-call ability-url num))

;; NUMTYPE -> JsExpr
;; Retrieves the JSON data from the rest call for type data
(define (call/type num) (make-call type-url num))

;; NUMMOVE -> JsExpr
;; Retrieves the JSON data from the rest call for move data
(define (call/move num) (make-call move-url num))

;; NUMEGG -> JsExpr
;; Retrieves the JSON data from the rest call for egg data
(define (call/egg num) (make-call egg-url num))

;; NUMPOKEDEX -> JsExpr
;; Retrieves the JSON data from the rest call for pokedex data
(define (call/pokedex num) (make-call pokedex-url num))

;; NUMSPRITE -> JsExpr
;; Retrieves the JSON data from the rest call for sprite data
(define (call/sprite num) (make-call sprite-url num))

;; NUMGAME -> JsExpr
;; Retrieves the JSON data from the rest call for game data
(define (call/game num) (make-call game-url num))

;; NUMDESCRIPTION -> JsExpr
;; Retrieves the JSON data from the rest call for description data
(define (call/description num) (make-call description-url num))

;; ResourceType ?POKENUM? ?NAMEPOKEMON? -> Resource
(define (get resource-type #:id [id #f] #:name [name #f])
  (define rid (cond [id id]
                    [name name]
                    [else 0]))
  (cond [(symbol=? resource-type 'pokemon) (create-pokemon (call/pokemon rid))]
        [(symbol=? resource-type 'move)    (create-move (call/move rid))]
        [(symbol=? resource-type 'ability) (create-ability (call/ability rid))]
        [(symbol=? resource-type 'type)    (create-type (call/type rid))]
        [(symbol=? resource-type 'egg)     (create-egg (call/egg rid))]
        [(symbol=? resource-type 'pokedex) (create-pokedex (call/pokedex rid))]
        [else void]))

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
        (map jsexpr-name (hash-ref jsexpr 'ineffective))
        (map jsexpr-name (hash-ref jsexpr 'no_effect))
        (map jsexpr-name (hash-ref jsexpr 'super_effective))
        (map jsexpr-name (hash-ref jsexpr 'weakness))))

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