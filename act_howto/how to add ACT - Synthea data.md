# Preface

ACT / Synthea dataset is supported, but not included "by default" into Docker image due to size and time it takes to load. To add this dataset, some extra steps outlined below are necessary.

For this guide, you need to have built and running instance of "default" stage. See README.md in root folder about how to do it.

Beware; step where data is loaded takes significant amount of time, especially loading of bigger tables. This step may take 24 hours.

Beware; if you want to do any other operation than "load all data", e.g. restart the interrupted process, or manipulate the data, you will need SQL knowledge and tools. No i2b2 specific or medical knowledge is needed, basic CRUD operations are sufficient.

If interrupted, you will have to remove all inserted data to start process from scratch, or manipulate script to avoid redundant inserts. This is due to how data structured, mostly absence of PKs or CPKs on it. We decided that keeping data consistent with original source is more important.

To remove the data, there is no need to re-build "default" images. Stop all containers, and delete stopped project. Then re-start it. You can double-check with script at the bottom. "By default" tables are not even created.

For manual data manipulation, IRIS is exposed as database, JDBC connection string is `jdbc:IRIS://localhost:51773/IRISAPP`, user is `_SYSTEM` and password is `SYS` by default. You can use JDBC driver from `dockerize_i2b2_core-server` directory, if not provided with SQL tool of your choice already.

We strongly advice to initiate these operations knowing how long it will take. That said, loading could be left unsupervised, notwithstanding Docker "freezes". This is a good operation to leave overnight or over weekends. Even if some step fail for some reason, when error is not critical, loading will continue for next table.

# Used data

## i2b2 Data Release 1.7.12a

Can be downloaded at https://github.com/i2b2/i2b2-data/releases/tag/v1.7.12a.0001

Matches i2b2-core-server version at time of creation.

For speed, we adapted some of scripts (newline changes, date-time operations), but data logically is identical.

## ACT Ontology data

ACT Network Ontology resources, starting from https://dbmi-pitt.github.io/ACT-Network

For speed, we added file `insert_metadata_ACT_CPT_PX_2018AA_adapted.sql` here directly, but file is coming originally from ACT project, named `ACT_CPT_PX_2018AA.dsv`.

# Preparation

Extract `i2b2 Data Release 1.7.12a` file, and navigate to

`.../i2b2-data-1.7.12a.0001/edu.harvard.i2b2.data/Release_1-7/NewInstall/Metadata/act/scripts/oracle`

Extract `metadata.zip`

Copy all extracted .sql files into this folder (`act_howto`) from where default Docker image was built and started

Navigate to

`.../i2b2-data-1.7.12a.0001/edu.harvard.i2b2.data/Release_1-7/NewInstall/Metadata/act/scripts/`

(One folder above previous)

Copy two .sql files into this folder (`act_howto`)

Some of provided queries have issues with date-time operations. This affects only execution, and not insertion, this data is changed by two specialized scripts at the end of insertion. If you need to adapt your data, see `adapt_time_...` scripts for examples.

Extract `adapted.tar.gz` directly into this folder (`act_howto`)

Do not worry if you see files with names different only in `_adapted`. These are files with fixed issues. They are already used in loading process.

# Executing SQL scripts

Assuming git checkout folder is `i2b2-on-iris`, your Docker project is named `i2b2-on-iris` as well

Then IRIS container is named `i2b2-on-iris_iris_1`

Open CLI on that container, using host system CLI (https://docs.docker.com/engine/reference/commandline/exec/) or Docker Dashboard (`>_` icon for `i2b2-on-iris_iris_1`)

From here on, all commands are executed on that container

Navigate to scripts folder

`cd /irisrun/repo/act_howto`

Check that files are in place

`ls -l`

You should see all files that you copied or extracted in preparation step

```
act_i2b2.script
adapt_datetime_1.sql
adapt_datetime_2.sql
create_i2b2metadata_tables.sql
how to add ACT - Synthea data.md
insert_metadata_ACT_CPT_PX_2018AA_adapted.sql
insert_metadata_demo_V2_adapted.sql
insert_metadata_dx_icd10_V2.sql
insert_metadata_dx_icd10_icd9_V1.sql
insert_metadata_dx_icd10_icd9_V1_adapted.sql
insert_metadata_dx_icd9_V2.sql
insert_metadata_labs_V1_adapted.sql
insert_metadata_labs_V2.sql
insert_metadata_med_alpha_V2.sql
insert_metadata_med_va_V2.sql
insert_metadata_px_hcpcs_V2.sql
insert_metadata_px_icd10_V2.sql
insert_metadata_px_icd9_V2.sql
insert_metadata_visit_details_V1.sql
schemes_insert_data_adapted.sql
table_access_insert_data.sql
zz_create_i2b2metadata_index.sql
```

as well as other files.

Run ObjectScript file that will install all SQL files above as DDL Imports:

`iris session IRIS < act_i2b2.script`

Wait for DDLs to execute.

Check ...`_Errors.log` for errors. Files should be empty, or absent at all.

Check ...`_Unsupported.log` for unsupported operations. Files should be empty, or absent at all.

If you want to be sure that all data is loaded, there are no missing rows or duplicates, following SQL script has number of rows on "control" database. Run it against Docker instance.

```
SELECT count(*) FROM ACT_CPT_PX_2018AA; -- 13'353
SELECT count(*) FROM ACT_HCPCS_PX_2018AA; -- 7'523
SELECT count(*) FROM ACT_ICD10CM_DX_2018AA; -- 94'505
SELECT count(*) FROM ACT_ICD10PCS_PX_2018AA; -- 190'177
SELECT count(*) FROM ACT_ICD9CM_DX_2018AA; -- 17'738
SELECT count(*) FROM ACT_ICD9CM_PX_2018AA; -- 4'671
SELECT count(*) FROM ACT_LOINC_LAB_2018AA; -- 142'860
SELECT count(*) FROM ACT_MED_ALPHA_V2_092818; -- 660'091
SELECT count(*) FROM ACT_MED_VA_V2_092818; -- 1'140'758
SELECT count(*) FROM NCATS_DEMOGRAPHICS; -- 164
SELECT count(*) FROM NCATS_ICD10_ICD9_DX_V1; -- 128'362
SELECT count(*) FROM NCATS_LABS; -- 516
SELECT count(*) FROM NCATS_VISIT_DETAILS; -- 161

SELECT * FROM SCHEMES; -- 27
SELECT * FROM TABLE_ACCESS; -- 26
```

After this step, if all data matches, you can delete all .sql files to save space, they are no longer necessary.
