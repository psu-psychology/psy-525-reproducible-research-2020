# Helper functions for pwr package

power_to_df <- function(x) {
  df <- data.frame(n1 = x$n1, n2 = x$n2, d = x$d, sig.level = x$sig.level, power = x$power, alternative = x$alternative)
  df
}

power_from_p_male <- function(p_male) {
  n_male <- p_male*300
  n_female <- n - n_male
  pwr::pwr.t2n.test(n_male, n_female, sig.level = 0.01, 
                    power = .8, alternative = "greater")
}

pow_calc <- function(p_male) {
  power_to_df(power_from_p_male(p_male))
}
