# Suppress R CMD check "no visible binding for global variable" notes
# These are column names used in dplyr verbs (mutate, select, filter, etc.)
utils::globalVariables(c(
  # hanwoo_info.R column names
  "abattDate", "backfat", "birthYmd", "birthmonth", "butcheryYmd",
  "cattleNo", "costAmt", "fatsak", "growth", "injectionYmd",
  "insfat", "inspectDt", "issueDate", "judgeSexNm", "qgrade",
  "rea", "regYmd", "tissue", "weight", "wgrade", "windex", "yuksak",
  # hanwoo_bull.R column names
  "BIRTH_DATETM", "BRBL_SPCHCKN_CODE_NM", "BRDR_BCKF_THCN",
  "BRDR_CRWG", "BRDR_LN_Y_AR", "BRDR_MRSC", "SCDR_KPN", "SLE_AT_NM",
  # hanwoo_stock.R column names
  "date"
))
