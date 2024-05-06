DELIMITER //

DROP TRIGGER IF EXISTS insert_ErregistroData //
CREATE TRIGGER insert_ErregistroData
BEFORE INSERT ON Bezeroa
FOR EACH ROW
    set new.ErregistroData = CURDATE();
//



    DELIMITER //

DROP TRIGGER IF EXISTS EstadistikaTotalaBeteInsert //
CREATE TRIGGER EstadistikaTotalaBeteInsert
BEFORE INSERT ON EstadistikakEgunean
FOR EACH ROW
BEGIN
    UPDATE EstadistikaTotala
    SET Entzunaldiak =  Entzunaldiak + 1
    WHERE IdAudio = NEW.IdAudio; 
END;
//

DELIMITER //

DROP TRIGGER IF EXISTS EstadistikaTotalaBeteUpdate //
CREATE TRIGGER EstadistikaTotalaBeteUpdate
BEFORE UPDATE ON EstadistikakEgunean
FOR EACH ROW
BEGIN
    UPDATE EstadistikaTotala
    SET Entzunaldiak =  Entzunaldiak + 1
    WHERE IdAudio = NEW.IdAudio; 
END;
//


