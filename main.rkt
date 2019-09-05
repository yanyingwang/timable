#lang racket/base

(module+ test
  (require rackunit))

;; Notice
;; To install (from within the package directory):
;;   $ raco pkg install
;; To install (once uploaded to pkgs.racket-lang.org):
;;   $ raco pkg install <<name>>
;; To uninstall:
;;   $ raco pkg remove <<name>>
;; To view documentation:
;;   $ raco docs <<name>>
;;
;; For your convenience, we have included a LICENSE.txt file, which links to
;; the GNU Lesser General Public License.
;; If you would prefer to use a different license, replace LICENSE.txt with the
;; desired license.
;;
;; Some users like to add a `private/` directory, place auxiliary files there,
;; and require them in `main.rkt`.
;;
;; See the current version of the racket style guide here:
;; http://docs.racket-lang.org/style/index.html

;; Code here


(require srfi/19
         srfi/42
         (only-in gregor
                  days-in-month))

(provide beginning-date
         beginning-date/year
         beginning-date/month
         beginning-date/day
         epoch-time

         end-date
         end-date/day
         end-date/month
         end-date/year

         previous-date/day yesterday-date
         previous-date/month last-month-date

         parse-date

         hour-ago/time hour-ago/date hour-ago
         hours-ago/time hours-ago/date hours-ago

         day-ago/time hour-ago/date day-ago
         days-ago/time hours-ago/date days-ago

         hour-from-now/time hour-from-now/date hour-from-now
         hours-from-now/time hours-from-now/date hours-from-now

         day-from-now/time day-from-now/date day-from-now
         days-from-now/time days-from-now/date days-from-now

         date->how-many-days-ago

         time-in-range==? time-in-range=<>=?
         time-in-range? time-in-range<>?
         time-in-range=<>? time-in-range<>=?
         hour-duration day-duration

         last-oclock last-oclock/date last-oclock/time
         oclocks-between oclocks-between/date oclocks-between/time

         time-utc->date->string
         time-utc->string)


(define epoch-time (make-time time-utc 0 0))
(define epoch-date (make-date 0 ;nanosecond
                              0 ;second
                              0 ;minute
                              0 ;hour
                              1 ;day
                              1 ;month
                              1970
                              0))


(define time-in-range<>?
  (lambda (t t1 t2)
    (if (time<? t1 t2)
        (and (time>? t t1) (time<? t t2))
        (and (time>? t t2) (time<? t t1)))))
