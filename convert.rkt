(require gregor
         db
         ;; srfi/19
         db/util/datetime)


(provide datetime->sql-timestamp
         moment->sql-timestamp-tz)



(define (datetime->sql-timestamp gregor-d)
  (sql-timestamp (->year gregor-d)
                 (->month gregor-d)
                 (->day gregor-d)
                 (->hours gregor-d)
                 (->minutes gregor-d)
                 (->seconds gregor-d)
                 (->nanoseconds gregor-d)
                 #f))


(define (moment->sql-timestamp-tz gregor-d)
  (sql-timestamp (->year gregor-d)
                 (->month gregor-d)
                 (->day gregor-d)
                 (->hours gregor-d)
                 (->minutes gregor-d)
                 (->seconds gregor-d)
                 (->nanoseconds gregor-d)
                 #f))