# Proof-Of-Concept of I2B2 using IRIS as backend

## Executive Summary

InterSystems IRIS platform is a leading technical infrastructure used in production and research settings for Healthcare and Life Sciences.

The i2b2/Transmart community has implemented its query builder and underlying i2b2 core on top of three mainstream data sources - MS SQL Server, Oracle and Postgres.

This POC is focused on assessment and gap analysis for adding InterSystems IRIS as an additional data source. This would allow i2b2 clients to take advantage of the IRIS high-performance data querying capabilities as well as multitude of other features and functionality offered by IRIS.

## What & Why - Phase 1

### Phase 1 goals

    * Investigate compatibility of the i2b2 Query builder, i2b2 web and i2b2 core with IRIS backend and identify gaps preventing usage of the i2b2 Web client with IRIS back end.
    * Determine steps necessary to mitigate compatibility gaps for i2b2 with IRIS backend.
    * Develop a data migration path from i2b2 to IRIS.
    * Execute direct SQL queries against i2b2 data in IRIS and achieve equivalence of the results with the results in the relational DB (Postgres) within limited POC scope. Capture and document the differences as well as steps to expand to a larger scope.
    * Implement an infrastructure for exporting i2b2 patient data as FHIR resources, map and export sample resources (e.g. Patient, Meds) based on the data in the i2b2 instance.
    * Document findings and publish to InterSystems open exchange.

Phase 1 was completed, summary findings are in `Documentation i2b2 on Iris - Phase 1.pdf`

### How Phase 1 was done

Steps creating the project

    1. Set up Linux VM.
    2. Install and configure InterSystems IRIS for Health 2020.3 or higher on this VM.
    3. Install and configure a reference i2b2 instance on the POC Linux VM with Postgres DB as a data source with a demo patient data set
    4. Configure and test i2b2 Web client (query builder) with the Postgres DB as a data source.
    5. Migrate i2b2 schema and demo patient data from the reference i2b2 instance into IRIS.
    6. Create and execute several representative identical queries in IRIS SQL tool and in a Postgres SQL UI (PGAdmin). Compare results and document difference between I2B2 and IRIS.
    7. Create and implement I2B2 - FHIR mapping for two representative FHIR resources (e.g. Patient, MedicationRequest) and demonstrate FHIR export for a few patients.
    8. Create IRIS production to export patient data from IRIS as FHIR resources (e.g. by patient_id).
    9. Document the process of implementation of I2B2 on IRIS.
    10. Publish the implementation and documentation to InterSystems Open Exchange.

## What & Why - Phase 2

### Phase 2 goals

    * Based on findings of Phase 1, provide i2b2-core-server variation that can use IRIS as database backend
    * Provide fully dockerized test setup for i2b2 and IRIS, pre-configured for immediate use

## Running IRIS with sample I2B2 dataset

These steps are following instructions provided by InterSystems community.

### Prerequisites

Make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) installed.

Since Docker Desktop became paid application, we suggest you can actually use Docker Engine. There will be no "nice UI" though.

For Windows, starting point for them is [here](https://docs.docker.com/engine/install/binaries/#install-server-and-client-binaries-on-windows).

Get `docker-compose` executable [here](https://github.com/docker/compose/releases/).

Make sure that you can run `docker run hello-world`. Remember CLI settings (like path and admin rights) and use them for this setup.

Steps below assume that you have `docker` and `docker-compose` in path, and your CLI has admin rights to access service instance of `dockerd`. `dockerd` should be running as well.

### Installation 

1. Clone/git pull the repo into any local directory

```
$ git clone https://gitlab.com/i3335/i2b2-on-iris
```

2. Open the terminal in this directory and run:

```
$ docker-compose build
```

This step may take some time to complete, since FHIR packages are prepared. Up to 15 minutes may be necessary, depending on your machine power.

3. Run the IRIS container with your project:

```
$ docker-compose up -d
```

### How to Test it

On Docker host machine execute:

```
$ curl -H "Accept: application/fhir+json" -X GET http://localhost:52773/i2b2/fhir/r4/Patient/1000000035
```

Expected response is:

```json
{"resourceType":"Patient","address":[{"city":"Braintree","country":"US","postalCode":"02185","state":"Massachusetts","type":"both","use":"home"}],"birthDate":"1988-01-20","communication":[{"language":{"coding":[{"code":"es","display":"spanish","system":"http://hl7.org/fhir/ValueSet/languages"}]},"preferred":true}],"deceasedBoolean":false,"extension":[{"url":"http://hl7.org/fhir/StructureDefinition/patient-nationality","valueCoding":{"code":"2186-5","display":"Not Hispanic or Latino","system":"http://terminology.hl7.org/CodeSystem/v3-Ethnicity"}},{"url":"http://hl7.org/fhir/StructureDefinition/patient-religion","valueCoding":{"code":"1007","display":"Atheism","system":"http://terminology.hl7.org/CodeSystem/v3-ReligiousAffiliation"}}],"gender":"male","id":"1000000035","identifier":[{"assigner":{"display":"i2b2"},"period":{"start":"2010-11-04"},"type":{"coding":[{"code":"PLAC","system":"http://terminology.hl7.org/CodeSystem/v2-0203"}]},"use":"usual","value":"1000000035"}],"maritalStatus":{"coding":[{"code":"U","display":"unmarried","system":"http://terminology.hl7.org/CodeSystem/v3-MaritalStatus"}]}}
```

Open `localhost:8082` in web browser supported by i2b2 web client. Expected outcome is i2b2-webclient login page, with pre-configured credentials for demo data.

Log in with pre-configured credentials, i2b2 query builder interface should be present. Notice prepared category tree.

## Troubleshooting

Q: `docker-compose build` output froze.

A1: Try pressing Return key, sometimes console refresh is suspended.

A2: Dataset import takes long time. This step would be cached by docker, if possible, so typically only one start-up is long.

Q: I get error `ERROR: Service 'iris' failed to build: Error processing tar file(exit status 1): write /usr/irissys/mgr/IRIS.DAT: no space left on device` or similar.

Q: I get error `tar: data.gof: Wrote only ... of ... bytes tar: Exiting with failure status due to previous errors` or similar.

A: Make sure that docker has enough free space for image creation. Use `prune` command to free up space. See `https://docs.docker.com/config/pruning/` for detailed instructions.

## Notice

The project uses the intersystemsdc/irishealth-community:2022.1.1.374.0-zpm container. The license key in this container will expire on October 18, 2023.