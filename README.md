
<!-- README.md is generated from README.Rmd. Please edit that file -->

# hanwoo <img src="man/figures/logo.png" align="right" />

<!-- badges: start -->
<!-- badges: end -->

A system for modeling the nutrient requirement of *Hanwoo*.

## Overview

한우와 관련된 데이터 분석을 위한 패키지입니다. 한국가축사양표준에 따른
모델 정보를 제공합니다. 또한 공공데이터 API로 제공하는 한우의 기본정보,
도체정보 및 KPN 씨수소 등 다양한 정보를 R로 importing 해올 수 있는
함수를 제공합다.

## Installation

``` r
# install.packages("remotes")
remotes::install_github("adatalab/hanwoo")
```

## Usage

``` r
library(hanwoo)
```

### 영양소 요구량 함수

#### req\_\*

체중(bw; body weight)과 일당증체(dg; daily gain)에 따른 한우의 영양소
요구량을 데이터프레임 형식으로 제공합니다.

``` r
req_steer(bw = 150, dg = 0.8) # 거세우의 영양소 요구량
#> # A tibble: 1 × 12
#>   sex   BW_kg ADG_kg  CP_g TDN_kg DE_Mcal ME_Mcal NEg_Mcal  Ca_g   P_g vitA_10…¹
#>   <chr> <dbl>  <dbl> <dbl>  <dbl>   <dbl>   <dbl>    <dbl> <dbl> <dbl>     <dbl>
#> 1 steer   150    0.8  532.   2.57    11.3    9.28     1.83  25.9  11.8      6.36
#> # … with 1 more variable: vitD_1000IU <dbl>, and abbreviated variable name
#> #   ¹​vitA_1000IU

req_bull(bw = 200, dg = 1.0) # 거세하지 않은 숫소의 영양소 요구량
#> # A tibble: 1 × 10
#>   sex   BW_kg ADG_kg  CP_g ME_Mcal NEg_Mcal  Ca_g   P_g vitA_1000IU vitD_1000IU
#>   <chr> <dbl>  <dbl> <dbl>   <dbl>    <dbl> <dbl> <dbl>       <dbl>       <dbl>
#> 1 bull    200      1  654.    11.7     2.28  32.2  15.0        8.48         1.2
```

여러 구간의 요구량을 한번에 importing 해야 할 경우 다음과 같이 응용할 수
있습니다.

``` r
library(purrr)
library(dplyr)

df <- data.frame(
  month = 6:15,
  체중 = c(160, 184, 208, 233, 258, 284, 310, 337, 366, 395),
  일당증체 = c(0.8, 0.8, 0.8, 0.9, 0.9, 0.9, 0.9, 1, 1, 1)
)

req <- map2(df$체중, df$일당증체, req_steer)

req %>%
  map_df(as_tibble)
#> # A tibble: 10 × 12
#>    sex   BW_kg ADG_kg  CP_g TDN_kg DE_Mcal ME_Mcal NEg_Mcal  Ca_g   P_g vitA_1…¹
#>    <chr> <dbl>  <dbl> <dbl>  <dbl>   <dbl>   <dbl>    <dbl> <dbl> <dbl>    <dbl>
#>  1 steer   160    0.8  540.   2.69    11.9    9.74     1.92  25.9  12.1     6.78
#>  2 steer   184    0.8  558.   2.99    13.2   10.8      2.13  26.0  12.6     7.80
#>  3 steer   208    0.8  575.   3.28    14.5   11.9      2.34  26.0  13.2     8.82
#>  4 steer   233    0.9  625.   3.74    16.5   13.5      2.86  28.4  14.5     9.88
#>  5 steer   258    0.9  640.   4.03    17.8   14.6      3.09  28.4  15.1    10.9 
#>  6 steer   284    0.9  655.   4.33    19.1   15.7      3.32  28.4  15.7    12.0 
#>  7 steer   310    0.9  670.   4.63    20.4   16.7      3.54  28.3  16.3    13.1 
#>  8 steer   337    1    712.   5.14    22.7   18.6      4.19  30.3  17.5    14.3 
#>  9 steer   366    1    726.   5.47    24.1   19.8      4.46  30.2  18.2    15.5 
#> 10 steer   395    1    739.   5.79    25.6   21.0      4.72  30.0  18.8    16.7 
#> # … with 1 more variable: vitD_1000IU <dbl>, and abbreviated variable name
#> #   ¹​vitA_1000IU
```

