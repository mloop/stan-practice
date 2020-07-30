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
  matrix[N_obs_both] y_obs_both;
  vector[N_obs_y1] y1;
  vector[N_obs_y2] y2;
  int<lower=0> N_mis;
}

// The parameters accepted by the model. Our model
// accepts two parameters 'mu' and 'sigma'.
parameters {
  vector[2] mu;
  real<lower=0> sigma;
  vector[N_mis] y_mis;
}

// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'mu'
// and standard deviation 'sigma'.
model {
  y_obs ~ normal(mu, sigma);
  y_mis ~ normal(mu, sigma);
}

