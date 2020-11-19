FROM ubuntu:18.04
# ENV HTTP_PROXY="http://host.docker.internal:1087"
# ENV HTTPS_PROXY="https://host.docker.internal:1087"
RUN apt-get update && \
    apt-get install -y \    
    libssl-dev \
    git \
    gcc \
    libsodium-dev\
    libcurl4 \
    openssl \
    mongodb\
    build-essential\
    vim\
    unzip\
    lsof

# install ruby.
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    rm -rf /var/lib/apt/lists/*
RUN add-apt-repository ppa:brightbox/ruby-ng
RUN apt-get update
RUN apt-get install -y ruby2.6 ruby2.6-dev
RUN apt -y install libsecp256k1-dev
RUN apt-get install -y wget

# Define mountable directories.
VOLUME ["/data/db"]

# CKB
RUN wget https://github.com/nervosnetwork/ckb/releases/download/v0.38.0-rc1/ckb_v0.38.0-rc1_x86_64-unknown-linux-gnu.tar.gz
RUN tar -zxvf ckb_v0.38.0-rc1_x86_64-unknown-linux-gnu.tar.gz
RUN mkdir testnet

# CKB indexer
RUN wget https://github.com/nervosnetwork/ckb-indexer/releases/download/v0.1.8/ckb-indexer-0.1.8-linux.zip
RUN unzip ckb-indexer-0.1.8-linux.zip 
RUN tar -zxvf ckb-indexer-linux-x86_64.tar.gz 
RUN mkdir indexer_tmp

# Get channel demo.
# RUN git config --global http.proxy 'socks5://host.docker.internal:1086'
# RUN git config --global https.proxy 'socks5://host.docker.internal:1086'
RUN git clone http://github.com/ZhichunLu-11/channel_demo_tg_msg_sender.git
WORKDIR /channel_demo_tg_msg_sender/client
RUN gem install bundler
RUN gem install \
    "thor"\
    "bson:~> 4.8.2"\
    'mongo:~>2.4'\
    "net-http-persistent:~>3.1.0"\
    "rbnacl:~>7.1.1"\
    "bitcoin-secp256k1:~>0.5.2"
RUN bundle install


COPY docker-entrypoint.sh /usr/local/bin
RUN chmod 777 /usr/local/bin/docker-entrypoint.sh
# RUN unset HTTP_PROXY
# RUN unset HTTPS_PROXY
ENTRYPOINT ["docker-entrypoint.sh"]
