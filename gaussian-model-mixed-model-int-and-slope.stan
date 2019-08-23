//
// This Stan program defines a simple model, with a
// vector of values 'y' modeled as normally distributed
// with mean 'mu' and standard deviation 'sigma'.
//
// Learn more about model development with Stan at:
//
//    http://mc-stan.org/users/interfaces/rstan.html
//    https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started
//

// The input data is a vector 'y' of length 'N'.
data {
  int<lower=0> N_obs;
  vector[N_obs] y;
  int<lower=0> n_groups;
  matrix[N_obs, n_groups] x_group;
  vector[N_obs] height;
}

// The parameters accepted by the model. Our model
// accepts two parameters 'mu' and 'sigma'.
parameters {
  real b_0;
  real b_1;
  real<lower=0> sigma;
  matrix[n_groups, 2] u;
  real<lower=0> groups_int;
  real<lower=0> groups_slope;
  matrix[2, 2] Sigma_r;
}

// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'mu'
// and standard deviation 'sigma'.
model {
  y ~ normal(b_0 + x_group * u[, 1] + b_1 * height + height * (x_group * u[, 2]), sigma);
  u ~ multi_normal(0, Sigma_r);
  
  // priors
  b_0 ~ normal(0, 10);
  b_0 ~ normal(0, 5);
  sigma ~ cauchy(0, 1);
  Sigma_r ~ cauchy(0, 1);
}

