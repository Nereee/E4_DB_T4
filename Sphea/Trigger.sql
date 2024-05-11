use Sphea;
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
AFTER INSERT ON EstadistikakEgunean
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
AFTER UPDATE ON EstadistikakEgunean
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
AFTER UPDATE ON EstadistikakEgunean
FOR EACH ROW
BEGIN
    UPDATE EstadistikaTotala
    SET Entzunaldiak =  Entzunaldiak + 1
    WHERE IdAudio = NEW.IdAudio; 
END;
//

DELIMITER //
DROP TRIGGER IF EXISTS EstadistikakEguneanBete_Insert// 
CREATE TRIGGER EstadistikakEguneanBete_Insert
AFTER INSERT ON Erreprodukzioak
FOR EACH ROW
BEGIN
    IF(BadagoGaurIdAudio(NEW.IdAudio)) then
    UPDATE EstadistikakEgunean
    SET Entzunaldiak =  Entzunaldiak + 1
    WHERE IdAudio = NEW.IdAudio and DAY(Eguna) = DAY(NEW.ErreData);
    ELSE
    INSERT INTO EstadistikakEgunean VALUES(NEW.IdAudio,now(),1);
    END IF;
END;
//


DROP FUNCTION IF EXISTS BadagoGaurIdAudio;
CREATE FUNCTION BadagoGaurIdAudio(IdAudioa int)
RETURNS BOOLEAN 
READS sql data
BEGIN
    
    DECLARE rowExist int;
    
    SELECT IdAudio into rowExist FROM EstadistikakEgunean
    WHERE IdAudio = IdAudioa and DAY(Eguna) = DAY(now());

    IF (rowExist = IdAudioa) THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;

