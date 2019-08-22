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
  int<lower = 0, upper = 1> run_estimation; 
}

// The parameters accepted by the model. Our model
// accepts two parameters 'mu' and 'sigma'.
parameters {
  real mu;
  real<lower=0> sigma;
}

// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'mu'
// and standard deviation 'sigma'.
model {
  if(run_estimation==1){
  y_obs ~ normal(mu, sigma);
  }
  
  // priors
  mu ~ normal(0, 5);
  sigma ~ cauchy(0, 0.5);
}

generated quantities {
  real y_rep[N_obs];

  for (n in 1:N_obs)
    y_rep[n] = normal_rng(mu, sigma); 
}
