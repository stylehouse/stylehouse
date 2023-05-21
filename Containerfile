FROM perl:latest
WORKDIR /app
# Install required packages
RUN apt-get update && apt-get install -y \
    libuuid-perl \
    libyaml-syck-perl \
    libmojolicious-perl \
    libjson-xs-perl \
    libfile-slurp-perl \
    liblist-moreutils-perl
CMD ./serve.pl
