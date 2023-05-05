# list all the bisextile years since 1880

for (i in 1880:2023) {
    if (i %% 4 == 0 & i %% 100 != 0) {
      print(i)
    } else if (i %% 400 == 0) {
        print(i)
    }
}
