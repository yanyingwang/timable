#lang info
(define collection "timeless")
(define deps '("base" "srfi" "gregor" "db"))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib"))
(define scribblings '(("scribblings/timeless.scrbl" ())))
(define pkg-desc "extend srfi 19/time")
(define version "0.1")
(define pkg-authors '(yanyingwang))
