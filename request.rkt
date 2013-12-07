#lang racket

(require net/url json)
(require "models.rkt")

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

; A POKENUM is one of:
; - NUMPOKEMON
; - NUMABILITY
; - NUMTYPE 
; - NUMMOVE
; - NUMEGG

; A Resource is one of:
; - 'pokemon
; - 'ability
; - 'type
; - 'move
; - 'egg

(define BASE-URL "http://www.pokeapi.co/api/v1/")

;; An APIURI is one of:
(define POKE-URL "pokemon/")
(define ABIL-URL "ability/")
(define TYPE-URL "type/")
(define MOVE-URL "move/")
(define EGG-URL  "egg/")

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
(define (egg-url num) (create-api-url EGG-URL num))

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

;; NUMEGG -> JsExpr
;; Retrieves the JSON data from the rest call for egg data
(define (call/egg num) (make-call egg-url num))

(define (get resource-type #:id [id #f] #:name [name #f])
  (define rid (cond [id id]
                    [name name]
                    [else 0]))
  (cond [(symbol=? resource-type 'pokemon)
         (create-pokemon (call/pokemon rid))]
        [else void]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CONVERSION FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (jsexpr-name h)
  (hash-ref h 'name))

(define (create-pokemon jsexpr)
  (pokemon (hash-ref jsexpr 'national_id)
           (hash-ref jsexpr 'pkdx_id)
           (hash-ref jsexpr 'name)
           (hash-ref jsexpr 'modified)
           (hash-ref jsexpr 'created)
           (hash-ref jsexpr 'exp)
           (hash-ref jsexpr 'height)
           (map jsexpr-name (hash-ref jsexpr 'types))
           (map jsexpr-name (hash-ref jsexpr 'abilities))
           (hash-ref jsexpr 'attack)
           (hash-ref jsexpr 'defense)
           (hash-ref jsexpr 'sp_atk)
           (hash-ref jsexpr 'sp_def)
           (hash-ref jsexpr 'catch_rate)
           (hash-ref jsexpr 'egg_cycles)
           (map jsexpr-name (hash-ref jsexpr 'egg_groups))
           (hash-ref jsexpr 'ev_yield)
           (create-evolution (hash-ref jsexpr 'evolutions))
           (hash-ref jsexpr 'growth_rate)
           (hash-ref jsexpr 'happiness)
           (hash-ref jsexpr 'hp)
           (hash-ref jsexpr 'male_female_ratio)
           (map jsexpr-name (hash-ref jsexpr 'moves))
           (hash-ref jsexpr 'species)
           (hash-ref jsexpr 'speed)
           (hash-ref jsexpr 'sprites) ;; Not sure what to do for sprites
           (hash-ref jsexpr 'total)
           (hash-ref jsexpr 'weight)))

(define (create-evolution jsexpr)
  (evolution (hash-ref jsexpr 'method)
             (hash-ref jsexpr 'level)
             (hash-ref jsexpr 'to)))