#' IGDB Games
#'
#' Search for a list of games from the IGDB API.
#'
#' @md
#' @param search a string with a keyword or title.
#' @param id a vector containing game ids.
#' @param n maximum number of results to return.
#' @param limit maximum number of results per page.
#' @param scroll an alternative method for retrieving multiple pages of results.
#' @param filter a string that limits the kinds of results returned.
#' @param fields a vector of fields to retrieve. NULL returns a data.frame with
#' all available fields that contain data.
#' @param order a string defining how results are sorted.
#' @param api_key the IGDB api key.
#' @param ... include extra url arguments (e.g. expander).
#'
#' @importFrom httr GET modify_url stop_for_status http_type headers content
#' @importFrom jsonlite fromJSON flatten
#' @importFrom stats setNames
#' @seealso [IGDB API](https://igdb.github.io/api/about/welcome/)
#' @examples
#' \dontrun{
#' # Search for the game Bioshock, ordering by the release date.
#' bioshock <- igdb_games(
#'   search = "bioshock",
#'   order = "first_release_date:asc"
#' )
#' }
#'
#' @export
igdb_games <- function(search = NULL, id = NULL, n = 50, limit = 50,
                       scroll = FALSE, filter = NULL, fields = NULL,
                       order = NULL, api_key = igdb_key(), ...) {
  # Configure parameters.
  base_url <- "https://api-2445582011268.apicast.io"
  id <- if (!is.null(id)) paste0(id, collapse = ",")  else NULL
  fields <- if (!is.null(fields)) paste0(fields, collapse = ",") else "*"
  limit <- if (n < limit) as.integer(n) else as.integer(limit)

  # Parse the api url.
  query <- httr::modify_url(
    url = base_url,
    path = paste0("games/", id),
    query = list(
      search = search,
      fields = fields,
      order = order,
      scroll = ifelse(scroll == TRUE, 1, 0),
      limit = limit,
      ...
      )
    )

  # Filters follow a special format, so those are appended rather than added
  # with modify_url.
  query <- add_filter(query, filter, base_url)

  headers <- httr::add_headers(
    "user-key" = api_key,
    "Accept" = "application/json"
    )
  query <- httr::GET(query, headers)

  # Check the request for problems.
  if (httr::http_error(query)) {
    stop(httr::http_status(query)[["message"]])
  }

  if (httr::http_type(query) != "application/json") {
    stop("Request did not return json", call. = FALSE)
  }


  res <- httr::content(query, type = "text", encoding = "UTF-8")
  res <- jsonlite::fromJSON(res, flatten = TRUE)

  h <- httr::headers(query)
  # Maximum number of results the query can return.
  m <- as.integer(h[["x-count"]])

  if (length(m) == 0) {
    m <- NROW(res)
    } else if (n == limit) {
      m <- NROW(res)
      } else if (m > n) {
        m <- n
        }

  if (scroll == TRUE && NROW(res) != m) {
    m <- if (m > n) n else m
    # Path for the next page. We can just query using this multiple times to
    # get several pages.
    s <- h[["x-next-page"]]

    res_list <- list(res)
    # Length of the list is just the maximum amount divided by the limit each
    # query returns. The default is set to 50.
    length(res_list) <- ceiling(m / limit)

    for (i in 2:length(res_list)) {
      query <- httr::modify_url(
        url = base_url,
        path = s
        )

      query <- httr::GET(query, httr::add_headers("user-key" = api_key))

      # Check the request for problems.
      if (httr::http_error(query)) {
        warning("Final query returned an error.")
        break
      }

      if (httr::http_type(query) != "application/json") {
        warning("Request did not return json.", call. = FALSE)
        break
      }

      res <- httr::content(query, type = "text", encoding = "UTF-8")
      res <- jsonlite::fromJSON(res, flatten = TRUE)
      res_list[[i]] <- res
    }
    res <- do.call(rbind2, res_list)
  } else if (NROW(res) != m) {

    if (m >= 10000) {
      warning("Offset can only retrieve 10000. Use scroll instead.")
      m <- 10000
    }

    limit <- if (is.null(limit)) 50 else limit

    res_list <- list(res)
    # Length of the list is just the maximum amount divided by the limit each
    # query returns. The default is set to 50.

    length(res_list) <- ceiling(m / limit)
    offset <- limit

    for (i in 2:length(res_list)) {
      query <- httr::modify_url(
        url = base_url,
        path = paste0("games/", id),
        query = list(
          search = search,
          fields = fields,
          order = order,
          limit = limit,
          offset = offset
        )
      )

      query <- add_filter(query, filter, base_url)

      headers <- httr::add_headers(
        "user-key" = api_key,
        "Accept" = "application/json"
      )
      query <- httr::GET(query, headers)

      # Check the request for problems.
      if (httr::http_error(query)) {
        warning("Final query returned an error.")
        break
      }

      if (httr::http_type(query) != "application/json") {
        warning("Request did not return json.", call. = FALSE)
        break
      }

      res <- httr::content(query, type = "text", encoding = "UTF-8")
      res <- jsonlite::fromJSON(res, flatten = TRUE)
      res_list[[i]] <- res
      offset <- offset + limit
    }
    res <- do.call(rbind2, res_list)
  }

  date_cols <- names(res) %in% date_cols
  if (any(date_cols)) {
    res[date_cols] <- lapply(
      X = res[date_cols],
      FUN = function(x) as.POSIXct(x / 1000, origin = "1970-01-01")
    )
  }

  setNames(res, gsub("[[:punct:]]", "_", names(res)))
}
