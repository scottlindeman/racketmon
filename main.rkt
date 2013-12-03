#lang racket

(require net/url json)

; http://www.pokeapi.co/api/v1/
;
; pokemon/NUMPOKEMON
; Where NUMPOKEMON is a Num and 1 <= NUMPOKEMON <= 718
;
; ability/NUMABILITY
; Where NUMABILITY is a Num and 1 <= NUMBAILITY <= 248
;
; type/NUMTYPE
; Where NUMTYPE is a Num and 1 <= NUMTYPE <= 18
;
; move/NUMMOVE
; Where NUMMOVE is a Num and 1 <= NUMMOVE <= 650

; A POKENUM is one of:
; - NUMPOKEMON
; - NUMABILITY
; - NUMTYPE 
; - NUMMOVE

(define BASE-URL "http://www.pokeapi.co/api/v1/")

;; An APIURI is one of:
(define POKE-URL "pokemon/")
(define ABIL-URL "ability/")
(define TYPE-URL "type/")
(define MOVE-URL "move/")

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

;; input-port -> JsExpr | #f
;; Given a port, if the port can be read into a json then the json is returned
(define (poke-port port)
  (let ([data (read-json port)])
    (if (jsexpr? data)
        data
        #f)))

;; NUMPOKEMON -> JsExpr
;; Retrieves the JSON data from the rest call for pokemon data
(define (call/pokemon num)
  (let ([url (pokemon-url num)])
    (call/input-url url
                    get-pure-port
                    poke-port)))