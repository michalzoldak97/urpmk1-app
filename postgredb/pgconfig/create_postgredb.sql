CREATE DATABASE urpmk1_db_pg
WITH
	ENCODING = 'UTF8';

\c urpmk1_db_pg;
	
CREATE SCHEMA plr;

CREATE TABLE plr.tbl_player(
	player_id BIGSERIAL PRIMARY KEY,
	player_team_id BIGSERIAL,  -- FOREIGN KEY +,
	username VARCHAR(64),
	email VARCHAR(255) UNIQUE NOT NULL,
	coins INTEGER DEFAULT 0,
	experience INTEGER DEFAULT 0,
	created_datetime TIMESTAMP DEFAULT NOW(),
	last_logged_in TIMESTAMP,
	deactivated_datetime TIMESTAMP
);

CREATE TABLE  plr.tbl_player_team(
	player_team_id BIGSERIAL PRIMARY KEY,
	player_team_name VARCHAR(64)
);

CREATE TABLE  plr.tbl_player_level(
	tbl_player_level BIGSERIAL PRIMARY KEY,
	player_id BIGSERIAL,  -- FOREIGN KEY +,
	level INTEGER DEFAULT 1
);

CREATE TABLE plr.tbl_player_placeable_object(
	player_placeable_object_id BIGSERIAL PRIMARY KEY,
	player_id BIGSERIAL,  -- FOREIGN KEY +,
	placeable_object_id BIGSERIAL,  -- FOREIGN KEY +,
	purchased_datetime TIMESTAMP DEFAULT NOW()
);

CREATE SCHEMA po;

CREATE TABLE po.tbl_placeable_object(
	placeable_object_id BIGSERIAL PRIMARY KEY,
	placeable_object_type_id BIGSERIAL,  -- FOREIGN KEY +,
	placeable_object_name VARCHAR(255),
	coins_price INTEGER DEFAULT 0,
	experience_price INTEGER DEFAULT 0,
	placeable_object_image VARCHAR(255),
	placeable_object_icon VARCHAR(255),
	placeable_object_description VARCHAR(4096),
	deactivated_datetime TIMESTAMP
);

CREATE TABLE po.tbl_placeable_object_type(
	placeable_object_type_id BIGSERIAL PRIMARY KEY,
	placeable_object_type_name VARCHAR(255)
);

CREATE TABLE po.tbl_placeable_object_scriptable_object(
	placeable_object_scriptable_object_id BIGSERIAL PRIMARY KEY,
	placeable_object_id BIGSERIAL,  -- FOREIGN KEY +,
	scriptable_object_id BIGSERIAL  -- FOREIGN KEY +,
);

CREATE TABLE po.tbl_placeable_object_player_team_level_max_quantity(
	placeable_object_player_team_level_max_quantity_id BIGSERIAL PRIMARY KEY,
	placeable_object_id BIGSERIAL,  -- FOREIGN KEY +,
	player_team_id BIGSERIAL,  -- FOREIGN KEY +,
	level INTEGER DEFAULT 1,
	max_quantity INTEGER DEFAULT 1
);

CREATE SCHEMA tsk;

CREATE TABLE tsk.tbl_task(
	task_id BIGSERIAL PRIMARY KEY,
	task_content VARCHAR(32768) NOT NULL,
	task_answer VARCHAR(255) NOT NULL DEFAULT '1',
	created_datetime TIMESTAMP DEFAULT NOW(),
	deactivated_datetime TIMESTAMP
);

CREATE TABLE tsk.tbl_task_level(
	task_level_id BIGSERIAL PRIMARY KEY,
	task_id BIGSERIAL,  -- FOREIGN KEY +,
	level INTEGER DEFAULT 1
);

CREATE TABLE tsk.tbl_task_player_team(
	task_player_team_id BIGSERIAL PRIMARY KEY,
	task_id BIGSERIAL,  -- FOREIGN KEY +,
	player_team_id BIGSERIAL  -- FOREIGN KEY +,
);

CREATE SCHEMA so;

CREATE TABLE so.tbl_scriptable_object(
	scriptable_object_id BIGSERIAL PRIMARY KEY,
	scriptable_object_type_id BIGSERIAL,  -- FOREIGN KEY,
	scriptable_object_name VARCHAR(255),
	scriptable_object_jsonb JSONB
);

CREATE TABLE so.tbl_scriptable_object_type(
	scriptable_object_type_id BIGSERIAL PRIMARY KEY,
	scriptable_object_type_name VARCHAR(255)
);

