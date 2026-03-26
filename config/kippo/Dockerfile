FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Dependencias do sistema conforme roteiro do professor
RUN apt-get update && apt-get install -y \
    python2 python2-dev openssl authbind gcc git wget vim openssh-client \
    && rm -rf /var/lib/apt/lists/*

# Instalar pip2
RUN wget -q https://bootstrap.pypa.io/pip/2.7/get-pip.py && \
    python2 get-pip.py && \
    rm get-pip.py

# Instalar bibliotecas Python conforme roteiro
RUN pip2 install Twisted==15.2.1 pycrypto pyasn1

# Criar usuario kippo conforme roteiro
RUN useradd -d /home/kippo -s /bin/bash -m kippo

# Configurar authbind para porta 22
RUN touch /etc/authbind/byport/22 && \
    chown kippo /etc/authbind/byport/22 && \
    chmod 777 /etc/authbind/byport/22

# Clonar kippo como usuario kippo
RUN su kippo -c "git clone https://github.com/desaster/kippo.git /home/kippo/kippo"

# Copiar userdb
COPY userdb.txt /home/kippo/kippo/data/userdb.txt

# Configurar kippo.cfg a partir do dist
RUN cp /home/kippo/kippo/kippo.cfg.dist /home/kippo/kippo/kippo.cfg && \
    sed -i 's/^#\?ssh_port.*/ssh_port = 2222/' /home/kippo/kippo/kippo.cfg

# Corrigir start.sh conforme roteiro do professor
RUN sed -i 's|twistd -y kippo.tac|authbind --deep twistd -y kippo.tac|' \
    /home/kippo/kippo/start.sh

RUN chown -R kippo:kippo /home/kippo/kippo

WORKDIR /home/kippo/kippo

USER kippo

EXPOSE 2222

CMD ["authbind", "--deep", "twistd", "-n", "-y", "kippo.tac"]