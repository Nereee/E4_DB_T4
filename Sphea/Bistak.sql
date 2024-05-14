use Sphea;

drop view if exists EstadistikaAbestiaEgunean;
create view EstadistikaAbestiaEgunean as
select Artista.IzenArtistikoa as Musikaria, Audio.Izena as Abestia, sum(Entzunaldiak) as Entzunaldiak, Eguna as Eguna
from Artista join Album using(IdArtista) 
join Abestia using(IdAlbum)
join EstadistikakEgunean using (IdAudio)
join Audio using(IdAudio)
where day(Eguna) = day(now())
group by Artista.IzenArtistikoa, Audio.Izena, Eguna, Mota
order by Entzunaldiak Desc;

drop view if exists EstadistikaAbestiaHilean;
create view EstadistikaAbestiaHilean as
select Artista.IzenArtistikoa as Musikaria, Audio.Izena as Abestia, sum(Entzunaldiak) as Entzunaldiak, Hilea
from Artista join Album using(IdArtista) 
join Abestia using(IdAlbum) 
join EstadistikakHilean using (IdAudio) 
join Audio using(IdAudio)
where month(Hilea) = month(now()) and year(Hilea) = year(Hilea)
group by Artista.IzenArtistikoa, Audio.Izena, Hilea 
order by Entzunaldiak Desc;

drop view if exists EstadistikaAbestiaUrtean;
create view EstadistikaAbestiaUrtean as
select Artista.IzenArtistikoa as Musikaria, Audio.Izena as Abestia, sum(Entzunaldiak) as Entzunaldiak, EstadistikakUrtean.Urtea
from Artista join Album using(IdArtista) 
join Abestia using(IdAlbum) 
join EstadistikakUrtean using (IdAudio) 
join Audio using(IdAudio)
where EstadistikakUrtean.Urtea = year(now())
group by Artista.IzenArtistikoa, Audio.Izena, EstadistikakUrtean.Urtea 
order by Entzunaldiak Desc;

drop view if exists EstadistikaPodcastEgunean;
create view EstadistikaPodcastEgunean as
select Artista.IzenArtistikoa as Podcasterra, Audio.Izena as Izena, sum(Entzunaldiak) as Entzunaldiak
from Artista join Podcaster using (IdArtista)
join  Podcast using (IdArtista)
join Audio using (IdAudio)
join EstadistikakEgunean using(IdAudio)
where date(Eguna) = date(now())
group by Podcasterra, Izena, EstadistikakEgunean.Entzunaldiak
order by EstadistikakEgunean.Entzunaldiak Desc;

drop view if exists EstadistikaPodcastHilean;
create view EstadistikaPodcastHilean as
select Artista.IzenArtistikoa as Podcasterra, Audio.Izena as Izena, sum(Entzunaldiak) as Entzunaldiak
from Artista join Podcaster using (IdArtista)
join  Podcast using (IdArtista)
join Audio using (IdAudio)
join EstadistikakHilean using(IdAudio)
where month(Hilea) = month(now()) and year(Hilea) = year(Hilea)
group by Podcasterra, Izena, EstadistikakHilean.Entzunaldiak
order by EstadistikakHilean.Entzunaldiak Desc;

drop view if exists EstadistikaPodcastUrtean;
create view EstadistikaPodcastUrtean as
select Artista.IzenArtistikoa as Podcasterra, Audio.Izena as Izena, sum(Entzunaldiak) as Entzunaldiak
from Artista join Podcaster using (IdArtista)
join  Podcast using (IdArtista)
join Audio using (IdAudio)
join EstadistikakUrtean using(IdAudio)
where Urtea = year(now())
group by Podcasterra, Izena, EstadistikakUrtean.Entzunaldiak
order by EstadistikakUrtean.Entzunaldiak Desc;

drop view if exists EntzundaEgunean;
create view EntzundaEgunean as
select Audio.Izena as Izena, sum(Entzunaldiak) as Entzunaldiak
from EstadistikakEgunean
join Audio using(IdAudio)
where day(Eguna) = day(now())
group by Audio.Izena
order by Entzunaldiak Desc;

drop view if exists EntzundaHilean;
create view EntzundaHilean as
select Audio.Izena as Izena, sum(Entzunaldiak) as Entzunaldiak
from EstadistikakHilean
join Audio using(IdAudio)
where month(Hilea) = month(now()) and year(Hilea) = year(Hilea)
group by Audio.Izena
order by Entzunaldiak Desc;

drop view if exists EntzundaUrtean;
create view EntzundaUrtean as
select Audio.Izena as Izena, sum(Entzunaldiak) as Entzunaldiak
from EstadistikakUrtean
join Audio using(IdAudio)
where Urtea = year(now())
group by Audio.Izena
order by Entzunaldiak Desc;

drop view if exists EstadistikaAlbumakEgunean;
create view EstadistikaAlbumakEgunean as
select Artista.IzenArtistikoa as Artista, Izenburua as Albuma, sum(Entzunaldiak) as Entzunaldiak
from Artista join Album using(IdArtista) 
join Abestia using(IdAlbum)
join EstadistikakEgunean using (IdAudio)
join Audio using(IdAudio)
where day(Eguna) = day(now())
group by Izenburua
order by Entzunaldiak Desc;

drop view if exists EstadistikaAlbumaklHilean;
create view EstadistikaAlbumaklHilean as
select Artista.IzenArtistikoa as Artista, Izenburua as Albuma, sum(Entzunaldiak) as Entzunaldiak
from Artista join Album using(IdArtista) 
join Abestia using(IdAlbum)
join EstadistikakHilean using (IdAudio)
join Audio using(IdAudio)
where month(Hilea) = month(now()) and year(Hilea) = year(Hilea)
group by Izenburua
order by Entzunaldiak Desc;

drop view if exists EstadistikaAlbumakUrtean;
create view EstadistikaAlbumakUrtean as
select Artista.IzenArtistikoa as Artista, Izenburua as Albuma, sum(Entzunaldiak) as Entzunaldiak
from Artista join Album using(IdArtista) 
join Abestia using(IdAlbum)
join EstadistikakUrtean using (IdAudio)
join Audio using(IdAudio)
where EstadistikakUrtean.Urtea = year(now())
group by Izenburua
order by Entzunaldiak Desc;

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
