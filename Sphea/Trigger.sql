DELIMITER //

DROP TRIGGER IF EXISTS insert_ErregistroData //
CREATE TRIGGER insert_ErregistroData
BEFORE INSERT ON Bezeroa
FOR EACH ROW
    set new.ErregistroData = CURDATE();
//