# Exercice 4 : problème aux N-corps

Ce fichier fait partie du rendu évalué pour le BE de Calcul parallèle.

## Question 1

Déterminer quels calculs peuvent être parallélisés et quelles communications mettre en
place dans le code séquentiel suivant. Proposer une réécriture parallèle avec
transmission de messages de ce code.

```
variables : force[1,...,N], data[1,...,N]
for t in 1, nb_steps do
  for i in 1, N do
    force[i] = 0
    for j in 1, N do
      force[i] = force[i] + interaction(data[i], data[j])
    end for
  end for
  for i in 1, N do
    data[i] = update(data[i], force[i])
  end for
end for
```

### Réponse Q1

Il est possible de paralleliser les deux boucles for imbriquées. Il faut
cependant faire attention à la dépendance de données entre les deux boucles.

Voici une version parallèle du code avec MPI.
```
variables : force[1,...,N], data[1,...,N]
m = N / MPI_Comm_size(MPI_COMM_WORLD) // Nombre de processus
local_force[1,...,m] // Force locale
// Scatter force on all processes
MPI_Scatter(force, local_force, m, MPI_DOUBLE, MPI_COMM_WORLD)
for t in 1, nb_steps do
  for i in 1, m do
    local_force[i] = 0
    for j in 1, N do
      data_i = (rank - 1) * m + i
      local_force[i] = local_force[i] + interaction(data[data_i], data[j])
    end for
  end for
  // beggining of data
  begin = (rank - 1) * m + 1
  // end of data
  end = rank * m
  for i in begin, end do
    data[i] = update(data[i], local_force[i])
  end for
  local_data[1,...,m] // Data to send to other processes
  for i in 1, m do
    local_data[i] = data[begin + i]
  end for
  // Gather data from all processes
  MPI_Gather(local_force, m, MPI_DOUBLE, force, m, MPI_DOUBLE, MPI_COMM_WORLD)
  MPI_Allgather(local_data, m, MPI_DOUBLE, data, m, MPI_DOUBLE, MPI_COMM_WORLD)
end for
```

## Question 2

Proposer une version parallèle du code suivant.

```
variables : force[1,...,N], data[1,...,N]
for t in 1, nb_steps do
  for i in 1, N do
    force[i] = 0
  end for
  for i in 1, N do
    for j in 1, i-1 do
      f = interaction(data[i],data[j])
      force[i] = force[i] + f
      force[j] = force[j] - f
    end for
  end for
  for i in 1, N do
    data[i] = update(data[i], force[i])
  end for
end for
```

### Réponse Q2


```
variables : force[1,...,N], data[1,...,N]
m = N / MPI_Comm_size(MPI_COMM_WORLD) // Nombre de processus
local_force[1,...,m] // Force locale
// Scatter force on all processes
MPI_Scatter(force, local_force, m, MPI_DOUBLE, MPI_COMM_WORLD)
for t in 1, nb_steps do
  for i in 1, m do
    local_force[i] = 0
  end for
  MPI_Allgather(local_force, m, MPI_DOUBLE, force, m, MPI_DOUBLE, MPI_COMM_WORLD)
  // Same as sequential code
  for i in 1, N do
    for j in 1, i-1 do
      f = interaction(data[i],data[j])
      force[i] = force[i] + f
      force[j] = force[j] - f
    end for
  end for
  MPI_Scatter(data, local_data, m, MPI_DOUBLE, MPI_COMM_WORLD)
  for i in 1, m do
    begin = (rank - 1) * m + i
    local_data[i] = update(local_data[i], force[begin])
  end for
  MPI_Gather(local_data, m, MPI_DOUBLE, data, m, MPI_DOUBLE, MPI_COMM_WORLD)
end for
```

## Question 3

Quels sont les inconvénients de cette version ?
Proposer une solution pour les atténuer.

### Réponse Q3

On parallelise les boucles for exterieures qui sont en O(N) mais on garde la boucle for interieure qui est en O(N^2). On a donc parallelisé une partie du code de complexité negligable par rapport à la partie séquentielle.
Faire un graph de dependance de données pour voir si on peut paralleliser la boucle for interieure.

