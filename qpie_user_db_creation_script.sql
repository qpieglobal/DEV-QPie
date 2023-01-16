
CREATE SCHEMA IF NOT EXISTS qpie_user DEFAULT CHARACTER SET utf8 ;
USE qpie_user ;

CREATE  TABLE IF NOT EXISTS qpie_user.feed_topics (
  topic_id INT(10) NOT NULL ,
  segment_id INT(10) NULL DEFAULT NULL ,
  topic VARCHAR(1000) NOT NULL 
   );

ALTER TABLE qpie_user.feed_topics ADD CONSTRAINT pk_feed_topics PRIMARY KEY  (topic_id);

ALTER TABLE qpie_user.feed_topics ADD CONSTRAINT fk_fo_seg FOREIGN KEY(segment_id) REFERENCES qpie_user.feed_topics(topic_id);


CREATE  TABLE IF NOT EXISTS qpie_user.locations (
  location_id VARCHAR(10) NOT NULL ,
  country VARCHAR(100) NULL DEFAULT NULL ,
  state VARCHAR(100) NULL DEFAULT NULL ,
  city VARCHAR(100) NULL DEFAULT NULL  );

ALTER TABLE qpie_user.locations ADD CONSTRAINT pk_locations PRIMARY KEY  (location_id);


CREATE  TABLE IF NOT EXISTS qpie_user.media_type (
  media_type_id INT(4) NOT NULL ,
  description VARCHAR(100) NOT NULL 
 );

ALTER TABLE qpie_user.media_type ADD CONSTRAINT pk_media_type PRIMARY KEY  (media_type_id);

ALTER TABLE qpie_user.media_type ADD CONSTRAINT uk_media_type_desc UNIQUE  (description);

CREATE  TABLE IF NOT EXISTS qpie_user.user (
  user_id VARCHAR(50) NOT NULL ,
  first_name VARCHAR(200),
  last_name VARCHAR(200) ,
  mobile_number VARCHAR(13) NOT NULL COMMENT 'Mobile number with country code ex: +91997290xxxx' ,
  email_id VARCHAR(200) NULL DEFAULT NULL ,
  create_date DATETIME DEFAULT CONVERT_TZ(NOW(),'SYSTEM','UTC') ,
  last_modified_date DATETIME NULL DEFAULT NULL ,
  status VARCHAR(30) NULL DEFAULT NULL ,
  profile_picture VARCHAR(4000) NULL DEFAULT NULL COMMENT 'URL of the profile picture' ,
  current_location VARCHAR(50) NULL DEFAULT NULL COMMENT 'current location of user at the time of profile creation' ,
  description VARCHAR(4000) NULL DEFAULT NULL ,
  dob DATE ,
  occupation VARCHAR(200),
  PP_Accepted CHAR(1),
  PP_Accepted_date DATETIME,
  PP_Accepted_Page VARCHAR(50)  );

ALTER TABLE qpie_user.user ADD CONSTRAINT pk_user PRIMARY KEY  (user_id);

ALTER TABLE qpie_user.user ADD CONSTRAINT uk_user_mobile UNIQUE  (mobile_number);

CREATE  TABLE IF NOT EXISTS qpie_user.user_city_feed_prefs (
  user_id VARCHAR(50) NOT NULL ,
  location_id VARCHAR(10) NOT NULL );

ALTER TABLE qpie_user.user_city_feed_prefs ADD CONSTRAINT fk_ucf_user FOREIGN KEY(user_id) REFERENCES qpie_user.user(user_id);

ALTER TABLE qpie_user.user_city_feed_prefs ADD CONSTRAINT fk_ucf_loc FOREIGN KEY(location_id) REFERENCES qpie_user.locations(location_id);

CREATE  TABLE IF NOT EXISTS qpie_user.user_email (
  user_id VARCHAR(50) NULL DEFAULT NULL ,
  email_id VARCHAR(200) NOT NULL ,
  verified CHAR(1) NULL DEFAULT 'N' ,
  verified_date DATETIME NULL DEFAULT NULL ,
  create_date DATETIME NULL DEFAULT NULL,
  current_email CHAR(1)  );

ALTER TABLE qpie_user.user_email ADD CONSTRAINT fk_uemail_user FOREIGN KEY(user_id) REFERENCES qpie_user.user(user_id);

ALTER TABLE qpie_user.user_email ADD CONSTRAINT uk_user_email UNIQUE  (user_id,email_id);

CREATE  TABLE IF NOT EXISTS qpie_user.user_feed_prefs (
  user_id VARCHAR(50) NOT NULL ,
  pref_topic_id INT(10) NOT NULL );