#### steer\_\*

거세우의 개월령(month), 체고(height), 체장(length) 및 흉위(chest)
길이(cm)를 이용해 체중(kg)을 예측하는 모델입니다. `stats::predict`
함수를 이용하여 라이브러리에 내장 모델을 사용할 수 있습니다.

``` r
predict(
  steer_h,
  data.frame(height = 100:140)
)
#>        1        2        3        4        5        6        7        8 
#> 120.9779 135.5122 150.0465 164.5808 179.1152 193.6495 208.1838 222.7181 
#>        9       10       11       12       13       14       15       16 
#> 237.2524 251.7867 266.3210 280.8554 295.3897 309.9240 324.4583 338.9926 
#>       17       18       19       20       21       22       23       24 
#> 353.5269 368.0612 382.5956 397.1299 411.6642 426.1985 440.7328 455.2671 
#>       25       26       27       28       29       30       31       32 
#> 469.8014 484.3358 498.8701 513.4044 527.9387 542.4730 557.0073 571.5416 
#>       33       34       35       36       37       38       39       40 
#> 586.0760 600.6103 615.1446 629.6789 644.2132 658.7475 673.2818 687.8162 
#>       41 
#> 702.3505

predict(
  steer_c,
  data.frame(chest = 125:230)
)
#>        1        2        3        4        5        6        7        8 
#> 122.4100 127.9419 133.4738 139.0057 144.5375 150.0694 155.6013 161.1332 
#>        9       10       11       12       13       14       15       16 
#> 166.6651 172.1970 177.7289 183.2608 188.7927 194.3246 199.8565 205.3884 
#>       17       18       19       20       21       22       23       24 
#> 210.9203 216.4522 221.9841 227.5160 233.0479 238.5798 244.1117 249.6436 
#>       25       26       27       28       29       30       31       32 
#> 255.1755 260.7073 266.2392 271.7711 277.3030 282.8349 288.3668 293.8987 
#>       33       34       35       36       37       38       39       40 
#> 299.4306 304.9625 310.4944 316.0263 321.5582 327.0901 332.6220 338.1539 
#>       41       42       43       44       45       46       47       48 
#> 343.6858 349.2177 354.7496 360.2815 365.8134 371.3453 376.8771 382.4090 
#>       49       50       51       52       53       54       55       56 
#> 387.9409 393.4728 399.0047 404.5366 410.0685 415.6004 421.1323 426.6642 
#>       57       58       59       60       61       62       63       64 
#> 432.1961 437.7280 443.2599 448.7918 454.3237 459.8556 465.3875 470.9194 
#>       65       66       67       68       69       70       71       72 
#> 476.4513 481.9832 487.5151 493.0470 498.5788 504.1107 509.6426 515.1745 
#>       73       74       75       76       77       78       79       80 
#> 520.7064 526.2383 531.7702 537.3021 542.8340 548.3659 553.8978 559.4297 
#>       81       82       83       84       85       86       87       88 
#> 564.9616 570.4935 576.0254 581.5573 587.0892 592.6211 598.1530 603.6849 
#>       89       90       91       92       93       94       95       96 
#> 609.2168 614.7486 620.2805 625.8124 631.3443 636.8762 642.4081 647.9400 
#>       97       98       99      100      101      102      103      104 
#> 653.4719 659.0038 664.5357 670.0676 675.5995 681.1314 686.6633 692.1952 
#>      105      106 
#> 697.7271 703.2590

predict(
  steer_m,
  data.frame(month = 10:30)
)
#>        1        2        3        4        5        6        7        8 
#> 253.8400 278.8345 303.8290 328.8235 353.8180 378.8125 403.8070 428.8015 
#>        9       10       11       12       13       14       15       16 
#> 453.7960 478.7905 503.7850 528.7795 553.7740 578.7685 603.7631 628.7576 
#>       17       18       19       20       21 
#> 653.7521 678.7466 703.7411 728.7356 753.7301
```

