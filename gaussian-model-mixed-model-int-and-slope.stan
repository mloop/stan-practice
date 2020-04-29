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
  vector[N_obs] height;
  int<lower=1, upper=n_groups> group[N_obs];
}

// The parameters accepted by the model. Our model
// accepts two parameters 'mu' and 'sigma'.
parameters {
  vector[n_groups] a;
  vector[n_groups] b;
  vector[n_groups] a_group;
  vector[n_groups] b_group;
  real<lower=0> sigma_y;
  corr_matrix[2] omega;
  vector<lower=0>[2] sigma_group;
  vector[2] mu_ab;
}

transformed parameters {
  // declarations
  vector[n_groups] ab_vector[3];
  
  
  // definitions
  for (j in 1:1) {
    ab_vector[j] = a;
  }
  for (j in 2:2) {
    ab_vector[j] = b;
  }
}

// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'mu'
// and standard deviation 'sigma'.
model {
  for (j in 1:n_groups) {
  ab_vector[j] ~ multi_normal(mu_ab, quad_form_diag(omega, sigma_group));  
  }
  for (n in 1:N_obs){
  y[n] ~ normal(a[group[n]] + b[group[n]] * height[n], sigma_y);
  }
  
  // priors
  sigma_y ~ cauchy(0, 1);
  sigma_group ~ cauchy(0, 1);
  omega ~ lkj_corr(2);
}

