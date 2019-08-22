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
  vector[N_obs] y_obs;
  int<lower=0> n_groups;
  matrix[N_obs, n_groups] x_group;
}

// The parameters accepted by the model. Our model
// accepts two parameters 'mu' and 'sigma'.
parameters {
  real mu;
  real<lower=0> sigma;
  vector[n_groups] u;
  real<lower=0> rate_u;
  real<lower=0> shape_u;
}

// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'mu'
// and standard deviation 'sigma'.
model {
  y_obs ~ normal(mu + x_group * u, sigma);
  u ~ gamma(shape_u, rate_u);
  
  // priors
  mu ~ normal(0, 10);
  sigma ~ cauchy(0, 1);
  shape_u ~ cauchy(0, 1);
  rate_u ~ cauchy(0, 1);
}

