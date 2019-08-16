library(rstan)
library(bayesplot)
library(truncnorm)
library(rstanarm)
library(tidyverse)

options(mc.cores = parallel::detectCores())

d = list(
  N_obs = 100,
  y_obs = rtruncnorm(100, mean = 1, sd = 1, a = 0),
  L = 0
)

fit <- stan(file = "gaussian-model-truncated-outcome.stan",
            data = d)

print(fit)
mcmc_intervals(fit, pars = c('mu', 'sigma'))

as.data.frame(fit) %>% 
  as_tibble() %>%
  group_by(mu, sigma) %>%
  mutate(
    posterior_prediction = rtruncnorm(1, a = 0, mean = mu, sd = sigma)
  ) %>%
  ungroup() %>%
  mutate(
    trunc_mean = mu + (sigma * dnorm((0 - mu) / sigma)) / (sigma * (1 - pnorm((0 - mu) / sigma)))
  ) %>%
  ggplot(aes(x = posterior_prediction)) +
  geom_histogram() +
  geom_vline(aes(xintercept = mean(trunc_mean)))
