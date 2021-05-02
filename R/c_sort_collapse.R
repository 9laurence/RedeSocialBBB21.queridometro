#' c_sort_collapse
#'
#' @description Sort and collapse two vectors in a column.
#'
#'
#' @export
c_sort_collapse <- function(...){
  c(...) %>%
    sort() %>%
    str_c(collapse = ".")
}
