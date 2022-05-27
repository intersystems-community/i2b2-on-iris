FROM jboss/wildfly:17.0.1.Final

ADD i2b2.war /opt/jboss/wildfly/standalone/deployments/
ADD intersystems-jdbc-3.2.0.jar /opt/jboss/wildfly/standalone/deployments/
ADD iris-ds.xml /opt/jboss/wildfly/standalone/deployments/

CMD ["/opt/jboss/wildfly/bin/standalone.sh", "--debug", "0.0.0.0:8787", "-b", "0.0.0.0"]
