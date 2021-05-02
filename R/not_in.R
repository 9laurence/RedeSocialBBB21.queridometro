#' not_in
#'
#' @description Opposite of the %in% operator.
#'
#'
#' @export
'%!in%' <- function(x,y){
  !('%in%'(x,y))
}
