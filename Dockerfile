ARG IMAGE=intersystemsdc/irishealth-community:2022.1.1.374.0-zpm
FROM $IMAGE
USER root

WORKDIR /opt/irisbuild

## unpack dataset
COPY dataset dataset
RUN tar -xf /opt/irisbuild/dataset/data.gof.tar.gz --directory /opt/irisbuild/dataset

COPY src src
COPY Installer.cls Installer.cls
COPY module.xml module.xml
COPY iris.script iris.script

RUN chown -R ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisbuild
USER ${ISC_PACKAGE_MGRUSER}

## prepare IRIS and FHIR, cache long operation
RUN iris start IRIS \
    && iris session IRIS < iris.script \
    && iris stop IRIS quietly

COPY dataset.script dataset.script

## upload dataset
RUN iris start IRIS \
    && iris session IRIS < dataset.script \
    && iris stop IRIS quietly

## config SQL interface for i2b2
COPY configsql.script configsql.script
RUN iris start IRIS \
    && iris session IRIS < configsql.script \
    && iris stop IRIS quietly

## Special for this branch - clear existing queries; force single DS
COPY force_single_data_source.script force_single_data_source.script
COPY force_single_data_source.sql force_single_data_source.sql
RUN iris start IRIS \
    && iris session IRIS < force_single_data_source.script \
    && iris stop IRIS quietly
