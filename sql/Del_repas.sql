--TP ANOBD
--Script DDL : Data Definition Language

--Permet de sélectionner la base de données à laquelle on souhaite se connecter
USE [master]
GO --Demande à l'interpréteur de requête SQL d'exécuter le lot d'instructions


--On check si la base existe déjà
--IF EXISTS (<reqête>) permet de vérifier si une requête retourne au moins un résultat
--sys.databases permet de lister les bases de données de l'instance
IF EXISTS (SELECT TOP(1) 1 FROM sys.databases WHERE Name = 'DEL_REPAS')
BEGIN
	--On passe la base en mode mono-utilisateur (une seule session possible)
	--WITH ROLLBACK IMMEDIATE permet d'annuler les transactions incomplètes en cours
	--le mode mono-utilisateur déconnecte automatiquement les autres sessions
	ALTER DATABASE [DEL_REPAS] SET
		SINGLE_USER WITH ROLLBACK IMMEDIATE

--Permet de supprimer une base de données
	DROP DATABASE [DEL_REPAS]
END



GO
CREATE DATABASE [DEL_REPAS]
ON PRIMARY --Fichier de données
(
	NAME = DEL_REPAS_dat --Nom logique du fichier
	,FILENAME = '\\fija.local\Groupe\Communs\0.Production\DBaseProd\BackupBdd\REPAS\DEL_REPAS.mdf' --Chemin physique
	,SIZE = 64MB --Taille initiale
	,FILEGROWTH = 64MB --Taille d'agrandissement lorsque la taille max est atteinte
	,MAXSIZE = UNLIMITED --Taille maximum
)
LOG ON --Fichier journal
(
	NAME = DEL_REPAS_log
	,FILENAME = '\\fija.local\Groupe\Communs\0.Production\DBaseProd\BackupBdd\REPAS\DEL_REPAS.ldf' --Chemin physique
	,SIZE = 512MB --Taille initiale
	,FILEGROWTH = 128MB --Taille d'agrandissement lorsque la taille max est atteinte
	,MAXSIZE = UNLIMITED --Taille maximum
)


GO
USE [DEL_REPAS]

GO
CREATE TABLE [DEL_REPAS].[dbo].[Repas]
(
	--<COLUMN_NAME>	<TYPE>			[NULL|NOT NULL]	[IDENTITY]
    [REP_Identifier]	                BIGINT			NOT NULL					IDENTITY, --IDENTITY => incrément automatique
    [REP_Titre]   	                    NVARCHAR(150)	NOT NULL,
	[REP_Description]			        NVARCHAR(500)	NOT NULL,
	[REP_Type]	 	        	        NVARCHAR(50) 	NOT NULL,
    [REP_Categorie]	        	        NVARCHAR(150) 	NOT NULL
)

GO
CREATE TABLE [DEL_REPAS].[dbo].[Menu]
(
	--<COLUMN_NAME>	<TYPE>			[NULL|NOT NULL]	[IDENTITY]
    [MEN_Identifier]	                BIGINT			NOT NULL					IDENTITY, --IDENTITY => incrément automatique
    [MEN_RepasIdentifier]               BIGINT			NOT NULL,
	[MEN_Date]		        	        DATETIME    	NOT NULL,
	[MEN_NombreRepas]	       	        INT 	        NOT NULL,
)

GO
CREATE TABLE [DEL_REPAS].[dbo].[Utilisateur]
(
	--<COLUMN_NAME>	<TYPE>			[NULL|NOT NULL]	[IDENTITY]
    [UTI_Identifier]	                BIGINT			NOT NULL					IDENTITY, --IDENTITY => incrément automatique
    [UTI_Nom]   	                    NVARCHAR(150)	NOT NULL,
	[UTI_Prenom]		    	        NVARCHAR(150)	NOT NULL,
	[UTI_Email]	 	        	        NVARCHAR(500) 	NOT NULL,
    [UTI_Password]	        	        NVARCHAR(500) 	NOT NULL,
    [UTI_Fonction]	        	        NVARCHAR(150) 	NOT NULL
)

