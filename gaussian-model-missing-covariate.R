library(rstan)
library(bayesplot)
library(tidyverse)
library(tidybayes)

options(mc.cores = parallel::detectCores())

N = 100
x = rnorm(100, mean = 0, sd = 1)
y = rnorm(100, mean = 5 + 3 * x, sd = 1)
x[c(3,8, 39, 50, 38, 45, 99)] = NA
x_obs <- x[which(is.na(x) == FALSE)]
x_mis <- x[which(is.na(x) == TRUE)]

d <- list(
  N = N,
  y = y,
  x_obs = x_obs,
  x_mis = x_mis,
  i_obs = which(is.na(x) == FALSE),
  i_mis = which(is.na(x) == TRUE),
  N_obs = length(x_obs),
  N_mis = length(x_mis)
)

fit <- stan(file = "gaussian-model-missing-covariate.stan",
            data = d)

library(rethinking)
precis(fit)

# Model is clearly struggling to identify the correct slope of b_1, which is 3, apart from the variance, which is 1. It's giving a b_1 of 0 and a sigma of 3.

# UPDATE: even with more relaxed prior on b_0, there's a problem.

gather_draws(fit, b_0, b_1, sigma, mu_x, sigma_x) %>%
  median_qi() %>%
  ggplot(aes(y = .variable, x = .value, xmin = .lower, xmax = .upper)) +
  geom_pointintervalh()