-- Define foreign keys

ALTER TABLE plr.tbl_player
ADD CONSTRAINT fk_tbl_player_player_team_id
FOREIGN KEY (player_team_id)
REFERENCES plr.tbl_player_team(player_team_id)
ON UPDATE NO ACTION
ON DELETE NO ACTION
;

ALTER TABLE plr.tbl_player_level
ADD CONSTRAINT fk_tbl_player_level_player_id
FOREIGN KEY (player_id)
REFERENCES plr.tbl_player(player_id)
ON UPDATE NO ACTION
ON DELETE NO ACTION
;

ALTER TABLE plr.tbl_player_placeable_object
ADD CONSTRAINT fk_tbl_player_placeable_object_player_id
FOREIGN KEY (player_id)
REFERENCES plr.tbl_player(player_id)
ON UPDATE NO ACTION
ON DELETE NO ACTION
;

ALTER TABLE plr.tbl_player_placeable_object
ADD CONSTRAINT fk_tbl_player_placeable_object_placeable_object_id
FOREIGN KEY (placeable_object_id)
REFERENCES po.tbl_placeable_object(placeable_object_id)
ON UPDATE NO ACTION
ON DELETE NO ACTION
;

ALTER TABLE po.tbl_placeable_object
ADD CONSTRAINT fk_tbl_placeable_object_placeable_object_type_id
FOREIGN KEY (placeable_object_type_id)
REFERENCES po.tbl_placeable_object_type(placeable_object_type_id)
ON UPDATE NO ACTION
ON DELETE NO ACTION
;

ALTER TABLE po.tbl_placeable_object_scriptable_object
ADD CONSTRAINT fk_tbl_placeable_object_scriptable_object_placeable_object_id
FOREIGN KEY (placeable_object_id)
REFERENCES po.tbl_placeable_object(placeable_object_id)
ON UPDATE NO ACTION
ON DELETE NO ACTION
;

ALTER TABLE po.tbl_placeable_object_scriptable_object
ADD CONSTRAINT fk_tbl_placeable_object_scriptable_object_scriptable_object_id
FOREIGN KEY (scriptable_object_id)
REFERENCES so.tbl_scriptable_object(scriptable_object_id)
ON UPDATE NO ACTION
ON DELETE NO ACTION
;

ALTER TABLE po.tbl_placeable_object_player_team_level_max_quantity
ADD CONSTRAINT fk_tbl_placeable_object_player_team_level_max_quantity_placeable_object_id
FOREIGN KEY (placeable_object_id)
REFERENCES po.tbl_placeable_object(placeable_object_id)
ON UPDATE NO ACTION
ON DELETE NO ACTION
;

ALTER TABLE po.tbl_placeable_object_player_team_level_max_quantity
ADD CONSTRAINT fk_tbl_placeable_object_player_team_level_max_quantity_player_team_id
FOREIGN KEY (player_team_id)
REFERENCES plr.tbl_player_team(player_team_id)
ON UPDATE NO ACTION
ON DELETE NO ACTION
;

ALTER TABLE tsk.tbl_task_level
ADD CONSTRAINT fk_tbl_task_level_task_id
FOREIGN KEY (task_id)
REFERENCES tsk.tbl_task(task_id)
ON UPDATE NO ACTION
ON DELETE NO ACTION
;

ALTER TABLE tsk.tbl_task_player_team
ADD CONSTRAINT fk_tbl_task_player_team_task_id
FOREIGN KEY (task_id)
REFERENCES tsk.tbl_task(task_id)
ON UPDATE NO ACTION
ON DELETE NO ACTION
;

ALTER TABLE tsk.tbl_task_player_team
ADD CONSTRAINT fk_tbl_task_player_team_player_team_id
FOREIGN KEY (player_team_id)
REFERENCES plr.tbl_player_team(player_team_id)
ON UPDATE NO ACTION
ON DELETE NO ACTION
;

ALTER TABLE so.tbl_scriptable_object
ADD CONSTRAINT fk_tbl_scriptable_object_scriptable_object_type_id
FOREIGN KEY (scriptable_object_type_id)
REFERENCES so.tbl_scriptable_object_type(scriptable_object_type_id)
ON UPDATE NO ACTION
ON DELETE NO ACTION
;
-- index definitions

CREATE INDEX idx_gin_so ON so.tbl_scriptable_object USING GIN(scriptable_object_jsonb);

