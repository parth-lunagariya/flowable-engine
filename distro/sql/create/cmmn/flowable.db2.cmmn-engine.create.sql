create table ACT_GE_PROPERTY (
    NAME_ varchar(64) not null,
    VALUE_ varchar(300),
    REV_ integer,
    primary key (NAME_)
);

create table ACT_GE_BYTEARRAY (
    ID_ varchar(64) not null,
    REV_ integer,
    NAME_ varchar(255),
    DEPLOYMENT_ID_ varchar(64),
    BYTES_ BLOB,
    GENERATED_ smallint check(GENERATED_ in (1,0)),
    primary key (ID_)
);

insert into ACT_GE_PROPERTY
values ('common.schema.version', '6.3.1.0', 1);

insert into ACT_GE_PROPERTY
values ('next.dbid', '1', 1);

create table ACT_RU_IDENTITYLINK (
    ID_ varchar(64) not null,
    REV_ integer,
    GROUP_ID_ varchar(255),
    TYPE_ varchar(255),
    USER_ID_ varchar(255),
    TASK_ID_ varchar(64),
    PROC_INST_ID_ varchar(64),
    PROC_DEF_ID_ varchar(64),
    SCOPE_ID_ varchar(255),
    SCOPE_TYPE_ varchar(255),
    SCOPE_DEFINITION_ID_ varchar(255),
    primary key (ID_)
);

create index ACT_IDX_IDENT_LNK_USER on ACT_RU_IDENTITYLINK(USER_ID_);
create index ACT_IDX_IDENT_LNK_GROUP on ACT_RU_IDENTITYLINK(GROUP_ID_);
create index ACT_IDX_IDENT_LNK_SCOPE on ACT_RU_IDENTITYLINK(SCOPE_ID_, SCOPE_TYPE_);
create index ACT_IDX_IDENT_LNK_SCOPE_DEF on ACT_RU_IDENTITYLINK(SCOPE_DEFINITION_ID_, SCOPE_TYPE_);

insert into ACT_GE_PROPERTY values ('identitylink.schema.version', '6.3.1.0', 1);
create table ACT_RU_TASK (
    ID_ varchar(64) not null,
    REV_ integer,
    EXECUTION_ID_ varchar(64),
    PROC_INST_ID_ varchar(64),
    PROC_DEF_ID_ varchar(64),
    TASK_DEF_ID_ varchar(64),
    SCOPE_ID_ varchar(255),
    SUB_SCOPE_ID_ varchar(255),
    SCOPE_TYPE_ varchar(255),
    SCOPE_DEFINITION_ID_ varchar(255),
    NAME_ varchar(255),
    PARENT_TASK_ID_ varchar(64),
    DESCRIPTION_ varchar(4000),
    TASK_DEF_KEY_ varchar(255),
    OWNER_ varchar(255),
    ASSIGNEE_ varchar(255),
    DELEGATION_ varchar(64),
    PRIORITY_ integer,
    CREATE_TIME_ timestamp,
    DUE_DATE_ timestamp,
    CATEGORY_ varchar(255),
    SUSPENSION_STATE_ integer,
    TENANT_ID_ varchar(255) default '',
    FORM_KEY_ varchar(255),
    CLAIM_TIME_ timestamp,
    IS_COUNT_ENABLED_ smallint check(IS_COUNT_ENABLED_ in (1,0)),
    VAR_COUNT_ integer, 
    ID_LINK_COUNT_ integer,
    SUB_TASK_COUNT_ integer,
    primary key (ID_)
);

create index ACT_IDX_TASK_CREATE on ACT_RU_TASK(CREATE_TIME_);
create index ACT_IDX_TASK_SCOPE on ACT_RU_TASK(SCOPE_ID_, SCOPE_TYPE_);
create index ACT_IDX_TASK_SUB_SCOPE on ACT_RU_TASK(SUB_SCOPE_ID_, SCOPE_TYPE_);
create index ACT_IDX_TASK_SCOPE_DEF on ACT_RU_TASK(SCOPE_DEFINITION_ID_, SCOPE_TYPE_);

