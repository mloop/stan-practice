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
  int<lower=0> N_x_obs;
  vector[N_x_obs] x_obs;
  int<lower=0> N_mis;
  int<lower=1>  ii_x_obs[N_x_obs];
  int<lower=1>  ii_x_mis[N_mis];
  
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

// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'mu'
// and standard deviation 'sigma'.
model {
  x_obs ~ normal(mu_x, sigma_x);
  x_imp ~ normal(mu_x, sigma_x);
  for (n in ii_x_obs) 
    y_obs[n] ~ normal(b_0 + b_1 * x_obs, sigma);
  for (n in ii_x_mis)
  y_obs[ii_x_mis] ~ normal(b_0 + b_1 * x_imp, sigma);
  
  // priors
  b_0 ~ normal(0, 5);
  b_1 ~ normal(0, 5);
  mu_x ~ normal(0, 5);
  sigma_x ~ cauchy(0, 1);
}
