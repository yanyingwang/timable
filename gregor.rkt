#lang racket/base


(require gregor
         (only-in racket/list
                  first
                  second
                  third
                  fourth
                  fifth
                  sixth
                  seventh)
         racket/string
         racket/contract
         racket/format)

(provide current-date
         current-datetime
         current-moment
         current-datetime/utc current-moment/utc
         years-ago months-ago days-ago hours-ago
         years-ago/utc months-ago/utc days-ago/utc hours-ago/utc
         years-from-now months-from-now days-from-now hours-from-now
         years-from-now/utc months-from-now/utc days-from-now/utc hours-from-now/utc
         prev-day next-day
         prev-month next-month
         prev-year next-year
         at-beginning/on-day at-end/on-day
         at-beginning/on-month at-end/on-month
         at-beginning/on-year at-end/on-year
         (contract-out [->utc-offset/hours (-> moment? number?)])
         (contract-out [parse/datetime (-> string? datetime?)])
         )


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

;; refactor with define-syntax and add more seconds-ago nano-seconds-ago and from-now
(define (years-ago i #:tz [tz (current-timezone)])
  (-years (now #:tz tz) i))
(define (months-ago i #:tz [tz (current-timezone)])
  (-months (now #:tz tz) i))
(define (days-ago i #:tz [tz (current-timezone)])
  (-days (now #:tz tz) i))
(define (hours-ago i #:tz [tz (current-timezone)])
  (-hours (now #:tz tz) i))

(define (years-ago/utc i)
  (-years (now/utc) i))
(define (months-ago/utc i)
  (-months (now/utc) i))
(define (days-ago/utc i)
  (-days (now/utc) i))
(define (hours-ago/utc i)
  (-hours (now/utc) i))

(define (years-from-now i #:tz [tz (current-timezone)])
  (+years (now #:tz tz) i))
(define (months-from-now i #:tz [tz (current-timezone)])
  (+months (now #:tz tz) i))
(define (days-from-now i #:tz [tz (current-timezone)])
  (+days (now #:tz tz) i))
(define (hours-from-now i #:tz [tz (current-timezone)])
  (+hours (now #:tz tz) i))

(define (years-from-now/utc i)
  (+years (now/utc) i))
(define (months-from-now/utc i)
  (+months (now/utc) i))
(define (days-from-now/utc i)
  (+days (now/utc) i))
(define (hours-from-now/utc i)
  (+hours (now/utc) i))

(define (prev-day d)
  (-days d 1))
(define (next-day d)
  (+days d 1))

(define (prev-month d)
  (-months d 1))
(define (next-month d)
  (+months d 1))

(define (prev-year d)
  (-years d 1))
(define (next-year d)
  (+years d 1))


(define (at-beginning/on-day d)
  (cond
    [(datetime? d)
    (datetime (->year d) (->month d) (->day d) 0 0 0 0)]
    [(moment? d)
     (moment (->year d) (->month d) (->day d) 0 0 0 0 #:tz (->utc-offset d))]
    [else (raise-argument-error 'at-beginning/on-day "(or datetime? moment?)") d]))
(define (at-end/on-day d)
  [cond
    [(datetime? d)
    (datetime (->year d) (->month d) (->day d) 23 59 59 999999999)]
    [(moment? d)
     (moment (->year d) (->month d) (->day d) 23 59 59 999999999 #:tz (->utc-offset d))]
    [else (raise-argument-error 'at-beginning/on-day "(or datetime? moment?)") d]])

(define (at-beginning/on-month d)
  (cond
    [(date? d)
     (date (->year d) (->month d) 1 0 0 0 0)]
    [(datetime? d)
     (datetime (->year d) (->month d) 1 0 0 0 0)]
    [(moment? d)
     (moment (->year d) (->month d) 1 0 0 0 0 #:tz (->utc-offset d))]
    [else (raise-argument-error 'at-beginning/on-day "(or date? datetime? moment?)") d]))

(define (at-end/on-month d)
  (cond
    [(date? d)
     (date (->year d) (->month d) (days-in-month (->year d) (->month d)))]
    [(datetime? d)
     (datetime (->year d) (->month d) (days-in-month (->year d) (->month d)) 23 59 59 999999999)]
    [(moment? d)
     (moment (->year d) (->month d) (days-in-month (->year d) (->month d)) 23 59 59 999999999 #:tz (->utc-offset d))]
    [else (raise-argument-error 'at-beginning/on-day "(or date? datetime? moment?)") d]))

(define (at-beginning/on-year d)
  (cond
    [(date? d)
     (date (->year d) 1 1)]
    [(datetime? d)
     (datetime (->year d) 1 1 0 0 0 0)]
    [(moment? d)
     (moment (->year d) 1 1 0 0 0 0 #:tz (->utc-offset d))]
    [else (raise-argument-error 'at-beginning/on-day "(or date? datetime? moment?)") d]))
(define (at-end/on-year d)
  (cond
    [(date? d)
     (date (->year d) 12 (days-in-month (->year d) 12))]
    [(datetime? d)
     (datetime (->year d) 12 (days-in-month (->year d) 12) 23 59 59 999999999)]
    [(moment? d)
     (datetime (->year d) 12 (days-in-month (->year d) 12) 23 59 59 999999999 #:tz (->utc-offset d))]
    [else (raise-argument-error 'at-beginning/on-day "(or date? datetime? moment?)") d]))



(define (parse/datetime str)
  (let* ([t-list (string-split (regexp-replace* #rx"(\\s|/|-|_|:|T)" str " ") " ")]
         [tz-str (findf (lambda (e)
                          (or (string-prefix? (string-trim e) "+")
                              (string-prefix? (string-trim e) "-")))
                        t-list)]
         [t-len (if tz-str
                    (- (length t-list) 1)
                    (length t-list))])
    (datetime (if (>= t-len 1)
                  (string->number (let ([year (first t-list)])
                                    (if (string-prefix? str "-")
                                        (~a '- year)
                                        year))) ; year
                  1970)
              (if (>= t-len 2) ; month
                  (string->number (second t-list))
                  01)
              (if (>= t-len 3) ; day
                  (string->number (third t-list))
                  01)
              (if (>= t-len 4) ; hour
                  (string->number (fourth t-list))
                  00)
              (if (>= t-len 5) ; minute
                  (string->number (fifth t-list))
                  00)
              (if (>= t-len 6) ; second
                  (string->number (sixth t-list))
                  00)
              (if (>= t-len 7) ; nanosecond
                  (string->number (seventh t-list))
                  00000000))))




;; ------------------------------------------------------------
(module+ test
  (require rackunit)
  ;; Any code in this `test` submodule runs when this file is run using DrRacket
  ;; or with `raco test`. The code here does not run when this file is
  ;; required by another module.

  (check-equal?
   (->day (today))
   (->day (+days (days-ago 1) 1)))

  (check-equal?
   (->hours (now))
   (->hours (+hours (hours-ago 1) 1)))

  ;; from-now
  (check-equal? (->day (today))
                (->day (-days (days-from-now 1) 1)))
  (check-equal? (->hours (now))
                (->hours (-hours (hours-from-now 1) 1)))


  ;; prev-day
  (check-equal? (~t (prev-day (datetime 2016 3 1)) "y-M-d")
                "2016-2-29")
  (check-equal? (~t (prev-day (datetime 2017 3 1)) "y-M-d")
                "2017-2-28")
  (check-equal? (~t (prev-day (datetime 2017 4 1)) "y-M-d")
                "2017-3-31")
  (check-equal? (~t (prev-day (datetime 2017 5 1)) "y-M-d")
                "2017-4-30")
  ;; prev-month
  (check-equal? (~t (prev-month (datetime 2017 2 14)) "y-M-d")
                "2017-1-14")
  (check-equal? (~t (prev-month (datetime 2016 3 31)) "y-M-d")
                "2016-2-29")
  (check-equal? (~t (prev-month (datetime 2017 3 31)) "y-M-d")
                "2017-2-28")
  (check-equal? (~t (prev-month (datetime 2017 7 31)) "y-M-d")
                "2017-6-30")

  ;; at-beginning/month
  ;; (check-equal? (beginning-date (make-date 1 1 1 1 10 05 2019 0))
  ;;               (make-date 0 0 0 0 10 05 2019 0))
  (check-equal? (at-beginning/on-month (datetime 2019 2 14 12 40 50 1))
                (datetime 2019 2 1 0 0 0 0))
  ;; (check-equal? (beginning-date/year (make-date 1 1 1 1 10 05 2019 0))
  ;;               (make-date 0 0 0 0 1 1 2019 0))

  ;; (check-equal? (last-oclock (make-date 1 1 1 1 10 05 2019 0))
  ;;               (make-date 0 0 0 1 10 05 2019 0))

  ;; (check-equal? (length (oclocks-between (make-date 1 1 1 1 05 05 2019 0)
  ;;                                        (make-date 1 1 1 5 05 05 2019 0))) 5)


  ;; at-end/month
  #;(check-equal? (end-date/day (make-date 123456 50 40 12 14 02 2016 0))
                  (make-date 9999999 59 59 23 14 02 2016 0))

  (check-equal? (at-end/on-month (datetime 2016 2 14 12 40 50 1))
                (datetime 2016 2 29 23 59 59 999999999))
  (check-equal? (at-end/on-month (datetime 2019 2 14 12 40 50 1))
                (datetime 2019 2 28 23 59 59 999999999))

  #;(check-equal? (end-date/month (make-date 123456 50 40 12 14 03 2016 0))
                  (make-date 9999999 59 59 23 31 03 2016 0))
  #;(check-equal? (end-date/month (make-date 123456 50 40 12 14 04 2016 0))
                  (make-date 9999999 59 59 23 30 04 2016 0))

  ;; parse/datetime
  (check-equal? (parse/datetime "2018-02-14 12:30:45") (datetime 2018 2 14 12 30 45))
  (check-equal? (parse/datetime "2018/02-14 12-30 45") (datetime 2018 2 14 12 30 45))
  (check-equal? (parse/datetime "-600/02-14 12-30 45") (datetime -600 2 14 12 30 45))

  )