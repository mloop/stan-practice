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
  int<lower=0> N;
  vector[N] y;
  int<lower=0, upper=N> N_obs;
  int<lower=0, upper=N> N_mis;
  vector[N_obs] x_obs;
  int<lower=1, upper = N>  i_obs[N_obs];
  int<lower=1, upper = N>  i_mis[N_mis];
}

// The parameters accepted by the model. Our model
// accepts two parameters 'mu' and 'sigma'.
parameters {
  real b_0;
  real b_1;
  real<lower=0> sigma;
  vector[N_mis] x_imp;
  real mu_x;
  real<lower=0> sigma_x;
}

transformed parameters {
  vector[N] x;
  x[i_obs] = x_obs;
  x[i_mis] = x_imp;
}

// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'mu'
// and standard deviation 'sigma'.
model {
  x_obs ~ normal(mu_x, sigma_x);
  x_imp ~ normal(mu_x, sigma_x);
  y ~ normal(b_0 + b_1 * x, sigma);
  
  // priors
  b_0 ~ normal(0, 10);
  b_1 ~ normal(0, 10);
  mu_x ~ normal(0, 10);
  sigma_x ~ cauchy(0, 5);
}