(define-syntax time-in-range? (make-rename-transformer #'time-in-range<>?))

(define (time-in-range=<>=? t t1 t2)
  (if (time<? t1 t2)
      (and (time>=? t t1) (time<=? t t2))
      (and (time>=? t t2) (time<=? t t1))))
(define-syntax time-in-range==? (make-rename-transformer #'time-in-range=<>=?))

(define (time-in-range=<>? t t1 t2)
  (if (time=? t1 t2)
      #t
      (if (time<? t1 t2)
          (and (time>=? t t1) (time<? t t2))
          (and (time>? t t2) (time<=? t t1)))))

(define (time-in-range<>=? t t1 t2)
  (if (time=? t1 t2)
      #t
      (if (time<? t1 t2)
          (and (time>? t t1) (time<=? t t2))
          (and (time>=? t t2) (time<? t t1)))))


(define (hour-duration i)
  (make-time time-duration 0 (* 3600 i)))
(define (day-duration i)
  (make-time time-duration 0 (* 86400 i)))

(define (hour-ago/time i)
  (subtract-duration (current-time) (hour-duration i)))
(define (day-ago/time i)
  (subtract-duration (current-time) (day-duration i)))
(define-syntax hours-ago/time (make-rename-transformer #'hour-ago/time))
(define-syntax days-ago/time (make-rename-transformer #'day-ago/time))

(define (hour-ago/date i)
  (time-utc->date (hours-ago/time i)))
(define (day-ago/date i)
  (time-utc->date (days-ago/time i)))
(define-syntax hours-ago/date (make-rename-transformer #'hour-ago/date))
(define-syntax days-ago/date (make-rename-transformer #'day-ago/date))

(define-syntax hour-ago (make-rename-transformer #'hour-ago/date))
(define-syntax day-ago (make-rename-transformer #'day-ago/date))
(define-syntax hours-ago (make-rename-transformer #'hour-ago))
(define-syntax days-ago (make-rename-transformer #'day-ago))

(define hour-from-now/time
  (lambda (i)
    (add-duration (current-time) (hour-duration i))))
(define day-from-now/time
  (lambda (i)
    (add-duration (current-time) (day-duration i))))
(define-syntax hours-from-now/time (make-rename-transformer #'hour-from-now/time))
(define-syntax days-from-now/time (make-rename-transformer #'day-from-now/time))

(define hour-from-now/date
  (lambda (i) (time-utc->date (hours-from-now/time i))))
(define day-from-now/date
  (lambda (i) (time-utc->date (days-from-now/time i))))
(define-syntax hours-from-now/date (make-rename-transformer #'hour-from-now/date))
(define-syntax days-from-now/date (make-rename-transformer #'day-from-now/date))

(define-syntax hour-from-now (make-rename-transformer #'hour-from-now/date))
(define-syntax day-from-now (make-rename-transformer #'day-from-now/date))
(define-syntax hours-from-now (make-rename-transformer #'hour-from-now))
(define-syntax days-from-now (make-rename-transformer #'day-from-now))

(define (beginning-date/day d)
  (make-date 0 ;nanosecond
             0 ;second
             0 ;minute
             0 ;hour
             (date-day d)
             (date-month d)
             (date-year d)
             (date-zone-offset d)))

(define (beginning-date/month d)
  (make-date 0 ;nanosecond
             0 ;second
             0 ;minute
             0 ;hour
             1 ;day
             (date-month d)
             (date-year d)
             (date-zone-offset d)))

(define (beginning-date/year d)
  (make-date 0 ;nanosecond
             0 ;second
             0 ;minute
             0 ;hour
             1 ;day
             1 ;month
             (date-year d)
             (date-zone-offset d)))
(define-syntax beginning-date (make-rename-transformer #'beginning-date/day))

(define (end-date/day d)
  (make-date 9999999 ;nanosecond
             59 ;second
             59 ;minute
             23 ;hour
             (date-day d)
             (date-month d)
             (date-year d)
             (date-zone-offset d)))
(define (end-date/month d)
  (make-date 9999999 ;nanosecond
             59 ;second
             59 ;minute
             23 ;hour
             (days-in-month (date-year d) (date-month d))
             (date-month d)
             (date-year d)
             (date-zone-offset d)))
(define (end-date/year d)
  (make-date 9999999 ;nanosecond
             59 ;second
             59 ;minute
             23 ;hour
             31
             12
             (date-year d)
             (date-zone-offset d)))
(define-syntax end-date (make-rename-transformer #'end-date/day))


(define (previous-date/day d)
  (let* [(day (date-day d))
         (month (date-month d))
         (pmonth (- month 1))
         (year (date-year d))]
    (make-date (date-nanosecond d) ;nanosecond
               (date-second d) ;second
               (date-minute d) ;minute
               (date-hour d) ;hour
               (if (= day 1) ; day
                   (days-in-month year pmonth)
                   (- day 1))
               (if (= day 1) ; month
                   pmonth
                   month)
               year ; year
               (date-zone-offset d))))
(define-syntax yesterday-date (make-rename-transformer #'previous-date/day))

(define (previous-date/month d)
  (let* ([day (date-day d)]
         [month (date-month d)]
         [year (date-year d)]
         [pmonth (if (= month 1)
                     12
                     (- month 1))]
         [days-pmonth (days-in-month year pmonth)])
    (make-date (date-nanosecond d) ;nanosecond
               (date-second d) ;second
               (date-minute d) ;minute
               (date-hour d) ;hour
               (if (> day days-pmonth) ; day
                   days-pmonth
                   day)
               pmonth ; month
               year ; year
               (date-zone-offset d))))
(define-syntax last-month-date (make-rename-transformer #'previous-date/month))

(define (parse-date str)
  (let* ([t-list (string-split (regexp-replace* #rx"(\\s|/|-|_|:|T)" str " ") " ")]
         [tz-str (findf (lambda (e)
                          (or (string-prefix? (string-trim e) "+")
                              (string-prefix? (string-trim e) "-")))
                        t-list)]
         [t-len (if tz-str
                    (- (length t-list) 1)
                    (length t-list))]
         [tz-offset (if tz-str
                        (let ([hour (string->number (findf (lambda (e) (member e (map (lambda (n) (number->string n)) (range 1 14))))
                                                           (string-split tz-str "")))])
                          (if (string-prefix? tz-str "-")
                              (- (* hour 3600))
                              (* hour 3600)))
                        (date-zone-offset (current-date)))])
    (make-date (if (>= t-len 7) ; nanosecond
                   (string->number (seventh t-list))
                   00000000)
               (if (>= t-len 6) ; second
                   (string->number (sixth t-list))
                   00)
               (if (>= t-len 5) ; minute
                   (string->number (fifth t-list))
                   00)
               (if (>= t-len 4) ; hour
                   (string->number (fourth t-list))
                   00)
               (if (>= t-len 3) ; day
                   (string->number (third t-list))
                   01)
               (if (>= t-len 2) ; month
                   (string->number (second t-list))
                   01)
               (if (>= t-len 1)
                   (string->number (first t-list)) ; year
                   1970)
               tz-offset)))


(define (last-oclock/date d)
  (make-date 0 ;;(date-nanosecond d)
             0 ;;(date-second d)
             0 ;;(date-minute d)
             (date-hour d)
             (date-day d)
             (date-month d)
             (date-year d)
             (date-zone-offset d)))
(define (last-oclock/time t)
  ;; todo: "(time-type t)->date"
  (date->time-utc (last-oclock/date (time-utc->date t))))
(define-syntax last-oclock (make-rename-transformer #'last-oclock/date))


(define date->how-many-days-ago
  (lambda (d)
    (round (- (current-julian-day)
              (date->julian-day d)))))


(define (oclocks-between/time t1 t2)
  (let ([start-time (last-oclock/time (if (time<? t1 t2) t1 t2))]
        [end-time (if (time>? t1 t2) t1 t2)])
    (list-ec (:do ((t start-time))
                  (time<? t end-time)
                  ((add-duration t (hour-duration 1))))
             t)))

(define (oclocks-between/date d1 d2)
  (map (lambda (t) (time-utc->date t))
       (oclocks-between/time (date->time-utc d1)
                             (date->time-utc d2))))
(define-syntax oclocks-between (make-rename-transformer #'oclocks-between/date))

(define (time-utc->date->string t [plt "~c"])
  (date->string (time-utc->date t) plt))
(define-syntax time-utc->string (make-rename-transformer #'time-utc->date->string))



(module+ test
  ;; Any code in this `test` submodule runs when this file is run using DrRacket
  ;; or with `raco test`. The code here does not run when this file is
  ;; required by another module.

  ;;; time
  (require srfi/19)

  ;; duration
  (check-equal? (time-second (hour-duration 1))
                3600)
  (check-equal? (time-second (day-duration 1))
                86400)

  ;; ago
  (check-equal? (date->string (current-date) "~4")
                (date->string (time-utc->date (make-time time-utc 0 (+ (time-second (hours-ago/time 1)) 3600))) "~4"))
  (check-equal? (date->string (current-date) "~4")
                (date->string (time-utc->date (make-time time-utc 0 (+ (time-second (days-ago/time 1)) 86400))) "~4"))

  (check-equal? (date-day (current-date))
                (+ 1 (date-day (days-ago 1))))
  (check-equal? (date-hour (current-date))
                (+ 1 (date-hour (hours-ago 1))))

  ;; from-now
  (check-equal? (date->string (current-date) "~4")
                (date->string (time-utc->date (make-time time-utc 0 (- (time-second (hours-from-now/time 1)) 3600))) "~4"))
  (check-equal? (date->string (current-date) "~4")
                (date->string (time-utc->date (make-time time-utc 0 (- (time-second (days-from-now/time 1)) 86400))) "~4"))

  (check-equal? (date-day (current-date))
                (- (date-day (days-from-now 1)) 1))
  (check-equal? (date-hour (current-date))
                (- (date-hour (hours-from-now 1)) 1))

  ;; range?
  (check-true (time-in-range? (make-time time-utc 0 2)
                              (make-time time-utc 0 1) (make-time time-utc 0 3)))
  (check-true (time-in-range? (make-time time-utc 0 2)
                              (make-time time-utc 0 3) (make-time time-utc 0 1)))
  (check-false (time-in-range? (make-time time-utc 0 2)
                               (make-time time-utc 0 2) (make-time time-utc 0 3)))

  (check-true (time-in-range==? (make-time time-utc 0 2)
                                (make-time time-utc 0 1) (make-time time-utc 0 2)))
  (check-true (time-in-range==? (make-time time-utc 0 2)
                                (make-time time-utc 0 2) (make-time time-utc 0 2)))
  (check-true (time-in-range==? (make-time time-utc 0 2)
                                (make-time time-utc 0 2) (make-time time-utc 0 3)))
  (check-true (time-in-range==? (make-time time-utc 0 2)
                                (make-time time-utc 0 1) (make-time time-utc 0 3)))
  (check-true (time-in-range==? (make-time time-utc 0 2)
                                (make-time time-utc 0 3) (make-time time-utc 0 1)))
  (check-false (time-in-range==? (make-time time-utc 0 5)
                                 (make-time time-utc 0 1) (make-time time-utc 0 3)))

  (check-false (time-in-range=<>? (make-time time-utc 0 2)
                                  (make-time time-utc 0 1) (make-time time-utc 0 2)))
  (check-true (time-in-range=<>? (make-time time-utc 0 2)
                                 (make-time time-utc 0 2) (make-time time-utc 0 2)))
  (check-true (time-in-range=<>? (make-time time-utc 0 2)
                                 (make-time time-utc 0 2) (make-time time-utc 0 3)))
  (check-true (time-in-range=<>? (make-time time-utc 0 2)
                                 (make-time time-utc 0 1) (make-time time-utc 0 3)))
  (check-true (time-in-range=<>? (make-time time-utc 0 2)
                                 (make-time time-utc 0 3) (make-time time-utc 0 1)))
  (check-false (time-in-range=<>? (make-time time-utc 0 5)
                                  (make-time time-utc 0 1) (make-time time-utc 0 3)))

  (check-true (time-in-range<>=? (make-time time-utc 0 2)
                                 (make-time time-utc 0 1) (make-time time-utc 0 2)))
  (check-true (time-in-range<>=? (make-time time-utc 0 2)
                                 (make-time time-utc 0 2) (make-time time-utc 0 2)))
  (check-false (time-in-range<>=? (make-time time-utc 0 2)
                                  (make-time time-utc 0 2) (make-time time-utc 0 3)))
  (check-true (time-in-range<>=? (make-time time-utc 0 2)
                                 (make-time time-utc 0 1) (make-time time-utc 0 3)))
  (check-true (time-in-range<>=? (make-time time-utc 0 2)
                                 (make-time time-utc 0 3) (make-time time-utc 0 1)))
  (check-false (time-in-range<>=? (make-time time-utc 0 5)
                                  (make-time time-utc 0 1) (make-time time-utc 0 3)))

  ;; parse-date
  (check-equal? (date-year (parse-date "2018-02-14 12:30:45")) 2018)
  (check-equal? (date-month (parse-date "2018-02-14 12:30:45")) 2)
  (check-equal? (date-day (parse-date "2018-02-14 12:30:45")) 14)
  (check-equal? (date-hour (parse-date "2018-02-14 12:30:45")) 12)
  (check-equal? (date-minute (parse-date "2018-02-14 12:30:45")) 30)
  (check-equal? (date-second (parse-date "2018-02-14 12:30:45")) 45)

  ;; beginning-date
  (check-equal? (beginning-date (make-date 1 1 1 1 10 05 2019 0))
                (make-date 0 0 0 0 10 05 2019 0))
  (check-equal? (beginning-date/month (make-date 1 1 1 1 10 05 2019 0))
                (make-date 0 0 0 0 1 05 2019 0))
  (check-equal? (beginning-date/year (make-date 1 1 1 1 10 05 2019 0))
                (make-date 0 0 0 0 1 1 2019 0))

  (check-equal? (last-oclock (make-date 1 1 1 1 10 05 2019 0))
                (make-date 0 0 0 1 10 05 2019 0))

  (check-equal? (length (oclocks-between (make-date 1 1 1 1 05 05 2019 0)
                                         (make-date 1 1 1 5 05 05 2019 0))) 5)


  ;; end-date
  (check-equal? (end-date/day (make-date 123456 50 40 12 14 02 2016 0))
                (make-date 9999999 59 59 23 14 02 2016 0))

  (check-equal? (end-date/month (make-date 123456 50 40 12 14 02 2016 0))
                (make-date 9999999 59 59 23 29 02 2016 0))
  (check-equal? (end-date/month (make-date 123456 50 40 12 14 02 2019 0))
                (make-date 9999999 59 59 23 28 02 2019 0))

  (check-equal? (end-date/month (make-date 123456 50 40 12 14 03 2016 0))
                (make-date 9999999 59 59 23 31 03 2016 0))
  (check-equal? (end-date/month (make-date 123456 50 40 12 14 04 2016 0))
                (make-date 9999999 59 59 23 30 04 2016 0))

  ;; previous-date
  (check-equal? (date->string (previous-date/day (parse-date "2016-03-01")) "~1")
                "2016-02-29")
  (check-equal? (date->string (previous-date/day (parse-date "2017-03-01")) "~1")
                "2017-02-28")
  (check-equal? (date->string (previous-date/day (parse-date "2017-04-01")) "~1")
                "2017-03-31")
  (check-equal? (date->string (previous-date/day (parse-date "2017-05-01")) "~1")
                "2017-04-30")

  (check-equal? (date->string (previous-date/month (parse-date "2017-02-14 12:30:50")) "~1 ~3")
                "2017-01-14 12:30:50")
  (check-equal? (date->string (previous-date/month (parse-date "2016-03-31")) "~1")
                "2016-02-29")
  (check-equal? (date->string (previous-date/month (parse-date "2017-03-31")) "~1")
                "2017-02-28")
  (check-equal? (date->string (previous-date/month (parse-date "2017-07-31")) "~1")
                "2017-06-30")

  )


(module+ main
  ;; (Optional) main submodule. Put code here if you need it to be executed when
  ;; this file is run using DrRacket or the `racket` executable.  The code here
  ;; does not run when this file is required by another module. Documentation:
  ;; http://docs.racket-lang.org/guide/Module_Syntax.html#%28part._main-and-test%29

  (require racket/cmdline)
  (define who (box "world"))
  (command-line
    #:program "my-program"
    #:once-each
    [("-n" "--name") name "Who to say hello to" (set-box! who name)]
    #:args ()
    (printf "hello ~a~n" (unbox who))))
