CREATE USER auth_user WITH PASSWORD 'auth_dev_2026';
CREATE USER chat_user WITH PASSWORD 'chat_dev_2026';

CREATE DATABASE auth_db OWNER auth_user;
CREATE DATABASE chat_db OWNER chat_user;
