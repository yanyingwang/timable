#lang racket/base


(require gregor
         racket/contract)

(provide current-date
         current-datetime
         current-datetime-tz
         current-moment
         (contract-out [->utc-offset/hours (-> moment? number?)]))


(define (current-date) (today))
(define (current-datetime) (now))
(define (current-datetime-tz) (now/moment))
(define (current-moment) (now/moment))

(define (->utc-offset/hours moment)
  (let ([secs (->utc-offset moment)])
    (if (= secs 0)
        0
        (/ secs 3600))))