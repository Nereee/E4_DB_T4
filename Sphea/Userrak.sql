
#AdminRol
create role if not exists adminRol;
grant all privileges  on Sphea.* to adminRol;
grant grant option on Sphea.* to adminRol;

#Admin
create user "admin"@"%" identified by "headmin";
grant adminRol to "admin"@"%";

#ErabiltzaileRol
create role if not exists erabiltzaileRol;
grant insert,update,select on Sphea.* to erabiltzaileRol;
grant delete on Sphea.Gustokoak to erabiltzaileRol;
grant delete on Sphea.Playlist  to erabiltzaileRol;
grant delete on Sphea.PlaylistAbestiak  to erabiltzaileRol;

#Erabiltzaile
create user "erabiltzaile"@"%" identified by "4321";
grant erabiltzaileRol to "erabiltzaile"@"%";

#AnalistaRol
create role if not exists analistaRol;
grant select on Sphea.* to analistaRol;

#Analistak
create user "analista1"@"%" identified by "123";
create user "analista2"@"%" identified by "123";
grant analistaRol to "analista1"@"%","analista2"@"%";

#LangileaRol
create role if not exists langileaRol;
grant select on Sphea.* to langileaRol;
grant update on Sphea.Premium to langileaRol;

#Langilea
create user "langilea"@"%" identified by "321";
grant langileaRol to  "langilea"@"%";

#DepartBuruRol
create role if not exists DepartBuruRol;
grant select on Sphea.Estadistikak to DepartBuruRol;
grant update on Sphea.Premium to DepartBuruRol;


#DepartBuru
create user "departBuru"@"%" identified by "1234";
grant DepartBuruRol to "departBuru"@"%";










#