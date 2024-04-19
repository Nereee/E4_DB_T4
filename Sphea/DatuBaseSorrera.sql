drop database if exists Sphea;
create database Sphea collate utf8mb4_general_ci;

use Sphea;

create table Artista(
IdArtista int primary key auto_increment,
IzenArtistikoa varchar(30) not null unique,
Irudia blob,
Deskripzioa varchar(100)
);

create table Musikaria (
IdArtista int primary key,
Ezaugarria enum("bakarlaria","taldea") not null,	
foreign key (IdArtista) references Artista(IdArtista)
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
Irudia blob not null,
IdArtista int not null,
foreign key (IdArtista) references Musikaria(IdArtista)
on delete cascade on update cascade
);

create table Audio(
IdAudio int primary key auto_increment,
Izena varchar(20) not null,
Iraupena time not null,
Irudia blob not null,
Mota enum("abestia","podcast") not null
);

create table Podcast(
IdAudio int primary key,
Kolaboratzaileak varchar(50),
IdArtista int not null,
foreign key (IdAudio) references Audio(IdAudio),
foreign key (IdArtista) references Podcaster(IdArtista)
on delete cascade on update cascade
);

create table Abestia(
IdAudio int primary key,
IdAlbum int,
foreign key (IdAudio) references Audio(IdAudio),
foreign key (IdAlbum) references Album(IdAlbum)
on delete cascade on update cascade
);


create table Estadistikak(
IdAudio int primary key auto_increment,
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
on delete cascade on update cascade
);

create table Erreprodukzioak(
IdBezeroa int,
IdAudio int not null,
ErreData date not null,
primary key(IdBezeroa,IdAudio,ErreData),
foreign key (IdAudio) references Audio(IdAudio),
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
Izenburua varchar(20) not null,
SorreraData date not null,
IdBezeroa int not null,
foreign key (IdBezeroa) references Bezeroa(IdBezeroa)
on delete cascade on update cascade
);

create table PlaylistAbestiak(
IdList int,
IdAudio int,
PData date,
primary key (IdList,IdAudio),
foreign key (IdAudio) references Audio(IdAudio),
foreign key (IdList) references Playlist(IdList)
on delete cascade on update cascade
);

create table Gustokoak(
IdBezeroa int,
IdAudio int not null,
primary key(IdBezeroa,IdAudio),
foreign key (IdAudio) references Audio(IdAudio),
foreign key (IdBezeroa) references Bezeroa(IdBezeroa)
on delete cascade on update cascade
);
