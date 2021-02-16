USE BDD_ENCHERES
Go
CREATE OR ALTER PROCEDURE MY_PROCEDURE_ARTICLES
as
BEGIN
	UPDATE articles set is_finish = 1, id_acheteur = tt.id_winner from
	(select a.id, tmp.id_user as id_winner,tmp.montant FROM articles a 
	left outer JOIN (select id_article, max(montant) as montant, id_user from ENCHERES group by id_article, id_user) as tmp on tmp.id_article = a.id
	WHERE is_finish=0 AND is_actif=1 AND date_fin<DATEDIFF(s, '1970-01-01 00:00:00', GETDATE())) as tt
	WHERE articles.id = tt.id   
END

DROP TABLE IF EXISTS ENCHERES;
DROP TABLE IF EXISTS PHOTOS;
DROP TABLE IF EXISTS ARTICLES;
DROP TABLE IF EXISTS NOTATIONS;
DROP TABLE IF EXISTS USERS;
DROP TABLE IF EXISTS TYPE_USER;

DROP TABLE IF EXISTS CATEGORIES;

CREATE TABLE CATEGORIES (
    id   INTEGER NOT NULL CONSTRAINT Pk_categorie PRIMARY KEY IDENTITY (1,1),
    libelle        VARCHAR(30) NOT NULL
)

CREATE TABLE TYPE_USER(
	id INTEGER NOT NULL CONSTRAINT Pk_type PRIMARY KEY IDENTITY(1,1),
	libelle VARCHAR(50) NOT NULL
)


CREATE TABLE USERS (
    id   INTEGER NOT NULL CONSTRAINT Pk_utilisateurs PRIMARY KEY IDENTITY (1,1),
    pseudo           VARCHAR(50) NOT NULL,
    name              VARCHAR(50) NOT NULL,
    lastname           VARCHAR(50) NOT NULL,
    email            VARCHAR(50) NOT NULL,
    phone        VARCHAR(20),
	date 			date NOT NULL DEFAULT GETDATE(),
    street              VARCHAR(50) NOT NULL,
    zip      VARCHAR(20) NOT NULL,
    city            VARCHAR(50) NOT NULL,
    password     VARCHAR(10) NOT NULL,
    credit           FLOAT DEFAULT 0,
	note FLOAT NOT NULL DEFAULT 5.0,
    id_type_user INTEGER DEFAULT 2 CONSTRAINT Fk_users_type FOREIGN KEY REFERENCES TYPE_USER(id),
    latitude FLOAT NULL ,
    longitude FLOAT null,
	is_actif 			bit DEFAULT 1, /* permet de bloquer ou supprimer un utilisateurs */
	is_delete BIT DEFAULT 0
)
CREATE TABLE NOTATIONS (

id INTEGER CONSTRAINT Pk_notations PRIMARY KEY IDENTITY(1,1),
id_user INTEGER NOT NULL CONSTRAINT Fk_notations_user FOREIGN KEY REFERENCES USERS(id),
id_noteur INTEGER NOT NULL CONSTRAINT Fk_notations_noteur FOREIGN KEY REFERENCES USERS(id),
note INTEGER NOT NULL 

)

CREATE TABLE ARTICLES (
    id                    INTEGER NOT NULL CONSTRAINT Pk_articles PRIMARY KEY IDENTITY (1,1),
    name                   VARCHAR(50) NOT NULL,
    title VARCHAR(50) NOT NULL,
    description                   VARCHAR(500) NOT NULL,
	date_debut           	INTEGER NOT NULL,/* format UNIX */
    date_fin            	INTEGER NOT NULL, /* format UNIX */
    prix_initial                  FLOAT NOT NULL,
    prix_vente                    FLOAT DEFAULT 0,
    
    id_acheteur INTEGER DEFAULT NULL CONSTRAINT Fk_articles_acheteur FOREIGN KEY REFERENCES USERS(id),
    retire BIT DEFAULT 0,
    id_user                		INTEGER  NOT NULL CONSTRAINT Fk_articles_user FOREIGN KEY REFERENCES USERS(id),
    id_categorie                  INTEGER  DEFAULT 1 CONSTRAINT Fk_articles_categorie FOREIGN KEY REFERENCES CATEGORIES(id) ON DELETE SET DEFAULT ,
    street              VARCHAR(50) NOT NULL,
    zip      VARCHAR(20) NOT NULL,
    city            VARCHAR(50) NOT NULL, 
    latitude FLOAT NULL ,
    longitude FLOAT null,
    nb_photo Integer NOT NULL DEFAULT 1,
    is_finish BIT DEFAULT 0,
	is_actif BIT DEFAULT 1	 /* pour activer ou désactiver un article comprométant */
)



CREATE TABLE PHOTOS(

	id INTEGER NOT NULL CONSTRAINT Pk_photos PRIMARY KEY IDENTITY(1,1),
	id_article INTEGER NOT NULL CONSTRAINT Fk_photos_article REFERENCES ARTICLES(id) ON DELETE CASCADE,
	url VARCHAR(250) NOT NULL,
	extension VARCHAR(50) NOT NULL,
	name VARCHAR(250) NOT NULL
)


CREATE TABLE ENCHERES(	
	id  INTEGER NOT NULL CONSTRAINT Pk_enchere PRIMARY KEY IDENTITY(1,1),
	date INTEGER NOT NULL, /* format UNIX */
	montant FLOAT NOT NULL,
	id_article INTEGER NOT NULL CONSTRAINT Fk_encheres_articles FOREIGN KEY REFERENCES ARTICLES(id) ON DELETE CASCADE,
	id_user INTEGER NOT NULL CONSTRAINT Fk_encheres_utilisateurs FOREIGN KEY REFERENCES USERS(id)
 )
INSERT INTO TYPE_USER(libelle) VALUES('administrateur'),('utilisateur');

INSERT INTO USERS (pseudo, name,lastname,email,phone,street,zip,city,password,id_type_user)
VALUES ('binouz_admin','albin','LEPESSEC','albin_admin@yahoo.fr','0695876924','456 rue du bois bernard','74500','Publier','123456789',1),
('binouz_user','albin','LEPESSEC','albin_user@yahoo.fr','0695876924','456 rue du bois bernard','74500','Publier','123456789',2),
('sebdiver78_admin','MASSERA','sebastien','sebastien.massera2020@campus-eni.fr','0612345678','10 rue de la paix','75000','MONOPOLY','azerty',1),
('sebdiver78_user','MASSERA','sebastien','sebastien.massera2020@campus-eni.fr','0612345678','10 rue de la paix','75000','PARIS','MONOPOLY',2),
('anthony_admin','DI DIO','anthony','anthony_admin@yahoo.fr','0612345678','10 rue de la paix','75000','MONOPOLY','azerty',1),
('anthony_admin','DI DIO','anthony','anthony_user@yahoo.fr','0612345678','10 rue de la paix','75000','PARIS','MONOPOLY',2);



INSERT INTO CATEGORIES (libelle) 
VALUES('sans catégorie'),
('Véhicule'),
('Immobilier');



	
