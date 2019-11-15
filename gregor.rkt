
(require gregor)

(provide current-date
         current-datetime
         current-datetime-tz
         current-moment)

(define-syntax current-date (make-rename-transformer #'today))
(define-syntax current-datetime (make-rename-transformer #'now))
(define-syntax current-datetime-tz (make-rename-transformer #'now/moment))
(define-syntax current-moment (make-rename-transformer #'now/moment))

(define (->utc-offset/hours moment)
  (/ (->utc-offset moment)) 3600)