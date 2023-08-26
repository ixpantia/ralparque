###############################################################################
# R Al Parque 
# Dockerfile para los artistas
# Use Rocker r-base https://github.com/rocker-org/rocker
###############################################################################
FROM rocker/r-base

MAINTAINER "Frans van Dunné" frans.vandunne@gmail.com

### Set Up SSH basado en el ejemplo en docker.com con cambios para usar debian
# https://docs.docker.com/engine/examples/running_ssh_service/

RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
# Fix this to match debian instead of ubuntu
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
RUN service ssh restart

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Genera un password conocido
RUN echo 'root:artista' | chpasswd

# Genera un par de llaves para poder ingresar remotamente
RUN ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa

## Fix PAM in sshd config 
## http://stackoverflow.com/questions/18173889/cannot-access-centos-sshd-on-docker
#RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
#RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

### Set Up snow
RUN install.r snow
COPY . /usr/local/src/rscripts
WORKDIR /usr/local/src/rscripts

## Necesitamos fijar el IP de los contenedores y hacerlos al iniciar nuevas
# instancias de los artistas. 

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
#CMD ["/bin/bash", "docker-entrypoint.sh"]
