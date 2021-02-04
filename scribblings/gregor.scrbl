#lang scribble/manual

@(require (for-label gregor
                     @; racket/base
                     db
                     timable/gregor
                     timable/convert)
           scribble/eval)
@(define the-eval
   (make-eval-factory '(gregor
                        timable/convert
                        timable/gregor)))



@title[#:tag "extended-gregor"]{Extended gregor}
@declare-exporting[timable]


@; --------------------------------------------------------------------------------------------------
@section{from base gregor}
Procedures that extended from @other-doc['(lib "gregor/scribblings/gregor.scrbl")].

@defmodule[timable/gregor]

@examples[#:eval (the-eval)

(require timable/gregor
         gregor)
(current-datetime)
(prev-day (now))
(at-beginning/on-month (now))
(parse/datetime "2018-02-14 12:30:45")
]

@deftogether[(
@defproc[(current-date) date?]
@defproc[(current-datetime) datetime?]
@defproc[(current-datetime/utc) moment?]
@defproc[(current-moment) moment?]
@defproc[(current-moment/utc) moment?]
)]{
@racket[current-date] is an alias procedure of @racket[today].  @(linebreak)
@racket[current-datetime] is an alias procedure of @racket[now].  @(linebreak)
@racket[current-datetime/utc] is an alias procedure of @racket[now/utc].  @(linebreak)
@racket[current-moment] is an alias procedure of @racket[now/moment].  @(linebreak)
@racket[current-moment/utc] is an alias procedure of @racket[now/moment/utc].

@examples[#:eval (the-eval)
(current-date)
(current-datetime)
(current-moment)
(current-moment/utc)
]}

@deftogether[(
@defproc[(years-ago [n integer?]) datetime?]
@defproc[(months-ago [n integer?]) datetime?]
@defproc[(days-ago [n integer?]) datetime?]
@defproc[(hours-ago [n integer?]) datetime?]
@defproc[(years-ago/utc [n integer?]) datetime?]
@defproc[(months-ago/utc [n integer?]) datetime?]
@defproc[(days-ago/utc [n integer?]) datetime?]
@defproc[(hours-ago/utc [n integer?]) datetime?]
)]{
@examples[#:eval (the-eval)
(now)
(hours-ago 1)
(months-ago 3)
(years-ago 1)
(hours-ago/utc 1)
]}

@deftogether[(
@defproc[(years-from-now [n integer?]) datetime?]
@defproc[(days-from-now [n integer?]) datetime?]
@defproc[(hours-from-now [n integer?]) datetime?]
@defproc[(years-from-now/utc [n integer?]) datetime?]
@defproc[(days-from-now/utc [n integer?]) datetime?]
@defproc[(hours-from-now/utc [n integer?]) datetime?]
)]{
@examples[#:eval (the-eval)
(now)
(hours-from-now 1)
]}

@deftogether[(
@defproc[(prev-day [t (or/c date? time? datetime? moment?)]) (or/c date? time? datetime? moment?)]
@defproc[(next-day [t (or/c date? time? datetime? moment?)]) (or/c date? time? datetime? moment?)]
@defproc[(prev-month [t (or/c date? time? datetime? moment?)]) (or/c date? time? datetime? moment?)]
@defproc[(next-month [t (or/c date? time? datetime? moment?)]) (or/c date? time? datetime? moment?)]
@defproc[(prev-year [t (or/c date? time? datetime? moment?)]) (or/c date? time? datetime? moment?)]
@defproc[(next-year [t (or/c date? time? datetime? moment?)]) (or/c date? time? datetime? moment?)]
)]{
@examples[#:eval (the-eval)
(now)
(prev-year (now))
]}

@deftogether[(
@defproc[(at-beginning/on-day [t (or/c date? time? datetime? moment?)]) datetime?]
@defproc[(at-end/on-day [t (or/c date? time? datetime? moment?)]) datetime?]
@defproc[(at-beginning/on-month [t (or/c date? time? datetime? moment?)]) datetime?]
@defproc[(at-end/on-month [t (or/c date? time? datetime? moment?)]) datetime?]
@defproc[(at-beginning/on-year [t (or/c date? time? datetime? moment?)]) datetime?]
@defproc[(at-end/on-year [t (or/c date? time? datetime? moment?)]) datetime?]
)]{
@examples[#:eval (the-eval)
(now)
(at-beginning/on-day (now))
(at-beginning/on-month (now))
(at-end/on-month (now))
]}




@defproc[(->utc-offset/hours [m moment?]) number?]{
Return a number stands for the utc offset hours. While @racket[->utc-offset] returns the seconds.

@examples[#:eval (the-eval)
(now/moment)
(->utc-offset/hours (now/moment))
]}

@defproc[(parse/datetime [str string?]) datetime?]{
Parse @italic{str} and return a @racket[datetime] for it.

@examples[#:eval (the-eval)
(parse/datetime "2018-02-14 12:30:45")
(parse/datetime "2018/02-14 12-30 45")
]}




@; --------------------------------------------------------------------------------------------------
@section{from converting between sql and gregor}
Functions that converting between  @secref["mysql-types" #:doc '(lib "db/scribblings/db.scrbl")] and @other-doc['(lib "gregor/scribblings/gregor.scrbl")].

@defmodule[timable/convert]
@examples[#:eval (the-eval)
(require gregor)

(->sql-timestamp (today))

(today/sql)
]

@deftogether[(
@defproc[(date->sql-timestamp [d date?]) sql-timestamp?]
@defproc[(datetime->sql-timestamp [d datetime?]) sql-timestamp?]
@defproc[(moment->sql-timestamp [d moment?]) sql-timestamp?]
@defproc[(->sql-timestamp [d (or/c date? datetime? moment?)]) sql-timestamp?]
)]{
Convert @italic{d} from gregor moment to sql-timestamp.

@examples[#:eval (the-eval)
(->sql-timestamp (today))
(->sql-timestamp (now))
(->sql-timestamp (now/moment))
(->sql-timestamp (now))
(->sql-timestamp (now/moment #:tz "Asia/Shanghai"))
]
}

@deftogether[(
@defproc[(now/sql [d moment?]) sql-timestamp?]
@defproc[(now/moment/sql [d moment?]) sql-timestamp?]
@defproc[(today/sql [d date?]) sql-date?]

@defproc[(current-datetime/sql [d datetime?])  sql-timestamp?]
@defproc[(current-moment/sql [d moment?]) sql-timestamp?]
@defproc[(current-date/sql [d date?]) sql-date?]
)]{
Use @racket[current-datetime/sql] as an alias of @racket[now/sql] to return @racket[now] in @racket[sql-timestamp] type.  @(linebreak)
Use @racket[current-moment/sql] as an alias of @racket[now/moment/sql] to return @racket[now/moment] in @racket[sql-timestamp-tz] type.  @(linebreak)
Use @racket[current-date/sql] as an alias of @racket[today/sql] to return @racket[today] in @racket[sql-date] type.  @(linebreak)

@examples[#:eval (the-eval)
(today)
(today/sql)
(now/sql)
(now/moment/sql #:tz "Asia/Shanghai")
]}
