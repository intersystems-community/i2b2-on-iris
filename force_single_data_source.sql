DELETE FROM qt_xml_result;
DELETE FROM qt_patient_set_collection;
DELETE FROM qt_patient_enc_collection;
DELETE FROM qt_query_result_instance;
DELETE FROM qt_query_instance;
DELETE FROM qt_query_master;

UPDATE crc_db_lookup  SET c_db_datasource = 'java:/IrisDS';
UPDATE im_db_lookup   SET c_db_datasource = 'java:/IrisDS';
UPDATE ont_db_lookup  SET c_db_datasource = 'java:/IrisDS';
UPDATE work_db_lookup SET c_db_datasource = 'java:/IrisDS';
