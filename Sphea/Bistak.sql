
use Sphea;

drop view if exists EstatistikakAurkestuAbestiakEgunero;
create view EstatistikakAurkestuAbestiakEgunero as
select ar.IzenArtistikoa, au.Izena, er.Egunero from Estadistikak er INNER JOIN Audio au on er.IdAudio = au.IdAudio
INNER JOIN Abestia ab on au.IdAudio = ab.IdAudio
INNER JOIN Album al ON ab.IdAlbum = al.IdAlbum
INNER JOIN Artista ar ON al.IdArtista = ar.IdArtista; 

drop view if exists EstatistikakAurkestuAbestiakAstero;
create view EstatistikakAurkestuAbestiakAstero as
select ar.IzenArtistikoa, au.Izena, er.Astero from Estadistikak er INNER JOIN Audio au on er.IdAudio = au.IdAudio
INNER JOIN Abestia ab on au.IdAudio = ab.IdAudio
INNER JOIN Album al ON ab.IdAlbum = al.IdAlbum
INNER JOIN Artista ar ON al.IdArtista = ar.IdArtista; 

drop view if exists EstatistikakAurkestuAbestiakHilero;
create view EstatistikakAurkestuAbestiakHilero as
select ar.IzenArtistikoa, au.Izena, er.Hilero from Estadistikak er INNER JOIN Audio au on er.IdAudio = au.IdAudio
INNER JOIN Abestia ab on au.IdAudio = ab.IdAudio
INNER JOIN Album al ON ab.IdAlbum = al.IdAlbum
INNER JOIN Artista ar ON al.IdArtista = ar.IdArtista; 

drop view if exists EstatistikakAurkestuAbestiakUrtero;
create view EstatistikakAurkestuAbestiakUrtero as
select ar.IzenArtistikoa, au.Izena, er.Urtero from Estadistikak er INNER JOIN Audio au on er.IdAudio = au.IdAudio
INNER JOIN Abestia ab on au.IdAudio = ab.IdAudio
INNER JOIN Album al ON ab.IdAlbum = al.IdAlbum
INNER JOIN Artista ar ON al.IdArtista = ar.IdArtista; 

drop view if exists EstatistikakAurkestuPodcastEgunero;
create view EstatistikakAurkestuPodcastEgunero as
select ar.IzenArtistikoa, au.Izena, er.Egunero from Estadistikak er INNER JOIN Audio au on er.IdAudio = au.IdAudio
INNER JOIN Podcast pod on au.IdAudio = pod.IdAudio
INNER JOIN Podcaster po on pod.IdArtista = po.IdArtista
INNER JOIN Artista ar on po.IdArtista = ar.IdArtista;

drop view if exists EstatistikakAurkestuPodcastAstero;
create view EstatistikakAurkestuPodcastAstero as
select ar.IzenArtistikoa, au.Izena, er.Astero from Estadistikak er INNER JOIN Audio au on er.IdAudio = au.IdAudio
INNER JOIN Podcast pod on au.IdAudio = pod.IdAudio
INNER JOIN Podcaster po on pod.IdArtista = po.IdArtista
INNER JOIN Artista ar on po.IdArtista = ar.IdArtista; 

drop view if exists EstatistikakAurkestuPodcastHilero;
create view EstatistikakAurkestuPodcastHilero as
select ar.IzenArtistikoa, au.Izena, er.Hilero from Estadistikak er INNER JOIN Audio au on er.IdAudio = au.IdAudio
INNER JOIN Podcast pod on au.IdAudio = pod.IdAudio
INNER JOIN Podcaster po on pod.IdArtista = po.IdArtista
INNER JOIN Artista ar on po.IdArtista = ar.IdArtista; 

drop view if exists EstatistikakAurkestuPodcastUrtero;
create view EstatistikakAurkestuPodcastUrtero as
select ar.IzenArtistikoa, au.Izena, er.Urtero from Estadistikak er INNER JOIN Audio au on er.IdAudio = au.IdAudio
INNER JOIN Podcast pod on au.IdAudio = pod.IdAudio
INNER JOIN Podcaster po on pod.IdArtista = po.IdArtista
INNER JOIN Artista ar on po.IdArtista = ar.IdArtista; 

drop view if exists EstatistikakAurkestuMusikariaTotala;
create view EstatistikakAurkestuMusikariaTotala as
select ar.IzenArtistikoa AS Izena, sum(er.Beti) as Totala , ar.Irudia as Irudia from Estadistikak er INNER JOIN Audio au on er.IdAudio = au.IdAudio
INNER JOIN Abestia ab on au.IdAudio = ab.IdAudio
INNER JOIN Album al ON ab.IdAlbum = al.IdAlbum
INNER JOIN Artista ar ON al.IdArtista = ar.IdArtista group by ar.IdArtista; 

drop view if exists EstatistikakAurkestuPodcasterraTotala;
create view EstatistikakAurkestuPodcasterraTotala as
select ar.IzenArtistikoa as Izena, sum(er.Beti) as Totala, ar.Irudia from Estadistikak er INNER JOIN Audio au on er.IdAudio = au.IdAudio
INNER JOIN Podcast pod on au.IdAudio = pod.IdAudio
INNER JOIN Podcaster po on pod.IdArtista = po.IdArtista
INNER JOIN Artista ar on po.IdArtista = ar.IdArtista group by ar.IdArtista; 