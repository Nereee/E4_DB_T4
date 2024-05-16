drop database if exists Sphea;
create database Sphea collate utf8mb4_general_ci;

use Sphea;

create table Artista(
IdArtista int primary key auto_increment,
IzenArtistikoa varchar(30) not null unique,
Irudia longblob,
Deskripzioa text
);

create table Musikaria (
IdArtista int primary key,
Ezaugarria enum("bakarlaria","taldea") not null,	
foreign key (IdArtista) references Artista(IdArtista)
on delete cascade on update cascade
);

create table Podcaster(
IdArtista int primary key,
foreign key (IdArtista) references Artista(IdArtista)
on delete cascade on update cascade
);

create table Album(
IdAlbum int primary key auto_increment,
Izenburua varchar(50) unique not null,
Urtea date not null,
Generoa varchar(20) not null,
Irudia longblob not null,
IdArtista int not null,
foreign key (IdArtista) references Musikaria(IdArtista)
on delete cascade on update cascade
);

create table Audio(
IdAudio int primary key auto_increment,
Izena varchar(50) not null,
Iraupena time not null,
Irudia longblob not null,
Mota enum("abestia","podcast", "iragarkia") not null
);

create table Podcast(
IdAudio int primary key,
Kolaboratzaileak varchar(50),
IdArtista int not null,
foreign key (IdAudio) references Audio(IdAudio)
on delete cascade on update cascade,
foreign key (IdArtista) references Podcaster(IdArtista)
on delete cascade on update cascade
);

create table Abestia(
IdAudio int primary key,
IdAlbum int,
foreign key (IdAudio) references Audio(IdAudio)
on delete cascade on update cascade,
foreign key (IdAlbum) references Album(IdAlbum)
on delete cascade on update cascade
);


create table EstadistikakEgunean(
IdAudio int auto_increment,
Eguna date,
Entzunaldiak int,
primary key(IdAudio, Eguna),
foreign key (IdAudio) references Audio(IdAudio)
on delete cascade on update cascade
);

create table EstadistikakHilean(
IdAudio int auto_increment,
Hilea date,
Entzunaldiak int,
primary key(IdAudio, Hilea),
foreign key (IdAudio) references Audio(IdAudio)
on delete cascade on update cascade
);

create table EstadistikakUrtean(
IdAudio int auto_increment,
Urtea year,
Entzunaldiak int,
primary key(IdAudio, Urtea),
foreign key (IdAudio) references Audio(IdAudio)
on delete cascade on update cascade
);

create table EstadistikaTotala(
IdAudio int primary key auto_increment,
Entzunaldiak int,
foreign key (IdAudio) references Audio(IdAudio)
on delete cascade on update cascade
);


create table Hizkuntza(
IdHizkuntza enum("ES","EU","EN","FR","DE","CA","GA","AR") primary key,
Deskribapena varchar(20) not null
);

create table Bezeroa(
IdBezeroa int primary key auto_increment,
Izena varchar(20) not null,
Abizena varchar(20) not null,
Erabiltzailea varchar(20) unique not null,
Pasahitza varchar(10) not null,
JaiotzeData date not null,
ErregistroData date, #default current_timestamp on update current_timestamp,
Mota enum("premium","free") default "free",
IdHizkuntza enum("ES","EU","EN","FR","DE","CA","GA","AR"),
foreign key (IdHizkuntza) references Hizkuntza(IdHizkuntza)
ON DELETE set null
);

create table Erreprodukzioak(
IdErre int auto_increment,
IdBezeroa int not null,
IdAudio int not null,
ErreData date not null,
primary key(IdErre, IdBezeroa,IdAudio,ErreData),
foreign key (IdAudio) references Audio(IdAudio)
on delete cascade on update cascade,
foreign key (IdBezeroa) references Bezeroa(IdBezeroa)
on delete cascade on update cascade
);


create table Premium(
IdBezeroa int primary key,
IraungitzeData date not null,
foreign key (IdBezeroa) references Bezeroa(IdBezeroa)
on delete cascade on update cascade
);

create table Playlist(
IdList int primary key auto_increment,
Izenburua varchar(200) not null,
SorreraData date not null,
IdBezeroa int not null,
foreign key (IdBezeroa) references Bezeroa(IdBezeroa)
on delete cascade on update cascade
);

create table PlaylistAbestiak(
IdList int,
IdAudio int,
PData date,
primary key (IdList,IdAudio, PData),
foreign key (IdAudio) references Audio(IdAudio)
on delete cascade on update cascade,
foreign key (IdList) references Playlist(IdList)
on delete cascade on update cascade
);

create table Gustokoak(
IdBezeroa int,
IdAudio int not null,
primary key(IdBezeroa,IdAudio),
foreign key (IdAudio) references Audio(IdAudio)
on delete cascade on update cascade,
foreign key (IdBezeroa) references Bezeroa(IdBezeroa)
on delete cascade on update cascade
);
