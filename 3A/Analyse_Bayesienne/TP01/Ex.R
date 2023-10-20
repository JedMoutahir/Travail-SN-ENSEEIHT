# 1) Initialisation

library(rootSolve)

# 2) Phase d'élicitation du prior

n = 150
x = 6

start = c(1, 10)

model = function(x, pa, qa, pb, qb){
    c(
        F1 = pa - pbeta(qa, x[1], x[2]),
        F2 = pb - pbeta(qb, x[1], x[2])
    )
}

sol = multiroot(f = model, start = start, pa = 0.05, qa = 0.01, pb = 0.9, qb = 0.05)
print(sol)

p = sol$root[1]
q = sol$root[2]

print(p)
print(q)

# 3) Elaboration du posterior

axe_x = seq(0, 0.2, 0.001)

# posterior
plot(axe_x, dbeta(axe_x, x + p, n + q - x), type="l")

# prior
lines(axe_x, dbeta(axe_x, p, q), col = "red")

# 4) distribution predictivea posteriori
polya = function(y, h, p, q, n, x){
    choose(h, y)*beta(y + x + p, h - y + n - x + q) / beta(x + p, n - x + q)
}

y = 0:10
par(mfrow=c(2,2))
for(h in c(5, 10,20,30)){
    plot(y, polya(y, h, p, q, n, x), type="h")
}

# 5) Outil d'aide à la prise de decision
par(mfrow=c(1,1))
h = seq(1, 30, 0.1)

p_h = 1 - polya(0, h, p, q, n, x)

plot(h, (1 - p_h) / p_h, type = "l")
abline(6, 0)

# 6) Epilogue
p = 0.5
q =0.5
polya = function(y, h, p, q, n, x){
    choose(h, y)*beta(y + x + p, h - y + n - x + q) / beta(x + p, n - x + q)
}

par(mfrow=c(1,1))
h = seq(1, 30, 0.1)

p_h = 1 - polya(0, h, p, q, n, x)

plot(h, (1 - p_h) / p_h, type = "l")
abline(6, 0)