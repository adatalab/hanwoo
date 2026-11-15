#' read_kahis
#'
#' This function gets livestock disease outbreak data. Data from KAHIS (Korea Animal Health Integrated System, kahis.go.kr).
#' @param path A file path or URL of the KAHIS outbreak CSV. Defaults to the dataset maintained on GitHub.
#' @keywords Hanwoo
#' @export
#' @import readr
#' @return A tibble containing livestock disease outbreak data. Date columns
#'   (outbreak, diagnosis and end dates) are parsed as Date and the number of
#'   affected animals as integer; all other columns are character.
#' @examples
#' \dontrun{
#' read_kahis()
#' }

read_kahis <- function(path = "https://raw.githubusercontent.com/Space-Agriculture/kahis/main/data/kahis_outbreaks.csv") {

  # Korean column names written as Unicode escapes to keep the source ASCII-only
  col_outbreak <- "\uBC1C\uC0DD\uC77C\uC790" # outbreak date
  col_diagnosis <- "\uC9C4\uB2E8\uC77C"      # diagnosis date
  col_end <- "\uC885\uC2DD\uC77C"            # end date
  col_heads <- "\uBC1C\uC0DD\uB450\uC218"    # number of affected animals

  col_spec <- list(.default = col_character())
  col_spec[[col_outbreak]] <- col_date("%Y-%m-%d")
  col_spec[[col_diagnosis]] <- col_date("%Y-%m-%d")
  col_spec[[col_end]] <- col_date("%Y-%m-%d")
  col_spec[[col_heads]] <- col_integer()

  kahis <- read_csv(
    path,
    locale = locale(encoding = "UTF-8"),
    na = c("", "NA", "-"),
    col_types = do.call(cols, col_spec),
    progress = FALSE
  )

  # Ignore future dates (e.g. typos such as 7021-02-01 in the source data)
  dates <- if (col_outbreak %in% names(kahis)) kahis[[col_outbreak]] else NULL
  dates <- dates[!is.na(dates) & dates <= Sys.Date()]
  if (length(dates) > 0) {
    last_date <- max(dates)
    cat(paste0("Data from https://www.kahis.go.kr; Last outbreak date: ", last_date, "\n"))
  }

  return(kahis)

}
