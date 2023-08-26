###############################################################################
# R Al Parque 
# Dockerfile para el organizador
# Use Rocker r-base https://github.com/rocker-org/rocker
###############################################################################
FROM rocker/r-base

MAINTAINER "Frans van Dunné" frans.vandunne@gmail.com

RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Genera llaves para tener la carpeta .ssh
RUN ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa

### Set Up snow
RUN install.r snow
#RUN install.r foreach
#RUN install.r doSNOW

COPY . /usr/local/src/rscripts

WORKDIR /usr/local/src/rscripts

#CMD ["/bin/bash"]

CMD ["Rscript", "organizador.R"]