insert into ACT_GE_PROPERTY values ('task.schema.version', '6.3.1.0', 1);
create table ACT_RU_VARIABLE (
    ID_ varchar(64) not null,
    REV_ integer,
    TYPE_ varchar(255) not null,
    NAME_ varchar(255) not null,
    EXECUTION_ID_ varchar(64),
    PROC_INST_ID_ varchar(64),
    TASK_ID_ varchar(64),
    SCOPE_ID_ varchar(255),
    SUB_SCOPE_ID_ varchar(255),
    SCOPE_TYPE_ varchar(255),
    BYTEARRAY_ID_ varchar(64),
    DOUBLE_ double precision,
    LONG_ bigint,
    TEXT_ varchar(4000),
    TEXT2_ varchar(4000),
    primary key (ID_)
);

create index ACT_IDX_RU_VAR_SCOPE_ID_TYPE on ACT_RU_VARIABLE(SCOPE_ID_, SCOPE_TYPE_);
create index ACT_IDX_RU_VAR_SUB_ID_TYPE on ACT_RU_VARIABLE(SUB_SCOPE_ID_, SCOPE_TYPE_);

create index ACT_IDX_VARIABLE_BA on ACT_RU_VARIABLE(BYTEARRAY_ID_);
alter table ACT_RU_VARIABLE 
    add constraint ACT_FK_VAR_BYTEARRAY 
    foreign key (BYTEARRAY_ID_) 
    references ACT_GE_BYTEARRAY (ID_);

insert into ACT_GE_PROPERTY values ('variable.schema.version', '6.3.1.0', 1);

CREATE TABLE ACT_CMMN_DATABASECHANGELOG (ID VARCHAR(255) NOT NULL, AUTHOR VARCHAR(255) NOT NULL, FILENAME VARCHAR(255) NOT NULL, DATEEXECUTED TIMESTAMP NOT NULL, ORDEREXECUTED INTEGER NOT NULL, EXECTYPE VARCHAR(10) NOT NULL, MD5SUM VARCHAR(35), DESCRIPTION VARCHAR(255), COMMENTS VARCHAR(255), TAG VARCHAR(255), LIQUIBASE VARCHAR(20), CONTEXTS VARCHAR(255), LABELS VARCHAR(255), DEPLOYMENT_ID VARCHAR(10));

CREATE TABLE ACT_CMMN_DEPLOYMENT (ID_ VARCHAR(255) NOT NULL, NAME_ VARCHAR(255), CATEGORY_ VARCHAR(255), KEY_ VARCHAR(255), DEPLOY_TIME_ TIMESTAMP, PARENT_DEPLOYMENT_ID_ VARCHAR(255), TENANT_ID_ VARCHAR(255) DEFAULT '', CONSTRAINT PK_ACT_CMMN_DEPLO PRIMARY KEY (ID_));

CREATE TABLE ACT_CMMN_DEPLOYMENT_RESOURCE (ID_ VARCHAR(255) NOT NULL, NAME_ VARCHAR(255), DEPLOYMENT_ID_ VARCHAR(255), RESOURCE_BYTES_ BLOB, CONSTRAINT PK_CMMN_DEPLOYMENT_RESOURCE PRIMARY KEY (ID_));

ALTER TABLE ACT_CMMN_DEPLOYMENT_RESOURCE ADD CONSTRAINT ACT_FK_CMMN_RSRC_DPL FOREIGN KEY (DEPLOYMENT_ID_) REFERENCES ACT_CMMN_DEPLOYMENT (ID_);

CREATE INDEX ACT_IDX_CMMN_RSRC_DPL ON ACT_CMMN_DEPLOYMENT_RESOURCE(DEPLOYMENT_ID_);