### 이력 및 품질 API 연동 함수

본 함수들을 사용하기 위해서는 먼저 [공공데이터포털](data.go.kr)에서
회원가입 및 목적에 따라 1) 축산물등급판정정보 2) 축산물통합이력정보 3)
축산물경락가격정보 및 4) 축산물등급판정확인서발급정보에 대한 각각의
계정신청 및 API key를 발급받아야합니다. 발급받은 api key 는 key_encoding
및 key_decoding에 지정해 줍니다. 발급 후 승인까지 수 시간이 소요될 수
있습니다.

#### hanwoo_info

특정 한우 개체번호를 입력하여 정보를 리스트 형태로 가져올 수 있습니다.

``` r
hanwoo_info(cattle = "002083191603", key_encoding = "your_encoded_api_key", key_decoding = "your_decoded_api_key")
hanwoo_info(cattle = "002083191603", key_encoding = "your_encoded_api_key", key_decoding = "your_decoded_api_key")
```

여러마리의 데이터를 importing 해야 할 경우 다음과 같이 응용할 수
있습니다.

``` r
code <- c("002070021011", "002065029272", "002062250044", "002063227367", "002066994812", "002067050894", "002064505530", "002070394423", "002064488463", "002064501114", "002121614931")

get_hanwoo <- function(x) {
  return(
    tryCatch(hanwoo_info(x, key_encoding, key_decoding)$quality_info, 
             error = function(e) NULL
    )
  )
} 

library(purrr)
library(pbapply)

multiple_result <- purrr::map(code, get_hanwoo)
# OR (for display a progress bar)
multiple_result <- pbapply::pblapply(code, get_hanwoo)

multiple_result %>% map_df(as_tibble)
```

#### hanwoo_bull

