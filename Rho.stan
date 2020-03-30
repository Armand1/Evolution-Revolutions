
data{
  int N; // number of obs
  int K; // number of variables
  matrix[N,K] X;
}

parameters{
  real rho_raw[K];
  real<lower=0> sigma[K];
  real rho_top;
  real<lower=0> sigma_top;
}

transformed parameters{
  real rho[K];
  for(i in 1:K)
    rho[i] = rho_top + rho_raw[i] * sigma_top;
}

model{
  for(i in 1:K)
    for(t in 2:N)
      X[t,i] ~ normal(rho[i] * X[t-1,i],sigma[i]);
  rho_raw ~ normal(0,1);
  rho_top ~ normal(0.5,1);
  sigma_top ~ normal(0,1);
  sigma ~ normal(0,1);
}

generated quantities{
  real rho_average;
  rho_average = normal_rng(rho_top,sigma_top);
}
