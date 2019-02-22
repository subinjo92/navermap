geocode_naver <- function (address, naver_id, naver_secret)
{
  if (is.character(address) == F) {
    stop("address is not character")
  }
  if (Encoding(address) == "UTF-8") {
    enc_address <- URLencode(address)
  }
  if (Encoding(address) != "UTF-8") {
    enc_address <- URLencode(iconv(address, localeToCharset()[1],
                                   to = "UTF-8"))
  }
  url <- "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?"
  url_fed_to_get <- paste0(url, "query=", enc_address)
  address_result <- GET(url_fed_to_get, add_headers(`X-NCP-APIGW-API-KEY-ID` = naver_id,
                                                    `X-NCP-APIGW-API-KEY` = naver_secret))
  json <- content(address_result, as = "text", encoding = "UTF-8")
  processed_json <- fromJSON(json)
  if (processed_json$meta$count == 0) {
    stop("incorrect address")
  }
  if (processed_json$meta$count != 1) {
    message("there are some results more than 1, please input more detail address")
    result <- processed_json$addresses[1, c(5,6)]
  }
  result <- processed_json$addresses[, c(5,6)]
  colnames(result) <- c('lon', 'lat')
  result$lon <- as.numeric(result$lon)
  result$lat <- as.numeric(result$lat)
  result
}
