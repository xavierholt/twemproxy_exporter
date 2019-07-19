FROM ruby:2.5.3-slim
MAINTAINER <jpantsjoha@gmail.com> 

# Metadata
ENV \
  EXPORTER_APPDIR=/opt/twemproxy_exporter \
  USER=exporter

# Prep and copy
RUN mkdir $EXPORTER_APPDIR && \
    useradd $USER
COPY . $EXPORTER_APPDIR
WORKDIR $EXPORTER_APPDIR

RUN apt-get update -y && \
    apt-get install git bundler -y && \
    bundle && \
    rm -rf /var/lib/apt/lists/* && \
    chown -R $USER $EXPORTER_APPDIR && \
    chmod 755 $EXPORTER_APPDIR/bin/*

USER $USER
EXPOSE 9876
CMD "/opt/twemproxy_exporter/bin/run.sh"
