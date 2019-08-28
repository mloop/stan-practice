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
  corr_matrix[n_groups] omega;
  vector<lower=0>[n_groups] sigma_group;
  vector[n_groups] mu_u;
}

transformed parameters{
  matrix[n_groups, n_groups] Sigma;
  Sigma = quad_form_diag(omega, sigma_group);  // Creates the diag(variance) * corr_matrix * diag(variance) decomposition of covariance matrix
}

// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'mu'
// and standard deviation 'sigma'.
model {
  u ~ multi_normal(mu_u, quad_form_diag(omega, sigma_group));  
  y ~ normal(b_0 + x_group * u[, 1] + b_1 * height + height * (x_group * u[, 2]), sigma);
  
  // priors
  b_0 ~ normal(0, 10);
  b_0 ~ normal(0, 5);
  sigma ~ cauchy(0, 1);
  sigma_groups ~ cauchy(0, 1);
  omega ~ lkj_corr(2);
}

