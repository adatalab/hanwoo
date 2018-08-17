#' hanwoo_info
#'
#' This function scraping the information of Hanwoo from data.go.kr. Please get your API key and request for applicate at data.go.kr.
#' @param cattle Number of cattle you get the inform.
#' @keywords Hanwoo
#' @export
#' @import XML
#' @examples
#' hanwoo_info(cattle="002083191603")

hanwoo_info<-function(cattle){
  
  # package
  stopifnot(require(XML))

  df <- list()
  
  #import basic informations
  url1<-paste("http://data.ekape.or.kr/openapi-data/service/user/mtrace/breeding/cattle?cattleNo=",cattle,"&ServiceKey=",API_key,sep="")
  xmlfile1<-xmlParse(url1)
  xmltop1<-xmlRoot(xmlfile1)
  get_inform <- xmlToDataFrame(getNodeSet(xmlfile1,"//item"),stringsAsFactors=FALSE)
  df[[1]] <- get_inform
  
  #import an issueNo
  url2<-paste("http://data.ekape.or.kr/openapi-data/service/user/grade/confirm/issueNo?animalNo=",cattle,"&ServiceKey=",API_key,sep="")
  xmlfile2<-xmlParse(url2)
  xmltop2<-xmlRoot(xmlfile2)
  get_issueNo<-xmlToDataFrame(getNodeSet(xmlfile2,"//item"),stringsAsFactors=FALSE)
  Issue_No<-gsub(" ","",as.character(get_issueNo$issueNo)) #OR Issue_No<-stringr::str_trim(as.character(get_issueNo$issueNo))
  df[[2]] <- get_issueNo
  
  #import the carcass characteristics (by using the IssueNo)
  url3<-paste("http://data.ekape.or.kr/openapi-data/service/user/grade/confirm/cattle?issueNo=",Issue_No,"&ServiceKey=",API_key,sep="")
  xmlfile3<-xmlParse(url3)
  xmltop3<-xmlRoot(xmlfile3)
  get_hanwoo<-xmlToDataFrame(getNodeSet(xmlfile3,"//item"),stringsAsFactors=FALSE)
  
  df[[3]] <- get_hanwoo
  
  return(df)
}