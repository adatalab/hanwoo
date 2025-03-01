#' hanwoo_info
#'
#' This function scrapes the information of Hanwoo from data.go.kr. Please get your API key and request for application at data.go.kr.
#' @param cattle Number of cattle to get the information for.
#' @param key_encoding Encoded API key from data.go.kr.
#' @param key_decoding Decoded API key from data.go.kr.
#' @param time_check Check the response time of the server.
#' @keywords Hanwoo
#' @export
#' @import XML
#' @import tibble
#' @importFrom lubridate ymd
#' @import dplyr
#' @import readr
#' @examples
#' hanwoo_info(cattle = "002083191603", key_encoding, key_decoding)
#' hanwoo_info(cattle = "002115280512", key_encoding, key_decoding)

hanwoo_info <- function(cattle, key_encoding, key_decoding, time_check = FALSE) {

  # 시간 체크 시작 (활성화된 경우)
  if(time_check == TRUE) {
    start_time <- Sys.time()
  }

  # 결과 리스트 초기화
  result <- list()

  # 소 번호의 길이를 확인하여 올바른 길이로 조정
  if (nchar(cattle) == 10) {
    cattle <- paste0("00", as.character(cattle))
  }
  if (nchar(cattle) == 9) {
    cattle <- paste0("000", as.character(cattle))
  }

  # XML을 안전하게 파싱하고 오류를 처리하기 위한 함수
  safe_xml_parse <- function(url) {
    tryCatch(
      {
        parsed_xml <- xmlParse(url)
        xmlRoot(parsed_xml)
      },
      error = function(e) {
        message("URL에서 XML 파싱 오류: ", url)
        return(NULL)
      }
    )
  }

  # 기본 정보 파싱 및 오류 확인
  basic_info <- safe_xml_parse(paste0("http://data.ekape.or.kr/openapi-data/service/user/animalTrace/traceNoSearch?ServiceKey=", key_encoding, "&traceNo=", cattle, "&optionNo=", 1))
  if (is.null(basic_info) || xmlToDataFrame(basic_info)$resultCode[1] == 99) {
    return(xmlToDataFrame(basic_info)$resultMsg[1])
  }

  # 기본 정보 추출 및 처리
  basic_info <- basic_info %>%
    getNodeSet("//item") %>%
    xmlToDataFrame(stringsAsFactors = FALSE) %>%
    as_tibble() %>%
    mutate(birthYmd = ymd(birthYmd))

  # 농장 정보 추출 및 처리
  farm_info <- safe_xml_parse(paste0("http://data.ekape.or.kr/openapi-data/service/user/animalTrace/traceNoSearch?ServiceKey=", key_encoding, "&traceNo=", cattle, "&optionNo=", 2)) %>%
    getNodeSet("//item") %>%
    xmlToDataFrame(stringsAsFactors = FALSE) %>%
    as_tibble() %>%
    mutate(cattleNo = cattle, regYmd = ymd(regYmd)) %>%
    select(cattleNo, everything())

  # 도축 정보 추출 및 처리
  butchery_info <- safe_xml_parse(paste0("http://data.ekape.or.kr/openapi-data/service/user/animalTrace/traceNoSearch?ServiceKey=", key_encoding, "&traceNo=", cattle, "&optionNo=", 3)) %>%
    getNodeSet("//item") %>%
    xmlToDataFrame(stringsAsFactors = FALSE) %>%
    as_tibble()
  if(nrow(butchery_info) > 0) {
    butchery_info <- butchery_info %>% mutate(butcheryYmd = ymd(butcheryYmd))
  }

  # 가공 정보 추출 및 처리
  process_info <- safe_xml_parse(paste0("http://data.ekape.or.kr/openapi-data/service/user/animalTrace/traceNoSearch?ServiceKey=", key_encoding, "&traceNo=", cattle, "&optionNo=", 4)) %>%
    getNodeSet("//item") %>%
    xmlToDataFrame(stringsAsFactors = FALSE) %>%
    as_tibble()

  # 백신 정보 추출 및 처리
  vaccine_info <- safe_xml_parse(paste0("http://data.ekape.or.kr/openapi-data/service/user/animalTrace/traceNoSearch?ServiceKey=", key_encoding, "&traceNo=", cattle, "&optionNo=", 5)) %>%
    getNodeSet("//item") %>%
    xmlToDataFrame(stringsAsFactors = FALSE) %>%
    as_tibble() %>%
    mutate(injectionYmd = ymd(injectionYmd))

  # 검사 정보 추출 및 처리
  inspect_info <- safe_xml_parse(paste0("http://data.ekape.or.kr/openapi-data/service/user/animalTrace/traceNoSearch?ServiceKey=", key_encoding, "&traceNo=", cattle, "&optionNo=", 6)) %>%
    getNodeSet("//item") %>%
    xmlToDataFrame(stringsAsFactors = FALSE) %>%
    as_tibble()

  # 브루셀라 정보 추출 및 처리
  brucella_info <- safe_xml_parse(paste0("http://data.ekape.or.kr/openapi-data/service/user/animalTrace/traceNoSearch?ServiceKey=", key_encoding, "&traceNo=", cattle, "&optionNo=", 7)) %>%
    getNodeSet("//item") %>%
    xmlToDataFrame(stringsAsFactors = FALSE) %>%
    as_tibble()
  if("inspectDt" %in% colnames(brucella_info)) {
    brucella_info <- brucella_info %>% mutate(inspectDt = ymd(inspectDt))
  }

  # 로트 정보 추출 및 처리
  lot_info <- safe_xml_parse(paste0("http://data.ekape.or.kr/openapi-data/service/user/animalTrace/traceNoSearch?ServiceKey=", key_encoding, "&traceNo=", cattle, "&optionNo=", 8)) %>%
    getNodeSet("//item") %>%
    xmlToDataFrame(stringsAsFactors = FALSE) %>%
    as_tibble()

  # 판매자 정보 추출 및 처리
  seller_info <- safe_xml_parse(paste0("http://data.ekape.or.kr/openapi-data/service/user/animalTrace/traceNoSearch?ServiceKey=", key_encoding, "&traceNo=", cattle, "&optionNo=", 9)) %>%
    getNodeSet("//item") %>%
    xmlToDataFrame(stringsAsFactors = FALSE) %>%
    as_tibble()

  # 추적 결과를 결과 리스트에 할당
  result$basic_info <- basic_info
  result$farm_info <- farm_info
  result$butchery_info <- butchery_info
  result$process_info <- process_info
  result$vaccine_info <- vaccine_info
  result$inspect_info <- inspect_info
  result$brucella_info <- brucella_info
  result$lot_info <- lot_info
  result$seller_info <- seller_info

  # 발급 번호 정보를 추출 및 처리
  get_issueNo <- safe_xml_parse(paste0("http://data.ekape.or.kr/openapi-data/service/user/grade/confirm/issueNo?animalNo=", cattle, "&ServiceKey=", key_encoding)) %>%
    getNodeSet("//item") %>%
    xmlToDataFrame(stringsAsFactors = FALSE)
  if (!is.null(get_issueNo) && !is.na(get_issueNo[1, 1])) {
    get_issueNo <- get_issueNo %>% as_tibble()
    get_issueNo$abattDate <- lubridate::ymd(get_issueNo$abattDate)
    get_issueNo$issueDate <- lubridate::ymd(get_issueNo$issueDate)
    get_issueNo$abattCode <- gsub(" ", "", as.character(get_issueNo$abattCode))
    result$get_issueNo <- get_issueNo
  }

  # 품질 정보 tibble 초기화
  quality_info <- tibble(cattleNo = NA, abattDate = NA, judgeSexNm = NA, birthmonth = NA, qgrade = NA, wgrade = NA, costAmt = NA, weight = NA, rea = NA, backfat = NA, insfat = NA, windex = NA, tissue = NA, yuksak = NA, fatsak = NA, growth = NA, abattAddr = NA, abattCode = NA, abattFno = NA, abattNm = NA, abattTelNo = NA, gradeCd = NA, gradeNm = NA, issueCnt = NA, issueDate = NA, issueNo = NA, judgeBreedNm = NA, judgeDate = NA, judgeKindCd = NA, judgeKindNm = NA, liveStockNm = NA, raterCode = NA, raterNm = NA, reqAddr = NA, reqComNm = NA, reqRegNo = NA, reqUserNm = NA)

  # 발급 번호가 있는 경우 품질 정보 추출 및 처리
  if (!is.null(get_issueNo) && !is.na(get_issueNo[1, 1])) {
    quality_info_add <- safe_xml_parse(paste0("http://data.ekape.or.kr/openapi-data/service/user/grade/confirm/cattle?issueNo=", get_issueNo$issueNo[1], "&issueDate=", get_issueNo$issueDate[1], "&ServiceKey=", key_decoding))
    if (!is.null(quality_info_add) && xmlToDataFrame(quality_info_add)$resultCode[1] != 99) {
      quality_info_add <- quality_info_add %>%
        getNodeSet("//item") %>%
        xmlToDataFrame(stringsAsFactors = FALSE) %>%
        as_tibble()

      # 새로운 컬럼을 기존 tibble에 추가
      new_columns <- setdiff(names(quality_info_add), names(quality_info))
      for (col in new_columns) {
        quality_info[[col]] <- NA
      }

      quality_info <- quality_info %>% add_row(quality_info_add) %>%
        mutate(
          qgrade = factor(qgrade, levels = c("D", "3", "2", "1", "1+", "1++")),
          issueDate = ymd(issueDate),
          abattDate = lubridate::ymd(abattDate),
          birthmonth = as.numeric(birthmonth),
          costAmt = as.integer(costAmt),
          weight = as.integer(weight),
          rea = as.integer(rea),
          backfat = as.integer(backfat),
          insfat = as.integer(insfat),
          windex = as.numeric(windex),
          tissue = as.integer(tissue),
          yuksak = as.integer(yuksak),
          fatsak = as.integer(fatsak),
          growth = as.integer(growth)
        )
      if ("costAmt" %in% names(quality_info)) {
        quality_info <- quality_info %>%
          select(cattleNo, abattDate, judgeSexNm, birthmonth, qgrade, wgrade, costAmt, weight, rea, backfat, insfat, windex, tissue, yuksak, fatsak, growth, everything()) %>%
          mutate(
            abattDate = lubridate::ymd(abattDate),
            birthmonth = as.numeric(birthmonth),
            costAmt = as.integer(costAmt),
            weight = as.integer(weight),
            rea = as.integer(rea),
            backfat = as.integer(backfat),
            insfat = as.integer(insfat),
            windex = as.numeric(windex),
            tissue = as.integer(tissue),
            yuksak = as.integer(yuksak),
            fatsak = as.integer(fatsak),
            growth = as.integer(growth)
          )
      } else {
        quality_info <- quality_info %>%
          select(cattleNo, abattDate, judgeSexNm, birthmonth, qgrade, wgrade, weight, rea, backfat, insfat, windex, tissue, yuksak, fatsak, growth, everything()) %>%
          mutate(
            abattDate = lubridate::ymd(abattDate),
            birthmonth = as.numeric(birthmonth),
            costAmt = NA,
            weight = as.integer(weight),
            rea = as.integer(rea),
            backfat = as.integer(backfat),
            insfat = as.integer(insfat),
            windex = as.numeric(windex),
            tissue = as.integer(tissue),
            yuksak = as.integer(yuksak),
            fatsak = as.integer(fatsak),
            growth = as.integer(growth)
          )
      }
      quality_info <- quality_info %>% filter(!is.na(cattleNo))
    }
  }

  # 품질 정보를 결과 리스트에 할당
  result$quality_info <- quality_info

  # 시간 체크가 활성화된 경우 서버 응답 시간 출력
  if(time_check == TRUE) {
    time_check <- paste0("서버 응답 시간: ", Sys.time() - start_time)
    print(time_check)
  }

  # 결과 리스트 반환
  return(
    tryCatch(
      result,
      error = function(e) NULL
    )
  )
}
