#lang scribble/manual

 @(require scribble/eval
          (for-label (except-in racket/base date date? time)
                     (prefix-in base: (only-in racket/base date))
                     racket/contract
                     @; srfi/19
                     timable/srfi))

@(define the-eval (make-base-eval))
@; @(the-eval '(require srfi/19
@;                      timable/srfi))



@title[#:tag "srfi-19"]{extended srfi/19}
@declare-exporting[timable]
Procedures that extended from @secref["srfi-19" #:doc '(lib "srfi/scribblings/srfi.scrbl")].


@defmodule[timable/srfi]


@examples[
#:eval the-eval
(require srfi/19)
(require timable/srfi)

(hours-ago 5)
(time-in-range? (current-time) (hours-ago/time 1) (hours-from-now/time 1))
(last-oclock (current-date))
(last-oclock/time (current-time))
(oclocks-between (hours-ago 2) (hours-ago 5))
(oclocks-between/time (hours-ago/time 2) (hours-ago/time 5))

(beginning-date (current-date))
(beginning-date/month (current-date))
(beginning-date/year (current-date))
(date->string (date-parse "2018-01-01 11:11:11 +0800"))
(date->string (date-parse "2018/01/01 12"))
]


@defthing[unix-epoch-time time?]{
returns the unix epoch time, which is @italic{1970-01-01T00:00:00Z}.
}

@defthing[unix-epoch-date date?]{
returns the @racket[unix-epoch-time] in date type.
}

@defproc[(hours-ago [n number?]) date?]{
an alias procedure of @racket[hours-ago/date]
}

@defproc[(hours-ago/time [n number?]) time?]{
returns a time of @italic{n} hours ago.
}

@defproc[(hours-ago/date [n number?]) date?]{
returns a date of @italic{n} hours ago.
}


@defproc[(hours-from-now [n number?]) date?]{
an alias procedure of @racket[hours-from-now/date]
}

@defproc[(hours-from-now/time [n number?]) time?]{
returns a time of @italic{n} hours from now on.
}

@defproc[(hours-from-now/date [n number?]) date?]{
returns a date of @italic{n} hours from now on.
}

@defproc[(time-in-range? [time1 time?]
                         [time2 time?]
                         [time3 time?]) boolean?]{
an alias procedure of @racket[time-in-range<>?]
}
@defproc[(time-in-range<>? [time1 time?]
                         [time2 time?]
                         [time3 time?]) boolean?]{
Is @italic{time1} in the range of @italic{time2} and @italic{time3}?
}

@defproc[(time-in-range==? [time1 time?]
                         [time2 time?]
                         [time3 time?]) boolean?]{
an alias procedure of @racket[time-in-range=<>=?]
}
@defproc[(time-in-range=<>=? [time1 time?]
                         [time2 time?]
                         [time3 time?]) boolean?]{
Is @italic{time1} in the range of @italic{time2} and @italic{time3}(is in if @italic{time1} equals @italic{time2} or @italic{time3})?
}

@defproc[(time-in-range=<>? [time1 time?]
                         [time2 time?]
                         [time3 time?]) boolean?]{
Is @italic{time1} in the range of @italic{time2} and @italic{time3}(is in if @italic{time1} equals @italic{time2})?
}

@defproc[(time-in-range<>=? [time1 time?]
                         [time2 time?]
                         [time3 time?]) boolean?]{
Is @italic{time1} in the range of @italic{time2} and @italic{time3}(is in if @italic{time1} equals @italic{time3})?
}


@defproc[(beginning-date [d date?]) date?]{
@racket[beginning-date] is an alias procedure of @racket[beginning-date/day].
}
@defproc[(beginning-date/day [d date?]) date?]{
@racket[beginning-date/day] returns a new date which is the first date of the day of @italic{d}.
}
@defproc[(beginning-date/month [d date?]) date?]{
@racket[beginning-date/month] returns a new date which is the first date of the month of @italic{d}.
}
@defproc[(beginning-date/year [d date?]) date?]{
@racket[beginning-date/year] returns a new date which is the first date of the year of @italic{d}.
}

@defproc[(end-date [d date?]) date?]{
@racket[end-date] is an alias procedure of @racket[end-date/day].
}
@defproc[(end-date/day [d date?]) date?]{
@racket[end-date/day] returns a new date which is the end date of the day of @italic{d}.
}
@defproc[(end-date/month [d date?]) date?]{
@racket[end-date/month] returns a new date which is the end date of the month of @italic{d}.
}
@defproc[(end-date/year [d date?]) date?]{
@racket[end-date/year] returns a new date which is the endt date of the year of @italic{d}.
}


@defproc[(previous-date/day [d date?]) date?]{
returns a new date which is the same date of yesterday of @italic{d}.
}


@defproc[(date-parse [str string?]) date?]{
try to returns a date with parsing the string @italic{str}.
}

@defproc[(previous-date/month [d date?]) date?]{
returns a new date which is the same date of last month of @italic{d}.
}


@defproc[(last-oclock/time [d time?]) time?]{
returns a new time which is the recently last oclock time of @italic{d}.
}
@defproc[(last-oclock/date [d date?]) date?]{
returns a new date which is the recently last oclock time of @italic{d}.
}
@defproc[(last-oclock [d date?]) date?]{
an alias procedure of @racket[last-oclock/date].
}




@defproc[(oclocks-between [d1 date?]
                          [d2 date?]) list?]{
an alias procedure of @racket[oclocks-between/date].
}
@defproc[(oclocks-between/time [t1 time?]
                               [t2 time?]) list?]{
returns a list of all the time oclocks between @italic{t1} and @italic{t2}.
}
@defproc[(oclocks-between/date [d1 date?]
                               [d2 date?]) list?]{
returns a list of all the date oclocks between @italic{d1} and @italic{d2}.
}



@defproc[(time-utc->date->string [t time?]
                                 [format-string string? "~c"]) string?]{
convert the time to date and then to string with @italic{format-string} of PLT-specific extensions(@racket[string->date]).
}
@defproc[(time-utc->string [t time?]
                           [format-string string? "~c"]) string?]{
an alias procedure of @racket[time-utc->date->string].
}
