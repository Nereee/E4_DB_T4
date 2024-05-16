use Sphea;
DELIMITER //

DROP TRIGGER IF EXISTS insert_ErregistroData //
CREATE TRIGGER insert_ErregistroData
BEFORE INSERT ON Bezeroa
FOR EACH ROW
BEGIN
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erregistro data ezartzerakoan errorea';
    set new.ErregistroData = CURDATE();
    END;
//

DELIMITER //

DROP TRIGGER IF EXISTS EstadistikaTotalaBeteInsert //
CREATE TRIGGER EstadistikaTotalaBeteInsert
BEFORE INSERT ON EstadistikakEgunean
FOR EACH ROW
BEGIN
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Errorea Estadistika totalean insterta egitean';
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
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Errorea Estadistika totalak eguneratzean';
    UPDATE EstadistikaTotala
    SET Entzunaldiak =  Entzunaldiak + 1
    WHERE IdAudio = NEW.IdAudio; 
END;
//


DELIMITER //
drop procedure if exists InsertatuMusikaria //
CREATE PROCEDURE InsertatuMusikaria(izena varchar(30),irudia text,deskripzioa varchar(100),ezaugarria varchar(20)) 
BEGIN
	declare lastId varchar(30);
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Errorea musikaria insertatzean';
    Insert into Artista (IzenArtistikoa,Irudia,Deskripzioa) values(izena,from_base64(irudia),deskripzioa);
    select IdArtista into lastId from Artista where IzenArtistikoa = izena;
    Insert into Musikaria values (lastId,ezaugarria);
END;
//



DELIMITER //

DROP TRIGGER IF EXISTS EstadistikaTotalaBeteUpdate //
CREATE TRIGGER EstadistikaTotalaBeteUpdate
BEFORE UPDATE ON EstadistikakEgunean
FOR EACH ROW
BEGIN
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Errorea Estadistika totala eguneratzean';
    UPDATE EstadistikaTotala
    SET Entzunaldiak =  Entzunaldiak + 1
    WHERE IdAudio = NEW.IdAudio; 
END;
//

DELIMITER //
DROP FUNCTION IF EXISTS BadagoGaurIdAudio //
CREATE FUNCTION BadagoGaurIdAudio(IdAudioa int)
RETURNS BOOLEAN
READS sql data
BEGIN
    DECLARE rowExist int;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Errorea gaurkorako aurkitzean audioa';
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
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Errorra inserta egitean EstadistikakEgunean';
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
DROP EVENT if exists EstadistikaHilean //
CREATE EVENT EstadistikaHilean
ON SCHEDULE EVERY 1 Month
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
    
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Errorea hileko estadistikak kargatzean';
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
DROP EVENT if exists EstadistikaUrtean //
CREATE EVENT EstadistikaUrtean
ON SCHEDULE EVERY 1 Year
STARTS '2025-01-01 00:00:00'
DO
BEGIN
	DECLARE id int;
    DECLARE entzun int;
    DECLARE amaitu boolean default 0;
    

    DECLARE estadistikaZerrenda cursor for 
    SELECT  IdAudio,sum(Entzunaldiak)
    FROM EstadistikakHilean
    WHERE year(Hilea) = year(now() - Interval 1 year) 
    GROUP BY IdAudio;
    DECLARE CONTINUE HANDLER FOR NOT FOUND
    SET amaitu = 1;
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Errorea urteko estadistikak kargatzean';
	open estadistikaZerrenda;
	
    fetch estadistikaZerrenda into id,entzun;
    
    while amaitu = 0 do
    INSERT INTO EstadistikakUrtean VALUES(id, current_date() - INTERVAL 1 YEAR,entzun);
    fetch estadistikaZerrenda into id,entzun;
    end while;
	
    close estadistikaZerrenda;
    
END; 
//	


DELIMITER //
drop procedure if exists InsertatuMusikaria //
CREATE PROCEDURE InsertatuMusikaria(izena varchar(30),irudia longtext,deskripzioa varchar(100),ezaugarria varchar(20)) 
BEGIN
	declare lastId varchar(30);
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Errorea musikaria insertatzerakoan';
    Insert into Artista (IzenArtistikoa,Irudia,Deskripzioa) values(izena,from_base64(irudia),deskripzioa);
    select IdArtista into lastId from Artista where IzenArtistikoa = izena;
    Insert into Musikaria values (lastId,ezaugarria);
END;
//





DELIMITER //
drop procedure if exists AldatuMusikaria //
CREATE PROCEDURE AldatuMusikaria(id int,izena varchar(30),irudia longtext,deskripzioa varchar(100),ezaugarria varchar(20)) 
BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Errorea musikaria aldatzerakoan';
    Update Artista set IzenArtistikoa = izena,  
    Irudia = from_base64(irudia),  
    Deskripzioa = deskripzioa
    WHERE IdArtista = id;
    
    Update  Musikaria set 
    Ezaugarria = ezaugarria
    WHERE IdArtista = id;
END;
//

DELIMITER //
drop procedure if exists InsertatuAlbum //
CREATE PROCEDURE InsertatuAlbum(izena varchar(30), irudia longtext, generoa varchar(30), urtea date, idMusikaria int) 
BEGIN
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Errorea albumera insertatzerakoan';
    Insert into Album (Izenburua, Urtea, Generoa, Irudia, IdArtista) values(izena,urtea, generoa, from_base64(irudia),idMusikaria);
END;
//

drop procedure InsertatuAbestia;
Delimiter //
Create procedure InsertatuAbestia(izena varchar(30),iraupena time,irudia longtext,idAlbum int)
begin 
		declare newId int;
		Insert into Audio (Izena,Iraupena,Irudia) VALUES(izena,iraupena,from_base64(irudia));
        Select IdAudio into newId from Audio where izena = izena;
        Insert into Abestia VALUES(newId,idAlbum);
        Insert into EstadistikaTotala values(newId,0);
    end;
   //