GO
CREATE TABLE [DEL_REPAS].[dbo].[Commande]
(
	--<COLUMN_NAME>	<TYPE>			[NULL|NOT NULL]	[IDENTITY]
    [COM_Identifier]	               BIGINT			NOT NULL					IDENTITY, --IDENTITY => incrément automatique
    [COM_MenuIdentifier]	           BIGINT			NOT NULL,
    [COM_UtilisateurIdentifier]        BIGINT      	NOT NULL
)

GO
CREATE TABLE [DEL_REPAS].[dbo].[Droit]
(
	--<COLUMN_NAME>	<TYPE>			[NULL|NOT NULL]	[IDENTITY]
    [DRO_Identifier]	              BIGINT			NOT NULL					IDENTITY, --IDENTITY => incrément automatique
    [DRO_Nom]	                      NVARCHAR(150)   NOT NULL
)

GO
CREATE TABLE [DEL_REPAS].[dbo].[DroitUtilisateur]
(
	--<COLUMN_NAME>	<TYPE>			[NULL|NOT NULL]	[IDENTITY]
    [DROUTI_Identifier]	             BIGINT			NOT NULL					IDENTITY, --IDENTITY => incrément automatique
    [DROUTI_UtilisateurIdentifier]	 BIGINT         NOT NULL,
    [DROUTI_DroitIdentifier]	 BIGINT         NOT NULL
)

-------------------Creation des clés primaires ------------------------
--Ne fontionne pas sql server pre-2017
/*DECLARE @statement NVARCHAR(MAX);

SELECT
	@statement = STRING_AGG(t0.line, CHAR(13))
FROM 
(
	SELECT
		CONCAT
		(
			N'ALTER TABLE '
			,t0.TABLE_NAME
			,N' ADD CONSTRAINT [PK_'
			,t0.TABLE_NAME
			,N'_Identifier] PRIMARY KEY (['
			,t0.COLUMN_NAME
			,'])') AS line
	FROM
		INFORMATION_SCHEMA.COLUMNS AS t0
	WHERE 
		COLUMN_NAME LIKE '%[_]Identifier'
) as t0
PRINT @statement
--PRINT @Statement --Affiche dans la sorie la requête qui va être exécutée
EXEC sp_executesql @statement */
ALTER TABLE Repas ADD CONSTRAINT [PK_Repas_Identifier] PRIMARY KEY ([REP_Identifier])
ALTER TABLE Menu ADD CONSTRAINT [PK_Menu_Identifier] PRIMARY KEY ([MEN_Identifier])
ALTER TABLE Utilisateur ADD CONSTRAINT [PK_Utilisateur_Identifier] PRIMARY KEY ([UTI_Identifier])
ALTER TABLE Commande ADD CONSTRAINT [PK_Commande_Identifier] PRIMARY KEY ([COM_Identifier])
ALTER TABLE Droit ADD CONSTRAINT [PK_Droit_Identifier] PRIMARY KEY ([DRO_Identifier])
ALTER TABLE DroitUtilisateur ADD CONSTRAINT [PK_DroitUtilisateur_Identifier] PRIMARY KEY ([DROUTI_Identifier])
--------------------- Creation des clés étrangere ---------------------
/* DECLARE @statement NVARCHAR(MAX);

SELECT
	@statement = STRING_AGG(t0.line, CHAR(13))
FROM 
(
	SELECT
		CONCAT
		(
			N'ALTER TABLE '
			,t0.TABLE_NAME
			,N' ADD CONSTRAINT [FK_'
			,t0.TABLE_NAME, '_'
			,SUBSTRING(
				t0.COLUMN_NAME, 
				CHARINDEX('_', t0.COLUMN_NAME) + 1,
				CHARINDEX('Identifier',t0.COLUMN_NAME) - CHARINDEX('_', t0.COLUMN_NAME) - 1
			)
			,N'_Identifier'
			,N'_'
			,SUBSTRING(
				t0.COLUMN_NAME, 
				CHARINDEX('_', t0.COLUMN_NAME) + 1,
				CHARINDEX('Identifier',t0.COLUMN_NAME) - CHARINDEX('_', t0.COLUMN_NAME) + LEN('Identifier')
			)
			,N'] FOREIGN KEY (['
			,t0.COLUMN_NAME
			,N']) REFERENCES '
			,SUBSTRING(
				t0.COLUMN_NAME, 
				CHARINDEX('_', t0.COLUMN_NAME) + 1,
				CHARINDEX('Identifier',t0.COLUMN_NAME) - CHARINDEX('_', t0.COLUMN_NAME) - 1
			)
			,N'(['
			,
			(SELECT COLUMN_NAME
			FROM INFORMATION_SCHEMA.COLUMNS
			WHERE TABLE_NAME = 
				SUBSTRING(
					t0.COLUMN_NAME, 
					CHARINDEX('_', t0.COLUMN_NAME) + 1,
					CHARINDEX('Identifier',t0.COLUMN_NAME) - CHARINDEX('_', t0.COLUMN_NAME) - 1
				)
			AND COLUMN_NAME LIKE '%[_]Identifier')
			,']) ON DELETE CASCADE ON UPDATE CASCADE') AS line
	FROM
		INFORMATION_SCHEMA.COLUMNS AS t0
	WHERE 
		COLUMN_NAME LIKE '%[^_]Identifier'
) as t0
PRINT @statement
--PRINT @Statement --Affiche dans la sorie la requête qui va être exécutée
EXEC sp_executesql @statement  */

