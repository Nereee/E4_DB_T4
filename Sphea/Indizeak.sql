/*Indizeak*/

/*Estadistiken gertaerak hobetzeko*/
CREATE INDEX idx_EstadistikaEgun ON EstadistikakEgunean(Eguna);
CREATE INDEX idx_EstadistikaHile ON EstadistikakHilean(Hilea);
CREATE INDEX idx_EstadistikaUrte ON EstadistikakUrtean(Urtea);

