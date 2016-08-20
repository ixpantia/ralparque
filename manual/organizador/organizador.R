#############################################################################
# Como esto es una prueba de concepto, buscamonos ejemplos bien descritos
# Comenzamos con el ejemplo de Hernan Resnizky como descrito aqui:
# https://hernanresnizky.com/2014/01/10/quick-guide-to-parallel-r-with-snow/
#############################################################################
# Para extender a multiples maquinas tenemos los siguientes ejemplos.
#
# Hay una discusion sobre multiples maquinas aqui:
# http://r.789695.n4.nabble.com/multi-machine-parallel-setup-td4568855.html
#
# alli Uwe Ligges dice:
# With appropriate ssh keys that do not need passwords and with the same 
# username on all machines, it should work out of the box. At least, it 
# does for me: 
# 
# Say you want two, one on your own machine, the other one on your friends: 
# 
#   cl <- makeCluster(c("localhost", "192.168.2.10"), "SOCK") 
### 
# Otro ejemplo con enfasis en la coneccion de SSH
# http://helmingstay.blogspot.com/2011/02/snow-and-ssh-secure-inter-machine.html
###
# Validar la coneccion entre maquinas resula dificil. Aqui hay una buena 
# Discucion porque, y como resolverlo:
# http://stackoverflow.com/questions/17966055/makecluster-function-in-r-snow-hangs-indefinitely
#############################################################################
library("snow")
library("foreach")
library("doSNOW")

#Create cluster
 
clus <- makeCluster(c("172.18.0.2", "172.18.0.3", "172.18.0.4"), type = "SOCK")
 
#Option 1. Declare the function for each node
 
clusterEvalQ(clus, custom.function <- function(a,b,c){
result <- (a+b)*c
return(result)})
 
#Option 2. Export it form base workspace
 
custom.function <- function(a,b,c){
result <- (a+b)*c
return(result)}
 
clusterExport(clus,"custom.function")
 
ex.df <- data.frame(a=seq(1,100,1),b=seq(10,1000,10),c=runif(100))
 
#Apply the declared function
 
aa <- parRapply(clus,ex.df, function(x) custom.function(x[1],x[2],x[3]))


print("Listo! Termine el script del Organizador")
print("el resultado es: \n")
print(aa)

