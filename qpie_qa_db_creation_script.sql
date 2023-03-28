
CREATE SCHEMA IF NOT EXISTS qpie_qa DEFAULT CHARACTER SET UTF8MB4 ;
USE qpie_qa ;

-- -----------------------------------------------------
-- Table qpie_qa.mv_user
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS qpie_qa.mv_user (
  user_id VARCHAR(50) NOT NULL ,
  first_name VARCHAR(200) NULL ,
  last_name VARCHAR(200)  NULL ,
  UNIQUE INDEX uk_mv_user (user_id ASC) )
;

/*
-- -----------------------------------------------------
-- Table qpie_qa.questions
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS qpie_qa.questions (
  question_id VARCHAR(50) NOT NULL ,
  description VARCHAR(4000) NOT NULL ,
  create_date DATETIME NOT NULL ,
  modified_date DATETIME NULL DEFAULT NULL ,
  search_count INT,
  PRIMARY KEY (question_id) )
;
*/

CREATE  TABLE IF NOT EXISTS qpie_qa.questions (
  user_id VARCHAR(50) NOT NULL ,
  question_id VARCHAR(50) NOT NULL unique,
  description MEDIUMTEXT NOT NULL ,
  create_date DATETIME NOT NULL DEFAULT (UTC_TIMESTAMP),
  Question_modified_date DATETIME NULL DEFAULT NULL ,
  Attribute_modified_date DATETIME NULL DEFAULT NULL ,
  search_count INT,
  posted_anonymous CHAR(1) NULL DEFAULT NULL ,
  input_mode VARCHAR(10) NOT NULL ,
  turnoff_question CHAR(1) NULL DEFAULT NULL ,
  Changed_anonymous CHAR(1) NULL DEFAULT NULL ,
  attachment_urls TEXT,
  longitude VARCHAR(15) NOT NULL ,
  latitude VARCHAR(15) NOT NULL ,
  user_hashtags VARCHAR(10000),
  INDEX pk_user_question (user_id ASC,question_id ASC) ,
  CONSTRAINT pk_user_question
    PRIMARY KEY (user_id,question_id),
  CONSTRAINT fk_user_question_user
    FOREIGN KEY (user_id )
    REFERENCES qpie_qa.mv_user (user_id ))
;
/*
-- -----------------------------------------------------
-- Table qpie_qa.answers
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS qpie_qa.answers (
  answer_id VARCHAR(50) NOT NULL ,
  question_id VARCHAR(50) NOT NULL ,
  description VARCHAR(4000) NOT NULL ,
  create_date DATETIME NOT NULL ,
  modified_date DATETIME NULL DEFAULT NULL ,
  PRIMARY KEY (answer_id) ,
  INDEX fk_answer_question (question_id ASC) ,
  CONSTRAINT fk_answer_question
    FOREIGN KEY (question_id )
    REFERENCES qpie_qa.questions (question_id ))
;
*/
-- -----------------------------------------------------
-- Table qpie_qa.answers
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS qpie_qa.answers (
  user_id VARCHAR(50) NOT NULL ,
  answer_id VARCHAR(50) NOT NULL Unique,
  question_id VARCHAR(50) NOT NULL ,
  description MEDIUMTEXT NOT NULL ,
  create_date DATETIME NOT NULL DEFAULT (UTC_TIMESTAMP),
  Answer_modified_date DATETIME NULL DEFAULT NULL ,
  Attribute_modified_date DATETIME NULL DEFAULT NULL ,
  posted_anonymous CHAR(1) NULL DEFAULT NULL ,
  input_mode VARCHAR(10) NOT NULL ,
  delete_answer CHAR(1) NULL DEFAULT NULL ,
  attachment_urls TEXT,
  user_hashtags VARCHAR(10000),
  INDEX pk_answer (user_id ASC,answer_id ASC) ,
  CONSTRAINT pk_answer
    PRIMARY KEY (user_id,answer_id ),
  CONSTRAINT fk_answer_question_id
    FOREIGN KEY (question_id)
    REFERENCES qpie_qa.questions (question_id ),
  CONSTRAINT fk_user_answer_user
    FOREIGN KEY (user_id )
    REFERENCES qpie_qa.mv_user (user_id ))
;


