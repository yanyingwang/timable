#lang info

(define collection "timable")
(define deps '("base" "srfi" "gregor" "db"))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib"))
(define scribblings '(("scribblings/timable.scrbl" ())))
(define pkg-desc "extend racket's various time libs and make them be able to work together more smoothly.")
(define version "0.2")
(define pkg-authors '("Yanying Wang"))
