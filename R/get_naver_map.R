get_naver_map <- function (center = c(lon = 126.9849208, lat = 37.5664519), zoom = 5,
                           size = c(640, 640), format = c("png", "jpeg", "jpg"),
                           crs = c("EPSG:4326", "NHN:2048", "NHN:128", "EPSG:4258",
                                   "EPSG:4162", "EPSG:2096", "EPSG:2097", "EPSG:2098", "EPSG:900913"),
                           maptype = c("basic", "satellite", "terrain"), color = c("color", "bw"),
                           markers, scale = 1,
                           naver_id, naver_secret,
                           address = FALSE,
                           filename = "ggmapTemp",
                           messaging = FALSE, urlonly = FALSE, force = FALSE, where = tempdir(),
                           archiving = TRUE, ...)
{
  args <- as.list(match.call(expand.dots = TRUE)[-1])
  argsgiven <- names(args)
  crs <- match.arg(crs)
  if (address) {
    center <- as.numeric(geocode_naver(center, naver_key,
                                       naver_secret))
  }

  if ("center" %in% argsgiven) {
    if (!((is.numeric(center) && length(center) == 2) ||
          (is.character(center) && length(center) == 1))) {
      stop("center of map misspecified, see ?get_googlemap.",
           call. = F)
    }
    if (all(is.numeric(center))) {
      lon <- center[1]
      lat <- center[2]
      if (lon < -180 || lon > 180) {
        stop("longitude of center must be between -180 and 180 degrees.",
             " note ggmap uses lon/lat, not lat/lon.", call. = F)
      }
      if (lat < -90 || lat > 90) {
        stop("latitude of center must be between -90 and 90 degrees.",
             " note ggmap uses lon/lat, not lat/lon.", call. = F)
      }
    }
  }
  if ("zoom" %in% argsgiven) {
    if (!(is.numeric(zoom) && zoom == round(zoom) && zoom >=
          0)) {
      stop("zoom must be a whole number between 0 and 20",
           call. = F)
    }
  }
  if ("size" %in% argsgiven) {
    stopifnot(all(is.numeric(size)) && all(size == round(size)) &&
                all(size > 0))
  }
  if ("markers" %in% argsgiven) {
    markers_stop <- TRUE
    if (is.data.frame(markers) && all(apply(markers[, 1:2],
                                            2, is.numeric)))
      markers_stop <- FALSE
    if (class(markers) == "list" && all(sapply(markers, function(elem) {
      is.data.frame(elem) && all(apply(elem[, 1:2], 2,
                                       is.numeric))
    })))
      markers_stop <- FALSE
    if (is.character(markers) && length(markers) == 1)
      markers_stop <- FALSE
    if (markers_stop)
      stop("improper marker specification, see ?get_naver_map.",
           call. = F)
  }

  if ("filename" %in% argsgiven) {
    filename_stop <- TRUE
    if (is.character(filename) && length(filename) == 1)
      filename_stop <- FALSE
    if (filename_stop)
      stop("improper filename specification, see ?get_naver_map",
           call. = F)
  }
  if ("messaging" %in% argsgiven)
    stopifnot(is.logical(messaging))
  if ("urlonly" %in% argsgiven)
    stopifnot(is.logical(urlonly))
  format <- match.arg(format)
  color <- match.arg(color)
  maptype <- match.arg(maptype)
  crs <- match.arg(crs)

  if (!missing(markers) && class(markers) == "list")
    markers <- list_to_dataframe(markers)

  base_url <- "https://naveropenapi.apigw.ntruss.com/map-static/v2/raster?"

  center_url <- if (all(is.numeric(center))) {
    center <- round(center, digits = 6)
    lon <- center[1]
    lat <- center[2]
    paste0("center=", paste(lon, lat, sep = ","))
  }
  else {
    stop("improper center specification, see ?get_naver_map.",
         call. = F)
  }
  zoom_url <- paste0("level=", zoom)
  size_url <- paste0("w=", paste(size, collapse = "&h="))
  format_url <- paste0("format=", format)
  maptype_url <- paste0("maptype=", maptype)

  crs_url <- paste0("crs=", crs)
  color_url <- paste0("color=", color)
  scale_url <- paste0("scale=", scale)
  markers_url <- if (!missing(markers)) {
    if (is.data.frame(markers)) {
      paste("markers=", paste(apply(markers, 1, function(v) paste(round(v,
                                                                        6), collapse = ",")), collapse = ","), sep = "")
    }
    else {
      paste("markers=", markers, sep = "")
    }
  }
  else {
    ""
  }

  post_url <- paste(crs_url, center_url,
                    zoom_url, size_url, maptype_url, format_url,
                    markers_url, scale_url, sep = "&")
  url <- paste(base_url, post_url, sep = "")
  url <- gsub("[&]+", "&", url)
  if (substr(url, nchar(url), nchar(url)) == "&") {
    url <- substr(url, 1, nchar(url) - 1)
  }
  url <- URLencode(url)
  if (urlonly)
    return(url)
  if (nchar(url) > 2048)
    stop("max url length is 2048 characters.", call. = FALSE)
  map <- file_drawer_get(url)

  if (!is.null(map) && !force)
    return(map)


  map<- httr::GET(url, add_headers(`X-NCP-APIGW-API-KEY-ID` = naver_id,
                                   `X-NCP-APIGW-API-KEY` = naver_secret))

  map <- httr::content(map)
  message(paste0("Map from URL : ", url))

  if (color == "color") {
    map <- apply(map, 2, rgb)
  }
  else if (color == "bw") {
    mapd <- dim(map)
    map <- gray(0.3 * map[, , 1] + 0.59 * map[, , 2] + 0.11 *
                  map[, , 3])
    dim(map) <- mapd[1:2]
  }

  class(map) <- c("ggmap", "raster")
  ll <- get_border_lon_lat(center[1], center[2], zoom + 1, size[1],
                           size[2])
  attr(map, "bb") <- data.frame(ll.lat = ll[2], ll.lon = ll[1],
                                ur.lat = ll[4], ur.lon = ll[3])
  out <- t(map)
  attr(map, "source") <- "naver"
  attr(map, "maptype") <- "naver"
  attr(map, "zoom") <- zoom
  if (archiving)
    file_drawer_set(url, out)
  out
}