-- -----------------------------------------------------
-- Table qpie_qa.answer_ratings
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS qpie_qa.answer_ratings (
  answer_id VARCHAR(50) NOT NULL ,
  rated_user VARCHAR(50) NOT NULL ,
  rating TINYINT NOT NULL ,
  create_date DATETIME NOT NULL DEFAULT (UTC_TIMESTAMP) ,
  modified_date DATETIME NULL DEFAULT NULL ,
  INDEX fk_answer_rating (answer_id ASC) ,
  INDEX fk_answer_rating_ru (rated_user ASC) ,
  CONSTRAINT fk_answer_rating_ru
    FOREIGN KEY (rated_user )
    REFERENCES qpie_qa.mv_user (user_id ),
  CONSTRAINT fk_answer_rating
    FOREIGN KEY (answer_id )
    REFERENCES qpie_qa.answers (answer_id ))
;


-- -----------------------------------------------------
-- Table qpie_qa.answer_tags
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS qpie_qa.answer_tags (
  answer_id VARCHAR(50) NOT NULL ,
  tag VARCHAR(100) NOT NULL COMMENT 'it is the keyword used in the answer' ,
  create_date DATETIME NOT NULL DEFAULT (UTC_TIMESTAMP) ,
  modified_date DATETIME NULL DEFAULT NULL ,
  repeat_count INT NULL DEFAULT NULL COMMENT 'How many times the tag used in the answer' ,
  weightage_percent DECIMAL(3,3) NULL DEFAULT NULL COMMENT 'percentage of number of times the tag is used in the answer when compared to other tags' ,
  status CHAR(1) NULL DEFAULT NULL COMMENT 'Active :Y, Inactive :N' ,
  UNIQUE INDEX uk_answer_tags (tag ASC, answer_id ASC) ,
  INDEX fk_answer_tagg (answer_id ASC) ,
  CONSTRAINT fk_answer_tagg
    FOREIGN KEY (answer_id )
    REFERENCES qpie_qa.answers (answer_id ))
;


-- -----------------------------------------------------
-- Table qpie_qa.location_tracking
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS qpie_qa.location_tracking (
  user_id VARCHAR(50) NOT NULL ,
  longitude VARCHAR(15) NOT NULL ,
  latitude VARCHAR(15) NOT NULL ,
  TRACKING_DATE DATETIME NOT NULL DEFAULT (UTC_TIMESTAMP) COMMENT 'DATETIME while capturing location' )
;
ALTER TABLE qpie_qa.location_tracking ADD CONSTRAINT PK_LOCATION_TRACKING PRIMARY key (user_id);
Alter table qpie_qa.location_tracking ADD CONSTRAINT FK_LOCATION_TRACKING FOREIGN key(user_id) references qpie_qa.mv_user (user_id );

-- -----------------------------------------------------
-- Table qpie_qa.non_tags
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS qpie_qa.non_tags (
  key_word VARCHAR(100) NOT NULL COMMENT 'commonly used words' ,
  tag_status CHAR(1) NULL DEFAULT NULL COMMENT 'Active: Y, Inactive: N' ,
  type VARCHAR(50) NULL DEFAULT NULL COMMENT 'VERB, CONJUNCTION, PRONOUN, PRE-POSITION, etc..' ,
  create_date DATETIME NOT NULL DEFAULT (UTC_TIMESTAMP),
  modified_date DATETIME NULL DEFAULT NULL   )
;


-- -----------------------------------------------------
-- Table qpie_qa.question_ratings
-- -----------------------------------------------------
/*
CREATE  TABLE IF NOT EXISTS qpie_qa.question_ratings (
  question_id VARCHAR(50) NOT NULL ,
  rated_user VARCHAR(50) NOT NULL ,
  rating TINYINT(2) NOT NULL ,
  create_date DATETIME NULL DEFAULT NULL ,
  INDEX fk_question_rating (question_id ASC) ,
  INDEX fk_question_rating_ru (rated_user ASC) ,
  CONSTRAINT fk_question_rating_ru
    FOREIGN KEY (rated_user )
    REFERENCES qpie_qa.mv_user (user_id ),
  CONSTRAINT fk_question_rating
    FOREIGN KEY (question_id )
    REFERENCES qpie_qa.questions (question_id ))

;
*/

-- -----------------------------------------------------
-- Table qpie_qa.question_tags
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS qpie_qa.question_tags (
  question_id VARCHAR(50) NOT NULL ,
  tag VARCHAR(100) NOT NULL COMMENT 'it is the keyword used in the question' ,
  create_date DATETIME NOT NULL DEFAULT (UTC_TIMESTAMP) ,
  modified_date DATETIME NULL DEFAULT NULL ,
  repeat_count INT NULL DEFAULT NULL COMMENT 'How many times the tag used in the queston' ,
  weightage_percent DECIMAL(3,3) NULL DEFAULT NULL COMMENT 'percentage of number of times the tag is used in the question when compared to other tags' ,
  status CHAR(1) NULL DEFAULT NULL COMMENT 'Active :Y, Inactive :N' ,
  UNIQUE INDEX uk_question_tags (tag ASC, question_id ASC) ,
  INDEX fk_question_tagg (question_id ASC) ,
  CONSTRAINT fk_question_tagg
    FOREIGN KEY (question_id )
    REFERENCES qpie_qa.questions (question_id ))
