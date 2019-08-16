library(rstan)
library(bayesplot)

options(mc.cores = parallel::detectCores())

d = list(
  N_obs = 100,
  y_obs = rnorm(100, mean = 0, sd = 1)
)

fit <- stan(file = "gaussian-model.stan",
            data = d)

print(fit)
mcmc_intervals(fit, pars = c('mu', 'sigma'))