CREATE TABLE ACT_CMMN_CASEDEF (ID_ VARCHAR(255) NOT NULL, REV_ INTEGER NOT NULL, NAME_ VARCHAR(255), KEY_ VARCHAR(255) NOT NULL, VERSION_ INTEGER NOT NULL, CATEGORY_ VARCHAR(255), DEPLOYMENT_ID_ VARCHAR(255), RESOURCE_NAME_ VARCHAR(4000), DESCRIPTION_ VARCHAR(4000), HAS_GRAPHICAL_NOTATION_ SMALLINT, TENANT_ID_ VARCHAR(255) DEFAULT '', CONSTRAINT PK_ACT_CMMN_CASED PRIMARY KEY (ID_));

ALTER TABLE ACT_CMMN_CASEDEF ADD CONSTRAINT ACT_FK_CASE_DEF_DPLY FOREIGN KEY (DEPLOYMENT_ID_) REFERENCES ACT_CMMN_DEPLOYMENT (ID_);

CREATE INDEX ACT_IDX_CASE_DEF_DPLY ON ACT_CMMN_CASEDEF(DEPLOYMENT_ID_);

CREATE TABLE ACT_CMMN_RU_CASE_INST (ID_ VARCHAR(255) NOT NULL, REV_ INTEGER NOT NULL, BUSINESS_KEY_ VARCHAR(255), NAME_ VARCHAR(255), PARENT_ID_ VARCHAR(255), CASE_DEF_ID_ VARCHAR(255), STATE_ VARCHAR(255), START_TIME_ TIMESTAMP, START_USER_ID_ VARCHAR(255), CALLBACK_ID_ VARCHAR(255), CALLBACK_TYPE_ VARCHAR(255), TENANT_ID_ VARCHAR(255) DEFAULT '', CONSTRAINT PK_ACT_CMMN_RU_CA PRIMARY KEY (ID_));

ALTER TABLE ACT_CMMN_RU_CASE_INST ADD CONSTRAINT ACT_FK_CASE_INST_CASE_DEF FOREIGN KEY (CASE_DEF_ID_) REFERENCES ACT_CMMN_CASEDEF (ID_);

CREATE INDEX ACT_IDX_CASE_INST_CASE_DEF ON ACT_CMMN_RU_CASE_INST(CASE_DEF_ID_);

CREATE INDEX ACT_IDX_CASE_INST_PARENT ON ACT_CMMN_RU_CASE_INST(PARENT_ID_);

CREATE TABLE ACT_CMMN_RU_PLAN_ITEM_INST (ID_ VARCHAR(255) NOT NULL, REV_ INTEGER NOT NULL, CASE_DEF_ID_ VARCHAR(255), CASE_INST_ID_ VARCHAR(255), STAGE_INST_ID_ VARCHAR(255), IS_STAGE_ SMALLINT, ELEMENT_ID_ VARCHAR(255), NAME_ VARCHAR(255), STATE_ VARCHAR(255), START_TIME_ TIMESTAMP, START_USER_ID_ VARCHAR(255), REFERENCE_ID_ VARCHAR(255), REFERENCE_TYPE_ VARCHAR(255), TENANT_ID_ VARCHAR(255) DEFAULT '', CONSTRAINT PK_CMMN_PLAN_ITEM_INST PRIMARY KEY (ID_));

ALTER TABLE ACT_CMMN_RU_PLAN_ITEM_INST ADD CONSTRAINT ACT_FK_PLAN_ITEM_CASE_DEF FOREIGN KEY (CASE_DEF_ID_) REFERENCES ACT_CMMN_CASEDEF (ID_);

CREATE INDEX ACT_IDX_PLAN_ITEM_CASE_DEF ON ACT_CMMN_RU_PLAN_ITEM_INST(CASE_DEF_ID_);

ALTER TABLE ACT_CMMN_RU_PLAN_ITEM_INST ADD CONSTRAINT ACT_FK_PLAN_ITEM_CASE_INST FOREIGN KEY (CASE_INST_ID_) REFERENCES ACT_CMMN_RU_CASE_INST (ID_);

CREATE INDEX ACT_IDX_PLAN_ITEM_CASE_INST ON ACT_CMMN_RU_PLAN_ITEM_INST(CASE_INST_ID_);

