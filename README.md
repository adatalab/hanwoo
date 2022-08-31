
<!-- README.md is generated from README.Rmd. Please edit that file -->

# hanwoo <img src="man/figures/logo.png" align="right" />

<!-- badges: start -->
<!-- badges: end -->

A system for modeling the nutrient requirement of *Hanwoo*.

## Overview

-   한우의 영양 모델링을 위한 패키지입니다. 한국가축사양표준에 따른 모델
    정보를 제공합니다. 또한 공공데이터포털에서 XML 형태로 제공하는
    한우의 기본정보, 도체정보 및 KPN 씨수소의 정보를 R로 importing 해올
    수 있습니다.  
-   한우는 대한민국의 고유 유전자원으로 혈통/유전적인 정보와 도체성적이
    각각 종축개량협회와 축산물품질평가원에서 철저히 관리되고 있습니다.
    본 패키지의 목적은 이러한 **유전/환경/영양적인 요소를 모두 고려한**
    한우생산모델을 만듦에 있습니다.

## Installation

``` r
# install.packages("remotes")
remotes::install_github("adatalab/hanwoo")
```

## Usage

``` r
library(hanwoo)
```

### 영양소 요구량

#### req\_\*

체중(bw; body weight)과 일당증체(dg; daily gain)에 따른 한우의 영양소
요구량을 데이터프레임 형식으로 제공합니다.

``` r
req_steer(bw = 150, dg = 0.8) # 거세우의 영양소 요구량

req_bull(bw = 200, dg = 1.0) # 거세하지 않은 숫소의 영양소 요구량
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

predict(
  steer_c,
  data.frame(chest = 125:230)
)

predict(
  steer_m,
  data.frame(month = 10:30)
)
```

### 한우 이력 및 품질 API

**본 함수들을 사용하기 위해서는 먼저 [공공데이터포털](data.go.kr)에서
회원가입 및 1) 축산물등급판정정보 2) 축산물통합이력정보 3)
축산물경락가격정보 및 4) 축산물등급판정확인서발급정보에 대한 각각의
계정신청 및API key를 발급받아야합니다.** 발급받은 api key 는
key_encoding 및 key_decoding에 지정해 줍니다.

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

#### hanwoo_price

주요 도축장 별로 한육우의 낙찰가를 조회할 수 있습니다.
공공데이터에포탈에서는 최근 1주간의 데이터만 제공됩니다.

``` r
hanwoo_price(date = "", type = "df", key_encoding)
hanwoo_price(date = "2020-11-10", type = "list", key_encoding)
```

### QR 코드 만들기

개체번호 기반 축산물이력제 또는 종축개량협회 링크와 연결되는 QR코드
이미지를 생성합니다.

``` r
hanwoo_qrcode(cattle = "002095123103", site = "mtrace")
```

<img src="man/figures/README-unnamed-chunk-2-1.png" width="30%" />

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
