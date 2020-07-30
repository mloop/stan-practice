library(rstan)
library(bayesplot)
library(MASS)

options(mc.cores = parallel::detectCores())

d = list(
  N_obs = 100,
  N_mis = 10,
  y_obs = mvrnorm(110, mu = c(0, 0), Sigma = matrix(c(1, 0.5, 0.5, 1), ncol = 2))
)

fit <- stan(file = "gaussian-model-missing-data.stan",
            data = d)

print(fit)
mcmc_intervals(fit, pars = c('mu', 'sigma', 'y_mis[1]'))
