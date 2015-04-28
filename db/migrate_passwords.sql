Alter table users add column encrypted_password varchar(255);
Update users SET encrypted_password = crypted_password;
