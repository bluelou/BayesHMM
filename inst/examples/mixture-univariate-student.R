mySpec <- mixture(
  K = 3, R = 1,
  observation = Student(
    mu    = Default(),
    sigma = Gaussian(0,  10, bounds = list(0, NULL)),
    nu    = Gaussian(0, 100, bounds = list(0, NULL))
  ),
  initial     = Dirichlet(alpha = Default()),
  name = "Univariate Student t Mixture"
)

set.seed(9000)
y <- as.matrix(
  c(rnorm(50, 5, 1), rnorm(300, 0, 1), rnorm(100, -5, 1))
)

myFit <- fit(mySpec, y = y, chains = 1, iter = 500)

plot_obs(myFit)

print_all(myFit)
