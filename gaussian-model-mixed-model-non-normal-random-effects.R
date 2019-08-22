library(rstan)
library(bayesplot)

options(mc.cores = parallel::detectCores())

N_obs = 10000
n_groups = 5
u = matrix(rgamma(n_groups, shape = 10, rate = 2), ncol = 1)
group = sample(x = seq(1, n_groups, by = 1), size = N_obs, replace = TRUE, prob = rep(1 / n_groups, n_groups)) %>% factor()
x_group = model.matrix(~ -1 + group)
y_obs = rnorm(10000, mean = (3 + x_group %*% u), sd = 1)

d = list(
  N_obs = N_obs,
  n_groups = n_groups,
  u = u,
  group = group,
  x_group = x_group,
  y_obs = y_obs
)

initf1 <- function() {
  list(mu = 3, sigma = 1, shape_u = 10, rate_u = 2)
} 

fit <- stan(file = "gaussian-model-mixed-model-non-normal-random-effects.stan",
            data = d,
            iter = 4000,
            control = list(adapt_delta = 0.9),
            init = initf1)

print(fit)
mcmc_intervals(fit, pars = tidyselect::vars_select(names(fit), -contains("lp")))