ALTER TABLE qpie_user.user_feed_prefs ADD CONSTRAINT fk_ufp_user FOREIGN KEY(user_id) REFERENCES qpie_user.user(user_id);

ALTER TABLE qpie_user.user_feed_prefs ADD CONSTRAINT fk_ufp_topic FOREIGN KEY(pref_topic_id) REFERENCES qpie_user.feed_topics(topic_id);

CREATE  TABLE IF NOT EXISTS qpie_user.user_following (
  user_id VARCHAR(50) NOT NULL ,
  following_user VARCHAR(50) NOT NULL ,
  follow_status CHAR(1) NOT NULL ,
  create_date DATETIME NOT NULL ,
  modified_date DATETIME NULL DEFAULT NULL ,
  following_since DATETIME NULL DEFAULT NULL  );

ALTER TABLE qpie_user.user_following ADD CONSTRAINT fk_follow_user FOREIGN KEY(user_id) REFERENCES qpie_user.user(user_id);

ALTER TABLE qpie_user.user_following ADD CONSTRAINT fk_follow_follow FOREIGN KEY(following_user) REFERENCES qpie_user.user(user_id);

ALTER TABLE qpie_user.user_following ADD CONSTRAINT uk_user_following UNIQUE(user_id , following_user);


CREATE  TABLE IF NOT EXISTS qpie_user.user_media_links (
  user_id VARCHAR(50) NOT NULL DEFAULT '' ,
  media_type_id INT(4) NOT NULL ,
  url VARCHAR(4000) NOT NULL ,
  display_pref CHAR(1) NOT NULL DEFAULT 'Y' );

ALTER TABLE qpie_user.user_media_links ADD CONSTRAINT pk_user_media_links PRIMARY KEY (user_id, media_type_id);

ALTER TABLE qpie_user.user_media_links ADD CONSTRAINT fk_uml_user FOREIGN KEY(user_id) REFERENCES qpie_user.user(user_id);

ALTER TABLE qpie_user.user_media_links ADD CONSTRAINT fk_uml_media FOREIGN KEY(media_type_id) REFERENCES qpie_user.media_type(media_type_id);


CREATE  TABLE IF NOT EXISTS qpie_user.user_mobile (
  user_id VARCHAR(50) NULL DEFAULT NULL ,
  mobile_number varchar(13) NOT NULL ,
  verified CHAR(1) NULL DEFAULT 'N' ,
  verified_date DATETIME NULL DEFAULT NULL ,
  create_date DATETIME DEFAULT CONVERT_TZ(NOW(),'SYSTEM','UTC'),
  current_mobile CHAR(1),
  device_id varchar(200));

ALTER TABLE qpie_user.user_mobile ADD CONSTRAINT pk_user_mobile PRIMARY KEY(user_id,mobile_number);
ALTER TABLE qpie_user.user_mobile ADD CONSTRAINT fk_um_user FOREIGN KEY(user_id) REFERENCES qpie_user.user(user_id);


CREATE  TABLE IF NOT EXISTS qpie_user.user_privacy_pref (
  user_id VARCHAR(50) NULL DEFAULT NULL ,
  location_tracking CHAR(1) NOT NULL DEFAULT 'Y' ,
  availble_to_chat CHAR(1) NOT NULL DEFAULT 'Y' ,
  display_media_links CHAR(1) NOT NULL DEFAULT 'Y' ,
  display_questions CHAR(1) NOT NULL DEFAULT 'Y' ,
  display_answers CHAR(1) NOT NULL DEFAULT 'Y' ,
  pref_feeds_enabled CHAR(1) NOT NULL DEFAULT 'Y' ,
  city_feeds_enabled CHAR(1) NOT NULL DEFAULT 'Y');

ALTER TABLE qpie_user.user_privacy_pref ADD CONSTRAINT uk_upp_user UNIQUE(user_id);

ALTER TABLE qpie_user.user_privacy_pref ADD CONSTRAINT fk_upp_user FOREIGN KEY(user_id) REFERENCES qpie_user.user(user_id);


CREATE  TABLE IF NOT EXISTS qpie_user.user_event_log (
  user_id VARCHAR(50) NOT NULL ,
  event_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  event_desc VARCHAR(500) NOT NULL,
  create_date DATETIME NOT NULL DEFAULT CONVERT_TZ(NOW(),'SYSTEM','UTC') 
    );

ALTER TABLE qpie_user.user_event_log ADD CONSTRAINT fk_user_event FOREIGN KEY(user_id) REFERENCES qpie_user.user(user_id);

