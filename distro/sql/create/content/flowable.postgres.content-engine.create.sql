
CREATE TABLE act_co_databasechangelog (ID VARCHAR(255) NOT NULL, AUTHOR VARCHAR(255) NOT NULL, FILENAME VARCHAR(255) NOT NULL, DATEEXECUTED TIMESTAMP WITHOUT TIME ZONE NOT NULL, ORDEREXECUTED INTEGER NOT NULL, EXECTYPE VARCHAR(10) NOT NULL, MD5SUM VARCHAR(35), DESCRIPTION VARCHAR(255), COMMENTS VARCHAR(255), TAG VARCHAR(255), LIQUIBASE VARCHAR(20), CONTEXTS VARCHAR(255), LABELS VARCHAR(255), DEPLOYMENT_ID VARCHAR(10));

CREATE TABLE ACT_CO_CONTENT_ITEM (ID_ VARCHAR(255) NOT NULL, NAME_ VARCHAR(255) NOT NULL, MIME_TYPE_ VARCHAR(255), TASK_ID_ VARCHAR(255), PROC_INST_ID_ VARCHAR(255), CONTENT_STORE_ID_ VARCHAR(255), CONTENT_STORE_NAME_ VARCHAR(255), FIELD_ VARCHAR(400), CONTENT_AVAILABLE_ BOOLEAN DEFAULT FALSE, CREATED_ TIMESTAMP(6) WITHOUT TIME ZONE, CREATED_BY_ VARCHAR(255), LAST_MODIFIED_ TIMESTAMP(6) WITHOUT TIME ZONE, LAST_MODIFIED_BY_ VARCHAR(255), CONTENT_SIZE_ BIGINT DEFAULT 0, TENANT_ID_ VARCHAR(255), CONSTRAINT ACT_CO_CONTENT_ITEM_PKEY PRIMARY KEY (ID_));

CREATE INDEX idx_contitem_taskid ON ACT_CO_CONTENT_ITEM(TASK_ID_);

CREATE INDEX idx_contitem_procid ON ACT_CO_CONTENT_ITEM(PROC_INST_ID_);

INSERT INTO act_co_databasechangelog (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE, DEPLOYMENT_ID) VALUES ('1', 'activiti', 'org/flowable/content/db/liquibase/flowable-content-db-changelog.xml', NOW(), 1, '8:7644d7165cfe799200a2abdd3419e8b6', 'createTable tableName=ACT_CO_CONTENT_ITEM; createIndex indexName=idx_contitem_taskid, tableName=ACT_CO_CONTENT_ITEM; createIndex indexName=idx_contitem_procid, tableName=ACT_CO_CONTENT_ITEM', '', 'EXECUTED', NULL, NULL, '3.6.1', '6984985431');

ALTER TABLE ACT_CO_CONTENT_ITEM ADD SCOPE_ID_ VARCHAR(255);

ALTER TABLE ACT_CO_CONTENT_ITEM ADD SCOPE_TYPE_ VARCHAR(255);

CREATE INDEX idx_contitem_scope ON ACT_CO_CONTENT_ITEM(SCOPE_ID_, SCOPE_TYPE_);

INSERT INTO act_co_databasechangelog (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE, DEPLOYMENT_ID) VALUES ('2', 'flowable', 'org/flowable/content/db/liquibase/flowable-content-db-changelog.xml', NOW(), 3, '8:fe7b11ac7dbbf9c43006b23bbab60bab', 'addColumn tableName=ACT_CO_CONTENT_ITEM; createIndex indexName=idx_contitem_scope, tableName=ACT_CO_CONTENT_ITEM', '', 'EXECUTED', NULL, NULL, '3.6.1', '6984985431');

