#lang racket/base

(require racket/contract
         gregor
         (only-in db
                  sql-date
                  sql-date?
                  sql-timestamp
                  sql-timestamp?)
         (file "./gregor.rkt")
         (only-in srfi/19 [date? srfi-date?])
         db/util/datetime)


(provide (contract-out [date->sql-date (-> date? sql-date?)]
                       [date->sql-timestamp (-> date? sql-timestamp?)]
                       [datetime->sql-timestamp (-> datetime? sql-timestamp?)]
                       [moment->sql-timestamp (-> moment? sql-timestamp?)]
                       [->sql-timestamp (-> (or/c srfi-date? date? moment? datetime?) sql-timestamp?)]
                       [current-datetime/sql (-> sql-timestamp?)]
                       [current-moment/sql (-> sql-timestamp?)]
                       [current-date/sql (-> sql-date?)])
         now/sql
         now/moment/sql
         today/sql
         datetime-tz->sql-timestamp)

(define (date->sql-date gregor-d)
  (sql-date (->year gregor-d)
            (->month gregor-d)
            (->day gregor-d)))

(define (date->sql-timestamp gregor-d)
  (sql-timestamp (->year gregor-d)
                 (->month gregor-d)
                 (->day gregor-d)
                 0
                 0
                 0
                 0
                 #f))

(define (datetime->sql-timestamp gregor-d)
  (sql-timestamp (->year gregor-d)
                 (->month gregor-d)
                 (->day gregor-d)
                 (->hours gregor-d)
                 (->minutes gregor-d)
                 (->seconds gregor-d)
                 (->nanoseconds gregor-d)
                 #f))

(define (moment->sql-timestamp gregor-d)
  (sql-timestamp (->year gregor-d)
                 (->month gregor-d)
                 (->day gregor-d)
                 (->hours gregor-d)
                 (->minutes gregor-d)
                 (->seconds gregor-d)
                 (->nanoseconds gregor-d)
                 (->utc-offset/hours gregor-d)))
(define (datetime-tz->sql-timestamp) (moment->sql-timestamp))

(define (->sql-timestamp d)
  (cond
    [(srfi-date? d) (srfi-date->sql-timestamp d)]
    [(date? d) (date->sql-timestamp d)]
    [(datetime? d) (datetime->sql-timestamp d)]
    [(moment? d) (moment->sql-timestamp d)]))



(define (current-datetime/sql)
  (datetime->sql-timestamp (current-datetime)))
(define (now/sql)
  (current-datetime/sql))

(define (current-moment/sql #:tz [tz (current-timezone)])
  (moment->sql-timestamp (current-moment #:tz tz)))
(define (now/moment/sql #:tz [tz (current-timezone)])
  (current-moment/sql))

(define (current-date/sql)
  (date->sql-date (today)))
(define (today/sql)
  (current-date/sql))