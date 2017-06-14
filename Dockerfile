FROM java:openjdk-7-jre

#MAINTAINER Team Docksal, https://docksal.io

# Solr version
ENV SOLR_VERSION 4.10.4
ENV SOLR_MIRROR http://archive.apache.org/dist/lucene/solr
ENV SOLR solr-$SOLR_VERSION
ENV SOLR_COLLECTION_PATH /opt/$SOLR/example/solr/collection1

# Download and unpack solr, symlink configuration and data directories
RUN set -x && \
	curl -sSL $SOLR_MIRROR/$SOLR_VERSION/$SOLR.tgz -o /opt/$SOLR.tgz && \
	tar -C /opt/ --extract --file /opt/$SOLR.tgz && \
	rm /opt/$SOLR.tgz && \
	ln -s /opt/$SOLR /opt/solr && \
	mv /opt/$SOLR/example /opt/solr && \
	rm -rf $SOLR_COLLECTION_PATH/conf

# Configure core0 as the default core
RUN mkdir /opt/$SOLR/config && \
  mv /opt/solr/multicore/core0 /opt/solr/config/core0 && \
  ln -s /var/lib/solr/conf /opt/solr/config/core0/conf && \
  ln -s /var/lib/solr/data /opt/solr/config/core0/data

# Copy configs
COPY ./solr/core0/conf /var/lib/solr/conf

# Persistent volume for solr data
VOLUME ["/var/lib/solr/data"]

EXPOSE 8983

WORKDIR /opt/solr/example

CMD ["/opt/solr/bin/solr", "-f"]
