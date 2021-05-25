#lang scribble/manual


@require[scribble-rainbow-delimiters]
@script/rainbow-delimiters*

@title{timable}
@author[@author+email["Yanying Wang" "yanyingwang1@gmail.com"]]
@defmodule[timable]
@section-index["timable"]

@bold{
This library provides a bundle of extended functions for racket's various time/date libs. @; to make them be able to work together more smoothly.
}

@itemlist[
@item{@smaller{source code: @url["https://github.com/yanyingwang/timable"]}}
@item{@smaller{Since this lib is not very stable, I may change the interfaces along with my learning of racket lang, you'd better specify this pkg with the git commit id such as: @italic["https://github.com/yanyingwang/timable#a6c610de02336a0f0858e50ce5f016bd82b79b8a"]. @(linebreak)
Check more at @secref["concept:source" #:doc '(lib "pkg/scribblings/pkg.scrbl")].}}
@item{@smaller{Please use gregor instead of srfi/19 if possible, since this lib is tightly sticking with  gregor.}}
@item{@smaller{@racket[(require timable)] is same as @racket[(require timable/gregor timable/convert)].}}
]



@(table-of-contents)


@include-section["gregor.scrbl"]
@include-section["srfi-19.scrbl"]


@section{Change Logs}
@itemlist[
@item{at-end/on-month. --2020/02/04}
@item{enh docs for gregor. --2020/02/03}
@item{version 0.2.0}
@item{add parse/datetime to gregor lib. --2019/12/16}
@item{add now/sql now/moment/sql today/sql ... to convert lib.}
@item{rename timeless to timable and add support to gregor and sql-timestamp.}
@item{splited from chive and name it to timeless only support srfi/19 lib.}
@item{refactor chive from chez scheme version to racket.}
]