;




-- -----------------------------------------------------
-- Table qpie_qa.user_saved_questions
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS qpie_qa.user_saved_questions (
  user_id VARCHAR(50) NOT NULL ,
  question_id VARCHAR(50) NOT NULL ,
  create_date DATETIME NOT NULL DEFAULT (UTC_TIMESTAMP) ,
  INDEX fk_user_sv_question_user (user_id ASC) ,
  INDEX fk_user_sv_question (question_id ASC) ,
  CONSTRAINT fk_user_sv_question
    FOREIGN KEY (question_id )
    REFERENCES qpie_qa.questions (question_id ),
  CONSTRAINT fk_user_sv_question_user
    FOREIGN KEY (user_id )
    REFERENCES qpie_qa.mv_user (user_id ))
;

CREATE  TABLE IF NOT EXISTS qpie_qa.user_chat (
  user_id VARCHAR(50) NOT NULL REFERENCES qpie_qa.mv_user (user_id ),
  question_id VARCHAR(50) REFERENCES qpie_qa.questions (question_id ),
  answer_id varchar(50) REFERENCES qpie_qa.answers (answer_id ),
  chat_user_id VARCHAR(50) NOT NULL,
  chat_comments VARCHAR(4000) NOT NULL,
  chat_seq   INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  private_chat CHAR(1), 
  create_date DATETIME NOT NULL DEFAULT (UTC_TIMESTAMP),
  modified_date DATETIME NULL DEFAULT NULL   
    );

CREATE  TABLE IF NOT EXISTS qpie_qa.question_likes (
  user_id VARCHAR(50) NOT NULL REFERENCES qpie_qa.mv_user (user_id ),
  question_id VARCHAR(50) REFERENCES qpie_qa.questions (question_id ),
  like_status CHAR(1) DEFAULT 'Y',
  create_date DATETIME NOT NULL DEFAULT (UTC_TIMESTAMP),
  modified_date DATETIME  
    );

CREATE  TABLE IF NOT EXISTS qpie_qa.answer_likes (
  user_id VARCHAR(50) NOT NULL REFERENCES qpie_qa.mv_user (user_id ),
  answer_id VARCHAR(50) REFERENCES qpie_qa.answers (answer_id ),
  like_status CHAR(1) DEFAULT 'Y',
  create_date DATETIME NOT NULL DEFAULT (UTC_TIMESTAMP),
  modified_date DATETIME  
    );
	

USE qpie_qa ; 

SET GLOBAL event_scheduler = ON;

DROP EVENT IF EXISTS qpie_qa.evt_copy_user_info;


delimiter |
use qpie_qa|
CREATE EVENT qpie_qa.evt_copy_user_info
   ON SCHEDULE EVERY 1 MINUTE
   STARTS CURRENT_TIMESTAMP + Interval 1 minute
   ON COMPLETION PRESERVE
   DO
   evt_body:BEGIN
      	declare lock_stat int ; 
      	select is_free_lock('lock1') into lock_stat;
      	if lock_stat=1 then
      		SELECT GET_LOCK('lock1',-1);
      	else
      		leave evt_body;
      	end if;
         WHILE TRUE
         DO
            INSERT INTO qpie_qa.mv_user(user_id, first_name, last_name)
               (SELECT user_id, first_name, last_name
                  FROM qpie_user.user u
                 WHERE u.user_id NOT IN (SELECT mu.user_id
                                           FROM qpie_qa.mv_user mu));
             COMMIT;
             
             UPDATE qpie_qa.mv_user mu 
 					JOIN qpie_user.user u
 		  			  ON u.user_id=mu.user_id 
 		 			 AND( (mu.first_name is null and u.first_name is not null)
                             OR(mu.last_name is null and u.last_name is not null)
                             OR(u.first_name<>mu.first_name OR u.last_name<>mu.last_name)
							) 
 				SET mu.first_name=u.first_name,
 	 				mu.last_name=u.last_name;
            COMMIT;
         END WHILE;
         select release_lock('lock1');
      END|
      delimiter ;
