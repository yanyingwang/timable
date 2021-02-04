#lang scribble/manual


@title{timable}
@author[@author+email["Yanying Wang" "yanyingwang1@gmail.com"]]
@defmodule[timable]
@section-index["timable"]

@bold{
This library provides a bundle of extended functions for racket's various time/date libs. @; to make them be able to work together more smoothly.
@(linebreak)
@smaller{(This lib is not very stable, I may change the procedure names along with the time of learning racket lang.)}
}

@itemlist[
@item{source code: @url["https://github.com/yanyingwang/timable"]}
@item{@smaller{Please use gregor instead of srfi/19 if possible, since this lib is tightly sticking with gregor.}}
@item{@smaller{@racket[(require timable)] is same as @racket[(require timable/gregor timable/convert)]}}
]


@(table-of-contents)



@include-section["gregor.scrbl"]
@include-section["srfi-19.scrbl"]


@section{Change Logs}
@itemlist[
@item{at-end/on-month. --2020/02/04}

@item{enh docs for gregor. --2020/02/03}
@item{add parse/datetime to gregor lib. --2019/12/16}
@item{add now/sql now/moment/sql today/sql ... to convert lib.}
@item{rename timeless to timable and add support to gregor and sql-timestamp.}
@item{splited from chive and name it to timeless only support srfi/19 lib.}
@item{refactor chive from chez scheme version to racket.}
]
