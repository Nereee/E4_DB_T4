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

DELIMITER //
DROP FUNCTION IF EXISTS BadagoGaurIdAudio;
CREATE FUNCTION BadagoGaurIdAudio(IdAudioa int)
RETURNS BOOLEAN 
READS sql data
BEGIN
    DECLARE rowExist int;
    
    SELECT IdAudio into rowExist FROM EstadistikakEgunean
    WHERE IdAudio = IdAudioa and Eguna = current_date();

    IF (rowExist = IdAudioa) THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
//

DELIMITER //
DROP TRIGGER IF EXISTS EstadistikakEguneanBete_Insert// 
CREATE TRIGGER EstadistikakEguneanBete_Insert
BEFORE INSERT ON Erreprodukzioak
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

delimiter //
DROP EVENT if exists EstadistikaHilean;
CREATE EVENT EstadistikaHilean
ON SCHEDULE EVERY 1 MONTH
STARTS '2024-06-01 00:00:00'
DO
BEGIN
	    DECLARE id int;
    DECLARE entzun int;
    DECLARE amaitu boolean default 0;
    
    DECLARE estadistikaZerrendaHilean cursor for 
    SELECT  IdAudio,sum(Entzunaldiak)
    FROM EstadistikakEgunean
    WHERE month(Eguna) = month(now() - INTERVAL 1 MONTH) 
    GROUP BY IdAudio;
    DECLARE CONTINUE HANDLER FOR NOT FOUND
    SET amaitu = 1;
    
	open estadistikaZerrendaHilean;
	
    fetch estadistikaZerrendaHilean into id,entzun;
    
    while amaitu = 0 do
    INSERT INTO EstadistikakHilean VALUES(id, current_date() - INTERVAL 1 MONTH,entzun);
    fetch estadistikaZerrendaHilean into id,entzun;
    end while;
	
    close estadistikaZerrendaHilean;
    
END; 
//
	

delimiter //
DROP EVENT if exists EstadistikaUrtean;
CREATE EVENT EstadistikaUrtean
ON SCHEDULE EVERY 1 YEAR
STARTS '2025-01-01 00:00:00'
DO
BEGIN
	DECLARE id int;
    DECLARE entzun int;
    DECLARE amaitu boolean default 0;
    
    DECLARE estadistikaZerrenda cursor for 
    SELECT  IdAudio,sum(Entzunaldiak)
    FROM EstadistikakHilean
    WHERE year(Hilea) = year(now()- Interval 1 year) 
    GROUP BY IdAudio;
    DECLARE CONTINUE HANDLER FOR NOT FOUND
    SET amaitu = 1;
    
	open estadistikaZerrenda;
	
    fetch estadistikaZerrenda into id,entzun;
    
    while amaitu = 0 do
    INSERT INTO EstadistikakUrtean VALUES(id, current_date() - INTERVAL 1 YEAR,entzun);
    fetch estadistikaZerrenda into id,entzun;
    end while;
	
    close estadistikaZerrenda;
    
END; 
//






































