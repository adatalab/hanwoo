# hanwoo
A package for scraping the information of Hanwoo from DATA.GO.KR

## Overview
공공데이터포털에서 제공하는 한우의 기본정보, 도체정보 및 KPN 씨수소의 정보를 가져오는 패키지입니다.  

## Installation  

``` r
# The development version from GitHub:
# install.packages("devtools")
devtools::install_github("youngjunna/hanwoo")
```

## Usage
먼저 data.go.kr에서 API key를 신청하고 그 다음 활용 신청을 해야합니다. [다음글](https://youngjunna.github.io/2017/12/01/hanwoo-scraping/)을 참고해 진행하시면 됩니다.

### hanwoo.key
제일먼저 발급받은 API키를 등록해야 정상적으로 한우의 정보 및 도체정보를 가져올 수 있습니다.  

``` r
library(hanwoo)

hanwoo.key(key="YOUR_API_KEY_FROM_DATA.GO.KR")
```

### hanwoo.info
특정 한우 개체번호(002로 시작)를 입력하여 정보를 리스트형태로 가져올 수 있습니다.  

``` r
hanwoo.info(cattle="002083191603")
```

### hanwoo.bull
KPN 한우 씨수소의 정보를 가져올 수 있습니다. API key를 요구하지 않습니다.

``` r
hanwoo.bull(KPN=1080)
```

## Getting helps
Email: ruminoreticulum@gmail.com
