use Sphea;

drop view if exists EstadistikaAbestiaEgunean;
create view EstadistikaAbestiaEgunean as
select Artista.IzenArtistikoa as Musikaria, Audio.Izena as Abestia, sum(Entzunaldiak) as Entzunaldiak, Eguna
from Artista join Album using(IdArtista) 
join Abestia using(IdAlbum)
join EstadistikakEgunean using (IdAudio)
join Audio using(IdAudio)
group by Artista.IzenArtistikoa, Audio.Izena, Eguna;

drop view if exists EstatistikakAurkestuMusikariaTotala;
create view EstatistikakAurkestuMusikariaTotala as
select ar.IzenArtistikoa AS Izena, sum(er.Entzunaldiak) as Totala , ar.Irudia as Irudia from EstadistikaTotala er INNER JOIN Audio au on er.IdAudio = au.IdAudio
INNER JOIN Abestia ab on au.IdAudio = ab.IdAudio
INNER JOIN Album al ON ab.IdAlbum = al.IdAlbum
INNER JOIN Artista ar ON al.IdArtista = ar.IdArtista group by ar.IdArtista; 

drop view if exists EstatistikakAurkestuPodcasterraTotala;
create view EstatistikakAurkestuPodcasterraTotala as
select ar.IzenArtistikoa as Izena, sum(er.Entzunaldiak) as Totala, ar.Irudia from  EstadistikaTotala er INNER JOIN Audio au on er.IdAudio = au.IdAudio
INNER JOIN Podcast pod on au.IdAudio = pod.IdAudio
INNER JOIN Podcaster po on pod.IdArtista = po.IdArtista
INNER JOIN Artista ar on po.IdArtista = ar.IdArtista group by ar.IdArtista; 
