FROM tomcat:8


ENV ADAPTER_DOWNLOAD_URL https://downloads.jboss.org/keycloak/2.5.1.Final/adapters/keycloak-oidc/keycloak-tomcat8-adapter-dist-2.5.1.Final.tar.gz

RUN mkdir -p /opt/tomcat/bin && \
    mkdir -p /opt/tomcat/conf/Catalina/localhost && \
    mkdir -p /opt/tomcat/logs && \
    mkdir -p /opt/tomcat/temp && \
    mkdir -p /opt/tomcat/work && \
    cp /usr/local/tomcat/conf/*.* /opt/tomcat/conf

RUN cd /usr/local/tomcat/lib && \
    curl -SL "$ADAPTER_DOWNLOAD_URL" -o keycloak_adapter.tgz && \
    tar -xzf keycloak_adapter.tgz && \
    rm -f keycloak_adapter.tgz && \
    chown -R root:root * 

COPY startTomcat.sh /startTomcat.sh
COPY logging.properties /opt/tomcat/conf/

ENTRYPOINT ["/startTomcat.sh"]

CMD ["run"]

EXPOSE 8080

