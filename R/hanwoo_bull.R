#' hanwoo_bull
#'
#' This function scraping the bull information of Hanwoo from data.go.kr.
#' @param KPN KPN number of a bull you get the inform.
#' @keywords Hanwoo bull
#' @export
#' @import XML
#' @examples
#' hanwoo_bull(KPN=1080)

hanwoo_bull<-function(KPN){
  
  # package
  stopifnot(require(XML))
  
  #import bull informations
  url1<-paste("http://hanwoori.nias.go.kr/openapi/brblInfoOk.jsp?dataType=xml&brblNo=","KPN",KPN,sep="")
  xmlfile1<-xmlParse(url1)
  xmltop1<-xmlRoot(xmlfile1)
  get_inform<-xmlToDataFrame(getNodeSet(xmlfile1,"//item"),stringsAsFactors=FALSE)
  
  get_inform<-get_inform[-c(1,2,3,10,11,12,13,14,20,22,23,24,25,26,29,31,38,39,40,41,43,45,53,54)]
  
  #print
  return(get_inform)
}