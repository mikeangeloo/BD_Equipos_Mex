/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2014                    */
/* Created on:     05/10/2015 11:24:35 p. m.                    */
/*==============================================================*/
create database Equipos_Mexico
go
use Equipos_Mexico
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('DIRECTOR') and o.name = 'FK_DIRECTOR_ASIGANDO_EQUIPO')
alter table DIRECTOR
   drop constraint FK_DIRECTOR_ASIGANDO_EQUIPO
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('JUGADOR') and o.name = 'FK_JUGADOR_RELACION_PADRE')
alter table JUGADOR
   drop constraint FK_JUGADOR_RELACION_PADRE
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('JUGADOR') and o.name = 'FK_JUGADOR_TIENE_EQUIPO')
alter table JUGADOR
   drop constraint FK_JUGADOR_TIENE_EQUIPO
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('DIRECTOR')
            and   name  = 'ASIGANDO_FK'
            and   indid > 0
            and   indid < 255)
   drop index DIRECTOR.ASIGANDO_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('DIRECTOR')
            and   type = 'U')
   drop table DIRECTOR
go

if exists (select 1
            from  sysobjects
           where  id = object_id('EQUIPO')
            and   type = 'U')
   drop table EQUIPO
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('JUGADOR')
            and   name  = 'RELACION_FK'
            and   indid > 0
            and   indid < 255)
   drop index JUGADOR.RELACION_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('JUGADOR')
            and   name  = 'TIENE_FK'
            and   indid > 0
            and   indid < 255)
   drop index JUGADOR.TIENE_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('JUGADOR')
            and   type = 'U')
   drop table JUGADOR
go

if exists (select 1
            from  sysobjects
           where  id = object_id('PADRE')
            and   type = 'U')
   drop table PADRE
go

/*==============================================================*/
/* Table: DIRECTOR                                              */
/*==============================================================*/
create table DIRECTOR (
   ID_DIRECTOR          int                  not null,
   ID_EQUIPO            int                  null,
   NOMBREDIRECTOR       varchar(25)          null,
   APELLIDOSDIRECTOR    varchar(255)         null,
   TELEFONODIRECTOR     varchar(15)          null,
   constraint PK_DIRECTOR primary key (ID_DIRECTOR)
)
go

/*==============================================================*/
/* Index: ASIGANDO_FK                                           */
/*==============================================================*/




create nonclustered index ASIGANDO_FK on DIRECTOR (ID_EQUIPO ASC)
go

/*==============================================================*/
/* Table: EQUIPO                                                */
/*==============================================================*/
create table EQUIPO (
   ID_EQUIPO            int                  not null,
   NOMBREEQUIPO         varchar(30)          null,
   COLOR                varchar(30)          null,
   constraint PK_EQUIPO primary key (ID_EQUIPO)
)
go

/*==============================================================*/
/* Table: JUGADOR                                               */
/*==============================================================*/
create table JUGADOR (
   ID_JUGADOR           int                  not null,
   ID_PADRE             int                  null,
   ID_EQUIPO            int                  null,
   NOMBREJUGADOR        varchar(25)          null,
   APELLIDOSJUGADOR     varchar(255)         null,
   EDAD                 int                  null,
   constraint PK_JUGADOR primary key (ID_JUGADOR)
)
go

/*==============================================================*/
/* Index: TIENE_FK                                              */
/*==============================================================*/




create nonclustered index TIENE_FK on JUGADOR (ID_EQUIPO ASC)
go

/*==============================================================*/
/* Index: RELACION_FK                                           */
/*==============================================================*/




create nonclustered index RELACION_FK on JUGADOR (ID_PADRE ASC)
go

/*==============================================================*/
/* Table: PADRE                                                 */
/*==============================================================*/
create table PADRE (
   ID_PADRE             int                  not null,
   APELLIDOSPADRE       varchar(255)         null,
   NOMBREPADRE          varchar(25)          null,
   DIRECCION            varchar(255)         null,
   TELEFONOPADRE        varchar(15)          null,
   constraint PK_PADRE primary key (ID_PADRE)
)
go

alter table DIRECTOR
   add constraint FK_DIRECTOR_ASIGANDO_EQUIPO foreign key (ID_EQUIPO)
      references EQUIPO (ID_EQUIPO)
         on update cascade on delete set null
go

alter table JUGADOR
   add constraint FK_JUGADOR_RELACION_PADRE foreign key (ID_PADRE)
      references PADRE (ID_PADRE)
         on update cascade on delete set null
go

alter table JUGADOR
   add constraint FK_JUGADOR_TIENE_EQUIPO foreign key (ID_EQUIPO)
      references EQUIPO (ID_EQUIPO)
         on update cascade on delete set null
go

