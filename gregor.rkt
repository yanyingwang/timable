#lang racket/base


(require gregor
         racket/contract)

(provide current-date
         current-datetime
         current-moment
         current-datetime/utc current-moment/utc
         years-ago days-ago hours-ago
         years-ago/utc days-ago/utc hours-ago/utc
         years-from-now days-from-now hours-from-now
         years-from-now/utc days-from-now/utc hours-from-now/utc
         prev-day prev-month
         next-month
         at-beginning/month at-end/month
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

;; refactor with define-syntax and add more seconds-ago nano-seconds-ago and from-now
(define (years-ago i #:tz [tz (current-timezone)])
  (-years (now #:tz tz) i))
(define (days-ago i #:tz [tz (current-timezone)])
  (-days (now #:tz tz) i))
(define (hours-ago i #:tz [tz (current-timezone)])
  (-hours (now #:tz tz) i))

(define (years-ago/utc i)
  (-years (now/utc) i))
(define (days-ago/utc i)
  (-days (now/utc) i))
(define (hours-ago/utc i)
  (-hours (now/utc) i))

(define (years-from-now i #:tz [tz (current-timezone)])
  (+years (now #:tz tz) i))
(define (days-from-now i #:tz [tz (current-timezone)])
  (+days (now/utc #:tz tz) i))
(define (hours-from-now i #:tz [tz (current-timezone)])
  (+hours (now #:tz tz) i))

(define (years-from-now/utc i)
  (+years (now/utc) i))
(define (days-from-now/utc i)
  (+days (now/utc) i))
(define (hours-from-now/utc i)
  (+hours (now/utc) i))

(define (prev-day d)
  (let* ([year (->year d)]
         [month (->month d)]
         [day (->day d)]
         [pmonth (if (= month 1)
                     12
                     (- month 1))]
         [nmonth (if (= day 1) pmonth month)]
         [nday (if (= day 1) (days-in-month year pmonth) (- day 1))])
    (datetime year nmonth nday (->hours d) (->minutes d) (->seconds d) (->nanoseconds d))))

(define (prev-month d)
  (let* ([year (->year d)]
         [month (->month d)]
         [day (->day d)]
         [nmonth (if (= month 1)
                     12
                     (- month 1))]
         [days-nmonth (days-in-month year nmonth)]
         [nday (if (> day days-nmonth)
                   days-nmonth
                   day)])
    (datetime year nmonth nday (->hours d) (->minutes d) (->seconds d) (->nanoseconds d))))
(define (next-month d)
  (let* ([year (->year d)]
         [month (->month d)]
         [day (->day d)]
         [nmonth (if (= month 12)
                     1
                     (+ month 1))]
         [days-nmonth (days-in-month year nmonth)]
         [nday (if (> day days-nmonth)
                   days-nmonth
                   day)])
    (datetime year nmonth nday (->hours d) (->minutes d) (->seconds d) (->nanoseconds d))))

(define (at-beginning/month d)
  (datetime (->year d) (->month d) 1 (->hours d) (->minutes d) (->seconds d) (->nanoseconds d)))
(define (at-end/month d)
  (datetime (->year d) (->month d) (days-in-month (->year d) (->month d)) 23 59 59 999999999))

(module+ test
  (require rackunit)
  ;; Any code in this `test` submodule runs when this file is run using DrRacket
  ;; or with `raco test`. The code here does not run when this file is
  ;; required by another module.

  ;; (check-equal? (date-day (current-date))
  ;;               (+ 1 (date-day (days-ago 1))))
  ;; (check-equal? (date-hour (current-date))
  ;;               (+ 1 (date-hour (hours-ago 1))))

  ;; ;; from-now
  ;; (check-equal? (date->string (current-date) "~4")
  ;;               (date->string (time-utc->date (make-time time-utc 0 (- (time-second (hours-from-now/time 1)) 3600))) "~4"))
  ;; (check-equal? (date->string (current-date) "~4")
  ;;               (date->string (time-utc->date (make-time time-utc 0 (- (time-second (days-from-now/time 1)) 86400))) "~4"))

  ;; (check-equal? (date-day (current-date))
  ;;               (- (date-day (days-from-now 1)) 1))
  ;; (check-equal? (date-hour (current-date))
  ;;               (- (date-hour (hours-from-now 1)) 1))


  ;; prev-day
  (check-equal? (~t (prev-day (datetime 2016 3 1)) "y-M-d")
                "2016-2-29")
  (check-equal? (~t (prev-day (datetime 2017 3 1)) "y-M-d")
                "2016-2-28")
  (check-equal? (~t (prev-day (datetime 2017 4 1)) "y-M-d")
                "2016-3-31")
  (check-equal? (~t (prev-day (datetime 2017 5 1)) "y-M-d")
                "2016-4-30")
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
  (check-equal? (at-beginning/month (make-date 2019 2 14))
                (datetime 2019 2 14 8 40 50 1))
  ;; (check-equal? (beginning-date/year (make-date 1 1 1 1 10 05 2019 0))
  ;;               (make-date 0 0 0 0 1 1 2019 0))

  ;; (check-equal? (last-oclock (make-date 1 1 1 1 10 05 2019 0))
  ;;               (make-date 0 0 0 1 10 05 2019 0))

  ;; (check-equal? (length (oclocks-between (make-date 1 1 1 1 05 05 2019 0)
  ;;                                        (make-date 1 1 1 5 05 05 2019 0))) 5)


  ;; at-end/month
  #;(check-equal? (end-date/day (make-date 123456 50 40 12 14 02 2016 0))
                  (make-date 9999999 59 59 23 14 02 2016 0))

  (check-equal? (at-end/month (datetime 2016 2 14 12 40 50 1))
                (datetime 2016 2 29 23 59 59 999999999))
  (check-equal? (at-end/month (datetime 2019 2 14 12 40 50 1))
                (datetime 2019 2 23 23 59 59 999999999))

  #;(check-equal? (end-date/month (make-date 123456 50 40 12 14 03 2016 0))
                  (make-date 9999999 59 59 23 31 03 2016 0))
  #;(check-equal? (end-date/month (make-date 123456 50 40 12 14 04 2016 0))
                  (make-date 9999999 59 59 23 30 04 2016 0))

  )