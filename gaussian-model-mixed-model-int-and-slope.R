library(rstan)
library(bayesplot)
library(MASS)
library(tidyverse)

options(mc.cores = parallel::detectCores())


N_obs = 1000
n_groups = 3
Sigma <- matrix(c(1, 0.5, 0.5, 2),2,2)
u = matrix(mvrnorm(n_groups, mu = c(0, 0), Sigma = Sigma), ncol = 2)
group = sample(x = seq(1, n_groups, by = 1), size = 1000, replace = TRUE, prob = c(0.5, 0.3, 0.2)) %>% factor()
height = rnorm(N_obs, mean = 0, sd = 1)
x_group = model.matrix(~ -1 + group)
y = rnorm(1000, mean = (3 + x_group %*% u[, 1] + 2 * height + x_group %*% u[, 2] * height ), sd = 1)

d = list(
  N_obs = N_obs,
  n_groups = n_groups,
  height = height,
  x_group = x_group,
  y = y
)

fit <- stan(file = "gaussian-model-mixed-model-int-and-slope.stan",
            data = d)

print(fit)
mcmc_intervals(fit, pars = tidyselect::vars_select(names(fit), -contains("lp")))