ALTER TABLE Menu ADD CONSTRAINT [FK_Menu_Repas_Identifier_RepasIdentifier] FOREIGN KEY ([MEN_RepasIdentifier]) REFERENCES Repas([REP_Identifier]) ON DELETE CASCADE ON UPDATE CASCADE
ALTER TABLE Commande ADD CONSTRAINT [FK_Commande_Menu_Identifier_MenuIdentifier] FOREIGN KEY ([COM_MenuIdentifier]) REFERENCES Menu([MEN_Identifier]) ON DELETE CASCADE ON UPDATE CASCADE
ALTER TABLE Commande ADD CONSTRAINT [FK_Commande_Utilisateur_Identifier_UtilisateurIdentifier] FOREIGN KEY ([COM_UtilisateurIdentifier]) REFERENCES Utilisateur([UTI_Identifier]) ON DELETE CASCADE ON UPDATE CASCADE
ALTER TABLE DroitUtilisateur ADD CONSTRAINT [FK_DroitUtilisateur_Droit_Identifier_DroitIdentifier] FOREIGN KEY ([DROUTI_DroitIdentifier]) REFERENCES Droit([DRO_Identifier]) ON DELETE CASCADE ON UPDATE CASCADE
ALTER TABLE DroitUtilisateur ADD CONSTRAINT [FK_DroitUtilisateur_Utilisateur_Identifier_UtilisateurIdentifier] FOREIGN KEY ([DROUTI_UtilisateurIdentifier]) REFERENCES Utilisateur([UTI_Identifier]) ON DELETE CASCADE ON UPDATE CASCADE
-----------------CONSTRAINT UNIQUE--------------------
GO ---> AffaireMatiere ([AFFMAT_AffaireIdentifier], [AFFMAT_MatiereIdentifier])
ALTER TABLE DroitUtilisateur
ADD CONSTRAINT [UK_DroitUtilisateur_DROUTI_UtilisateurIdentifier_DROUTI_DroitIdentifier]
	UNIQUE  ([DROUTI_UtilisateurIdentifier], [DROUTI_DroitIdentifier])


