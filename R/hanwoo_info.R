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
#' \dontrun{
#' hanwoo_info(cattle = "002083191603", key_encoding, key_decoding)
#' hanwoo_info(cattle = "002115280512", key_encoding, key_decoding)
#' }

hanwoo_info <- function(cattle, key_encoding, key_decoding, time_check = FALSE) {

  # Start time check (if enabled)
  if(time_check == TRUE) {
    start_time <- Sys.time()
  }

  # Initialize result list
  result <- list()

  # Adjust cattle number to correct length
  if (nchar(cattle) == 10) {
    cattle <- paste0("00", as.character(cattle))
  }
  if (nchar(cattle) == 9) {
    cattle <- paste0("000", as.character(cattle))
  }

  # Helper function to safely parse XML and handle errors
  safe_xml_parse <- function(url) {
    tryCatch(
      {
        parsed_xml <- xmlParse(url)
        xmlRoot(parsed_xml)
      },
      error = function(e) {
        message("XML parsing error from URL: ", url)
        return(NULL)
      }
    )
  }

  # Parse basic info and check for errors
  basic_info <- safe_xml_parse(paste0("http://data.ekape.or.kr/openapi-data/service/user/animalTrace/traceNoSearch?ServiceKey=", key_encoding, "&traceNo=", cattle, "&optionNo=", 1))
  if (is.null(basic_info) || xmlToDataFrame(basic_info)$resultCode[1] == 99) {
    return(xmlToDataFrame(basic_info)$resultMsg[1])
  }

  # Extract and process basic info
  basic_info <- basic_info %>%
    getNodeSet("//item") %>%
    xmlToDataFrame(stringsAsFactors = FALSE) %>%
    as_tibble() %>%
    mutate(birthYmd = ymd(birthYmd))

  # Extract and process farm info
  farm_info <- safe_xml_parse(paste0("http://data.ekape.or.kr/openapi-data/service/user/animalTrace/traceNoSearch?ServiceKey=", key_encoding, "&traceNo=", cattle, "&optionNo=", 2)) %>%
    getNodeSet("//item") %>%
    xmlToDataFrame(stringsAsFactors = FALSE) %>%
    as_tibble() %>%
    mutate(cattleNo = cattle, regYmd = ymd(regYmd)) %>%
    select(cattleNo, everything())

  # Extract and process butchery info
  butchery_info <- safe_xml_parse(paste0("http://data.ekape.or.kr/openapi-data/service/user/animalTrace/traceNoSearch?ServiceKey=", key_encoding, "&traceNo=", cattle, "&optionNo=", 3)) %>%
    getNodeSet("//item") %>%
    xmlToDataFrame(stringsAsFactors = FALSE) %>%
    as_tibble()
  if(nrow(butchery_info) > 0) {
    butchery_info <- butchery_info %>% mutate(butcheryYmd = ymd(butcheryYmd))
  }

  # Extract and process processing info
  process_info <- safe_xml_parse(paste0("http://data.ekape.or.kr/openapi-data/service/user/animalTrace/traceNoSearch?ServiceKey=", key_encoding, "&traceNo=", cattle, "&optionNo=", 4)) %>%
    getNodeSet("//item") %>%
    xmlToDataFrame(stringsAsFactors = FALSE) %>%
    as_tibble()

  # Extract and process vaccine info
  vaccine_info <- safe_xml_parse(paste0("http://data.ekape.or.kr/openapi-data/service/user/animalTrace/traceNoSearch?ServiceKey=", key_encoding, "&traceNo=", cattle, "&optionNo=", 5)) %>%
    getNodeSet("//item") %>%
    xmlToDataFrame(stringsAsFactors = FALSE) %>%
    as_tibble() %>%
    mutate(injectionYmd = ymd(injectionYmd))

  # Extract and process inspection info
  inspect_info <- safe_xml_parse(paste0("http://data.ekape.or.kr/openapi-data/service/user/animalTrace/traceNoSearch?ServiceKey=", key_encoding, "&traceNo=", cattle, "&optionNo=", 6)) %>%
    getNodeSet("//item") %>%
    xmlToDataFrame(stringsAsFactors = FALSE) %>%
    as_tibble()

  # Extract and process brucella info
  brucella_info <- safe_xml_parse(paste0("http://data.ekape.or.kr/openapi-data/service/user/animalTrace/traceNoSearch?ServiceKey=", key_encoding, "&traceNo=", cattle, "&optionNo=", 7)) %>%
    getNodeSet("//item") %>%
    xmlToDataFrame(stringsAsFactors = FALSE) %>%
    as_tibble()
  if("inspectDt" %in% colnames(brucella_info)) {
    brucella_info <- brucella_info %>% mutate(inspectDt = ymd(inspectDt))
  }

  # Extract and process lot info
  lot_info <- safe_xml_parse(paste0("http://data.ekape.or.kr/openapi-data/service/user/animalTrace/traceNoSearch?ServiceKey=", key_encoding, "&traceNo=", cattle, "&optionNo=", 8)) %>%
    getNodeSet("//item") %>%
    xmlToDataFrame(stringsAsFactors = FALSE) %>%
    as_tibble()

  # Extract and process seller info
  seller_info <- safe_xml_parse(paste0("http://data.ekape.or.kr/openapi-data/service/user/animalTrace/traceNoSearch?ServiceKey=", key_encoding, "&traceNo=", cattle, "&optionNo=", 9)) %>%
    getNodeSet("//item") %>%
    xmlToDataFrame(stringsAsFactors = FALSE) %>%
    as_tibble()

  # Assign trace results to result list
  result$basic_info <- basic_info
  result$farm_info <- farm_info
  result$butchery_info <- butchery_info
  result$process_info <- process_info
  result$vaccine_info <- vaccine_info
  result$inspect_info <- inspect_info
  result$brucella_info <- brucella_info
  result$lot_info <- lot_info
  result$seller_info <- seller_info

  # Extract and process issue number info
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

  # Initialize quality info tibble
  quality_info <- tibble(cattleNo = NA, abattDate = NA, judgeSexNm = NA, birthmonth = NA, qgrade = NA, wgrade = NA, costAmt = NA, weight = NA, rea = NA, backfat = NA, insfat = NA, windex = NA, tissue = NA, yuksak = NA, fatsak = NA, growth = NA, abattAddr = NA, abattCode = NA, abattFno = NA, abattNm = NA, abattTelNo = NA, gradeCd = NA, gradeNm = NA, issueCnt = NA, issueDate = NA, issueNo = NA, judgeBreedNm = NA, judgeDate = NA, judgeKindCd = NA, judgeKindNm = NA, liveStockNm = NA, raterCode = NA, raterNm = NA, reqAddr = NA, reqComNm = NA, reqRegNo = NA, reqUserNm = NA)

  # Extract and process quality info if issue number is available
  if (!is.null(get_issueNo) && !is.na(get_issueNo[1, 1])) {
    quality_info_add <- safe_xml_parse(paste0("http://data.ekape.or.kr/openapi-data/service/user/grade/confirm/cattle?issueNo=", get_issueNo$issueNo[1], "&issueDate=", get_issueNo$issueDate[1], "&ServiceKey=", key_decoding))
    if (!is.null(quality_info_add) && xmlToDataFrame(quality_info_add)$resultCode[1] != 99) {
      quality_info_add <- quality_info_add %>%
        getNodeSet("//item") %>%
        xmlToDataFrame(stringsAsFactors = FALSE) %>%
        as_tibble()

      # Add new columns to existing tibble
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

  # Assign quality info to result list
  result$quality_info <- quality_info

  # Print server response time if time check is enabled
  if(time_check == TRUE) {
    time_check <- paste0("Server response time: ", Sys.time() - start_time)
    print(time_check)
  }

  # Return result list
  return(
    tryCatch(
      result,
      error = function(e) NULL
    )
  )
}
