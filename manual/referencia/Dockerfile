###############################################################################
# Dockerfile para la referencia (snow-cluster en una sola maquina)
# Use Rocker r-base
# https://github.com/rocker-org/rocker
###############################################################################

FROM rocker/r-base
RUN install.r snow
COPY . /usr/local/src/rscripts
WORKDIR /usr/local/src/rscripts
CMD ["Rscript", "referencia.R"]
