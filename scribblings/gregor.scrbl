#lang scribble/manual

@(require (for-label gregor
                     @; racket/base
                     timable/gregor
                     timable/convert)
           scribble/eval)
@(define the-eval
   (make-eval-factory '(timable/srfi
                        timable/convert
                        timable/gregor)))



@title[#:tag "gregor"]{extended gregor}
@declare-exporting[timable]


@; --------------------------------------------------------------------------------------------------
@section{extended gregor}
Procedures that extended from @other-doc['(lib "gregor/scribblings/gregor.scrbl")].

@defmodule[timable/gregor]
@examples[
#:eval (the-eval)
(require timable/gregor)

(current-date)
(current-datetime)
(current-moment)
(current-moment/utc)

(require gregor)

(prev-day (now))
(prev-month (now))
(next-month (now))
(prev-year (now))

(at-beginning/on-month (now))
(at-end/on-month (now))
(at-beginning/on-day (now))
(at-end/on-year (now))

(parse/datetime "2018-02-14 12:30:45")
(parse/datetime "2018/02-14 12-30 45")
]

@deftogether[(
@defproc[(current-date) date?]
@defproc[(current-datetime) datetime?]
@defproc[(current-datetime/utc) moment?]
@defproc[(current-moment) moment?]
@defproc[(current-moment/utc) moment?]
)]{
@racket[current-date] is an alias procedure of @racket[today].  @[linebreak]
@racket[current-datetime] is an alias procedure of @racket[now].  @[linebreak]
@racket[current-datetime/utc] is an alias procedure of @racket[now/utc].  @[linebreak]
@racket[current-moment] is an alias procedure of @racket[now/moment].  @[linebreak]
@racket[current-moment/utc] is an alias procedure of @racket[now/moment/utc].
}

@deftogether[(
@defproc[(years-ago [n integer?]) datetime?]
@defproc[(days-ago [n integer?]) datetime?]
@defproc[(hours-ago [n integer?]) datetime?]
@defproc[(years-ago/utc [n integer?]) datetime?]
@defproc[(days-ago/utc [n integer?]) datetime?]
@defproc[(hours-ago/utc [n integer?]) datetime?]
)]{
return a previous datetime.
}

@deftogether[(
@defproc[(years-from-now [n integer?]) datetime?]
@defproc[(days-from-now [n integer?]) datetime?]
@defproc[(hours-from-now [n integer?]) datetime?]
@defproc[(years-from-now/utc [n integer?]) datetime?]
@defproc[(days-from-now/utc [n integer?]) datetime?]
@defproc[(hours-from-now/utc [n integer?]) datetime?]
)]

@deftogether[(
@defproc[(prev-day [t (or/c date? time? datetime? moment?)]) (or/c date? time? datetime? moment?)]
@defproc[(next-day [t (or/c date? time? datetime? moment?)]) (or/c date? time? datetime? moment?)]
@defproc[(prev-month [t (or/c date? time? datetime? moment?)]) (or/c date? time? datetime? moment?)]
@defproc[(next-month [t (or/c date? time? datetime? moment?)]) (or/c date? time? datetime? moment?)]
@defproc[(prev-year [t (or/c date? time? datetime? moment?)]) (or/c date? time? datetime? moment?)]
@defproc[(next-year [t (or/c date? time? datetime? moment?)]) (or/c date? time? datetime? moment?)]
)]

@deftogether[(
@defproc[(at-beginning/on-day [t (or/c date? time? datetime? moment?)]) datetime?]
@defproc[(at-end/on-day [t (or/c date? time? datetime? moment?)]) datetime?]
@defproc[(at-beginning/on-month [t (or/c date? time? datetime? moment?)]) datetime?]
@defproc[(at-end/on-month [t (or/c date? time? datetime? moment?)]) datetime?]
@defproc[(at-beginning/on-year [t (or/c date? time? datetime? moment?)]) datetime?]
@defproc[(at-end/on-year [t (or/c date? time? datetime? moment?)]) datetime?]
)]



@defproc[(->utc-offset/hours [m moment?]) number?]{
return a number stands for the utc offset hours. While @racket[->utc-offset] returns the seconds.
}
@defproc[(parse/datetime [str string?]) datetime?]{
try to parse @litchar{str} and return a @racket[datetime] for it.
}




@; --------------------------------------------------------------------------------------------------
@section{converting between sql and gregor}
functions that converting between  @secref["mysql-types" #:doc '(lib "db/scribblings/db.scrbl")] and @other-doc['(lib "gregor/scribblings/gregor.scrbl")].

@defmodule[timable/convert]
@examples[
#:eval (the-eval)
(require gregor)

(->sql-timestamp (today))
(->sql-timestamp (now))
(->sql-timestamp (now/moment))
(->sql-timestamp (now))
(->sql-timestamp (now/moment #:tz "Asia/Shanghai"))

(today/sql)
(now/sql)
(now/moment/sql #:tz "Asia/Shanghai")
]

@deftogether[(
@defproc[(date->sql-timestamp [d date?]) sql-timestamp?]
@defproc[(datetime->sql-timestamp [d datetime?]) sql-timestamp?]
@defproc[(moment->sql-timestamp [d moment?]) sql-timestamp?]
@defproc[(->sql-timestamp [d (or/c date? datetime? moment?)]) sql-timestamp?]
)]{
convert @italic{d} from gregor moment to sql-timestamp.
}

@deftogether[(
@defproc[(now/sql [d moment?]) sql-timestamp?]
@defproc[(now/moment/sql [d moment?]) sql-timestamp?]
@defproc[(today/sql [d date?]) sql-date?]

@defproc[(current-datetime/sql [d datetime?])  sql-timestamp?]
@defproc[(current-moment/sql [d moment?]) sql-timestamp?]
@defproc[(current-date/sql [d date?]) sql-date?]
)]{
use @racket[current-datetime/sql] as an alias of @racket[now/sql] to return @racket[now] in @racket[sql-timestamp] type.  @[linebreak]
use @racket[current-moment/sql] as an alias of @racket[now/moment/sql] to return @racket[now/moment] in @racket[sql-timestamp-tz] type.  @[linebreak]
use @racket[current-date/sql] as an alias of @racket[today/sql] to return @racket[today] in @racket[sql-date] type.  @[linebreak]
}
