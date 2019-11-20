#lang racket/base


(require gregor
         racket/contract)

(provide current-date
         current-datetime
         current-moment
         current-datetime/utc current-moment/utc
         (contract-out [->utc-offset/hours (-> moment? number?)]))


(define (current-date) (today))

(define (current-datetime #:tz [tz (current-timezone)])
  (now #:tz tz))

(define (current-moment #:tz [tz (current-timezone)])
  (now/moment #:tz tz))

(define (current-datetime/utc)
  (now/utc))
(define (current-moment/utc)
  (now/moment/utc))

(define (->utc-offset/hours moment)
  (let ([secs (->utc-offset moment)])
    (if (= secs 0)
        0
        (/ secs 3600))))