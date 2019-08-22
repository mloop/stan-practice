library(rstan)
library(bayesplot)
library(tidybayes)

options(mc.cores = parallel::detectCores())

d = list(
  N_obs = 100,
  y_obs = rnorm(100, mean = 0, sd = 1),
  run_estimation = 0
)

compiled_model <- stan_model(file = "gaussian-model-prior-predictive-check.stan")

prior_checks <- sampling(compiled_model,
                         data = d,
                         )

mcmc_intervals(prior_checks)

prior_checks %>%
  spread_draws()
  as.data.frame() %>%
  as_tibble() %>%
  mutate(iteration = )
  select(contains("y_rep")) %>%
  gather(observation, prediction) %>%
  group_by()
