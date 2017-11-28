#' IGDB API KEY
#'
#' Helper function to retrieve an IDGB api key.
#'
#' @md
#' @export
igdb_key <- function() {
  key <- Sys.getenv("IGDB_KEY")
  if (identical(key, "")) {
    stop("Please set environment variable 'IGDB_KEY' with your api key.")
  }
  key
}

#' rbind2
#'
#' Bind rows with mismatching column names.
#'
#' @md
#' @note `dplyr::bind_rows` is a much better alternative, but implementing
#' `rbind2` kept the number of package dependencies low.
#'
#' @param ... two or more valid objects that can be joined with `rbind`.
#'
rbind2 <- function(...) {
  dots <- as.list(substitute(as.list(...)))[-1L]
  res <- lapply(dots, eval, envir = parent.frame())
  cols <- unique(unlist(lapply(res, colnames)))
  res <- lapply(res, function(s) {
    d <- setdiff(cols, names(s))
    if (length(d) > 0 && NROW(s) > 0) {
      s[, d] <- NA
    }
    s
  })
  do.call(rbind, res)
}

#' Add filter
#'
#' Add a filter to a query url.
#'
#' @md
#' @param query a query url.
#' @param filter a filter string.
#' @param base_url api base url.
add_filter <- function(query, filter, base_url) {
  if (!is.null(filter) & !identical(query, base_url)) {
    query <- paste0(query, "&filter", filter)
  } else if (!is.null(filter)) {
    query <- paste0(query, "?filter", filter)
  }

  gsub("[[:space:]]", "", query)
}
