# TP 02 - Algorithme de Metropolis-Hastings

y = c(9.37, 10.18, 9.16, 11.60, 10.33)
sig2 = 1
d2 = 10
b = 5
n = 5

# Y ~ N(Teta, sig2)
# Teta ~ N(b, d2)
# Teta | y ~ N( ((b/d2) + (n*yb/sig2) / (1/d2) + n/sig2) , 1 / (1/d2 + n))

mu = (b/d2 + sum(y)/sig2) / (1/d2+n/sig2)
print(mu)

s2 = 1/(1/d2 + n/sig2)
print(s2)

# dnorm -> densite loi normale
# pnorm -> repartition loi normale
# qnorm -> quantile loi normale
# rnorm -> generateur loi normale
# runif -> generateur loi uniforme

# r = f(Teta*) * Produit( f(y_k | Teta*) ) / [ f(Teta_i-1) * Produit( f(y_k | Teta_i-1) ) ]

chaine=function(delta2, S){
    theta = 0; f = 0; THETA = 0
    for(i in 1:S){
        theta.star = rnorm(1, theta, sqrt(delta2)) 
        log.r = sum(dnorm(y, theta.star, sqrt(sig2), log=T)) +
            dnorm(theta.star, b, sqrt(d2), log=T) -
            sum(dnorm(y, theta, sqrt(sig2), log=T)) -
            dnorm(theta, b, sqrt(d2), log=T)

        if(log(runif(1)) < log.r){
            theta = theta.star
            f = f + 1
        }
        THETA = c(THETA, theta)
    }
    print(paste("Frequence d'acceptation = ", f / S))
    return(THETA)
}

L = chaine(2, 10000)

hist(L[50:10000], prob=T)
x = seq(8, 12, 0.01)
lines(x, dnorm(x, mu, sqrt(s2)), lwd=10)

# delta2 = 2 ==> f ~= 35%
# delta2 = 64 ==> f ~= 7%
# delta2 = 1/32 ==> f ~= 87%

# On vise en general 20% < f < 40%
