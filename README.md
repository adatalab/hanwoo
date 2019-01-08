# hanwoo <img src="man/figures/logo.png" align="right" />
A system for modeling the nutrient requirement of Hanwoo.

## Overview
한국가축사양표준(한우)에 따른 동물 영양 모델 및 기계학습 모델을 위한 패키지입니다. 또한 공공데이터포털에서 제공하는 한우의 기본정보, 도체정보 및 KPN 씨수소의 정보를 가져올 수 있습니다.  

## Installation  

``` r
# The development version from GitHub:
# install.packages("devtools")
devtools::install_github("adatalab/hanwoo")
```

## Usage
### 1. 요구량 설정
``` r
library(hanwoo)
```

### 2. 한우정보 및 도체성적 가져오기
먼저 data.go.kr에서 API key를 신청하고 그 다음 활용 신청을 해야합니다. [다음글](https://youngjunna.github.io/r/animal%20science/2017/12/01/hanwoo-scraping.html)을 참고해 진행하시면 됩니다.

#### hanwoo_key
제일먼저 발급받은 API키를 등록해야 정상적으로 한우의 정보 및 도체정보를 가져올 수 있습니다.  

``` r
hanwoo_key(key = "YOUR_API_KEY_FROM_DATA.GO.KR")
```

#### hanwoo_info
특정 한우 개체번호(002로 시작)를 입력하여 정보를 리스트 또는 데이터프레임 형태로 가져올 수 있습니다.  

``` r
hanwoo_info(cattle = "002083191603", type = "list")
hanwoo_info(cattle = "002083191603", type = "df")
```

#### hanwoo_bull
KPN 한우 씨수소의 정보를 가져올 수 있습니다. API key를 요구하지 않습니다.

``` r
hanwoo_bull(KPN = 1080)
```

## Notification
개발중인 패키지입니다.  

## Getting helps
Email: ruminoreticulum@gmail.com