CREATE TABLE ACT_CMMN_RU_SENTRY_PART_INST (ID_ VARCHAR(255) NOT NULL, REV_ INTEGER NOT NULL, CASE_DEF_ID_ VARCHAR(255), CASE_INST_ID_ VARCHAR(255), PLAN_ITEM_INST_ID_ VARCHAR(255), ON_PART_ID_ VARCHAR(255), IF_PART_ID_ VARCHAR(255), TIME_STAMP_ TIMESTAMP, CONSTRAINT PK_CMMN_SENTRY_PART_INST PRIMARY KEY (ID_));

ALTER TABLE ACT_CMMN_RU_SENTRY_PART_INST ADD CONSTRAINT ACT_FK_SENTRY_CASE_DEF FOREIGN KEY (CASE_DEF_ID_) REFERENCES ACT_CMMN_CASEDEF (ID_);

CREATE INDEX ACT_IDX_SENTRY_CASE_DEF ON ACT_CMMN_RU_SENTRY_PART_INST(CASE_DEF_ID_);

ALTER TABLE ACT_CMMN_RU_SENTRY_PART_INST ADD CONSTRAINT ACT_FK_SENTRY_CASE_INST FOREIGN KEY (CASE_INST_ID_) REFERENCES ACT_CMMN_RU_CASE_INST (ID_);

CREATE INDEX ACT_IDX_SENTRY_CASE_INST ON ACT_CMMN_RU_SENTRY_PART_INST(CASE_INST_ID_);

ALTER TABLE ACT_CMMN_RU_SENTRY_PART_INST ADD CONSTRAINT ACT_FK_SENTRY_PLAN_ITEM FOREIGN KEY (PLAN_ITEM_INST_ID_) REFERENCES ACT_CMMN_RU_PLAN_ITEM_INST (ID_);

CREATE INDEX ACT_IDX_SENTRY_PLAN_ITEM ON ACT_CMMN_RU_SENTRY_PART_INST(PLAN_ITEM_INST_ID_);

CREATE TABLE ACT_CMMN_RU_MIL_INST (ID_ VARCHAR(255) NOT NULL, NAME_ VARCHAR(255) NOT NULL, TIME_STAMP_ TIMESTAMP NOT NULL, CASE_INST_ID_ VARCHAR(255) NOT NULL, CASE_DEF_ID_ VARCHAR(255) NOT NULL, ELEMENT_ID_ VARCHAR(255) NOT NULL, CONSTRAINT PK_ACT_CMMN_RU_MI PRIMARY KEY (ID_));

ALTER TABLE ACT_CMMN_RU_MIL_INST ADD CONSTRAINT ACT_FK_MIL_CASE_DEF FOREIGN KEY (CASE_DEF_ID_) REFERENCES ACT_CMMN_CASEDEF (ID_);

CREATE INDEX ACT_IDX_MIL_CASE_DEF ON ACT_CMMN_RU_MIL_INST(CASE_DEF_ID_);

ALTER TABLE ACT_CMMN_RU_MIL_INST ADD CONSTRAINT ACT_FK_MIL_CASE_INST FOREIGN KEY (CASE_INST_ID_) REFERENCES ACT_CMMN_RU_CASE_INST (ID_);

CREATE INDEX ACT_IDX_MIL_CASE_INST ON ACT_CMMN_RU_MIL_INST(CASE_INST_ID_);

CREATE TABLE ACT_CMMN_HI_CASE_INST (ID_ VARCHAR(255) NOT NULL, REV_ INTEGER NOT NULL, BUSINESS_KEY_ VARCHAR(255), NAME_ VARCHAR(255), PARENT_ID_ VARCHAR(255), CASE_DEF_ID_ VARCHAR(255), STATE_ VARCHAR(255), START_TIME_ TIMESTAMP, END_TIME_ TIMESTAMP, START_USER_ID_ VARCHAR(255), CALLBACK_ID_ VARCHAR(255), CALLBACK_TYPE_ VARCHAR(255), TENANT_ID_ VARCHAR(255) DEFAULT '', CONSTRAINT PK_ACT_CMMN_HI_CA PRIMARY KEY (ID_));

