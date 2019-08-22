library(rstan)
library(bayesplot)

options(mc.cores = parallel::detectCores())

d = list(
  N_obs = 1000,
  n_groups = 3,
  u = matrix(rnorm(n_groups, mean = 0, sd = 3), ncol = 1),
  group = sample(x = seq(1, n_groups, by = 1), size = 1000, replace = TRUE, prob = c(0.5, 0.3, 0.2)) %>% factor(),
  x_group = model.matrix(~ -1 + group),
  y_obs = rnorm(1000, mean = (0 + x_group %*% u), sd = 1)
)

fit <- stan(file = "gaussian-model-mixed-model.stan",
            data = d)

print(fit)
mcmc_intervals(fit, pars = tidyselect::vars_select(names(fit), -contains("lp")))
