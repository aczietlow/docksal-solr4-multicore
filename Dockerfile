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
	mv /opt/$SOLR/example/multicore /opt/$SOLR

# Configure core0 as the default core
RUN mkdir /opt/$SOLR/config && \
  mv /opt/solr/multicore/core0 /opt/solr/config/core0 && \
  mv /opt/solr/multicore/core1 /opt/solr/config/core1

# Clean up extra stuff we don't need
RUN rm -Rf /opt/$SOLR/docs

# Copy default configs
COPY ./solr/core0/conf /opt/$SOLR/config/core0/conf
COPY ./solr/core0/conf /opt/$SOLR/config/core1/conf
COPY ./solr/solr.xml /opt/$SOLR/config/solr.xml

# Persistent volume for solr data
VOLUME ["/var/lib/solr/data"]

EXPOSE 8983

WORKDIR /opt/$SOLR/config

CMD ["/opt/solr/bin/solr", "-f", "-s", "/opt/solr/config"]
