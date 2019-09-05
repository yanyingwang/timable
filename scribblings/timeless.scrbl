#lang scribble/manual
@require[@for-label[timeless
                    racket]]

@title{timeless}
@author[(author+email "yanyingwang" "yanyingwang1@gmail.com")]
@defmodule[timeless]


a useful time library, is splited from @hyperlink["https://gitlab.com/yanyingwang/chive" "chive"] and built on the top of srfi 19/time.

@hyperlink["https://gitlab.com/yanyingwang/timeless" "source code"]




@[table-of-contents]




@section{Procedure Reference}

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

@bold{same kind of rule comes to procedures @code{days-ago} and @code{days-from-now}, and the plural procedure name can be singular such as @code{hour-ago}. }

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
@defproc[(yesterday-date [d date?]) date?]{
@racket[end-date] is an alias procedure of @racket[previous-date/day].
}


@defproc[(parse-date [str string?]) date?]{
try to returns a date with parsing the string @italic{str}.
}

@defproc[(previous-date/month [d date?]) date?]{
returns a new date which is the same date of last month of @italic{d}.
}
@defproc[(yesterday-date [d date?]) date?]{
@racket[end-date] is an alias procedure of @racket[last-month-date].
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


@section{Example}

@codeblock[#:keep-lang-line? #f]|{

(require timeless)

(hours-ago 5)
;=> (date* 55 50 11 8 5 2019 3 127 #f 28800 996000000 "")

(time-in-range? (days-ago 2) (hours-ago 1) unix-epoch-time)
;=> #t

(last-olock (current-date))
;=> #[#{date pfwa3r0havo3glvxa5oa6eoyh-24} 0 0 0 15 5 11 2018 28800]

(last-olock/time (current-time))
;=> #[#{date pfwa3r0havo3glvxa5oa6eoyh-24} 0 0 0 15 5 11 2018 28800]

> (oclocks-between (hours-ago 2) (hours-ago 5))
(#[#{date pfwa3r0havo3glvxa5oa6eoyh-24} 0 0 0 10 5 11 2018 28800]
 #[#{date pfwa3r0havo3glvxa5oa6eoyh-24} 0 0 0 11 5 11 2018 28800]
 #[#{date pfwa3r0havo3glvxa5oa6eoyh-24} 0 0 0 12 5 11 2018 28800]
 #[#{date pfwa3r0havo3glvxa5oa6eoyh-24} 0 0 0 13 5 11 2018 28800])

> (oclocks-between/time (hours-ago/time 2) (hours-ago/time 5))
(#[#{time pfwa3r0havo3glvxa5oa6eoyh-25} time-utc 0 1541383200]
 #[#{time pfwa3r0havo3glvxa5oa6eoyh-25} time-utc 0 1541386800]
 #[#{time pfwa3r0havo3glvxa5oa6eoyh-25} time-utc 0 1541390400]
 #[#{time pfwa3r0havo3glvxa5oa6eoyh-25} time-utc 0 1541394000])


(require srfi/19)
(beginning-date (current-date))
;=> (date* 0 0 0 5 5 2019 0 124 #f 28800 0 "")

(beginning-date/month (current-date))
;=> (date* 0 0 0 1 5 2019 3 120 #f 28800 0 "")

(beginning-date/year (current-date))
;=> (date* 0 0 0 1 1 2019 2 0 #f 28800 0 "")

(date->string (parse-date "2018-01-01 11:11:11 +0800"))
;=> "Mon Jan 01 11:11:11+0800 2018"

(date->string (parse-date "2018/01/01 12"))
;=> "Mon Jan 01 12:00:00+0800 2018"
}|