KPN 한우 씨수소의 유전정보를 importing 할 수 있습니다. **API key를
요구하지 않습니다**. 보증 및 후보씨수소 목록은 농협경제지주
[한우개량사업소](http://www.limc.co.kr/KpnInfo/KpnList.asp)에서 확인하실
수 있습니다. 한우보증씨수소의 경우 1년에 2회 육종가 평가를 하기 때문에
같은 개체라도 평가 시기에 따라 육종가 다를 수 있습니다.

``` r
hanwoo_bull(KPN = 1080, type = "list")
hanwoo_bull(KPN = 950, type = "selected")
```

여러 KPN 데이터를 importing 해야 할 경우 다음과 같이 응용할 수 있습니다.

``` r
kpn <- 600:1100

get_bull <- function(x) {
  return(
    tryCatch(hanwoo_bull(x, type = "selected"), 
             error = function(e) NULL
    )
  )
}

result <- map(kpn, get_bull)
result %>% map_df(as_tibble)
```

#### hanwoo_stock

한우와 관련된 시세를 조회할 수 있습니다. 데이터는 축산물품질평가원
[축산유통정보](https://www.ekapepia.com/priceStat/distrPriceBeef.do)에서
제공되는 데이터를 기반으로 자체 DB에서 관리되며 1주일에 한번 업데이트
됩니다. Google OAuth access credentials 인증이 필요합니다.

``` r
stock <- hanwoo_stock()
#> Data from ekapepia.com; Last updated: 2022-09-28 by Antller Inc.
```

``` r
head(stock)
#> # A tibble: 6 × 12
#>   date       명절   암송…¹  숫송…²  농가…³ 지육_…⁴ 지육_…⁵ 도매_…⁶ 소비…⁷  year
#>   <date>     <chr>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>  <dbl> <dbl>
#> 1 2022-09-28 <NA>  2861000 4209000 6898000   19257   18507   73757 101640  2022
#> 2 2022-09-27 <NA>  2861000 4209000 7207000   20121   19246      NA 101580  2022
#> 3 2022-09-26 <NA>  2851000 4222000 5129000   14320   17678   77377 101610  2022
#> 4 2022-09-23 <NA>  2835000 4226000 6896000   19252   19279   77377 101550  2022
#> 5 2022-09-22 <NA>  2835000 4226000 7182000   20050   19572   74400  99930  2022
#> 6 2022-09-21 <NA>  2847000 4237000 7225000   20170   19595   76045  99810  2022
#> # … with 2 more variables: week <dbl>, wday <ord>, and abbreviated variable
#> #   names ¹​암송아지, ²​숫송아지, ³​농가수취가격_600kg, ⁴​지육_평균, ⁵​지육_1등급,
#> #   ⁶​도매_등심1등급, ⁷​소비자_등심1등급
```

#### hanwoo_price

주요 도축장 별로 한육우의 낙찰가를 조회할 수 있습니다.
공공데이터에포탈에서는 최근 1주간의 데이터만 제공됩니다.

``` r
hanwoo_price(date = "", type = "df", key_encoding)
hanwoo_price(date = "2020-11-10", type = "list", key_encoding)
```

### 기타 함수

#### hanwoo_qrcode

개체번호 기반 축산물이력제 또는 종축개량협회 링크와 연결되는 QR코드
이미지를 생성합니다.

``` r
hanwoo_qrcode(cattle = "002095123103", site = "mtrace")
```

<img src="man/figures/README-unnamed-chunk-7-1.png" width="30%" />

### 내장 데이터셋

#### hanwoo_kpn

농촌진흥청에서 제공하는 한우 씨수소(Korean Proven Bull) 의
[유전능력평가결과](https://www.nias.go.kr/front/prboardView.do?cmCode=M090814150801285&boardSeqNum=2482)
dataset입니다.

``` r
tail(hanwoo_kpn)
#> # A tibble: 6 × 141
#>   kpn      등록번호 근교계수 아비   조부  외조부 x12개…¹ x12개…² 도체…³ 도체중…⁴
#>   <chr>       <dbl>    <dbl> <chr>  <chr> <chr>    <dbl>   <dbl>  <dbl>    <dbl>
#> 1 KPN1668 231810911   0.0291 KPN12… KPN1… KPN950    50.4    0.67   58.9     0.57
#> 2 KPN1669 231758921   0.0118 KPN13… KPN9… KPN10…    48.1    0.64   60.3     0.55
#> 3 KPN1670 231703218   0.0185 KPN14… KPN1… KPN12…    55.2    0.64   77.3     0.54
#> 4 KPN1671 231703202   0.0071 KPN12… KPN1… KPN872    55.3    0.66   62.2     0.57
#> 5 KPN1672 231822768   0.0202 KPN14… KPN1… KPN685    69.2    0.64   77.5     0.55
#> 6 KPN1673 231830164   0.0146 <NA>   <NA>  <NA>      35.1    0.58   35.6     0.42
#> # … with 131 more variables: 등심단면적육종가 <dbl>, 등심단면적정확도 <dbl>,
#> #   등지방두께육종가 <dbl>, 등지방두께정확도 <dbl>, 근내지방도육종가 <dbl>,
#> #   근내지방도정확도 <dbl>, x12개월체중표준화육종가 <dbl>,
#> #   도체중표준화육종가 <dbl>, 등심단면적표준화육종가 <dbl>,
#> #   등지방두께표준화육종가 <dbl>, 근내지방도표준화육종가 <dbl>,
#> #   x12개월체고육종가 <dbl>, x12개월체고정확도 <dbl>,
#> #   x12개월십자부고육종가 <dbl>, x12개월십자부고정확도 <dbl>, …
```

#### weight_ku1 & weight_ku2

한우를 대상으로 건국대학교에서 수행한 연구(Na, 2017)의 월령별 체중 raw
dataset입니다.

``` r
weight_ku1
weight_ku2
```

#### program_nias

한우사양표준에서 제공하는 3단계/4단계 사양 프로그램표 dataset입니다.

``` r
program_nias
```

## Getting helps

For help or issues using `hanwoo`, please submit a [GitHub
issue](https://github.com/adatalab/hanwoo/issues).

For personal communication related to `hanwoo`, please contact Youngjun
Na (`ruminoreticulum@gmail.com`).