CREATE TABLE ACT_CMMN_HI_MIL_INST (ID_ VARCHAR(255) NOT NULL, REV_ INTEGER NOT NULL, NAME_ VARCHAR(255) NOT NULL, TIME_STAMP_ TIMESTAMP NOT NULL, CASE_INST_ID_ VARCHAR(255) NOT NULL, CASE_DEF_ID_ VARCHAR(255) NOT NULL, ELEMENT_ID_ VARCHAR(255) NOT NULL, CONSTRAINT PK_ACT_CMMN_HI_MI PRIMARY KEY (ID_));

INSERT INTO ACT_CMMN_DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE, DEPLOYMENT_ID) VALUES ('1', 'flowable', 'org/flowable/cmmn/db/liquibase/flowable-cmmn-db-changelog.xml', CURRENT TIMESTAMP, 1, '8:8b4b922d90b05ff27483abefc9597aa6', 'createTable tableName=ACT_CMMN_DEPLOYMENT; createTable tableName=ACT_CMMN_DEPLOYMENT_RESOURCE; addForeignKeyConstraint baseTableName=ACT_CMMN_DEPLOYMENT_RESOURCE, constraintName=ACT_FK_CMMN_RSRC_DPL, referencedTableName=ACT_CMMN_DEPLOYMENT; create...', '', 'EXECUTED', NULL, NULL, '3.6.1', '6984981508');

ALTER TABLE ACT_CMMN_CASEDEF ADD DGRM_RESOURCE_NAME_ VARCHAR(4000);

ALTER TABLE ACT_CMMN_CASEDEF ADD HAS_START_FORM_KEY_ SMALLINT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ACT_CMMN_CASEDEF');

ALTER TABLE ACT_CMMN_DEPLOYMENT_RESOURCE ADD GENERATED_ SMALLINT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ACT_CMMN_DEPLOYMENT_RESOURCE');

ALTER TABLE ACT_CMMN_RU_CASE_INST ADD LOCK_TIME_ TIMESTAMP;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ACT_CMMN_RU_CASE_INST');

ALTER TABLE ACT_CMMN_RU_PLAN_ITEM_INST ADD ITEM_DEFINITION_ID_ VARCHAR(255);

ALTER TABLE ACT_CMMN_RU_PLAN_ITEM_INST ADD ITEM_DEFINITION_TYPE_ VARCHAR(255);

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ACT_CMMN_RU_PLAN_ITEM_INST');

INSERT INTO ACT_CMMN_DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE, DEPLOYMENT_ID) VALUES ('2', 'flowable', 'org/flowable/cmmn/db/liquibase/flowable-cmmn-db-changelog.xml', CURRENT TIMESTAMP, 3, '8:65e39b3d385706bb261cbeffe7533cbe', 'addColumn tableName=ACT_CMMN_CASEDEF; addColumn tableName=ACT_CMMN_DEPLOYMENT_RESOURCE; addColumn tableName=ACT_CMMN_RU_CASE_INST; addColumn tableName=ACT_CMMN_RU_PLAN_ITEM_INST', '', 'EXECUTED', NULL, NULL, '3.6.1', '6984981508');

ALTER TABLE ACT_CMMN_RU_PLAN_ITEM_INST ADD IS_COMPLETEABLE_ SMALLINT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ACT_CMMN_RU_PLAN_ITEM_INST');

ALTER TABLE ACT_CMMN_RU_CASE_INST ADD IS_COMPLETEABLE_ SMALLINT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ACT_CMMN_RU_CASE_INST');

CREATE INDEX ACT_IDX_PLAN_ITEM_STAGE_INST ON ACT_CMMN_RU_PLAN_ITEM_INST(STAGE_INST_ID_);

