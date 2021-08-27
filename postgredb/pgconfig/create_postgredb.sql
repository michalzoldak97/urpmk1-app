CREATE DATABASE IF NOT EXISTS urpmk1_db_pg
WITH
	ENCODING = 'UTF8';

\c urpmk1_db_pg;
	
CREATE SCHEMA IF NOT EXISTS plr;

CREATE TABLE IF NOT EXISTS plr.tbl_player(
	player_id BIGSERIAL PRIMARY KEY,
	player_team_id BIGSERIAL FOREIGN KEY,
	username VARCHAR(64),
	email VARCHAR(255) UNIQUE NOT NULL,
	coins INTEGER DEFAULT 0,
	experience INTEGER DEFAULT 0,
	created_datetime TIMESTAMP DEFAULT NOW(),
	last_logged_in TIMESTAMP,
	is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS plr.tbl_player_team(
	player_team_id BIGSERIAL PRIMARY KEY,
	player_team_name VARCHAR(64)
);
CREATE TABLE IF NOT EXISTS plr.tbl_player_level(
	tbl_player_level BIGSERIAL PRIMARY KEY,
	player_id BIGSERIAL FOREIGN KEY,
	level INTEGER DEFAULT 1
);
CREATE TABLE IF NOT EXISTS plr.tbl_player_placeable_object(
	player_placeable_object_id BIGSERIAL PRIMARY KEY,
	player_id BIGSERIAL FOREIGN KEY,
	placeable_object_id BIGSERIAL FOREIGN KEY,
	purchased_datetime TIMESTAMP DEFAULT NOW()
);

CREATE SCHEMA IF NOT EXISTS po;

CREATE TABLE IF NOT EXISTS po.tbl_placeable_object(
	placeable_object_id BIGSERIAL PRIMARY KEY,
	placeable_object_type_id BIGSERIAL FOREIGN KEY,
	placeable_object_name VARCHAR(255),
	coins_price INTEGER DEFAULT 0,
	experience_price INTEGER DEFAULT 0,
	placeable_object_image VARCHAR(255),
	placeable_object_icon VARCHAR(255),
	placeable_object_desciption(4096),
	is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS po.tbl_placeable_object_type(
	placeable_object_type_id BIGSERIAL PRIMARY KEY,
	placeable_object_type_name VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS po.placeable_object_scriptable_object(
	placeable_object_scriptable_object_id BIGSERIAL PRIMARY KEY,
	placeable_object_id BIGSERIAL FOREIGN KEY,
	scriptable_object_id BIGSERIAL FOREIGN KEY
);

CREATE TABLE IF NOT EXISTS po.tbl_placeable_object_player_team_level_max_quantity(
	placeable_object_player_team_level_max_quantity_id BIGSERIAL PRIMARY KEY,
	placeable_object_id BIGSERIAL FOREIGN KEY,
	player_team_id BIGSERIAL FOREIGN KEY,
	level INTEGER DEFAULT 1,
	max_quantity INTEGER DEFAULT 1
);

CREATE SCHEMA IF NOT EXISTS tsk;

CREATE TABLE IF NOT EXISTS tsk.tbl_task(
	task_id BIGSERIAL PRIMARY KEY,
	task_content VARCHAR(32768) NOT NULL,
	task_answer VARCHAR(255) NOT NULL DEFAULT '1',
	created_datetime TIMESTAMP DEFAULT NOW(),
	is_active BOOLEAN DEFAULT TRUE
);
CREATE TABLE IF NOT EXISTS tsk.tbl_task_level(
	task_level_id BIGSERIAL PRIMARY KEY,
	task_id BIGSERIAL FOREIGN KEY,
	level INTEGER DEFAULT 1
);

CREATE TABLE IF NOT EXISTS tsk.tbl_task_player_team(
	task_player_team_id BIGSERIAL PRIMARY KEY,
	task_id BIGSERIAL FOREIGN KEY,
	player_team_id BIGSERIAL FOREIGN KEY
);

CREATE SCHEMA IF NOT EXISTS so;

CREATE TABLE IF NOT EXISTS so.tbl_scriptable_object(
	scriptable_object_id BIGSERIAL PRIMARY KEY,
	scriptable_object_type_id BIGSERIAL FOREIGN KEY,
	scriptable_object_name VARCHAR(255),
	scriptable_object_jsonb JSONB
);

CREATE INDEX idx_gin_so ON so.tbl_scriptable_object USING GIN(scriptable_object_jsonb);

CREATE TABLE IF NOT EXISTS so.tbl_scriptable_object_type(
	scriptable_object_type_id BIGSERIAL PRIMARY KEY,
	scriptable_object_type_name VARCHAR(255)
);
