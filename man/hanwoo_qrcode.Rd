% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/hanwoo_qrcode.R
\name{hanwoo_qrcode}
\alias{hanwoo_qrcode}
\title{hanwoo_qrcode}
\usage{
hanwoo_qrcode(cattle, site = "mtrace")
}
\arguments{
\item{cattle}{Number of cattle you want to gerate QR code.}

\item{site}{"mtrace" or "aiak"}
}
\description{
This function generate the QR code
}
\examples{
hanwoo_qrcode(cattle = "002095123103", site = "mtrace")
hanwoo_qrcode(cattle = "002095123103", site = "aiak")
}