ALTER TABLE ACT_CMMN_RU_PLAN_ITEM_INST ADD IS_COUNT_ENABLED_ SMALLINT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ACT_CMMN_RU_PLAN_ITEM_INST');

ALTER TABLE ACT_CMMN_RU_PLAN_ITEM_INST ADD VAR_COUNT_ INTEGER;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ACT_CMMN_RU_PLAN_ITEM_INST');

ALTER TABLE ACT_CMMN_RU_PLAN_ITEM_INST ADD SENTRY_PART_INST_COUNT_ INTEGER;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ACT_CMMN_RU_PLAN_ITEM_INST');

INSERT INTO ACT_CMMN_DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE, DEPLOYMENT_ID) VALUES ('3', 'flowable', 'org/flowable/cmmn/db/liquibase/flowable-cmmn-db-changelog.xml', CURRENT TIMESTAMP, 5, '8:c01f6e802b49436b4489040da3012359', 'addColumn tableName=ACT_CMMN_RU_PLAN_ITEM_INST; addColumn tableName=ACT_CMMN_RU_CASE_INST; createIndex indexName=ACT_IDX_PLAN_ITEM_STAGE_INST, tableName=ACT_CMMN_RU_PLAN_ITEM_INST; addColumn tableName=ACT_CMMN_RU_PLAN_ITEM_INST; addColumn tableNam...', '', 'EXECUTED', NULL, NULL, '3.6.1', '6984981508');

CREATE TABLE ACT_CMMN_HI_PLAN_ITEM_INST (ID_ VARCHAR(255) NOT NULL, REV_ INTEGER NOT NULL, NAME_ VARCHAR(255), STATE_ VARCHAR(255), CASE_DEF_ID_ VARCHAR(255), CASE_INST_ID_ VARCHAR(255), STAGE_INST_ID_ VARCHAR(255), IS_STAGE_ SMALLINT, ELEMENT_ID_ VARCHAR(255), ITEM_DEFINITION_ID_ VARCHAR(255), ITEM_DEFINITION_TYPE_ VARCHAR(255), CREATED_TIME_ TIMESTAMP, LAST_AVAILABLE_TIME_ TIMESTAMP, LAST_ENABLED_TIME_ TIMESTAMP, LAST_DISABLED_TIME_ TIMESTAMP, LAST_STARTED_TIME_ TIMESTAMP, LAST_SUSPENDED_TIME_ TIMESTAMP, COMPLETED_TIME_ TIMESTAMP, OCCURRED_TIME_ TIMESTAMP, TERMINATED_TIME_ TIMESTAMP, EXIT_TIME_ TIMESTAMP, ENDED_TIME_ TIMESTAMP, LAST_UPDATED_TIME_ TIMESTAMP, START_USER_ID_ VARCHAR(255), REFERENCE_ID_ VARCHAR(255), REFERENCE_TYPE_ VARCHAR(255), TENANT_ID_ VARCHAR(255) DEFAULT '', CONSTRAINT PK_ACT_CMMN_HI_PL PRIMARY KEY (ID_));

ALTER TABLE ACT_CMMN_RU_MIL_INST ADD TENANT_ID_ VARCHAR(255) DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ACT_CMMN_RU_MIL_INST');

ALTER TABLE ACT_CMMN_HI_MIL_INST ADD TENANT_ID_ VARCHAR(255) DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ACT_CMMN_HI_MIL_INST');

INSERT INTO ACT_CMMN_DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE, DEPLOYMENT_ID) VALUES ('4', 'flowable', 'org/flowable/cmmn/db/liquibase/flowable-cmmn-db-changelog.xml', CURRENT TIMESTAMP, 7, '8:e40d29cb79345b7fb5afd38a7f0ba8fc', 'createTable tableName=ACT_CMMN_HI_PLAN_ITEM_INST; addColumn tableName=ACT_CMMN_RU_MIL_INST; addColumn tableName=ACT_CMMN_HI_MIL_INST', '', 'EXECUTED', NULL, NULL, '3.6.1', '6984981508');


