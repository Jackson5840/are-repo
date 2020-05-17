--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE nmo;
ALTER ROLE nmo WITH NOSUPERUSER INHERIT NOCREATEROLE CREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'md52d6c58ccc2bde57f47c76b1f16f3a025';
CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS;
CREATE ROLE webuser;
ALTER ROLE webuser WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'md56b83a94773187d17fdce4a016b3e7418';






--
-- Databases
--

--
-- Database "template1" dump
--

\connect template1

--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2 (Ubuntu 12.2-4)
-- Dumped by pg_dump version 12.2 (Ubuntu 12.2-4)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- PostgreSQL database dump complete
--

--
-- Database "nmo" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2 (Ubuntu 12.2-4)
-- Dumped by pg_dump version 12.2 (Ubuntu 12.2-4)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: nmo; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE nmo WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';


ALTER DATABASE nmo OWNER TO postgres;

\connect nmo

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: ltree; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS ltree WITH SCHEMA public;


--
-- Name: EXTENSION ltree; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION ltree IS 'data type for hierarchical tree-like structures';


--
-- Name: age_scale_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.age_scale_type AS ENUM (
    'D',
    'M',
    'Y',
    'Not reported'
);


ALTER TYPE public.age_scale_type OWNER TO postgres;

--
-- Name: age_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.age_type AS ENUM (
    'adult',
    'aged',
    'embryonic',
    'fetus',
    'infant',
    'larval',
    'neonatal',
    'not reported',
    'old',
    'tadpole',
    'young',
    'young adult'
);


ALTER TYPE public.age_type OWNER TO postgres;

--
-- Name: completeness_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.completeness_type AS ENUM (
    'Incomplete',
    'Moderate',
    'Complete'
);


ALTER TYPE public.completeness_type OWNER TO postgres;

--
-- Name: domain_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.domain_type AS ENUM (
    'AP',
    'BS',
    'AX',
    'NEU',
    'PR'
);


ALTER TYPE public.domain_type OWNER TO postgres;

--
-- Name: exportstatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.exportstatus AS ENUM (
    'ready',
    'success',
    'warning',
    'error'
);


ALTER TYPE public.exportstatus OWNER TO postgres;

--
-- Name: gender_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.gender_type AS ENUM (
    'F',
    'H',
    'M',
    'M/F',
    'NR',
    'Not reported',
    'Not applicable'
);


ALTER TYPE public.gender_type OWNER TO postgres;

--
-- Name: objective_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.objective_type AS ENUM (
    'dry',
    'electron microscopy',
    'glycerin',
    'multiple',
    'Not reported',
    'oil',
    'water',
    'water or oil'
);


ALTER TYPE public.objective_type OWNER TO postgres;

--
-- Name: protocol_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.protocol_type AS ENUM (
    'culture',
    'ex vivo',
    'in ovo',
    'in utero',
    'in vitro',
    'in vivo',
    'Not reported'
);


ALTER TYPE public.protocol_type OWNER TO postgres;

--
-- Name: shrinkage_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.shrinkage_type AS ENUM (
    'reported and corrected',
    'reported and not corrected',
    'Not reported',
    'not applicable',
    'Not applicable'
);


ALTER TYPE public.shrinkage_type OWNER TO postgres;

--
-- Name: slicing_direction_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.slicing_direction_type AS ENUM (
    'coronal',
    'cross section',
    'custom',
    'flattened',
    'horizontal',
    'multiple',
    'near-coronal',
    'not applicable',
    'Not reported',
    'oblique coronal',
    'oblique horizontal',
    'parallel to the cortical surface',
    'parasagittal',
    'perpendicular to cortical layers',
    'perpendicular to the long axis',
    'sagittal',
    'semi-coronal',
    'semi-horizontal',
    'tangential',
    'thalamocortical',
    'transverse',
    'whole mount',
    'Not applicable',
    'Sagittal'
);


ALTER TYPE public.slicing_direction_type OWNER TO postgres;

--
-- Name: status_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.status_type AS ENUM (
    'ready',
    'read',
    'error',
    'ingested',
    'partial'
);


ALTER TYPE public.status_type OWNER TO postgres;

--
-- Name: ingest_celltype(text[], character varying); Type: PROCEDURE; Schema: public; Owner: nmo
--

CREATE PROCEDURE public.ingest_celltype(celltype_names text[], a_celltype_path character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
DECLARE
        celltypes character varying ARRAY;
        item character varying;
        nAncestors int;
        ndbancestors int;
        a_celltype_id int;
        arrSize int;
        counter int;
        ancPath character varying;
BEGIN
--      inserts a celltype and checks if it and its parents exist. If not parents exist, they are created. 
--      If not celltype exists, it is created. 
--      Full names are taken from array, matching the place in the path. 
--      A check is made if path size is matching the array with full names
	
        celltypes = regexp_split_to_array(a_celltype_path, '\.');
        nAncestors = array_length(celltypes, 1);
        arrSize = array_length(celltype_names, 1);
        IF nAncestors != arrSize THEN
                RAISE EXCEPTION 'Size of array and items indicated by path not matching'
                        USING hint = 'Please check input variables';
        END IF;
        
        select count(*) into ndbancestors from celltype  where text2ltree(a_celltype_path) <@ path;
        -- check if ancestors in array equals size of ancestors in path
        -- if not, missing ancestors will be inserted as needed.
        -- if so, nothing needs to be done.
        IF ndbancestors != nAncestors THEN
                -- loop over all ancestors and the item itself in path to check if they are there.
                ancPath = '';
                for counter in 1..nAncestors
                LOOP   
                       IF counter = 1 THEN
                        ancPath = celltypes[counter];
                       ELSE
                        ancPath = ancPath || '.' || celltypes[counter];
                       END IF;
                       Select celltype.id into a_celltype_id from celltype where celltype.path ~ lquery(ancPath);
	               IF a_celltype_id isnull THEN
	                       insert into celltype(name,path) values (REPLACE(celltype_names[counter],'''',''),text2ltree(ancPath));
	               END IF;
                        
                END LOOP;
        
	END IF;
	
	
	

COMMIT;
END;
 END;
$$;


ALTER PROCEDURE public.ingest_celltype(celltype_names text[], a_celltype_path character varying) OWNER TO nmo;

--
-- Name: ingest_data(character varying, character varying, character varying, character varying, character varying, public.age_type, integer, integer, date, date, character varying, public.objective_type, character varying, public.protocol_type, public.slicing_direction_type, character varying, character varying, character varying, boolean, public.shrinkage_type, public.age_scale_type, public.gender_type, double precision, double precision, double precision, double precision, text, integer, character varying, integer, integer, character varying, character varying, integer); Type: PROCEDURE; Schema: public; Owner: nmo
--

CREATE PROCEDURE public.ingest_data(a_neuron_name character varying, archive_name character varying, archive_url character varying, a_species character varying, a_expcond character varying, a_age public.age_type, a_region_id integer, a_celltype_id integer, a_depositiondate date, a_uploaddate date, magnification character varying, objective public.objective_type, a_originalformat character varying, protocol public.protocol_type, a_slicing_direction public.slicing_direction_type, slicingthickness character varying, a_staining character varying, a_strain character varying, has_soma boolean, shrinkage public.shrinkage_type, age_scale public.age_scale_type, gender public.gender_type, max_age double precision, min_age double precision, min_weight double precision, max_weight double precision, note text, a_pmid integer, a_doi character varying, a_summary_meas_id integer, a_shrinkagevalue_id integer, a_reconstruction_software character varying, a_url_reference character varying, INOUT a_neuron_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
   DECLARE
        a_archive_id int;
	a_expcond_id int;
	a_originalformat_id int;
	a_publication_id int;
	a_staining_id int;
	a_strain_id int;
	a_species_id int;
BEGIN
	
	Select archive.id into a_archive_id from archive where archive.name = archive_name;
	IF a_archive_id isnull THEN
		INSERT INTO archive (name, url) VALUES (archive_name, archive_url);
		Select archive.id into a_archive_id from archive where archive.name = archive_name;
	END IF;
	
	select species.id into a_species_id from species where species.name = a_species;
	IF a_species_id isnull THEN
		INSERT INTO species (name) VALUES (a_species);
		Select species.id into a_species_id from species where species.name = a_species;
	END IF;
	

	Select expcond.id into a_expcond_id from expcond where expcond.name = a_expcond;
	IF a_expcond_id isnull THEN
		INSERT INTO expcond (name) VALUES (a_expcond);
		Select expcond.id into a_expcond_id from expcond where expcond.name = a_expcond;
	END IF;

	Select originalformat.id into a_originalformat_id from originalformat where originalformat.name = a_originalformat;
	IF a_originalformat_id isnull THEN
		INSERT INTO originalformat (name) VALUES (a_originalformat);
		Select originalformat.id into a_originalformat_id from originalformat where originalformat.name = a_originalformat;
	END IF;
	
	Select staining.id into a_staining_id from staining where staining.name = a_staining;
	IF a_staining_id isnull THEN
		INSERT INTO staining (name) VALUES (a_staining);
		Select staining.id into a_staining_id from staining where staining.name = a_staining;
	END IF;
	
	Select strain.id into a_strain_id from strain where strain.name = a_strain;
	IF a_strain_id isnull THEN
		INSERT INTO strain (name,species_id) VALUES (a_strain,a_species_id);
		Select strain.id into a_strain_id from strain where strain.name = a_strain;
	END IF;
	
	Select publication.id into a_publication_id from publication where publication.pmid = a_pmid OR publication.doi = a_doi;
	IF a_publication_id isnull THEN
		INSERT INTO publication (pmid,doi) VALUES (a_pmid,a_doi);
		Select publication.id into a_publication_id from publication where publication.pmid = a_pmid;
	END IF;
	
--	Select region.id into a_region_id from region where region.path ~ lquery(a_region);
--	IF a_region_id isnull THEN
--		RAISE EXCEPTION 'Nonexistent region path --> %', a_region
 --                       USING HINT = 'Please check region path';
--	END IF;
	
--	Select celltype.id into a_celltype_id from celltype where celltype.path ~ lquery(a_celltype);
--	IF a_celltype_id isnull THEN
--		RAISE EXCEPTION 'Nonexistent celltype path --> %', a_celltype
 --                       USING HINT = 'Please check celltype path';
--	END IF;
	
	
	INSERT INTO neuron(name,archive_id,age,region_id,celltype_id,depositiondate,uploaddate,publication_id,expcond_id,magnification,summary_meas_id,objective,originalformat_id,protocol,slicing_direction,slicingthickness,staining_id,shrinkage,shrinkagevalue_id,age_scale,gender,max_age,min_age,min_weight,max_weight,note,url_reference, strain_id, reconstruction) 
	VALUES(a_neuron_name, a_archive_id,
		a_age,a_region_id, a_celltype_id, a_depositiondate, a_uploaddate, a_publication_id, a_expcond_id, magnification, a_summary_meas_id, objective, a_originalformat_id, protocol, a_slicing_direction, slicingthickness, a_staining_id, shrinkage, a_shrinkagevalue_id, age_scale, gender, max_age,min_age,min_weight,max_weight,note, a_url_reference, a_strain_id, a_reconstruction_software);
        select neuron.id into a_neuron_id from neuron where neuron.name = a_neuron_name;
        UPDATE ingestion set status='read',ingestion_date = a_uploaddate, message='Read from source' WHERE ingestion.neuron_name = a_neuron_name;
        --insert into export (neuron_id,exportdate,status) VALUES (a_neuron_id,(SELECT CURRENT_DATE),'ready');

COMMIT;
END;
 END;
$$;


ALTER PROCEDURE public.ingest_data(a_neuron_name character varying, archive_name character varying, archive_url character varying, a_species character varying, a_expcond character varying, a_age public.age_type, a_region_id integer, a_celltype_id integer, a_depositiondate date, a_uploaddate date, magnification character varying, objective public.objective_type, a_originalformat character varying, protocol public.protocol_type, a_slicing_direction public.slicing_direction_type, slicingthickness character varying, a_staining character varying, a_strain character varying, has_soma boolean, shrinkage public.shrinkage_type, age_scale public.age_scale_type, gender public.gender_type, max_age double precision, min_age double precision, min_weight double precision, max_weight double precision, note text, a_pmid integer, a_doi character varying, a_summary_meas_id integer, a_shrinkagevalue_id integer, a_reconstruction_software character varying, a_url_reference character varying, INOUT a_neuron_id integer) OWNER TO nmo;

--
-- Name: ingest_region(text[], character varying); Type: PROCEDURE; Schema: public; Owner: nmo
--

CREATE PROCEDURE public.ingest_region(reg_names text[], a_region_path character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
DECLARE
        regions character varying ARRAY;
        item character varying;
        nAncestors int;
        ndbancestors int;
        a_region_id int;
        arrSize int;
        counter int;
        ancPath character varying;
BEGIN
--      inserts a region and checks if it and its parents exist. If not parents exist, they are created. 
--      If not region exists, it is created. 
--      Full names are taken from array, matching the place in the path. 
--      A check is made if path size is matching the array with full names
	
        regions = regexp_split_to_array(a_region_path, '\.');
        nAncestors = array_length(regions, 1);
        arrSize = array_length(reg_names, 1);
        IF nAncestors != arrSize THEN
                RAISE EXCEPTION 'Size of array and items indicated by path not matching'
                        USING hint = 'Please check input variables';
        END IF;
        
        select count(*) into ndbancestors from region  where text2ltree(a_region_path) <@ path;
        -- check if ancestors in array equals size of ancestors in path
        -- if not, missing ancestors will be inserted as needed.
        -- if so, nothing needs to be done.
        IF ndbancestors != nAncestors THEN
                -- loop over all ancestors and the item itself in path to check if they are there.
                ancPath = '';
                for counter in 1..nAncestors
                LOOP   
                       IF counter = 1 THEN
                        ancPath = regions[counter];
                       ELSE
                        ancPath = ancPath || '.' || regions[counter];
                       END IF;
                       Select region.id into a_region_id from region where region.path ~ lquery(ancPath);
	               IF a_region_id isnull THEN
	                       insert into region(name,path) values (REPLACE(reg_names[counter],'''',''),text2ltree(ancPath));
	               END IF;
                        
                END LOOP;
        
	END IF;
	
	
	

COMMIT;
END;
 END;
$$;


ALTER PROCEDURE public.ingest_region(reg_names text[], a_region_path character varying) OWNER TO nmo;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: archive; Type: TABLE; Schema: public; Owner: nmo
--

CREATE TABLE public.archive (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    url character varying(1024)
);


ALTER TABLE public.archive OWNER TO nmo;

--
-- Name: archive_id_seq; Type: SEQUENCE; Schema: public; Owner: nmo
--

ALTER TABLE public.archive ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.archive_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: celltype; Type: TABLE; Schema: public; Owner: nmo
--

CREATE TABLE public.celltype (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    path public.ltree
);


ALTER TABLE public.celltype OWNER TO nmo;

--
-- Name: celltype_id_seq; Type: SEQUENCE; Schema: public; Owner: nmo
--

ALTER TABLE public.celltype ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.celltype_id_seq
    START WITH 3
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: expcond; Type: TABLE; Schema: public; Owner: nmo
--

CREATE TABLE public.expcond (
    id integer NOT NULL,
    name character varying(1024) NOT NULL
);


ALTER TABLE public.expcond OWNER TO nmo;

--
-- Name: expcond_id_seq; Type: SEQUENCE; Schema: public; Owner: nmo
--

ALTER TABLE public.expcond ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.expcond_id_seq
    START WITH 3
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: export; Type: TABLE; Schema: public; Owner: nmo
--

CREATE TABLE public.export (
    id integer NOT NULL,
    neuron_id integer,
    old_neuronid integer,
    exportdate date,
    status public.exportstatus,
    message text
);


ALTER TABLE public.export OWNER TO nmo;

--
-- Name: export_id_seq; Type: SEQUENCE; Schema: public; Owner: nmo
--

ALTER TABLE public.export ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.export_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: ingested_archives; Type: TABLE; Schema: public; Owner: nmo
--

CREATE TABLE public.ingested_archives (
    id integer NOT NULL,
    name character varying(255),
    date date,
    message text,
    status public.status_type
);


ALTER TABLE public.ingested_archives OWNER TO nmo;

--
-- Name: ingested_archives_id_seq; Type: SEQUENCE; Schema: public; Owner: nmo
--

ALTER TABLE public.ingested_archives ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.ingested_archives_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: ingestion; Type: TABLE; Schema: public; Owner: nmo
--

CREATE TABLE public.ingestion (
    id integer NOT NULL,
    neuron_id integer,
    ingestion_date date,
    message text,
    neuron_name character varying(255),
    archive character varying(255),
    status public.status_type
);


ALTER TABLE public.ingestion OWNER TO nmo;

--
-- Name: ingestion_id_seq; Type: SEQUENCE; Schema: public; Owner: nmo
--

ALTER TABLE public.ingestion ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.ingestion_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: measurements; Type: TABLE; Schema: public; Owner: nmo
--

CREATE TABLE public.measurements (
    id integer NOT NULL,
    soma_surface double precision,
    n_stems integer,
    n_bifs integer,
    n_branch integer,
    width double precision,
    height double precision,
    depth double precision,
    diameter double precision,
    length double precision,
    surface double precision,
    volume double precision,
    eucdistance double precision,
    pathdistance double precision,
    branch_order double precision,
    contraction double precision,
    fragmentation double precision,
    partition_asymmetry double precision,
    pk_classic double precision,
    bif_ampl_local double precision,
    bif_ampl_remote double precision,
    fractal_dim double precision
);


ALTER TABLE public.measurements OWNER TO nmo;

--
-- Name: measurements_id_seq; Type: SEQUENCE; Schema: public; Owner: nmo
--

ALTER TABLE public.measurements ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.measurements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: neuron; Type: TABLE; Schema: public; Owner: nmo
--

CREATE TABLE public.neuron (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    archive_id integer NOT NULL,
    age public.age_type,
    region_id integer NOT NULL,
    celltype_id integer NOT NULL,
    depositiondate date NOT NULL,
    uploaddate date NOT NULL,
    publication_id integer NOT NULL,
    expcond_id integer,
    magnification character varying(255),
    summary_meas_id integer,
    objective public.objective_type,
    originalformat_id integer,
    slicing_direction public.slicing_direction_type,
    slicingthickness character varying,
    has_soma boolean,
    shrinkage public.shrinkage_type,
    shrinkagevalue_id integer,
    age_scale public.age_scale_type,
    gender public.gender_type,
    max_age double precision,
    min_age double precision,
    min_weight double precision,
    max_weight double precision,
    note text,
    url_reference text,
    staining_id integer,
    protocol public.protocol_type,
    oldid integer,
    strain_id integer,
    reconstruction character varying
);


ALTER TABLE public.neuron OWNER TO nmo;

--
-- Name: neuron_id_seq; Type: SEQUENCE; Schema: public; Owner: nmo
--

ALTER TABLE public.neuron ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.neuron_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: neuron_segment; Type: TABLE; Schema: public; Owner: nmo
--

CREATE TABLE public.neuron_segment (
    id integer NOT NULL,
    radius integer NOT NULL,
    x double precision NOT NULL,
    y double precision NOT NULL,
    z double precision NOT NULL,
    type integer NOT NULL,
    path public.ltree,
    neuron_id integer
);


ALTER TABLE public.neuron_segment OWNER TO nmo;

--
-- Name: neuron_segment_id_seq; Type: SEQUENCE; Schema: public; Owner: nmo
--

ALTER TABLE public.neuron_segment ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.neuron_segment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: neuron_structure; Type: TABLE; Schema: public; Owner: nmo
--

CREATE TABLE public.neuron_structure (
    id integer NOT NULL,
    neuron_id integer NOT NULL,
    measurements_id integer,
    completeness public.completeness_type NOT NULL,
    domain public.domain_type NOT NULL,
    morph_attributes smallint
);


ALTER TABLE public.neuron_structure OWNER TO nmo;

--
-- Name: neuron_structure_id_seq; Type: SEQUENCE; Schema: public; Owner: nmo
--

ALTER TABLE public.neuron_structure ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.neuron_structure_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: originalformat; Type: TABLE; Schema: public; Owner: nmo
--

CREATE TABLE public.originalformat (
    id integer NOT NULL,
    name character varying(255),
    format_type integer
);


ALTER TABLE public.originalformat OWNER TO nmo;

--
-- Name: originalformat_id_seq; Type: SEQUENCE; Schema: public; Owner: nmo
--

ALTER TABLE public.originalformat ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.originalformat_id_seq
    START WITH 2
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: publication; Type: TABLE; Schema: public; Owner: nmo
--

CREATE TABLE public.publication (
    id integer NOT NULL,
    pmid integer,
    doi character varying(255),
    year smallint,
    journal character varying(255),
    title character varying(255),
    first_author character varying(255),
    last_author character varying(255),
    species_id integer,
    ocdate date,
    specific_details character varying(255),
    related_page integer,
    data_status character varying(255),
    literature_id character varying(128),
    abstract text,
    url character varying(4096)
);


ALTER TABLE public.publication OWNER TO nmo;

--
-- Name: publication_id_seq; Type: SEQUENCE; Schema: public; Owner: nmo
--

ALTER TABLE public.publication ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.publication_id_seq
    START WITH 2
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pvec; Type: TABLE; Schema: public; Owner: nmo
--

CREATE TABLE public.pvec (
    id integer NOT NULL,
    neuron_id integer,
    distance double precision,
    coeffs double precision[],
    sfactor double precision
);


ALTER TABLE public.pvec OWNER TO nmo;

--
-- Name: pvec_id_seq; Type: SEQUENCE; Schema: public; Owner: nmo
--

ALTER TABLE public.pvec ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.pvec_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: region; Type: TABLE; Schema: public; Owner: nmo
--

CREATE TABLE public.region (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    path public.ltree
);


ALTER TABLE public.region OWNER TO nmo;

--
-- Name: region_id_seq; Type: SEQUENCE; Schema: public; Owner: nmo
--

ALTER TABLE public.region ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.region_id_seq
    START WITH 3
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: shrinkagevalue; Type: TABLE; Schema: public; Owner: nmo
--

CREATE TABLE public.shrinkagevalue (
    id integer NOT NULL,
    reported_value double precision,
    reported_xy double precision,
    reported_z double precision,
    corrected_value double precision,
    corrected_xy double precision,
    corrected_z double precision
);


ALTER TABLE public.shrinkagevalue OWNER TO nmo;

--
-- Name: shrinkagevalue_id_seq; Type: SEQUENCE; Schema: public; Owner: nmo
--

ALTER TABLE public.shrinkagevalue ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.shrinkagevalue_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: species; Type: TABLE; Schema: public; Owner: nmo
--

CREATE TABLE public.species (
    id integer NOT NULL,
    name character varying(255)
);


ALTER TABLE public.species OWNER TO nmo;

--
-- Name: species_id_seq; Type: SEQUENCE; Schema: public; Owner: nmo
--

ALTER TABLE public.species ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.species_id_seq
    START WITH 2
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: staining; Type: TABLE; Schema: public; Owner: nmo
--

CREATE TABLE public.staining (
    id integer NOT NULL,
    name character varying(255)
);


ALTER TABLE public.staining OWNER TO nmo;

--
-- Name: staining_id_seq; Type: SEQUENCE; Schema: public; Owner: nmo
--

ALTER TABLE public.staining ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.staining_id_seq
    START WITH 2
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: strain; Type: TABLE; Schema: public; Owner: nmo
--

CREATE TABLE public.strain (
    id integer NOT NULL,
    name character varying(255),
    species_id integer
);


ALTER TABLE public.strain OWNER TO nmo;

--
-- Name: strain_id_seq; Type: SEQUENCE; Schema: public; Owner: nmo
--

ALTER TABLE public.strain ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.strain_id_seq
    START WITH 2
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Data for Name: archive; Type: TABLE DATA; Schema: public; Owner: nmo
--

COPY public.archive (id, name, url) FROM stdin;
15	testarchive	http://test.com
90	Canavesi	 
19	Bailey	NULL
20	Brecht	NULL
21	Abdolhoseini_Kluge	NULL
22	Bastian	NULL
23	Bareyre	NULL
24	Dong	NULL
25	Ellender	NULL
26	Anstoetz	NULL
27	Rudy	NULL
28	Zagreb Neuroembryological Collection	NULL
29	Szatko_Franke	NULL
30	Farrow	NULL
31	La Barbera	NULL
32	Lefler_Amsalem	NULL
34	Kawaguchi	NULL
35	Bercier	NULL
36	Gazan_Schiffmann	NULL
37	VanHook	NULL
\.


--
-- Data for Name: celltype; Type: TABLE DATA; Schema: public; Owner: nmo
--

COPY public.celltype (id, name, path) FROM stdin;
100	sensory	sensory
101	principal cell	principal_cell
102	Motoneuron	principal_cell.Motoneuron
103	Diaphragm innervating	principal_cell.Motoneuron.Diaphragm_innervating
104	medium spiny	principal_cell.medium_spiny
105	D2-type dopamine receptor-expressing	principal_cell.medium_spiny.D2type_dopamine_receptorexpressing
106	indirect pathway	principal_cell.medium_spiny.D2type_dopamine_receptorexpressing.indirect_pathway
107	projection	principal_cell.medium_spiny.D2type_dopamine_receptorexpressing.indirect_pathway.projection
108	ipsilateral optic tectum-projecting	principal_cell.ipsilateral_optic_tectumprojecting
109	contralateral	principal_cell.contralateral
110	midbrain and hindbrain tegmentum-projecting	principal_cell.contralateral.midbrain_and_hindbrain_tegmentumprojecting
111	ipsilateral medial cerebellum-projecting	principal_cell.ipsilateral_medial_cerebellumprojecting
\.


--
-- Data for Name: expcond; Type: TABLE DATA; Schema: public; Owner: nmo
--

COPY public.expcond (id, name) FROM stdin;
31	gruesome
35	Control
36	Ethanol
37	social touch paradigm in freely-cycling subjects
38	Chronic deferoxamine (DFO)-treatment
39	Spinal cord T8 lesion + Wheel running
40	Spinal cord T8 lesion
41	Wheel running
42	Resolvin D1
43	dynactin1a mutant
44	dynactin1b mutant
45	dynactin1a/b double mutant
46	dynactin2 mutant
47	diphtheria toxin bilateral injection
48	5 weeks of moderate ocular hypertension
49	diabetic
\.


--
-- Data for Name: export; Type: TABLE DATA; Schema: public; Owner: nmo
--

COPY public.export (id, neuron_id, old_neuronid, exportdate, status, message) FROM stdin;
\.


--
-- Data for Name: ingested_archives; Type: TABLE DATA; Schema: public; Owner: nmo
--

COPY public.ingested_archives (id, name, date, message, status) FROM stdin;
\.


--
-- Data for Name: ingestion; Type: TABLE DATA; Schema: public; Owner: nmo
--

COPY public.ingestion (id, neuron_id, ingestion_date, message, neuron_name, archive, status) FROM stdin;
\.


--
-- Data for Name: measurements; Type: TABLE DATA; Schema: public; Owner: nmo
--

COPY public.measurements (id, soma_surface, n_stems, n_bifs, n_branch, width, height, depth, diameter, length, surface, volume, eucdistance, pathdistance, branch_order, contraction, fragmentation, partition_asymmetry, pk_classic, bif_ampl_local, bif_ampl_remote, fractal_dim) FROM stdin;
\.


--
-- Data for Name: neuron; Type: TABLE DATA; Schema: public; Owner: nmo
--

COPY public.neuron (id, name, archive_id, age, region_id, celltype_id, depositiondate, uploaddate, publication_id, expcond_id, magnification, summary_meas_id, objective, originalformat_id, slicing_direction, slicingthickness, has_soma, shrinkage, shrinkagevalue_id, age_scale, gender, max_age, min_age, min_weight, max_weight, note, url_reference, staining_id, protocol, oldid, strain_id, reconstruction) FROM stdin;
\.


--
-- Data for Name: neuron_segment; Type: TABLE DATA; Schema: public; Owner: nmo
--

COPY public.neuron_segment (id, radius, x, y, z, type, path, neuron_id) FROM stdin;
1	10	1	2	3	1	root	\N
2	10	1	2	3	2	root.2	\N
\.


--
-- Data for Name: neuron_structure; Type: TABLE DATA; Schema: public; Owner: nmo
--

COPY public.neuron_structure (id, neuron_id, measurements_id, completeness, domain, morph_attributes) FROM stdin;
\.


--
-- Data for Name: originalformat; Type: TABLE DATA; Schema: public; Owner: nmo
--

COPY public.originalformat (id, name, format_type) FROM stdin;
10	DAT	\N
14	dat	\N
15	swc	\N
16	ndf	\N
17	mat	\N
18	asc	\N
19	ims	\N
20	traces	\N
\.


--
-- Data for Name: publication; Type: TABLE DATA; Schema: public; Owner: nmo
--

COPY public.publication (id, pmid, doi, year, journal, title, first_author, last_author, species_id, ocdate, specific_details, related_page, data_status, literature_id, abstract, url) FROM stdin;
25	1111111	doi.org/test/11111	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
29	29017910	NULL	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
30	32133220		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
32	31591961	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\.


--
-- Data for Name: pvec; Type: TABLE DATA; Schema: public; Owner: nmo
--

COPY public.pvec (id, neuron_id, distance, coeffs, sfactor) FROM stdin;
2	\N	\N	{1.3,4.3}	\N
\.


--
-- Data for Name: region; Type: TABLE DATA; Schema: public; Owner: nmo
--

COPY public.region (id, name, path) FROM stdin;
104	peripheral nervous system	peripheral_nervous_system
105	cornea	peripheral_nervous_system.cornea
106	spinal cord	spinal_cord
107	phrenic nucleus	spinal_cord.phrenic_nucleus
108	myelencephalon	myelencephalon
109	inferior olive	myelencephalon.inferior_olive
110	basal ganglia	basal_ganglia
111	striatum	basal_ganglia.striatum
112	mesencephalon	mesencephalon
113	tectum	mesencephalon.tectum
114	pretectal region	mesencephalon.tectum.pretectal_region
115	retinal arborization field 7 (AF7)	mesencephalon.tectum.pretectal_region.retinal_arborization_field_7_AF7
\.


--
-- Data for Name: shrinkagevalue; Type: TABLE DATA; Schema: public; Owner: nmo
--

COPY public.shrinkagevalue (id, reported_value, reported_xy, reported_z, corrected_value, corrected_xy, corrected_z) FROM stdin;
4	0.75	\N	\N	\N	\N	\N
5	0.75	\N	\N	\N	\N	\N
6	0.75	\N	\N	\N	\N	\N
7	\N	\N	1.11	\N	\N	\N
8	\N	\N	1.11	\N	\N	\N
9	\N	\N	1.11	\N	\N	\N
10	\N	\N	1.11	\N	\N	\N
11	\N	\N	1.11	\N	\N	\N
12	\N	\N	1.11	\N	\N	\N
13	\N	\N	1.11	\N	\N	\N
14	\N	\N	1.11	\N	\N	\N
15	\N	\N	1.11	\N	\N	\N
16	\N	\N	1.11	\N	\N	\N
17	\N	\N	1.11	\N	\N	\N
18	\N	\N	1.11	\N	\N	\N
19	\N	\N	1.11	\N	\N	\N
20	\N	\N	1.11	\N	\N	\N
21	\N	\N	0.87	\N	\N	\N
22	\N	\N	0.87	\N	\N	\N
23	\N	\N	0.87	\N	\N	\N
24	\N	\N	0.87	\N	\N	\N
25	\N	\N	0.87	\N	\N	\N
26	\N	\N	0.87	\N	\N	\N
27	\N	\N	0.87	\N	\N	\N
28	\N	\N	0.87	\N	\N	\N
29	\N	\N	0.87	\N	\N	\N
30	\N	\N	0.95	\N	\N	\N
31	\N	\N	0.95	\N	\N	\N
32	\N	\N	0.95	\N	\N	\N
33	\N	\N	0.95	\N	\N	\N
34	\N	\N	0.95	\N	\N	\N
35	\N	\N	0.95	\N	\N	\N
36	\N	\N	0.95	\N	\N	\N
37	\N	\N	0.95	\N	\N	\N
38	\N	\N	0.95	\N	\N	\N
39	\N	\N	0.95	\N	\N	\N
40	\N	\N	\N	\N	\N	\N
41	\N	\N	\N	\N	\N	\N
42	\N	\N	\N	\N	\N	\N
43	\N	\N	\N	\N	\N	\N
44	\N	\N	\N	\N	\N	\N
45	\N	\N	\N	\N	\N	\N
46	\N	\N	\N	\N	\N	\N
47	\N	\N	\N	\N	\N	\N
48	\N	\N	\N	\N	\N	\N
49	\N	\N	\N	\N	\N	\N
50	\N	\N	\N	\N	\N	\N
51	\N	\N	\N	\N	\N	\N
52	\N	\N	\N	\N	\N	\N
53	\N	\N	\N	\N	\N	\N
54	\N	\N	\N	\N	\N	\N
55	\N	\N	\N	\N	\N	\N
56	\N	\N	\N	\N	\N	\N
57	\N	\N	\N	\N	\N	\N
58	\N	\N	\N	\N	\N	\N
59	\N	\N	\N	\N	\N	\N
60	\N	\N	\N	\N	\N	\N
61	\N	\N	\N	\N	\N	\N
62	\N	\N	\N	\N	\N	\N
63	\N	\N	\N	\N	\N	\N
64	\N	\N	\N	\N	\N	\N
65	\N	\N	\N	\N	\N	\N
66	\N	\N	\N	\N	\N	\N
67	\N	\N	\N	\N	\N	\N
68	\N	\N	\N	\N	\N	\N
69	\N	\N	\N	\N	\N	\N
70	\N	\N	\N	\N	\N	\N
71	\N	\N	\N	\N	\N	\N
72	\N	\N	\N	\N	\N	\N
73	\N	\N	\N	\N	\N	\N
74	\N	\N	\N	\N	\N	\N
75	\N	\N	\N	\N	\N	\N
76	\N	\N	\N	\N	\N	\N
77	\N	\N	\N	\N	\N	\N
78	\N	\N	\N	\N	\N	\N
79	\N	\N	\N	\N	\N	\N
80	\N	\N	\N	\N	\N	\N
81	\N	\N	\N	\N	\N	\N
82	\N	\N	\N	\N	\N	\N
83	\N	\N	\N	\N	\N	\N
84	\N	\N	\N	\N	\N	\N
85	\N	\N	\N	\N	\N	\N
86	\N	\N	\N	\N	\N	\N
87	\N	\N	\N	\N	\N	\N
88	\N	\N	\N	\N	\N	\N
89	\N	\N	\N	\N	\N	\N
90	\N	\N	\N	\N	\N	\N
91	\N	\N	\N	\N	\N	\N
92	\N	\N	\N	\N	\N	\N
93	\N	\N	\N	\N	\N	\N
94	\N	\N	\N	\N	\N	\N
95	\N	\N	\N	\N	\N	\N
96	\N	\N	\N	\N	\N	\N
97	\N	\N	\N	\N	\N	\N
98	\N	\N	\N	\N	\N	\N
99	\N	\N	\N	\N	\N	\N
100	\N	\N	\N	\N	\N	\N
101	\N	\N	\N	\N	\N	\N
102	\N	\N	\N	\N	\N	\N
103	\N	\N	\N	\N	\N	\N
104	\N	\N	\N	\N	\N	\N
105	\N	\N	\N	\N	\N	\N
106	\N	\N	\N	\N	\N	\N
107	\N	\N	\N	\N	\N	\N
108	\N	\N	\N	\N	\N	\N
109	\N	\N	\N	\N	\N	\N
110	\N	\N	\N	\N	\N	\N
111	\N	\N	\N	\N	\N	\N
112	\N	\N	\N	\N	\N	\N
113	\N	\N	\N	\N	\N	\N
114	\N	\N	\N	\N	\N	\N
115	\N	\N	\N	\N	\N	\N
116	\N	\N	\N	\N	\N	\N
117	\N	\N	\N	\N	\N	\N
118	\N	\N	\N	\N	\N	\N
119	\N	\N	\N	\N	\N	\N
120	\N	\N	\N	\N	\N	\N
121	\N	\N	\N	\N	\N	\N
122	\N	\N	\N	\N	\N	\N
123	\N	\N	\N	\N	\N	\N
124	\N	\N	\N	\N	\N	\N
125	\N	\N	\N	\N	\N	\N
126	\N	\N	\N	\N	\N	\N
127	\N	\N	\N	\N	\N	\N
128	\N	\N	\N	\N	\N	\N
129	\N	\N	\N	\N	\N	\N
130	\N	\N	\N	\N	\N	\N
131	\N	\N	\N	\N	\N	\N
132	\N	\N	\N	\N	\N	\N
133	\N	\N	\N	\N	\N	\N
134	\N	\N	\N	\N	\N	\N
135	\N	\N	\N	\N	\N	\N
136	\N	\N	\N	\N	\N	\N
137	\N	\N	\N	\N	\N	\N
138	\N	\N	\N	\N	\N	\N
139	\N	\N	\N	\N	\N	\N
140	\N	\N	\N	\N	\N	\N
141	\N	\N	\N	\N	\N	\N
142	\N	\N	\N	\N	\N	\N
143	\N	\N	\N	\N	\N	\N
144	\N	\N	\N	\N	\N	\N
145	\N	\N	\N	\N	\N	\N
146	\N	\N	\N	\N	\N	\N
147	\N	\N	\N	\N	\N	\N
148	\N	\N	\N	\N	\N	\N
149	\N	\N	\N	\N	\N	\N
150	\N	\N	\N	\N	\N	\N
151	\N	\N	\N	\N	\N	\N
152	\N	\N	\N	\N	\N	\N
153	\N	\N	\N	\N	\N	\N
154	\N	\N	\N	\N	\N	\N
155	\N	\N	\N	\N	\N	\N
156	\N	\N	\N	\N	\N	\N
157	\N	\N	\N	\N	\N	\N
158	\N	\N	\N	\N	\N	\N
159	\N	\N	\N	\N	\N	\N
160	\N	\N	\N	\N	\N	\N
161	\N	\N	\N	\N	\N	\N
162	\N	\N	\N	\N	\N	\N
163	\N	\N	\N	\N	\N	\N
164	\N	\N	\N	\N	\N	\N
165	\N	\N	\N	\N	\N	\N
166	\N	\N	\N	\N	\N	\N
167	\N	\N	\N	\N	\N	\N
168	\N	\N	\N	\N	\N	\N
169	\N	\N	\N	\N	\N	\N
170	\N	\N	\N	\N	\N	\N
171	\N	\N	\N	\N	\N	\N
172	\N	\N	\N	\N	\N	\N
173	\N	\N	\N	\N	\N	\N
174	\N	\N	\N	\N	\N	\N
175	\N	\N	\N	\N	\N	\N
176	\N	\N	\N	\N	\N	\N
177	\N	\N	\N	\N	\N	\N
178	\N	\N	\N	\N	\N	\N
179	\N	\N	\N	\N	\N	\N
180	\N	\N	\N	\N	\N	\N
181	\N	\N	\N	\N	\N	\N
182	\N	\N	\N	\N	\N	\N
183	\N	\N	\N	\N	\N	\N
184	\N	\N	\N	\N	\N	\N
185	\N	\N	\N	\N	\N	\N
186	\N	\N	\N	\N	\N	\N
187	\N	\N	\N	\N	\N	\N
188	\N	\N	\N	\N	\N	\N
189	\N	\N	\N	\N	\N	\N
190	\N	\N	\N	\N	\N	\N
191	\N	\N	\N	\N	\N	\N
192	\N	\N	\N	\N	\N	\N
193	\N	\N	\N	\N	\N	\N
194	\N	\N	\N	\N	\N	\N
195	\N	\N	\N	\N	\N	\N
196	\N	\N	\N	\N	\N	\N
197	\N	\N	\N	\N	\N	\N
198	\N	\N	\N	\N	\N	\N
199	\N	\N	\N	\N	\N	\N
200	\N	\N	\N	\N	\N	\N
201	\N	\N	\N	\N	\N	\N
202	\N	\N	\N	\N	\N	\N
203	\N	\N	\N	\N	\N	\N
204	\N	\N	\N	\N	\N	\N
205	\N	\N	\N	\N	\N	\N
206	\N	\N	\N	\N	\N	\N
207	\N	\N	\N	\N	\N	\N
208	\N	\N	\N	\N	\N	\N
209	\N	\N	\N	\N	\N	\N
210	\N	\N	\N	\N	\N	\N
211	\N	\N	\N	\N	\N	\N
212	\N	\N	\N	\N	\N	\N
213	\N	\N	\N	\N	\N	\N
214	\N	\N	\N	\N	\N	\N
215	\N	\N	\N	\N	\N	\N
216	\N	\N	\N	\N	\N	\N
217	\N	\N	\N	\N	\N	\N
218	\N	\N	\N	\N	\N	\N
219	\N	\N	\N	\N	\N	\N
220	\N	\N	\N	\N	\N	\N
221	\N	\N	\N	\N	\N	\N
222	\N	\N	\N	\N	\N	\N
223	\N	\N	\N	\N	\N	\N
224	\N	\N	\N	\N	\N	\N
225	\N	\N	\N	\N	\N	\N
226	\N	\N	\N	\N	\N	\N
227	\N	\N	\N	\N	\N	\N
228	\N	\N	\N	\N	\N	\N
229	\N	\N	\N	\N	\N	\N
230	\N	\N	\N	\N	\N	\N
231	\N	\N	\N	\N	\N	\N
232	\N	\N	\N	\N	\N	\N
233	\N	\N	\N	\N	\N	\N
234	\N	\N	\N	\N	\N	\N
235	\N	\N	\N	\N	\N	\N
236	\N	\N	\N	\N	\N	\N
237	\N	\N	\N	\N	\N	\N
238	\N	\N	\N	\N	\N	\N
239	\N	\N	\N	\N	\N	\N
240	\N	\N	\N	\N	\N	\N
241	\N	\N	\N	\N	\N	\N
242	\N	\N	\N	\N	\N	\N
243	\N	\N	\N	\N	\N	\N
244	\N	\N	\N	\N	\N	\N
245	\N	\N	\N	\N	\N	\N
246	\N	\N	\N	\N	\N	\N
247	\N	\N	\N	\N	\N	\N
248	\N	\N	\N	\N	\N	\N
249	\N	\N	\N	\N	\N	\N
250	\N	\N	\N	\N	\N	\N
251	\N	\N	\N	\N	\N	\N
252	\N	\N	\N	\N	\N	\N
253	\N	\N	\N	\N	\N	\N
254	\N	\N	\N	\N	\N	\N
255	\N	\N	\N	\N	\N	\N
256	\N	\N	\N	\N	\N	\N
257	\N	\N	\N	\N	\N	\N
258	\N	\N	\N	\N	\N	\N
259	\N	\N	\N	\N	\N	\N
260	\N	\N	\N	\N	\N	\N
261	\N	\N	\N	\N	\N	\N
262	\N	\N	\N	\N	\N	\N
263	\N	\N	\N	\N	\N	\N
264	\N	\N	\N	\N	\N	\N
265	\N	\N	\N	\N	\N	\N
266	\N	\N	\N	\N	\N	\N
267	\N	\N	\N	\N	\N	\N
268	\N	\N	\N	\N	\N	\N
269	\N	\N	\N	\N	\N	\N
270	\N	\N	\N	\N	\N	\N
271	\N	\N	\N	\N	\N	\N
272	\N	\N	\N	\N	\N	\N
273	\N	\N	\N	\N	\N	\N
274	\N	\N	\N	\N	\N	\N
275	\N	\N	\N	\N	\N	\N
276	\N	\N	\N	\N	\N	\N
277	\N	\N	\N	\N	\N	\N
278	\N	\N	\N	\N	\N	\N
279	\N	\N	\N	\N	\N	\N
280	\N	\N	\N	\N	\N	\N
281	\N	\N	\N	\N	\N	\N
282	\N	\N	\N	\N	\N	\N
283	\N	\N	\N	\N	\N	\N
284	\N	\N	\N	\N	\N	\N
285	\N	\N	\N	\N	\N	\N
286	\N	\N	\N	\N	\N	\N
287	\N	\N	\N	\N	\N	\N
288	\N	\N	\N	\N	\N	\N
289	\N	\N	\N	\N	\N	\N
290	\N	\N	\N	\N	\N	\N
291	\N	\N	\N	\N	\N	\N
292	\N	\N	\N	\N	\N	\N
293	\N	\N	\N	\N	\N	\N
294	\N	\N	\N	\N	\N	\N
295	\N	\N	\N	\N	\N	\N
296	\N	\N	\N	\N	\N	\N
297	\N	\N	\N	\N	\N	\N
298	\N	\N	\N	\N	\N	\N
299	\N	\N	\N	\N	\N	\N
300	\N	\N	\N	\N	\N	\N
301	\N	\N	\N	\N	\N	\N
302	\N	\N	\N	\N	\N	\N
303	\N	\N	\N	\N	\N	\N
304	\N	\N	\N	\N	\N	\N
305	\N	\N	\N	\N	\N	\N
306	\N	\N	\N	\N	\N	\N
307	\N	\N	\N	\N	\N	\N
308	\N	\N	\N	\N	\N	\N
309	\N	\N	\N	\N	\N	\N
310	\N	\N	\N	\N	\N	\N
311	\N	\N	\N	\N	\N	\N
312	\N	\N	\N	\N	\N	\N
313	\N	\N	\N	\N	\N	\N
314	\N	\N	\N	\N	\N	\N
315	\N	\N	\N	\N	\N	\N
316	\N	\N	\N	\N	\N	\N
317	\N	\N	\N	\N	\N	\N
318	\N	\N	\N	\N	\N	\N
319	\N	\N	\N	\N	\N	\N
320	\N	\N	\N	\N	\N	\N
321	\N	\N	\N	\N	\N	\N
322	\N	\N	\N	\N	\N	\N
323	\N	\N	\N	\N	\N	\N
324	\N	\N	\N	\N	\N	\N
325	\N	\N	\N	\N	\N	\N
326	\N	\N	\N	\N	\N	\N
327	\N	\N	\N	\N	\N	\N
328	\N	\N	\N	\N	\N	\N
329	\N	\N	\N	\N	\N	\N
330	\N	\N	\N	\N	\N	\N
331	\N	\N	\N	\N	\N	\N
332	\N	\N	\N	\N	\N	\N
333	\N	\N	\N	\N	\N	\N
334	\N	\N	\N	\N	\N	\N
335	\N	\N	\N	\N	\N	\N
336	\N	\N	\N	\N	\N	\N
337	\N	\N	\N	\N	\N	\N
338	\N	\N	\N	\N	\N	\N
339	\N	\N	\N	\N	\N	\N
340	\N	\N	\N	\N	\N	\N
341	\N	\N	\N	\N	\N	\N
342	\N	\N	\N	\N	\N	\N
343	\N	\N	\N	\N	\N	\N
344	\N	\N	\N	\N	\N	\N
345	\N	\N	\N	\N	\N	\N
346	\N	\N	\N	\N	\N	\N
347	\N	\N	\N	\N	\N	\N
348	\N	\N	\N	\N	\N	\N
349	\N	\N	\N	\N	\N	\N
350	\N	\N	\N	\N	\N	\N
351	\N	\N	\N	\N	\N	\N
352	\N	\N	\N	\N	\N	\N
353	\N	\N	\N	\N	\N	\N
354	\N	\N	\N	\N	\N	\N
355	\N	\N	\N	\N	\N	\N
356	\N	\N	\N	\N	\N	\N
357	\N	\N	\N	\N	\N	\N
358	\N	\N	\N	\N	\N	\N
359	\N	\N	\N	\N	\N	\N
360	\N	\N	\N	\N	\N	\N
361	\N	\N	\N	\N	\N	\N
362	\N	\N	\N	\N	\N	\N
363	\N	\N	\N	\N	\N	\N
364	\N	\N	\N	\N	\N	\N
365	\N	\N	\N	\N	\N	\N
366	\N	\N	\N	\N	\N	\N
367	\N	\N	\N	\N	\N	\N
368	\N	\N	\N	\N	\N	\N
369	\N	\N	\N	\N	\N	\N
370	\N	\N	\N	\N	\N	\N
371	\N	\N	\N	\N	\N	\N
372	\N	\N	\N	\N	\N	\N
373	\N	\N	\N	\N	\N	\N
374	\N	\N	\N	\N	\N	\N
375	\N	\N	\N	\N	\N	\N
376	\N	\N	\N	\N	\N	\N
377	\N	\N	\N	\N	\N	\N
378	\N	\N	\N	\N	\N	\N
379	\N	\N	\N	\N	\N	\N
380	\N	\N	\N	\N	\N	\N
381	\N	\N	\N	\N	\N	\N
382	\N	\N	\N	\N	\N	\N
383	\N	\N	\N	\N	\N	\N
384	\N	\N	\N	\N	\N	\N
385	\N	\N	\N	\N	\N	\N
386	\N	\N	\N	\N	\N	\N
387	\N	\N	\N	\N	\N	\N
388	\N	\N	\N	\N	\N	\N
389	\N	\N	\N	\N	\N	\N
390	\N	\N	\N	\N	\N	\N
391	\N	\N	\N	\N	\N	\N
392	\N	\N	\N	\N	\N	\N
393	\N	\N	\N	\N	\N	\N
394	\N	\N	\N	\N	\N	\N
395	\N	\N	\N	\N	\N	\N
396	\N	\N	\N	\N	\N	\N
397	\N	\N	\N	\N	\N	\N
398	\N	\N	\N	\N	\N	\N
399	\N	\N	\N	\N	\N	\N
400	\N	\N	\N	\N	\N	\N
401	\N	\N	\N	\N	\N	\N
402	\N	\N	\N	\N	\N	\N
403	\N	\N	\N	\N	\N	\N
404	\N	\N	\N	\N	\N	\N
405	\N	\N	\N	\N	\N	\N
406	\N	\N	\N	\N	\N	\N
407	\N	\N	\N	\N	\N	\N
408	\N	\N	\N	\N	\N	\N
409	\N	\N	\N	\N	\N	\N
410	\N	\N	\N	\N	\N	\N
411	\N	\N	\N	\N	\N	\N
412	\N	\N	\N	\N	\N	\N
413	\N	\N	\N	\N	\N	\N
414	\N	\N	\N	\N	\N	\N
415	\N	\N	\N	\N	\N	\N
416	\N	\N	\N	\N	\N	\N
417	\N	\N	\N	\N	\N	\N
418	\N	\N	\N	\N	\N	\N
419	\N	\N	\N	\N	\N	\N
420	\N	\N	\N	\N	\N	\N
421	\N	\N	\N	\N	\N	\N
422	\N	\N	\N	\N	\N	\N
423	\N	\N	\N	\N	\N	\N
424	\N	\N	\N	\N	\N	\N
425	\N	\N	\N	\N	\N	\N
426	\N	\N	\N	\N	\N	\N
427	\N	\N	\N	\N	\N	\N
428	\N	\N	\N	\N	\N	\N
429	\N	\N	\N	\N	\N	\N
430	\N	\N	\N	\N	\N	\N
431	\N	\N	\N	\N	\N	\N
432	\N	\N	\N	\N	\N	\N
433	\N	\N	\N	\N	\N	\N
434	\N	\N	\N	\N	\N	\N
435	\N	\N	\N	\N	\N	\N
436	\N	\N	\N	\N	\N	\N
437	\N	\N	\N	\N	\N	\N
438	\N	\N	\N	\N	\N	\N
439	\N	\N	\N	\N	\N	\N
440	\N	\N	\N	\N	\N	\N
441	\N	\N	\N	\N	\N	\N
442	\N	\N	\N	\N	\N	\N
443	\N	\N	\N	\N	\N	\N
444	\N	\N	\N	\N	\N	\N
445	\N	\N	\N	\N	\N	\N
446	\N	\N	\N	\N	\N	\N
447	\N	\N	\N	\N	\N	\N
448	\N	\N	\N	\N	\N	\N
449	\N	\N	\N	\N	\N	\N
450	\N	\N	\N	\N	\N	\N
451	\N	\N	\N	\N	\N	\N
452	\N	\N	\N	\N	\N	\N
453	\N	\N	\N	\N	\N	\N
454	\N	\N	\N	\N	\N	\N
455	\N	\N	\N	\N	\N	\N
456	\N	\N	\N	\N	\N	\N
457	\N	\N	\N	\N	\N	\N
458	\N	\N	\N	\N	\N	\N
459	\N	\N	\N	\N	\N	\N
460	\N	\N	\N	\N	\N	\N
461	\N	\N	\N	\N	\N	\N
462	\N	\N	\N	\N	\N	\N
463	\N	\N	\N	\N	\N	\N
464	\N	\N	\N	\N	\N	\N
465	\N	\N	\N	\N	\N	\N
466	\N	\N	\N	\N	\N	\N
467	\N	\N	\N	\N	\N	\N
468	\N	\N	\N	\N	\N	\N
469	\N	\N	\N	\N	\N	\N
470	\N	\N	\N	\N	\N	\N
471	\N	\N	\N	\N	\N	\N
472	\N	\N	\N	\N	\N	\N
473	\N	\N	\N	\N	\N	\N
474	\N	\N	\N	\N	\N	\N
475	\N	\N	\N	\N	\N	\N
476	\N	\N	\N	\N	\N	\N
477	\N	\N	\N	\N	\N	\N
478	\N	\N	\N	\N	\N	\N
479	\N	\N	\N	\N	\N	\N
480	\N	\N	\N	\N	\N	\N
481	\N	\N	\N	\N	\N	\N
482	\N	\N	\N	\N	\N	\N
483	\N	\N	\N	\N	\N	\N
484	\N	\N	\N	\N	\N	\N
485	\N	\N	\N	\N	\N	\N
486	\N	\N	\N	\N	\N	\N
487	\N	\N	\N	\N	\N	\N
488	\N	\N	\N	\N	\N	\N
489	\N	\N	\N	\N	\N	\N
490	\N	\N	\N	\N	\N	\N
491	\N	\N	\N	\N	\N	\N
492	\N	\N	\N	\N	\N	\N
493	\N	\N	\N	\N	\N	\N
494	\N	\N	\N	\N	\N	\N
495	\N	\N	\N	\N	\N	\N
496	\N	\N	\N	\N	\N	\N
497	\N	\N	\N	\N	\N	\N
498	\N	\N	\N	\N	\N	\N
499	\N	\N	\N	\N	\N	\N
500	\N	\N	\N	\N	\N	\N
501	\N	\N	\N	\N	\N	\N
502	\N	\N	\N	\N	\N	\N
503	\N	\N	\N	\N	\N	\N
504	\N	\N	\N	\N	\N	\N
505	\N	\N	\N	\N	\N	\N
506	\N	\N	\N	\N	\N	\N
507	\N	\N	\N	\N	\N	\N
508	\N	\N	\N	\N	\N	\N
509	\N	\N	\N	\N	\N	\N
510	\N	\N	\N	\N	\N	\N
511	\N	\N	\N	\N	\N	\N
512	\N	\N	\N	\N	\N	\N
513	\N	\N	\N	\N	\N	\N
514	\N	\N	\N	\N	\N	\N
515	\N	\N	\N	\N	\N	\N
516	\N	\N	\N	\N	\N	\N
517	\N	\N	\N	\N	\N	\N
518	\N	\N	\N	\N	\N	\N
519	\N	\N	\N	\N	\N	\N
520	\N	\N	\N	\N	\N	\N
521	\N	\N	\N	\N	\N	\N
522	\N	\N	\N	\N	\N	\N
523	\N	\N	\N	\N	\N	\N
524	\N	\N	\N	\N	\N	\N
525	\N	\N	\N	\N	\N	\N
526	\N	\N	\N	\N	\N	\N
527	\N	\N	\N	\N	\N	\N
528	\N	\N	\N	\N	\N	\N
529	\N	\N	\N	\N	\N	\N
530	\N	\N	\N	\N	\N	\N
531	\N	\N	\N	\N	\N	\N
532	\N	\N	\N	\N	\N	\N
533	\N	\N	\N	\N	\N	\N
534	\N	\N	\N	\N	\N	\N
535	\N	\N	\N	\N	\N	\N
536	\N	\N	\N	\N	\N	\N
537	\N	\N	\N	\N	\N	\N
538	\N	\N	\N	\N	\N	\N
539	\N	\N	\N	\N	\N	\N
540	\N	\N	\N	\N	\N	\N
541	\N	\N	\N	\N	\N	\N
542	\N	\N	\N	\N	\N	\N
543	\N	\N	\N	\N	\N	\N
544	\N	\N	\N	\N	\N	\N
545	\N	\N	\N	\N	\N	\N
546	\N	\N	\N	\N	\N	\N
547	\N	\N	\N	\N	\N	\N
548	\N	\N	\N	\N	\N	\N
549	\N	\N	\N	\N	\N	\N
550	\N	\N	\N	\N	\N	\N
551	\N	\N	\N	\N	\N	\N
552	\N	\N	\N	\N	\N	\N
553	\N	\N	\N	\N	\N	\N
554	\N	\N	\N	\N	\N	\N
555	\N	\N	\N	\N	\N	\N
556	\N	\N	\N	\N	\N	\N
557	\N	\N	\N	\N	\N	\N
558	\N	\N	\N	\N	\N	\N
559	\N	\N	\N	\N	\N	\N
560	\N	\N	\N	\N	\N	\N
561	\N	\N	\N	\N	\N	\N
562	\N	\N	\N	\N	\N	\N
563	\N	\N	\N	\N	\N	\N
564	\N	\N	\N	\N	\N	\N
565	\N	\N	\N	\N	\N	\N
566	\N	\N	\N	\N	\N	\N
567	\N	\N	\N	\N	\N	\N
568	\N	\N	\N	\N	\N	\N
569	\N	\N	\N	\N	\N	\N
570	\N	\N	\N	\N	\N	\N
571	\N	\N	\N	\N	\N	\N
572	\N	\N	\N	\N	\N	\N
573	\N	\N	\N	\N	\N	\N
574	\N	\N	\N	\N	\N	\N
575	\N	\N	\N	\N	\N	\N
576	\N	\N	\N	\N	\N	\N
577	\N	\N	\N	\N	\N	\N
578	\N	\N	\N	\N	\N	\N
579	\N	\N	\N	\N	\N	\N
580	\N	\N	\N	\N	\N	\N
581	\N	\N	\N	\N	\N	\N
582	\N	\N	\N	\N	\N	\N
583	\N	\N	\N	\N	\N	\N
584	\N	\N	\N	\N	\N	\N
585	\N	\N	\N	\N	\N	\N
586	\N	\N	\N	\N	\N	\N
587	\N	\N	\N	\N	\N	\N
588	\N	\N	\N	\N	\N	\N
589	\N	\N	\N	\N	\N	\N
590	\N	\N	\N	\N	\N	\N
591	\N	\N	\N	\N	\N	\N
592	\N	\N	\N	\N	\N	\N
593	\N	\N	\N	\N	\N	\N
594	\N	\N	\N	\N	\N	\N
595	\N	\N	\N	\N	\N	\N
596	\N	\N	\N	\N	\N	\N
597	\N	\N	\N	\N	\N	\N
598	\N	\N	\N	\N	\N	\N
599	\N	\N	\N	\N	\N	\N
600	\N	\N	\N	\N	\N	\N
601	\N	\N	\N	\N	\N	\N
602	\N	\N	\N	\N	\N	\N
603	\N	\N	\N	\N	\N	\N
604	\N	\N	\N	\N	\N	\N
605	\N	\N	\N	\N	\N	\N
606	\N	\N	\N	\N	\N	\N
607	\N	\N	\N	\N	\N	\N
608	\N	\N	\N	\N	\N	\N
609	\N	\N	\N	\N	\N	\N
610	\N	\N	\N	\N	\N	\N
611	\N	\N	\N	\N	\N	\N
612	\N	\N	\N	\N	\N	\N
613	\N	\N	\N	\N	\N	\N
614	\N	\N	\N	\N	\N	\N
615	\N	\N	\N	\N	\N	\N
616	\N	\N	\N	\N	\N	\N
617	\N	\N	\N	\N	\N	\N
618	\N	\N	\N	\N	\N	\N
619	\N	\N	\N	\N	\N	\N
620	\N	\N	\N	\N	\N	\N
621	\N	\N	\N	\N	\N	\N
622	\N	\N	\N	\N	\N	\N
623	\N	\N	\N	\N	\N	\N
624	\N	\N	\N	\N	\N	\N
625	\N	\N	\N	\N	\N	\N
626	\N	\N	\N	\N	\N	\N
627	\N	\N	\N	\N	\N	\N
628	\N	\N	\N	\N	\N	\N
629	\N	\N	\N	\N	\N	\N
630	\N	\N	\N	\N	\N	\N
631	\N	\N	\N	\N	\N	\N
632	\N	\N	\N	\N	\N	\N
633	\N	\N	\N	\N	\N	\N
634	\N	\N	\N	\N	\N	\N
635	\N	\N	\N	\N	\N	\N
636	\N	\N	\N	\N	\N	\N
637	\N	\N	\N	\N	\N	\N
638	\N	\N	\N	\N	\N	\N
639	\N	\N	\N	\N	\N	\N
640	\N	\N	\N	\N	\N	\N
641	\N	\N	\N	\N	\N	\N
642	\N	\N	\N	\N	\N	\N
643	\N	\N	\N	\N	\N	\N
644	\N	\N	\N	\N	\N	\N
645	\N	\N	\N	\N	\N	\N
646	\N	\N	\N	\N	\N	\N
647	\N	\N	\N	\N	\N	\N
648	\N	\N	\N	\N	\N	\N
649	\N	\N	\N	\N	\N	\N
650	\N	\N	\N	\N	\N	\N
651	\N	\N	\N	\N	\N	\N
652	\N	\N	\N	\N	\N	\N
653	\N	\N	\N	\N	\N	\N
654	\N	\N	\N	\N	\N	\N
655	\N	\N	\N	\N	\N	\N
656	\N	\N	\N	\N	\N	\N
657	\N	\N	\N	\N	\N	\N
658	\N	\N	\N	\N	\N	\N
659	\N	\N	\N	\N	\N	\N
660	\N	\N	\N	\N	\N	\N
661	\N	\N	\N	\N	\N	\N
662	\N	\N	\N	\N	\N	\N
663	\N	\N	\N	\N	\N	\N
664	\N	\N	\N	\N	\N	\N
665	\N	\N	\N	\N	\N	\N
666	\N	\N	\N	\N	\N	\N
667	\N	\N	\N	\N	\N	\N
668	\N	\N	\N	\N	\N	\N
669	\N	\N	\N	\N	\N	\N
670	\N	\N	\N	\N	\N	\N
671	\N	\N	\N	\N	\N	\N
672	\N	\N	\N	\N	\N	\N
673	\N	\N	\N	\N	\N	\N
674	\N	\N	\N	\N	\N	\N
675	\N	\N	\N	\N	\N	\N
676	\N	\N	\N	\N	\N	\N
677	\N	\N	\N	\N	\N	\N
678	\N	\N	\N	\N	\N	\N
679	\N	\N	\N	\N	\N	\N
680	\N	\N	\N	\N	\N	\N
681	\N	\N	\N	\N	\N	\N
682	\N	\N	\N	\N	\N	\N
683	\N	\N	\N	\N	\N	\N
684	\N	\N	\N	\N	\N	\N
685	\N	\N	\N	\N	\N	\N
686	\N	\N	\N	\N	\N	\N
687	\N	\N	\N	\N	\N	\N
688	\N	\N	\N	\N	\N	\N
689	\N	\N	\N	\N	\N	\N
690	\N	\N	\N	\N	\N	\N
691	\N	\N	\N	\N	\N	\N
692	\N	\N	\N	\N	\N	\N
693	\N	\N	\N	\N	\N	\N
694	\N	\N	\N	\N	\N	\N
695	\N	\N	\N	\N	\N	\N
696	\N	\N	\N	\N	\N	\N
697	\N	\N	\N	\N	\N	\N
698	\N	\N	\N	\N	\N	\N
699	\N	\N	\N	\N	\N	\N
700	\N	\N	\N	\N	\N	\N
701	\N	\N	\N	\N	\N	\N
702	\N	\N	\N	\N	\N	\N
703	\N	\N	\N	\N	\N	\N
704	\N	\N	\N	\N	\N	\N
705	\N	\N	\N	\N	\N	\N
706	\N	\N	\N	\N	\N	\N
707	\N	\N	\N	\N	\N	\N
708	\N	\N	\N	\N	\N	\N
709	\N	\N	\N	\N	\N	\N
710	\N	\N	\N	\N	\N	\N
711	\N	\N	\N	\N	\N	\N
712	\N	\N	\N	\N	\N	\N
713	\N	\N	\N	\N	\N	\N
714	\N	\N	\N	\N	\N	\N
715	\N	\N	\N	\N	\N	\N
716	\N	\N	\N	\N	\N	\N
717	\N	\N	\N	\N	\N	\N
718	\N	\N	\N	\N	\N	\N
719	\N	\N	\N	\N	\N	\N
720	\N	\N	\N	\N	\N	\N
721	\N	\N	\N	\N	\N	\N
722	\N	\N	\N	\N	\N	\N
723	\N	\N	\N	\N	\N	\N
724	\N	\N	\N	\N	\N	\N
725	\N	\N	\N	\N	\N	\N
726	\N	\N	\N	\N	\N	\N
727	\N	\N	\N	\N	\N	\N
728	\N	\N	\N	\N	\N	\N
729	\N	\N	\N	\N	\N	\N
730	\N	\N	\N	\N	\N	\N
731	\N	\N	\N	\N	\N	\N
732	\N	\N	\N	\N	\N	\N
733	\N	\N	\N	\N	\N	\N
734	\N	\N	\N	\N	\N	\N
735	\N	\N	\N	\N	\N	\N
736	\N	\N	\N	\N	\N	\N
737	\N	\N	\N	\N	\N	\N
738	\N	\N	\N	\N	\N	\N
739	\N	\N	\N	\N	\N	\N
740	\N	\N	\N	\N	\N	\N
741	\N	\N	\N	\N	\N	\N
742	\N	\N	\N	\N	\N	\N
743	\N	\N	\N	\N	\N	\N
744	\N	\N	\N	\N	\N	\N
745	\N	\N	\N	\N	\N	\N
746	\N	\N	\N	\N	\N	\N
747	\N	\N	\N	\N	\N	\N
748	\N	\N	\N	\N	\N	\N
749	\N	\N	\N	\N	\N	\N
750	\N	\N	\N	\N	\N	\N
751	\N	\N	\N	\N	\N	\N
752	\N	\N	\N	\N	\N	\N
753	\N	\N	\N	\N	\N	\N
754	\N	\N	\N	\N	\N	\N
755	\N	\N	\N	\N	\N	\N
756	\N	\N	\N	\N	\N	\N
757	\N	\N	\N	\N	\N	\N
758	\N	\N	\N	\N	\N	\N
759	\N	\N	\N	\N	\N	\N
760	\N	\N	\N	\N	\N	\N
761	\N	\N	\N	\N	\N	\N
762	\N	\N	\N	\N	\N	\N
763	\N	\N	\N	\N	\N	\N
764	\N	\N	\N	\N	\N	\N
765	\N	\N	\N	\N	\N	\N
766	\N	\N	\N	\N	\N	\N
767	\N	\N	\N	\N	\N	\N
768	\N	\N	\N	\N	\N	\N
769	\N	\N	\N	\N	\N	\N
770	\N	\N	\N	\N	\N	\N
771	\N	\N	\N	\N	\N	\N
772	\N	\N	\N	\N	\N	\N
773	\N	\N	\N	\N	\N	\N
774	\N	\N	\N	\N	\N	\N
775	\N	\N	\N	\N	\N	\N
776	\N	\N	\N	\N	\N	\N
777	\N	\N	\N	\N	\N	\N
778	\N	\N	\N	\N	\N	\N
779	\N	\N	\N	\N	\N	\N
780	\N	\N	\N	\N	\N	\N
781	\N	\N	\N	\N	\N	\N
782	\N	\N	\N	\N	\N	\N
783	\N	\N	\N	\N	\N	\N
784	\N	\N	\N	\N	\N	\N
785	\N	\N	\N	\N	\N	\N
786	\N	\N	\N	\N	\N	\N
787	\N	\N	\N	\N	\N	\N
788	\N	\N	\N	\N	\N	\N
789	\N	\N	\N	\N	\N	\N
790	\N	\N	\N	\N	\N	\N
791	\N	\N	\N	\N	\N	\N
792	\N	\N	\N	\N	\N	\N
793	\N	\N	\N	\N	\N	\N
794	\N	\N	\N	\N	\N	\N
795	\N	\N	\N	\N	\N	\N
796	\N	\N	\N	\N	\N	\N
797	\N	\N	\N	\N	\N	\N
798	\N	\N	\N	\N	\N	\N
799	\N	\N	\N	\N	\N	\N
800	\N	\N	\N	\N	\N	\N
801	\N	\N	\N	\N	\N	\N
802	\N	\N	\N	\N	\N	\N
803	\N	\N	\N	\N	\N	\N
804	\N	\N	\N	\N	\N	\N
805	\N	\N	\N	\N	\N	\N
806	\N	\N	\N	\N	\N	\N
807	\N	\N	\N	\N	\N	\N
808	\N	\N	\N	\N	\N	\N
809	\N	\N	\N	\N	\N	\N
810	\N	\N	\N	\N	\N	\N
811	\N	\N	\N	\N	\N	\N
812	\N	\N	\N	\N	\N	\N
813	\N	\N	\N	\N	\N	\N
814	\N	\N	\N	\N	\N	\N
815	\N	\N	\N	\N	\N	\N
816	\N	\N	\N	\N	\N	\N
817	\N	\N	\N	\N	\N	\N
818	\N	\N	\N	\N	\N	\N
819	\N	\N	\N	\N	\N	\N
820	\N	\N	\N	\N	\N	\N
821	\N	\N	\N	\N	\N	\N
822	\N	\N	\N	\N	\N	\N
823	\N	\N	\N	\N	\N	\N
824	\N	\N	\N	\N	\N	\N
825	\N	\N	\N	\N	\N	\N
826	\N	\N	\N	\N	\N	\N
827	\N	\N	\N	\N	\N	\N
828	\N	\N	\N	\N	\N	\N
829	\N	\N	\N	\N	\N	\N
830	\N	\N	\N	\N	\N	\N
831	\N	\N	\N	\N	\N	\N
832	\N	\N	\N	\N	\N	\N
833	\N	\N	\N	\N	\N	\N
834	\N	\N	\N	\N	\N	\N
835	\N	\N	\N	\N	\N	\N
836	\N	\N	\N	\N	\N	\N
837	\N	\N	\N	\N	\N	\N
838	\N	\N	\N	\N	\N	\N
839	\N	\N	\N	\N	\N	\N
840	\N	\N	\N	\N	\N	\N
841	\N	\N	\N	\N	\N	\N
842	\N	\N	\N	\N	\N	\N
843	\N	\N	\N	\N	\N	\N
844	\N	\N	\N	\N	\N	\N
845	\N	\N	\N	\N	\N	\N
846	\N	\N	\N	\N	\N	\N
847	\N	\N	\N	\N	\N	\N
848	\N	\N	\N	\N	\N	\N
849	\N	\N	\N	\N	\N	\N
850	\N	\N	\N	\N	\N	\N
851	\N	\N	\N	\N	\N	\N
852	\N	\N	\N	\N	\N	\N
853	\N	\N	\N	\N	\N	\N
854	\N	\N	\N	\N	\N	\N
855	\N	\N	\N	\N	\N	\N
856	\N	\N	\N	\N	\N	\N
857	\N	\N	\N	\N	\N	\N
858	\N	\N	\N	\N	\N	\N
859	\N	\N	\N	\N	\N	\N
860	\N	\N	\N	\N	\N	\N
861	\N	\N	\N	\N	\N	\N
862	\N	\N	\N	\N	\N	\N
863	\N	\N	\N	\N	\N	\N
864	\N	\N	\N	\N	\N	\N
865	\N	\N	\N	\N	\N	\N
866	\N	\N	\N	\N	\N	\N
867	\N	\N	\N	\N	\N	\N
868	\N	\N	\N	\N	\N	\N
869	\N	\N	\N	\N	\N	\N
870	\N	\N	\N	\N	\N	\N
871	\N	\N	\N	\N	\N	\N
872	\N	\N	\N	\N	\N	\N
873	\N	\N	\N	\N	\N	\N
874	\N	\N	\N	\N	\N	\N
875	\N	\N	\N	\N	\N	\N
876	\N	\N	\N	\N	\N	\N
877	\N	\N	\N	\N	\N	\N
878	\N	\N	\N	\N	\N	\N
879	\N	\N	\N	\N	\N	\N
880	\N	\N	\N	\N	\N	\N
881	\N	\N	\N	\N	\N	\N
882	\N	\N	\N	\N	\N	\N
883	\N	\N	\N	\N	\N	\N
884	\N	\N	\N	\N	\N	\N
885	\N	\N	\N	\N	\N	\N
886	\N	\N	\N	\N	\N	\N
887	\N	\N	\N	\N	\N	\N
888	\N	\N	\N	\N	\N	\N
889	\N	\N	\N	\N	\N	\N
890	\N	\N	\N	\N	\N	\N
891	\N	\N	\N	\N	\N	\N
892	\N	\N	\N	\N	\N	\N
893	\N	\N	\N	\N	\N	\N
894	\N	\N	\N	\N	\N	\N
895	\N	\N	\N	\N	\N	\N
896	\N	\N	\N	\N	\N	\N
897	\N	\N	\N	\N	\N	\N
898	\N	\N	\N	\N	\N	\N
899	\N	\N	\N	\N	\N	\N
900	\N	\N	\N	\N	\N	\N
901	\N	\N	\N	\N	\N	\N
902	\N	\N	\N	\N	\N	\N
903	\N	\N	\N	\N	\N	\N
904	\N	\N	\N	\N	\N	\N
905	\N	\N	\N	\N	\N	\N
906	\N	\N	\N	\N	\N	\N
907	\N	\N	\N	\N	\N	\N
908	\N	\N	\N	\N	\N	\N
909	\N	\N	\N	\N	\N	\N
910	\N	\N	\N	\N	\N	\N
911	\N	\N	\N	\N	\N	\N
912	\N	\N	\N	\N	\N	\N
913	\N	\N	\N	\N	\N	\N
914	\N	\N	\N	\N	\N	\N
915	\N	\N	\N	\N	\N	\N
916	\N	\N	\N	\N	\N	\N
917	\N	\N	\N	\N	\N	\N
918	\N	\N	\N	\N	\N	\N
919	\N	\N	\N	\N	\N	\N
920	\N	\N	\N	\N	\N	\N
921	\N	\N	\N	\N	\N	\N
922	\N	\N	\N	\N	\N	\N
923	\N	\N	\N	\N	\N	\N
924	\N	\N	\N	\N	\N	\N
925	\N	\N	\N	\N	\N	\N
926	\N	\N	\N	\N	\N	\N
927	\N	\N	\N	\N	\N	\N
928	\N	\N	\N	\N	\N	\N
929	\N	\N	\N	\N	\N	\N
930	\N	\N	\N	\N	\N	\N
931	\N	\N	\N	\N	\N	\N
932	\N	\N	\N	\N	\N	\N
933	\N	\N	\N	\N	\N	\N
934	\N	\N	\N	\N	\N	\N
935	\N	\N	\N	\N	\N	\N
936	\N	\N	\N	\N	\N	\N
937	\N	\N	\N	\N	\N	\N
938	\N	\N	\N	\N	\N	\N
939	\N	\N	\N	\N	\N	\N
940	\N	\N	\N	\N	\N	\N
941	\N	\N	\N	\N	\N	\N
942	\N	\N	\N	\N	\N	\N
943	\N	\N	\N	\N	\N	\N
944	\N	\N	\N	\N	\N	\N
945	\N	\N	\N	\N	\N	\N
946	\N	\N	\N	\N	\N	\N
947	\N	\N	\N	\N	\N	\N
948	\N	\N	\N	\N	\N	\N
949	\N	\N	\N	\N	\N	\N
950	\N	\N	\N	\N	\N	\N
951	\N	\N	\N	\N	\N	\N
952	\N	\N	\N	\N	\N	\N
953	\N	\N	\N	\N	\N	\N
954	\N	\N	\N	\N	\N	\N
955	\N	\N	\N	\N	\N	\N
956	\N	\N	\N	\N	\N	\N
957	\N	\N	\N	\N	\N	\N
958	\N	\N	\N	\N	\N	\N
959	\N	\N	\N	\N	\N	\N
960	\N	\N	\N	\N	\N	\N
961	\N	\N	\N	\N	\N	\N
962	\N	\N	\N	\N	\N	\N
963	\N	\N	\N	\N	\N	\N
964	\N	\N	\N	\N	\N	\N
965	\N	\N	\N	\N	\N	\N
966	\N	\N	\N	\N	\N	\N
967	\N	\N	\N	\N	\N	\N
968	\N	\N	\N	\N	\N	\N
969	\N	\N	\N	\N	\N	\N
970	\N	\N	\N	\N	\N	\N
971	\N	\N	\N	\N	\N	\N
972	\N	\N	\N	\N	\N	\N
973	\N	\N	\N	\N	\N	\N
974	\N	\N	\N	\N	\N	\N
975	\N	\N	\N	\N	\N	\N
976	\N	\N	\N	\N	\N	\N
977	\N	\N	\N	\N	\N	\N
978	\N	\N	\N	\N	\N	\N
979	\N	\N	\N	\N	\N	\N
980	\N	\N	\N	\N	\N	\N
981	\N	\N	\N	\N	\N	\N
982	\N	\N	\N	\N	\N	\N
983	\N	\N	\N	\N	\N	\N
984	\N	\N	\N	\N	\N	\N
985	\N	\N	\N	\N	\N	\N
986	\N	\N	\N	\N	\N	\N
987	\N	\N	\N	\N	\N	\N
988	\N	\N	\N	\N	\N	\N
989	\N	\N	\N	\N	\N	\N
990	\N	\N	\N	\N	\N	\N
991	\N	\N	\N	\N	\N	\N
992	\N	\N	\N	\N	\N	\N
993	\N	\N	\N	\N	\N	\N
994	\N	\N	\N	\N	\N	\N
995	\N	\N	\N	\N	\N	\N
996	\N	\N	\N	\N	\N	\N
997	\N	\N	\N	\N	\N	\N
998	\N	\N	\N	\N	\N	\N
999	\N	\N	\N	\N	\N	\N
1000	\N	\N	\N	\N	\N	\N
1001	\N	\N	\N	\N	\N	\N
1002	\N	\N	\N	\N	\N	\N
1003	\N	\N	\N	\N	\N	\N
1004	\N	\N	\N	\N	\N	\N
1005	\N	\N	\N	\N	\N	\N
1006	\N	\N	\N	\N	\N	\N
1007	\N	\N	\N	\N	\N	\N
1008	\N	\N	\N	\N	\N	\N
1009	\N	\N	\N	\N	\N	\N
1010	\N	\N	\N	\N	\N	\N
1011	\N	\N	\N	\N	\N	\N
1012	\N	\N	\N	\N	\N	\N
1013	\N	\N	\N	\N	\N	\N
1014	\N	\N	\N	\N	\N	\N
1015	\N	\N	\N	\N	\N	\N
1016	\N	\N	\N	\N	\N	\N
1017	\N	\N	\N	\N	\N	\N
1018	\N	\N	\N	\N	\N	\N
1019	\N	\N	\N	\N	\N	\N
1020	\N	\N	\N	\N	\N	\N
1021	\N	\N	\N	\N	\N	\N
1022	\N	\N	\N	\N	\N	\N
1023	\N	\N	\N	\N	\N	\N
1024	\N	\N	\N	\N	\N	\N
1025	\N	\N	\N	\N	\N	\N
1026	\N	\N	\N	\N	\N	\N
1027	\N	\N	\N	\N	\N	\N
1028	\N	\N	\N	\N	\N	\N
1029	\N	\N	\N	\N	\N	\N
1030	\N	\N	\N	\N	\N	\N
1031	\N	\N	\N	\N	\N	\N
1032	\N	\N	\N	\N	\N	\N
1033	\N	\N	\N	\N	\N	\N
1034	\N	\N	\N	\N	\N	\N
1035	\N	\N	\N	\N	\N	\N
1036	\N	\N	\N	\N	\N	\N
1037	\N	\N	\N	\N	\N	\N
1038	\N	\N	\N	\N	\N	\N
1039	\N	\N	\N	\N	\N	\N
1040	\N	\N	\N	\N	\N	\N
1041	\N	\N	\N	\N	\N	\N
1042	\N	\N	\N	\N	\N	\N
1043	\N	\N	\N	\N	\N	\N
1044	\N	\N	\N	\N	\N	\N
1045	\N	\N	\N	\N	\N	\N
1046	\N	\N	\N	\N	\N	\N
1047	\N	\N	\N	\N	\N	\N
1048	\N	\N	\N	\N	\N	\N
1049	\N	\N	\N	\N	\N	\N
1050	\N	\N	\N	\N	\N	\N
1051	\N	\N	\N	\N	\N	\N
1052	\N	\N	\N	\N	\N	\N
1053	\N	\N	\N	\N	\N	\N
1054	\N	\N	\N	\N	\N	\N
1055	\N	\N	\N	\N	\N	\N
1056	\N	\N	\N	\N	\N	\N
1057	\N	\N	\N	\N	\N	\N
1058	\N	\N	\N	\N	\N	\N
1059	\N	\N	\N	\N	\N	\N
1060	\N	\N	\N	\N	\N	\N
1061	\N	\N	\N	\N	\N	\N
1062	\N	\N	\N	\N	\N	\N
1063	\N	\N	\N	\N	\N	\N
1064	\N	\N	\N	\N	\N	\N
1065	\N	\N	\N	\N	\N	\N
1066	\N	\N	\N	\N	\N	\N
1067	\N	\N	\N	\N	\N	\N
1068	\N	\N	\N	\N	\N	\N
1069	\N	\N	\N	\N	\N	\N
1070	\N	\N	\N	\N	\N	\N
1071	\N	\N	\N	\N	\N	\N
1072	\N	\N	\N	\N	\N	\N
1073	\N	\N	\N	\N	\N	\N
1074	\N	\N	\N	\N	\N	\N
1075	\N	\N	\N	\N	\N	\N
1076	\N	\N	\N	\N	\N	\N
1077	\N	\N	\N	\N	\N	\N
1078	\N	\N	\N	\N	\N	\N
1079	\N	\N	\N	\N	\N	\N
1080	\N	\N	\N	\N	\N	\N
1081	\N	\N	\N	\N	\N	\N
1082	\N	\N	\N	\N	\N	\N
1083	\N	\N	\N	\N	\N	\N
1084	\N	\N	\N	\N	\N	\N
1085	\N	\N	\N	\N	\N	\N
1086	\N	\N	\N	\N	\N	\N
1087	\N	\N	\N	\N	\N	\N
1088	\N	\N	\N	\N	\N	\N
1089	\N	\N	\N	\N	\N	\N
1090	\N	\N	\N	\N	\N	\N
1091	\N	\N	\N	\N	\N	\N
1092	\N	\N	\N	\N	\N	\N
1093	\N	\N	\N	\N	\N	\N
1094	\N	\N	\N	\N	\N	\N
1095	\N	\N	\N	\N	\N	\N
1096	\N	\N	\N	\N	\N	\N
1097	\N	\N	\N	\N	\N	\N
1098	\N	\N	\N	\N	\N	\N
1099	\N	\N	\N	\N	\N	\N
1100	\N	\N	\N	\N	\N	\N
1101	\N	\N	\N	\N	\N	\N
1102	\N	\N	\N	\N	\N	\N
1103	\N	\N	\N	\N	\N	\N
1104	\N	\N	\N	\N	\N	\N
1105	\N	\N	\N	\N	\N	\N
1106	\N	\N	\N	\N	\N	\N
1107	\N	\N	\N	\N	\N	\N
1108	\N	\N	\N	\N	\N	\N
1109	\N	\N	\N	\N	\N	\N
1110	\N	\N	\N	\N	\N	\N
1111	\N	\N	\N	\N	\N	\N
1112	\N	\N	\N	\N	\N	\N
1113	\N	\N	\N	\N	\N	\N
1114	\N	\N	\N	\N	\N	\N
1115	\N	\N	\N	\N	\N	\N
1116	\N	\N	\N	\N	\N	\N
1117	\N	\N	\N	\N	\N	\N
1118	\N	\N	\N	\N	\N	\N
1119	\N	\N	\N	\N	\N	\N
1120	\N	\N	\N	\N	\N	\N
1121	\N	\N	\N	\N	\N	\N
1122	\N	\N	\N	\N	\N	\N
1123	\N	\N	\N	\N	\N	\N
1124	\N	\N	\N	\N	\N	\N
1125	\N	\N	\N	\N	\N	\N
1126	\N	\N	\N	\N	\N	\N
1127	\N	\N	\N	\N	\N	\N
1128	\N	\N	\N	\N	\N	\N
1129	\N	\N	\N	\N	\N	\N
1130	\N	\N	\N	\N	\N	\N
1131	\N	\N	\N	\N	\N	\N
1132	\N	\N	\N	\N	\N	\N
1133	\N	\N	\N	\N	\N	\N
1134	\N	\N	\N	\N	\N	\N
1135	\N	\N	\N	\N	\N	\N
1136	\N	\N	\N	\N	\N	\N
1137	\N	\N	\N	\N	\N	\N
1138	\N	\N	\N	\N	\N	\N
1139	\N	\N	\N	\N	\N	\N
1140	\N	\N	\N	\N	\N	\N
1141	\N	\N	\N	\N	\N	\N
1142	\N	\N	\N	\N	\N	\N
1143	\N	\N	\N	\N	\N	\N
1144	\N	\N	\N	\N	\N	\N
1145	\N	\N	\N	\N	\N	\N
1146	\N	\N	\N	\N	\N	\N
1147	\N	\N	\N	\N	\N	\N
1148	\N	\N	\N	\N	\N	\N
1149	\N	\N	\N	\N	\N	\N
1150	\N	\N	\N	\N	\N	\N
1151	\N	\N	\N	\N	\N	\N
1152	\N	\N	\N	\N	\N	\N
1153	\N	\N	\N	\N	\N	\N
1154	\N	\N	\N	\N	\N	\N
1155	\N	\N	\N	\N	\N	\N
1156	\N	\N	\N	\N	\N	\N
1157	\N	\N	\N	\N	\N	\N
1158	\N	\N	\N	\N	\N	\N
1159	\N	\N	\N	\N	\N	\N
1160	\N	\N	\N	\N	\N	\N
1161	\N	\N	\N	\N	\N	\N
1162	\N	\N	\N	\N	\N	\N
1163	\N	\N	\N	\N	\N	\N
1164	\N	\N	\N	\N	\N	\N
1165	\N	\N	\N	\N	\N	\N
1166	\N	\N	\N	\N	\N	\N
1167	\N	\N	\N	\N	\N	\N
1168	\N	\N	\N	\N	\N	\N
1169	\N	\N	\N	\N	\N	\N
1170	\N	\N	\N	\N	\N	\N
1171	\N	\N	\N	\N	\N	\N
1172	\N	\N	\N	\N	\N	\N
1173	\N	\N	\N	\N	\N	\N
1174	\N	\N	\N	\N	\N	\N
1175	\N	\N	\N	\N	\N	\N
1176	\N	\N	\N	\N	\N	\N
1177	\N	\N	\N	\N	\N	\N
1178	\N	\N	\N	\N	\N	\N
1179	\N	\N	\N	\N	\N	\N
1180	\N	\N	\N	\N	\N	\N
1181	\N	\N	\N	\N	\N	\N
1182	\N	\N	\N	\N	\N	\N
1183	\N	\N	\N	\N	\N	\N
1184	\N	\N	\N	\N	\N	\N
1185	\N	\N	\N	\N	\N	\N
1186	\N	\N	\N	\N	\N	\N
1187	\N	\N	\N	\N	\N	\N
1188	\N	\N	\N	\N	\N	\N
1189	\N	\N	\N	\N	\N	\N
1190	\N	\N	\N	\N	\N	\N
1191	\N	\N	\N	\N	\N	\N
1192	\N	\N	\N	\N	\N	\N
1193	\N	\N	\N	\N	\N	\N
1194	\N	\N	\N	\N	\N	\N
1195	\N	\N	\N	\N	\N	\N
1196	\N	\N	\N	\N	\N	\N
1197	\N	\N	\N	\N	\N	\N
1198	\N	\N	\N	\N	\N	\N
1199	\N	\N	\N	\N	\N	\N
1200	\N	\N	\N	\N	\N	\N
1201	\N	\N	\N	\N	\N	\N
1202	\N	\N	\N	\N	\N	\N
1203	\N	\N	\N	\N	\N	\N
1204	\N	\N	\N	\N	\N	\N
1205	\N	\N	\N	\N	\N	\N
1206	\N	\N	\N	\N	\N	\N
1207	\N	\N	\N	\N	\N	\N
1208	\N	\N	\N	\N	\N	\N
1209	\N	\N	\N	\N	\N	\N
1210	\N	\N	\N	\N	\N	\N
1211	\N	\N	\N	\N	\N	\N
1212	\N	\N	\N	\N	\N	\N
1213	\N	\N	\N	\N	\N	\N
1214	\N	\N	\N	\N	\N	\N
1215	\N	\N	\N	\N	\N	\N
1216	\N	\N	\N	\N	\N	\N
1217	\N	\N	\N	\N	\N	\N
1218	\N	\N	\N	\N	\N	\N
1219	\N	\N	\N	\N	\N	\N
1220	\N	\N	\N	\N	\N	\N
1221	\N	\N	\N	\N	\N	\N
1222	\N	\N	\N	\N	\N	\N
1223	\N	\N	\N	\N	\N	\N
1224	\N	\N	\N	\N	\N	\N
1225	\N	\N	\N	\N	\N	\N
1226	\N	\N	\N	\N	\N	\N
1227	\N	\N	\N	\N	\N	\N
1228	\N	\N	\N	\N	\N	\N
1229	\N	\N	\N	\N	\N	\N
1230	\N	\N	\N	\N	\N	\N
1231	\N	\N	\N	\N	\N	\N
1232	\N	\N	\N	\N	\N	\N
1233	\N	\N	\N	\N	\N	\N
1234	\N	\N	\N	\N	\N	\N
1235	\N	\N	\N	\N	\N	\N
1236	\N	\N	\N	\N	\N	\N
1237	\N	\N	\N	\N	\N	\N
1238	\N	\N	\N	\N	\N	\N
1239	\N	\N	\N	\N	\N	\N
1240	\N	\N	\N	\N	\N	\N
1241	\N	\N	\N	\N	\N	\N
1242	\N	\N	\N	\N	\N	\N
1243	\N	\N	\N	\N	\N	\N
1244	\N	\N	\N	\N	\N	\N
1245	\N	\N	\N	\N	\N	\N
1246	\N	\N	\N	\N	\N	\N
1247	\N	\N	\N	\N	\N	\N
1248	\N	\N	\N	\N	\N	\N
1249	\N	\N	\N	\N	\N	\N
1250	\N	\N	\N	\N	\N	\N
1251	\N	\N	\N	\N	\N	\N
1252	\N	\N	\N	\N	\N	\N
1253	\N	\N	\N	\N	\N	\N
1254	\N	\N	\N	\N	\N	\N
1255	\N	\N	\N	\N	\N	\N
1256	\N	\N	\N	\N	\N	\N
1257	\N	\N	\N	\N	\N	\N
1258	\N	\N	\N	\N	\N	\N
1259	\N	\N	\N	\N	\N	\N
1260	\N	\N	\N	\N	\N	\N
1261	\N	\N	\N	\N	\N	\N
1262	\N	\N	\N	\N	\N	\N
1263	\N	\N	\N	\N	\N	\N
1264	\N	\N	\N	\N	\N	\N
1265	\N	\N	\N	\N	\N	\N
1266	\N	\N	\N	\N	\N	\N
1267	\N	\N	\N	\N	\N	\N
1268	\N	\N	\N	\N	\N	\N
1269	\N	\N	\N	\N	\N	\N
1270	\N	\N	\N	\N	\N	\N
1271	\N	\N	\N	\N	\N	\N
1272	\N	\N	\N	\N	\N	\N
1273	\N	\N	\N	\N	\N	\N
1274	\N	\N	\N	\N	\N	\N
1275	\N	\N	\N	\N	\N	\N
1276	\N	\N	\N	\N	\N	\N
1277	\N	\N	\N	\N	\N	\N
1278	\N	\N	\N	\N	\N	\N
1279	\N	\N	\N	\N	\N	\N
1280	\N	\N	\N	\N	\N	\N
1281	\N	\N	\N	\N	\N	\N
1282	\N	\N	\N	\N	\N	\N
1283	\N	\N	\N	\N	\N	\N
1284	\N	\N	\N	\N	\N	\N
1285	\N	\N	\N	\N	\N	\N
1286	\N	\N	\N	\N	\N	\N
1287	\N	\N	\N	\N	\N	\N
1288	\N	\N	\N	\N	\N	\N
1289	\N	\N	\N	\N	\N	\N
1290	\N	\N	\N	\N	\N	\N
1291	\N	\N	\N	\N	\N	\N
1292	\N	\N	\N	\N	\N	\N
1293	\N	\N	\N	\N	\N	\N
1294	\N	\N	\N	\N	\N	\N
1295	\N	\N	\N	\N	\N	\N
1296	\N	\N	\N	\N	\N	\N
1297	\N	\N	\N	\N	\N	\N
1298	\N	\N	\N	\N	\N	\N
1299	\N	\N	\N	\N	\N	\N
1300	\N	\N	\N	\N	\N	\N
1301	\N	\N	\N	\N	\N	\N
1302	\N	\N	\N	\N	\N	\N
1303	\N	\N	\N	\N	\N	\N
1304	\N	\N	\N	\N	\N	\N
1305	\N	\N	\N	\N	\N	\N
1306	\N	\N	\N	\N	\N	\N
1307	\N	\N	\N	\N	\N	\N
1308	\N	\N	\N	\N	\N	\N
1309	\N	\N	\N	\N	\N	\N
1310	\N	\N	\N	\N	\N	\N
1311	\N	\N	\N	\N	\N	\N
1312	\N	\N	\N	\N	\N	\N
1313	\N	\N	\N	\N	\N	\N
1314	\N	\N	\N	\N	\N	\N
1315	\N	\N	\N	\N	\N	\N
1316	\N	\N	\N	\N	\N	\N
1317	\N	\N	\N	\N	\N	\N
1318	\N	\N	\N	\N	\N	\N
1319	\N	\N	\N	\N	\N	\N
1320	\N	\N	\N	\N	\N	\N
1321	\N	\N	\N	\N	\N	\N
1322	\N	\N	\N	\N	\N	\N
1323	\N	\N	\N	\N	\N	\N
1324	\N	\N	\N	\N	\N	\N
1325	\N	\N	\N	\N	\N	\N
1326	\N	\N	\N	\N	\N	\N
1327	\N	\N	\N	\N	\N	\N
1328	\N	\N	\N	\N	\N	\N
1329	\N	\N	\N	\N	\N	\N
1330	\N	\N	\N	\N	\N	\N
1331	\N	\N	\N	\N	\N	\N
1332	\N	\N	\N	\N	\N	\N
1333	\N	\N	\N	\N	\N	\N
1334	\N	\N	\N	\N	\N	\N
1335	\N	\N	\N	\N	\N	\N
1336	\N	\N	\N	\N	\N	\N
1337	\N	\N	\N	\N	\N	\N
1338	\N	\N	\N	\N	\N	\N
1339	\N	\N	\N	\N	\N	\N
1340	\N	\N	\N	\N	\N	\N
1341	\N	\N	\N	\N	\N	\N
1342	\N	\N	\N	\N	\N	\N
1343	\N	\N	\N	\N	\N	\N
1344	\N	\N	\N	\N	\N	\N
1345	\N	\N	\N	\N	\N	\N
1346	\N	\N	\N	\N	\N	\N
1347	\N	\N	\N	\N	\N	\N
1348	\N	\N	\N	\N	\N	\N
1349	\N	\N	\N	\N	\N	\N
1350	\N	\N	\N	\N	\N	\N
1351	\N	\N	\N	\N	\N	\N
1352	\N	\N	\N	\N	\N	\N
1353	\N	\N	\N	\N	\N	\N
1354	\N	\N	\N	\N	\N	\N
1355	\N	\N	\N	\N	\N	\N
1356	\N	\N	\N	\N	\N	\N
1357	\N	\N	\N	\N	\N	\N
1358	\N	\N	\N	\N	\N	\N
1359	\N	\N	\N	\N	\N	\N
1360	\N	\N	\N	\N	\N	\N
1361	\N	\N	\N	\N	\N	\N
1362	\N	\N	\N	\N	\N	\N
1363	\N	\N	\N	\N	\N	\N
1364	\N	\N	\N	\N	\N	\N
1365	\N	\N	\N	\N	\N	\N
1366	\N	\N	\N	\N	\N	\N
1367	\N	\N	\N	\N	\N	\N
1368	\N	\N	\N	\N	\N	\N
1369	\N	\N	\N	\N	\N	\N
1370	\N	\N	\N	\N	\N	\N
1371	\N	\N	\N	\N	\N	\N
1372	\N	\N	\N	\N	\N	\N
1373	\N	\N	\N	\N	\N	\N
1374	\N	\N	\N	\N	\N	\N
1375	\N	\N	\N	\N	\N	\N
1376	\N	\N	\N	\N	\N	\N
1377	\N	\N	\N	\N	\N	\N
1378	\N	\N	\N	\N	\N	\N
1379	\N	\N	\N	\N	\N	\N
1380	\N	\N	\N	\N	\N	\N
1381	\N	\N	\N	\N	\N	\N
1382	\N	\N	\N	\N	\N	\N
1383	\N	\N	\N	\N	\N	\N
1384	\N	\N	\N	\N	\N	\N
1385	\N	\N	\N	\N	\N	\N
1386	\N	\N	\N	\N	\N	\N
1387	\N	\N	\N	\N	\N	\N
1388	\N	\N	\N	\N	\N	\N
1389	\N	\N	\N	\N	\N	\N
1390	\N	\N	\N	\N	\N	\N
1391	\N	\N	\N	\N	\N	\N
1392	\N	\N	\N	\N	\N	\N
1393	\N	\N	\N	\N	\N	\N
1394	\N	\N	\N	\N	\N	\N
1395	\N	\N	\N	\N	\N	\N
1396	\N	\N	\N	\N	\N	\N
1397	\N	\N	\N	\N	\N	\N
1398	\N	\N	\N	\N	\N	\N
1399	\N	\N	\N	\N	\N	\N
1400	\N	\N	\N	\N	\N	\N
1401	\N	\N	\N	\N	\N	\N
1402	\N	\N	\N	\N	\N	\N
1403	\N	\N	\N	\N	\N	\N
1404	\N	\N	\N	\N	\N	\N
1405	\N	\N	\N	\N	\N	\N
1406	\N	\N	\N	\N	\N	\N
1407	\N	\N	\N	\N	\N	\N
1408	\N	\N	\N	\N	\N	\N
1409	\N	\N	\N	\N	\N	\N
1410	\N	\N	\N	\N	\N	\N
1411	\N	\N	\N	\N	\N	\N
1412	\N	\N	\N	\N	\N	\N
1413	\N	\N	\N	\N	\N	\N
1414	\N	\N	\N	\N	\N	\N
1415	\N	\N	\N	\N	\N	\N
1416	\N	\N	\N	\N	\N	\N
1417	\N	\N	\N	\N	\N	\N
1418	\N	\N	\N	\N	\N	\N
1419	\N	\N	\N	\N	\N	\N
1420	\N	\N	\N	\N	\N	\N
1421	\N	\N	\N	\N	\N	\N
1422	\N	\N	\N	\N	\N	\N
1423	\N	\N	\N	\N	\N	\N
1424	\N	\N	\N	\N	\N	\N
1425	\N	\N	\N	\N	\N	\N
1426	\N	\N	\N	\N	\N	\N
1427	\N	\N	\N	\N	\N	\N
1428	\N	\N	\N	\N	\N	\N
1429	\N	\N	\N	\N	\N	\N
1430	\N	\N	\N	\N	\N	\N
1431	\N	\N	\N	\N	\N	\N
1432	\N	\N	\N	\N	\N	\N
1433	\N	\N	\N	\N	\N	\N
1434	\N	\N	\N	\N	\N	\N
1435	\N	\N	\N	\N	\N	\N
1436	\N	\N	\N	\N	\N	\N
1437	\N	\N	\N	\N	\N	\N
1438	\N	\N	\N	\N	\N	\N
1439	\N	\N	\N	\N	\N	\N
1440	\N	\N	\N	\N	\N	\N
1441	\N	\N	\N	\N	\N	\N
1442	\N	\N	\N	\N	\N	\N
1443	\N	\N	\N	\N	\N	\N
1444	\N	\N	\N	\N	\N	\N
1445	\N	\N	\N	\N	\N	\N
1446	\N	\N	\N	\N	\N	\N
1447	\N	\N	\N	\N	\N	\N
1448	\N	\N	\N	\N	\N	\N
1449	\N	\N	\N	\N	\N	\N
1450	\N	\N	\N	\N	\N	\N
1451	\N	\N	\N	\N	\N	\N
1452	\N	\N	\N	\N	\N	\N
1453	\N	\N	\N	\N	\N	\N
1454	\N	\N	\N	\N	\N	\N
1455	\N	\N	\N	\N	\N	\N
1456	\N	\N	\N	\N	\N	\N
1457	\N	\N	\N	\N	\N	\N
1458	\N	\N	\N	\N	\N	\N
1459	\N	\N	\N	\N	\N	\N
1460	\N	\N	\N	\N	\N	\N
1461	\N	\N	\N	\N	\N	\N
1462	\N	\N	\N	\N	\N	\N
1463	\N	\N	\N	\N	\N	\N
1464	\N	\N	\N	\N	\N	\N
1465	\N	\N	\N	\N	\N	\N
1466	\N	\N	\N	\N	\N	\N
1467	\N	\N	\N	\N	\N	\N
1468	\N	\N	\N	\N	\N	\N
1469	\N	\N	\N	\N	\N	\N
1470	\N	\N	\N	\N	\N	\N
1471	\N	\N	\N	\N	\N	\N
1472	\N	\N	\N	\N	\N	\N
1473	\N	\N	\N	\N	\N	\N
1474	\N	\N	\N	\N	\N	\N
1475	\N	\N	\N	\N	\N	\N
1476	\N	\N	\N	\N	\N	\N
1477	\N	\N	\N	\N	\N	\N
1478	\N	\N	\N	\N	\N	\N
1479	\N	\N	\N	\N	\N	\N
1480	\N	\N	\N	\N	\N	\N
1481	\N	\N	\N	\N	\N	\N
1482	\N	\N	\N	\N	\N	\N
1483	\N	\N	\N	\N	\N	\N
1484	\N	\N	\N	\N	\N	\N
1485	\N	\N	\N	\N	\N	\N
1486	\N	\N	\N	\N	\N	\N
1487	\N	\N	\N	\N	\N	\N
1488	\N	\N	\N	\N	\N	\N
1489	\N	\N	\N	\N	\N	\N
1490	\N	\N	\N	\N	\N	\N
1491	\N	\N	\N	\N	\N	\N
1492	\N	\N	\N	\N	\N	\N
1493	\N	\N	\N	\N	\N	\N
1494	\N	\N	\N	\N	\N	\N
1495	\N	\N	\N	\N	\N	\N
1496	\N	\N	\N	\N	\N	\N
1497	\N	\N	\N	\N	\N	\N
1498	\N	\N	\N	\N	\N	\N
1499	\N	\N	\N	\N	\N	\N
1500	\N	\N	\N	\N	\N	\N
1501	\N	\N	\N	\N	\N	\N
1502	\N	\N	\N	\N	\N	\N
1503	\N	\N	\N	\N	\N	\N
1504	\N	\N	\N	\N	\N	\N
1505	\N	\N	\N	\N	\N	\N
1506	\N	\N	\N	\N	\N	\N
1507	\N	\N	\N	\N	\N	\N
1508	\N	\N	\N	\N	\N	\N
1509	\N	\N	\N	\N	\N	\N
1510	\N	\N	\N	\N	\N	\N
1511	\N	\N	\N	\N	\N	\N
1512	\N	\N	\N	\N	\N	\N
1513	\N	\N	\N	\N	\N	\N
1514	\N	\N	\N	\N	\N	\N
1515	\N	\N	\N	\N	\N	\N
1516	\N	\N	\N	\N	\N	\N
1517	\N	\N	\N	\N	\N	\N
1518	\N	\N	\N	\N	\N	\N
1519	\N	\N	\N	\N	\N	\N
1520	\N	\N	\N	\N	\N	\N
1521	\N	\N	\N	\N	\N	\N
1522	\N	\N	\N	\N	\N	\N
1523	\N	\N	\N	\N	\N	\N
1524	\N	\N	\N	\N	\N	\N
1525	\N	\N	\N	\N	\N	\N
1526	\N	\N	\N	\N	\N	\N
1527	\N	\N	\N	\N	\N	\N
1528	\N	\N	\N	\N	\N	\N
1529	\N	\N	\N	\N	\N	\N
1530	\N	\N	\N	\N	\N	\N
1531	\N	\N	\N	\N	\N	\N
1532	\N	\N	\N	\N	\N	\N
1533	\N	\N	\N	\N	\N	\N
1534	\N	\N	\N	\N	\N	\N
1535	\N	\N	\N	\N	\N	\N
1536	\N	\N	\N	\N	\N	\N
1537	\N	\N	\N	\N	\N	\N
1538	\N	\N	\N	\N	\N	\N
1539	\N	\N	\N	\N	\N	\N
1540	\N	\N	\N	\N	\N	\N
1541	\N	\N	\N	\N	\N	\N
1542	\N	\N	\N	\N	\N	\N
1543	\N	\N	\N	\N	\N	\N
1544	\N	\N	\N	\N	\N	\N
1545	\N	\N	\N	\N	\N	\N
1546	\N	\N	\N	\N	\N	\N
1547	\N	\N	\N	\N	\N	\N
1548	\N	\N	\N	\N	\N	\N
1549	\N	\N	\N	\N	\N	\N
1550	\N	\N	\N	\N	\N	\N
1551	\N	\N	\N	\N	\N	\N
1552	\N	\N	\N	\N	\N	\N
1553	\N	\N	\N	\N	\N	\N
1554	\N	\N	\N	\N	\N	\N
1555	\N	\N	\N	\N	\N	\N
1556	\N	\N	\N	\N	\N	\N
1557	\N	\N	\N	\N	\N	\N
1558	\N	\N	\N	\N	\N	\N
1559	\N	\N	\N	\N	\N	\N
1560	\N	\N	\N	\N	\N	\N
1561	\N	\N	\N	\N	\N	\N
1562	\N	\N	\N	\N	\N	\N
1563	\N	\N	\N	\N	\N	\N
1564	\N	\N	\N	\N	\N	\N
1565	\N	\N	\N	\N	\N	\N
1566	\N	\N	\N	\N	\N	\N
1567	\N	\N	\N	\N	\N	\N
1568	\N	\N	\N	\N	\N	\N
1569	\N	\N	\N	\N	\N	\N
1570	\N	\N	\N	\N	\N	\N
1571	\N	\N	\N	\N	\N	\N
1572	\N	\N	\N	\N	\N	\N
1573	\N	\N	\N	\N	\N	\N
1574	\N	\N	\N	\N	\N	\N
1575	\N	\N	\N	\N	\N	\N
1576	\N	\N	\N	\N	\N	\N
1577	\N	\N	\N	\N	\N	\N
1578	\N	\N	\N	\N	\N	\N
1579	\N	\N	\N	\N	\N	\N
1580	\N	\N	\N	\N	\N	\N
1581	\N	\N	\N	\N	\N	\N
1582	\N	\N	\N	\N	\N	\N
1583	\N	\N	\N	\N	\N	\N
1584	\N	\N	\N	\N	\N	\N
1585	\N	\N	\N	\N	\N	\N
1586	\N	\N	\N	\N	\N	\N
1587	\N	\N	\N	\N	\N	\N
1588	\N	\N	\N	\N	\N	\N
1589	\N	\N	\N	\N	\N	\N
1590	\N	\N	\N	\N	\N	\N
1591	\N	\N	\N	\N	\N	\N
1592	\N	\N	\N	\N	\N	\N
1593	\N	\N	\N	\N	\N	\N
1594	\N	\N	\N	\N	\N	\N
1595	\N	\N	\N	\N	\N	\N
1596	\N	\N	\N	\N	\N	\N
1597	\N	\N	\N	\N	\N	\N
1598	\N	\N	\N	\N	\N	\N
1599	\N	\N	\N	\N	\N	\N
1600	\N	\N	\N	\N	\N	\N
1601	\N	\N	\N	\N	\N	\N
1602	\N	\N	\N	\N	\N	\N
1603	\N	\N	\N	\N	\N	\N
1604	\N	\N	\N	\N	\N	\N
1605	\N	\N	\N	\N	\N	\N
1606	\N	\N	\N	\N	\N	\N
1607	\N	\N	\N	\N	\N	\N
1608	\N	\N	\N	\N	\N	\N
1609	\N	\N	\N	\N	\N	\N
1610	\N	\N	\N	\N	\N	\N
1611	\N	\N	\N	\N	\N	\N
1612	\N	\N	\N	\N	\N	\N
1613	\N	\N	\N	\N	\N	\N
1614	\N	\N	\N	\N	\N	\N
1615	\N	\N	\N	\N	\N	\N
1616	\N	\N	\N	\N	\N	\N
1617	\N	\N	\N	\N	\N	\N
1618	\N	\N	\N	\N	\N	\N
1619	\N	\N	\N	\N	\N	\N
1620	\N	\N	\N	\N	\N	\N
1621	\N	\N	\N	\N	\N	\N
1622	\N	\N	\N	\N	\N	\N
1623	\N	\N	\N	\N	\N	\N
1624	\N	\N	\N	\N	\N	\N
1625	\N	\N	\N	\N	\N	\N
1626	\N	\N	\N	\N	\N	\N
1627	\N	\N	\N	\N	\N	\N
1628	\N	\N	\N	\N	\N	\N
1629	\N	\N	\N	\N	\N	\N
1630	\N	\N	\N	\N	\N	\N
1631	\N	\N	\N	\N	\N	\N
1632	\N	\N	\N	\N	\N	\N
1633	\N	\N	\N	\N	\N	\N
1634	\N	\N	\N	\N	\N	\N
1635	\N	\N	\N	\N	\N	\N
1636	\N	\N	\N	\N	\N	\N
1637	\N	\N	\N	\N	\N	\N
1638	\N	\N	\N	\N	\N	\N
1639	\N	\N	\N	\N	\N	\N
1640	\N	\N	\N	\N	\N	\N
1641	\N	\N	\N	\N	\N	\N
1642	\N	\N	\N	\N	\N	\N
1643	\N	\N	\N	\N	\N	\N
1644	\N	\N	\N	\N	\N	\N
1645	\N	\N	\N	\N	\N	\N
1646	\N	\N	\N	\N	\N	\N
1647	\N	\N	\N	\N	\N	\N
1648	\N	\N	\N	\N	\N	\N
1649	\N	\N	\N	\N	\N	\N
1650	\N	\N	\N	\N	\N	\N
1651	\N	\N	\N	\N	\N	\N
1652	\N	\N	\N	\N	\N	\N
1653	\N	\N	\N	\N	\N	\N
1654	\N	\N	\N	\N	\N	\N
1655	\N	\N	\N	\N	\N	\N
1656	\N	\N	\N	\N	\N	\N
1657	\N	\N	\N	\N	\N	\N
1658	\N	\N	\N	\N	\N	\N
1659	\N	\N	\N	\N	\N	\N
1660	\N	\N	\N	\N	\N	\N
1661	\N	\N	\N	\N	\N	\N
1662	\N	\N	\N	\N	\N	\N
1663	\N	\N	\N	\N	\N	\N
1664	\N	\N	\N	\N	\N	\N
1665	\N	\N	\N	\N	\N	\N
1666	\N	\N	\N	\N	\N	\N
1667	\N	\N	\N	\N	\N	\N
1668	\N	\N	\N	\N	\N	\N
1669	\N	\N	\N	\N	\N	\N
1670	\N	\N	\N	\N	\N	\N
1671	\N	\N	\N	\N	\N	\N
1672	\N	\N	\N	\N	\N	\N
1673	\N	\N	\N	\N	\N	\N
1674	\N	\N	\N	\N	\N	\N
1675	\N	\N	\N	\N	\N	\N
1676	\N	\N	\N	\N	\N	\N
1677	\N	\N	\N	\N	\N	\N
1678	\N	\N	\N	\N	\N	\N
1679	\N	\N	\N	\N	\N	\N
1680	\N	\N	\N	\N	\N	\N
1681	\N	\N	\N	\N	\N	\N
1682	\N	\N	\N	\N	\N	\N
1683	\N	\N	\N	\N	\N	\N
1684	\N	\N	\N	\N	\N	\N
1685	\N	\N	\N	\N	\N	\N
1686	\N	\N	\N	\N	\N	\N
1687	\N	\N	\N	\N	\N	\N
1688	\N	\N	\N	\N	\N	\N
1689	\N	\N	\N	\N	\N	\N
1690	\N	\N	\N	\N	\N	\N
1691	\N	\N	\N	\N	\N	\N
1692	\N	\N	\N	\N	\N	\N
1693	\N	\N	\N	\N	\N	\N
1694	\N	\N	\N	\N	\N	\N
1695	\N	\N	\N	\N	\N	\N
1696	\N	\N	\N	\N	\N	\N
1697	\N	\N	\N	\N	\N	\N
1698	\N	\N	\N	\N	\N	\N
1699	\N	\N	\N	\N	\N	\N
1700	\N	\N	\N	\N	\N	\N
1701	\N	\N	\N	\N	\N	\N
1702	\N	\N	\N	\N	\N	\N
1703	\N	\N	\N	\N	\N	\N
1704	\N	\N	\N	\N	\N	\N
1705	\N	\N	\N	\N	\N	\N
1706	\N	\N	\N	\N	\N	\N
1707	\N	\N	\N	\N	\N	\N
1708	\N	\N	\N	\N	\N	\N
1709	\N	\N	\N	\N	\N	\N
1710	\N	\N	\N	\N	\N	\N
1711	\N	\N	\N	\N	\N	\N
1712	\N	\N	\N	\N	\N	\N
1713	\N	\N	\N	\N	\N	\N
1714	\N	\N	\N	\N	\N	\N
1715	\N	\N	\N	\N	\N	\N
1716	\N	\N	\N	\N	\N	\N
1717	\N	\N	\N	\N	\N	\N
1718	\N	\N	\N	\N	\N	\N
1719	\N	\N	\N	\N	\N	\N
1720	\N	\N	\N	\N	\N	\N
1721	\N	\N	\N	\N	\N	\N
1722	\N	\N	\N	\N	\N	\N
1723	\N	\N	\N	\N	\N	\N
1724	\N	\N	\N	\N	\N	\N
1725	\N	\N	\N	\N	\N	\N
1726	\N	\N	\N	\N	\N	\N
1727	\N	\N	\N	\N	\N	\N
1728	\N	\N	\N	\N	\N	\N
1729	\N	\N	\N	\N	\N	\N
1730	\N	\N	\N	\N	\N	\N
1731	\N	\N	\N	\N	\N	\N
1732	\N	\N	\N	\N	\N	\N
1733	\N	\N	\N	\N	\N	\N
1734	\N	\N	\N	\N	\N	\N
1735	\N	\N	\N	\N	\N	\N
1736	\N	\N	\N	\N	\N	\N
1737	\N	\N	\N	\N	\N	\N
1738	\N	\N	\N	\N	\N	\N
1739	\N	\N	\N	\N	\N	\N
1740	\N	\N	\N	\N	\N	\N
1741	\N	\N	\N	\N	\N	\N
1742	\N	\N	\N	\N	\N	\N
1743	\N	\N	\N	\N	\N	\N
1744	\N	\N	\N	\N	\N	\N
1745	\N	\N	\N	\N	\N	\N
1746	\N	\N	\N	\N	\N	\N
1747	\N	\N	\N	\N	\N	\N
1748	\N	\N	\N	\N	\N	\N
1749	\N	\N	\N	\N	\N	\N
1750	\N	\N	\N	\N	\N	\N
1751	\N	\N	\N	\N	\N	\N
1752	\N	\N	\N	\N	\N	\N
1753	\N	\N	\N	\N	\N	\N
1754	\N	\N	\N	\N	\N	\N
1755	\N	\N	\N	\N	\N	\N
1756	\N	\N	\N	\N	\N	\N
1757	\N	\N	\N	\N	\N	\N
1758	\N	\N	\N	\N	\N	\N
1759	\N	\N	\N	\N	\N	\N
1760	\N	\N	\N	\N	\N	\N
1761	\N	\N	\N	\N	\N	\N
1762	\N	\N	\N	\N	\N	\N
1763	\N	\N	\N	\N	\N	\N
1764	\N	\N	\N	\N	\N	\N
1765	\N	\N	\N	\N	\N	\N
1766	\N	\N	\N	\N	\N	\N
1767	\N	\N	\N	\N	\N	\N
1768	\N	\N	\N	\N	\N	\N
1769	\N	\N	\N	\N	\N	\N
1770	\N	\N	\N	\N	\N	\N
1771	\N	\N	\N	\N	\N	\N
1772	\N	\N	\N	\N	\N	\N
1773	\N	\N	\N	\N	\N	\N
1774	\N	\N	\N	\N	\N	\N
1775	\N	\N	\N	\N	\N	\N
1776	\N	\N	\N	\N	\N	\N
1777	\N	\N	\N	\N	\N	\N
1778	\N	\N	\N	\N	\N	\N
1779	\N	\N	\N	\N	\N	\N
1780	\N	\N	\N	\N	\N	\N
1781	\N	\N	\N	\N	\N	\N
1782	\N	\N	\N	\N	\N	\N
1783	\N	\N	\N	\N	\N	\N
1784	\N	\N	\N	\N	\N	\N
1785	\N	\N	\N	\N	\N	\N
1786	\N	\N	\N	\N	\N	\N
1787	\N	\N	\N	\N	\N	\N
1788	\N	\N	\N	\N	\N	\N
1789	\N	\N	\N	\N	\N	\N
1790	\N	\N	\N	\N	\N	\N
1791	\N	\N	\N	\N	\N	\N
1792	\N	\N	\N	\N	\N	\N
1793	\N	\N	\N	\N	\N	\N
1794	\N	\N	\N	\N	\N	\N
1795	\N	\N	\N	\N	\N	\N
1796	\N	\N	\N	\N	\N	\N
1797	\N	\N	\N	\N	\N	\N
1798	\N	\N	\N	\N	\N	\N
1799	\N	\N	\N	\N	\N	\N
1800	\N	\N	\N	\N	\N	\N
1801	\N	\N	\N	\N	\N	\N
1802	\N	\N	\N	\N	\N	\N
1803	\N	\N	\N	\N	\N	\N
1804	\N	\N	\N	\N	\N	\N
1805	\N	\N	\N	\N	\N	\N
1806	\N	\N	\N	\N	\N	\N
1807	\N	\N	\N	\N	\N	\N
1808	\N	\N	\N	\N	\N	\N
1809	\N	\N	\N	\N	\N	\N
1810	\N	\N	\N	\N	\N	\N
1811	\N	\N	\N	\N	\N	\N
1812	\N	\N	\N	\N	\N	\N
1813	\N	\N	\N	\N	\N	\N
1814	\N	\N	\N	\N	\N	\N
1815	\N	\N	\N	\N	\N	\N
1816	\N	\N	\N	\N	\N	\N
1817	\N	\N	\N	\N	\N	\N
1818	\N	\N	\N	\N	\N	\N
1819	\N	\N	\N	\N	\N	\N
1820	\N	\N	\N	\N	\N	\N
1821	\N	\N	\N	\N	\N	\N
1822	\N	\N	\N	\N	\N	\N
1823	\N	\N	\N	\N	\N	\N
1824	\N	\N	\N	\N	\N	\N
1825	\N	\N	\N	\N	\N	\N
1826	\N	\N	\N	\N	\N	\N
1827	\N	\N	\N	\N	\N	\N
1828	\N	\N	\N	\N	\N	\N
1829	\N	\N	\N	\N	\N	\N
1830	\N	\N	\N	\N	\N	\N
1831	\N	\N	\N	\N	\N	\N
1832	\N	\N	\N	\N	\N	\N
1833	\N	\N	\N	\N	\N	\N
1834	\N	\N	\N	\N	\N	\N
1835	\N	\N	\N	\N	\N	\N
1836	\N	\N	\N	\N	\N	\N
1837	\N	\N	\N	\N	\N	\N
1838	\N	\N	\N	\N	\N	\N
1839	\N	\N	\N	\N	\N	\N
1840	\N	\N	\N	\N	\N	\N
1841	\N	\N	\N	\N	\N	\N
1842	\N	\N	\N	\N	\N	\N
1843	\N	\N	\N	\N	\N	\N
1844	\N	\N	\N	\N	\N	\N
1845	\N	\N	\N	\N	\N	\N
1846	\N	\N	\N	\N	\N	\N
1847	\N	\N	\N	\N	\N	\N
1848	\N	\N	\N	\N	\N	\N
1849	\N	\N	\N	\N	\N	\N
1850	\N	\N	\N	\N	\N	\N
1851	\N	\N	\N	\N	\N	\N
1852	\N	\N	\N	\N	\N	\N
1853	\N	\N	\N	\N	\N	\N
1854	\N	\N	\N	\N	\N	\N
1855	\N	\N	\N	\N	\N	\N
1856	\N	\N	\N	\N	\N	\N
1857	\N	\N	\N	\N	\N	\N
1858	\N	\N	\N	\N	\N	\N
1859	\N	\N	\N	\N	\N	\N
1860	\N	\N	\N	\N	\N	\N
1861	\N	\N	\N	\N	\N	\N
1862	\N	\N	\N	\N	\N	\N
1863	\N	\N	\N	\N	\N	\N
1864	\N	\N	\N	\N	\N	\N
1865	\N	\N	\N	\N	\N	\N
1866	\N	\N	\N	\N	\N	\N
1867	\N	\N	\N	\N	\N	\N
1868	\N	\N	\N	\N	\N	\N
1869	\N	\N	\N	\N	\N	\N
1870	\N	\N	\N	\N	\N	\N
1871	\N	\N	\N	\N	\N	\N
1872	\N	\N	\N	\N	\N	\N
1873	\N	\N	\N	\N	\N	\N
1874	\N	\N	\N	\N	\N	\N
1875	\N	\N	\N	\N	\N	\N
1876	\N	\N	\N	\N	\N	\N
1877	\N	\N	\N	\N	\N	\N
1878	\N	\N	\N	\N	\N	\N
1879	\N	\N	\N	\N	\N	\N
1880	\N	\N	\N	\N	\N	\N
1881	\N	\N	\N	\N	\N	\N
1882	\N	\N	\N	\N	\N	\N
1883	\N	\N	\N	\N	\N	\N
1884	\N	\N	\N	\N	\N	\N
1885	\N	\N	\N	\N	\N	\N
1886	\N	\N	\N	\N	\N	\N
1887	\N	\N	\N	\N	\N	\N
1888	\N	\N	\N	\N	\N	\N
1889	\N	\N	\N	\N	\N	\N
1890	\N	\N	\N	\N	\N	\N
1891	\N	\N	\N	\N	\N	\N
1892	\N	\N	\N	\N	\N	\N
1893	\N	\N	\N	\N	\N	\N
1894	\N	\N	\N	\N	\N	\N
1895	\N	\N	\N	\N	\N	\N
1896	\N	\N	\N	\N	\N	\N
1897	\N	\N	\N	\N	\N	\N
1898	\N	\N	\N	\N	\N	\N
1899	\N	\N	\N	\N	\N	\N
1900	\N	\N	\N	\N	\N	\N
1901	\N	\N	\N	\N	\N	\N
1902	\N	\N	\N	\N	\N	\N
1903	\N	\N	\N	\N	\N	\N
1904	\N	\N	\N	\N	\N	\N
1905	\N	\N	\N	\N	\N	\N
1906	\N	\N	\N	\N	\N	\N
1907	\N	\N	\N	\N	\N	\N
1908	\N	\N	\N	\N	\N	\N
1909	\N	\N	\N	\N	\N	\N
1910	\N	\N	\N	\N	\N	\N
1911	\N	\N	\N	\N	\N	\N
1912	\N	\N	\N	\N	\N	\N
1913	\N	\N	\N	\N	\N	\N
1914	\N	\N	\N	\N	\N	\N
1915	\N	\N	\N	\N	\N	\N
1916	\N	\N	\N	\N	\N	\N
1917	\N	\N	\N	\N	\N	\N
1918	\N	\N	\N	\N	\N	\N
1919	\N	\N	\N	\N	\N	\N
1920	\N	\N	\N	\N	\N	\N
1921	\N	\N	\N	\N	\N	\N
1922	\N	\N	\N	\N	\N	\N
1923	\N	\N	\N	\N	\N	\N
1924	\N	\N	\N	\N	\N	\N
1925	\N	\N	\N	\N	\N	\N
1926	\N	\N	\N	\N	\N	\N
1927	\N	\N	\N	\N	\N	\N
1928	\N	\N	\N	\N	\N	\N
1929	\N	\N	\N	\N	\N	\N
1930	\N	\N	\N	\N	\N	\N
1931	\N	\N	\N	\N	\N	\N
1932	\N	\N	\N	\N	\N	\N
1933	\N	\N	\N	\N	\N	\N
1934	\N	\N	\N	\N	\N	\N
1935	\N	\N	\N	\N	\N	\N
1936	\N	\N	\N	\N	\N	\N
1937	\N	\N	\N	\N	\N	\N
1938	\N	\N	\N	\N	\N	\N
1939	\N	\N	\N	\N	\N	\N
1940	\N	\N	\N	\N	\N	\N
1941	\N	\N	\N	\N	\N	\N
1942	\N	\N	\N	\N	\N	\N
1943	\N	\N	\N	\N	\N	\N
1944	\N	\N	\N	\N	\N	\N
1945	\N	\N	\N	\N	\N	\N
1946	\N	\N	\N	\N	\N	\N
1947	\N	\N	\N	\N	\N	\N
1948	\N	\N	\N	\N	\N	\N
1949	\N	\N	\N	\N	\N	\N
1950	\N	\N	\N	\N	\N	\N
1951	\N	\N	\N	\N	\N	\N
1952	\N	\N	\N	\N	\N	\N
1953	\N	\N	\N	\N	\N	\N
1954	\N	\N	\N	\N	\N	\N
1955	\N	\N	\N	\N	\N	\N
1956	\N	\N	\N	\N	\N	\N
1957	\N	\N	\N	\N	\N	\N
1958	\N	\N	\N	\N	\N	\N
1959	\N	\N	\N	\N	\N	\N
1960	\N	\N	\N	\N	\N	\N
1961	\N	\N	\N	\N	\N	\N
1962	\N	\N	\N	\N	\N	\N
1963	\N	\N	\N	\N	\N	\N
1964	\N	\N	\N	\N	\N	\N
1965	\N	\N	\N	\N	\N	\N
1966	\N	\N	\N	\N	\N	\N
1967	\N	\N	\N	\N	\N	\N
1968	\N	\N	\N	\N	\N	\N
1969	\N	\N	\N	\N	\N	\N
1970	\N	\N	\N	\N	\N	\N
1971	\N	\N	\N	\N	\N	\N
1972	\N	\N	\N	\N	\N	\N
1973	\N	\N	\N	\N	\N	\N
1974	\N	\N	\N	\N	\N	\N
1975	\N	\N	\N	\N	\N	\N
1976	\N	\N	\N	\N	\N	\N
1977	\N	\N	\N	\N	\N	\N
1978	\N	\N	\N	\N	\N	\N
1979	\N	\N	\N	\N	\N	\N
1980	\N	\N	\N	\N	\N	\N
1981	\N	\N	\N	\N	\N	\N
1982	\N	\N	\N	\N	\N	\N
1983	\N	\N	\N	\N	\N	\N
1984	\N	\N	\N	\N	\N	\N
1985	\N	\N	\N	\N	\N	\N
1986	\N	\N	\N	\N	\N	\N
1987	\N	\N	\N	\N	\N	\N
1988	\N	\N	\N	\N	\N	\N
1989	\N	\N	\N	\N	\N	\N
1990	\N	\N	\N	\N	\N	\N
1991	\N	\N	\N	\N	\N	\N
1992	\N	\N	\N	\N	\N	\N
1993	\N	\N	\N	\N	\N	\N
1994	\N	\N	\N	\N	\N	\N
1995	\N	\N	\N	\N	\N	\N
1996	\N	\N	\N	\N	\N	\N
1997	\N	\N	\N	\N	\N	\N
1998	\N	\N	\N	\N	\N	\N
1999	\N	\N	\N	\N	\N	\N
2000	\N	\N	\N	\N	\N	\N
2001	\N	\N	\N	\N	\N	\N
2002	\N	\N	\N	\N	\N	\N
2003	\N	\N	\N	\N	\N	\N
2004	\N	\N	\N	\N	\N	\N
2005	\N	\N	\N	\N	\N	\N
2006	\N	\N	\N	\N	\N	\N
2007	\N	\N	\N	\N	\N	\N
2008	\N	\N	\N	\N	\N	\N
2009	\N	\N	\N	\N	\N	\N
2010	\N	\N	\N	\N	\N	\N
2011	\N	\N	\N	\N	\N	\N
2012	\N	\N	\N	\N	\N	\N
2013	\N	\N	\N	\N	\N	\N
2014	\N	\N	\N	\N	\N	\N
2015	\N	\N	\N	\N	\N	\N
2016	\N	\N	\N	\N	\N	\N
2017	\N	\N	\N	\N	\N	\N
2018	\N	\N	\N	\N	\N	\N
2019	\N	\N	\N	\N	\N	\N
2020	\N	\N	\N	\N	\N	\N
2021	\N	\N	\N	\N	\N	\N
2022	\N	\N	\N	\N	\N	\N
2023	\N	\N	\N	\N	\N	\N
2024	\N	\N	\N	\N	\N	\N
2025	\N	\N	\N	\N	\N	\N
2026	\N	\N	\N	\N	\N	\N
2027	\N	\N	\N	\N	\N	\N
2028	\N	\N	\N	\N	\N	\N
2029	\N	\N	\N	\N	\N	\N
2030	\N	\N	\N	\N	\N	\N
2031	\N	\N	\N	\N	\N	\N
2032	\N	\N	\N	\N	\N	\N
2033	\N	\N	\N	\N	\N	\N
2034	\N	\N	\N	\N	\N	\N
2035	\N	\N	\N	\N	\N	\N
2036	\N	\N	\N	\N	\N	\N
2037	\N	\N	\N	\N	\N	\N
2038	\N	\N	\N	\N	\N	\N
2039	\N	\N	\N	\N	\N	\N
2040	\N	\N	\N	\N	\N	\N
2041	\N	\N	\N	\N	\N	\N
2042	\N	\N	\N	\N	\N	\N
2043	\N	\N	\N	\N	\N	\N
2044	\N	\N	\N	\N	\N	\N
2045	\N	\N	\N	\N	\N	\N
2046	\N	\N	\N	\N	\N	\N
2047	\N	\N	\N	\N	\N	\N
2048	\N	\N	\N	\N	\N	\N
2049	\N	\N	\N	\N	\N	\N
2050	\N	\N	\N	\N	\N	\N
2051	\N	\N	\N	\N	\N	\N
2052	\N	\N	\N	\N	\N	\N
2053	\N	\N	\N	\N	\N	\N
2054	\N	\N	\N	\N	\N	\N
2055	\N	\N	\N	\N	\N	\N
2056	\N	\N	\N	\N	\N	\N
2057	\N	\N	\N	\N	\N	\N
2058	\N	\N	\N	\N	\N	\N
2059	\N	\N	\N	\N	\N	\N
2060	\N	\N	\N	\N	\N	\N
2061	\N	\N	\N	\N	\N	\N
2062	\N	\N	\N	\N	\N	\N
2063	\N	\N	\N	\N	\N	\N
2064	\N	\N	\N	\N	\N	\N
2065	\N	\N	\N	\N	\N	\N
2066	\N	\N	1.11	\N	\N	\N
2067	\N	\N	1.11	\N	\N	\N
2068	\N	\N	1.11	\N	\N	\N
2069	\N	\N	1.11	\N	\N	\N
2070	\N	\N	1.11	\N	\N	\N
2071	\N	\N	1.11	\N	\N	\N
2072	\N	\N	0.87	\N	\N	\N
2073	\N	\N	1.11	\N	\N	\N
2074	\N	\N	1.11	\N	\N	\N
2075	\N	\N	1.11	\N	\N	\N
2076	\N	\N	0.87	\N	\N	\N
2077	\N	\N	0.87	\N	\N	\N
2078	\N	\N	0.87	\N	\N	\N
2079	\N	\N	0.87	\N	\N	\N
2080	\N	\N	0.87	\N	\N	\N
2081	\N	\N	0.87	\N	\N	\N
2082	\N	\N	0.87	\N	\N	\N
2083	\N	\N	0.95	\N	\N	\N
2084	\N	\N	0.95	\N	\N	\N
2085	\N	\N	0.95	\N	\N	\N
2086	\N	\N	0.95	\N	\N	\N
2087	\N	\N	0.95	\N	\N	\N
2088	\N	\N	0.95	\N	\N	\N
2089	\N	\N	0.95	\N	\N	\N
2090	\N	\N	0.95	\N	\N	\N
2091	\N	\N	0.95	\N	\N	\N
2092	\N	\N	0.95	\N	\N	\N
2093	\N	\N	0.87	\N	\N	\N
2094	\N	\N	3	\N	\N	\N
2095	\N	\N	3	\N	\N	\N
2096	\N	\N	3	\N	\N	\N
2097	\N	\N	3	\N	\N	\N
2098	\N	\N	3	\N	\N	\N
2099	\N	\N	3	\N	\N	\N
2100	\N	\N	\N	\N	\N	\N
2101	\N	\N	\N	\N	\N	\N
2102	\N	\N	\N	\N	\N	\N
2103	\N	\N	\N	\N	\N	\N
2104	\N	\N	\N	\N	\N	\N
2105	\N	\N	\N	\N	\N	\N
2106	\N	\N	\N	\N	\N	\N
2107	\N	\N	\N	\N	\N	\N
2108	\N	\N	\N	\N	\N	\N
2109	\N	\N	\N	\N	\N	\N
2110	\N	\N	\N	\N	\N	\N
2111	\N	\N	\N	\N	\N	\N
2112	\N	\N	\N	\N	\N	\N
2113	\N	\N	\N	\N	\N	\N
2114	\N	\N	\N	\N	\N	\N
2115	\N	\N	\N	\N	\N	\N
2116	\N	\N	\N	\N	\N	\N
2117	\N	\N	\N	\N	\N	\N
2118	\N	\N	\N	\N	\N	\N
2119	\N	\N	\N	\N	\N	\N
2120	\N	\N	\N	\N	\N	\N
2121	\N	\N	\N	\N	\N	\N
2122	\N	\N	\N	\N	\N	\N
2123	\N	\N	\N	\N	\N	\N
2124	\N	\N	\N	\N	\N	\N
2125	\N	\N	\N	\N	\N	\N
2126	\N	\N	\N	\N	\N	\N
2127	\N	\N	\N	\N	\N	\N
2128	\N	\N	\N	\N	\N	\N
2129	\N	\N	\N	\N	\N	\N
2130	\N	\N	\N	\N	\N	\N
2131	\N	\N	\N	\N	\N	\N
2132	\N	\N	\N	\N	\N	\N
2133	\N	\N	\N	\N	\N	\N
2134	\N	\N	\N	\N	\N	\N
2135	\N	\N	\N	\N	\N	\N
2136	\N	\N	\N	\N	\N	\N
2137	\N	\N	\N	\N	\N	\N
2138	\N	\N	\N	\N	\N	\N
2139	\N	\N	\N	\N	\N	\N
2140	\N	\N	\N	\N	\N	\N
2141	\N	\N	\N	\N	\N	\N
2142	\N	\N	\N	\N	\N	\N
2143	\N	\N	\N	\N	\N	\N
2144	\N	\N	\N	\N	\N	\N
2145	\N	\N	\N	\N	\N	\N
2146	\N	\N	\N	\N	\N	\N
2147	\N	\N	\N	\N	\N	\N
2148	\N	\N	\N	\N	\N	\N
2149	\N	\N	\N	\N	\N	\N
2150	\N	\N	\N	\N	\N	\N
2151	\N	\N	\N	\N	\N	\N
2152	\N	\N	\N	\N	\N	\N
2153	\N	\N	\N	\N	\N	\N
2154	\N	\N	\N	\N	\N	\N
2155	\N	\N	\N	\N	\N	\N
2156	\N	\N	\N	\N	\N	\N
2157	\N	\N	\N	\N	\N	\N
2158	\N	\N	\N	\N	\N	\N
2159	\N	\N	\N	\N	\N	\N
2160	\N	\N	\N	\N	\N	\N
2161	\N	\N	\N	\N	\N	\N
2162	\N	\N	\N	\N	\N	\N
2163	\N	\N	\N	\N	\N	\N
2164	\N	\N	\N	\N	\N	\N
2165	\N	\N	\N	\N	\N	\N
2166	\N	\N	\N	\N	\N	\N
2167	\N	\N	\N	\N	\N	\N
2168	\N	\N	\N	\N	\N	\N
2169	\N	\N	\N	\N	\N	\N
2170	\N	\N	\N	\N	\N	\N
2171	\N	\N	\N	\N	\N	\N
2172	\N	\N	\N	\N	\N	\N
2173	\N	\N	\N	\N	\N	\N
2174	\N	\N	\N	\N	\N	\N
2175	\N	\N	\N	\N	\N	\N
2176	\N	\N	\N	\N	\N	\N
2177	\N	\N	\N	\N	\N	\N
2178	\N	\N	\N	\N	\N	\N
2179	\N	\N	\N	\N	\N	\N
2180	\N	\N	\N	\N	\N	\N
2181	\N	\N	\N	\N	\N	\N
2182	\N	\N	\N	\N	\N	\N
2183	\N	\N	\N	\N	\N	\N
2184	\N	\N	\N	\N	\N	\N
2185	\N	\N	\N	\N	\N	\N
2186	\N	\N	\N	\N	\N	\N
2187	\N	\N	\N	\N	\N	\N
2188	\N	\N	\N	\N	\N	\N
2189	\N	\N	\N	\N	\N	\N
2190	\N	\N	\N	\N	\N	\N
2191	\N	\N	\N	\N	\N	\N
2192	\N	\N	\N	\N	\N	\N
2193	\N	\N	\N	\N	\N	\N
2194	\N	\N	\N	\N	\N	\N
2195	\N	\N	\N	\N	\N	\N
2196	\N	\N	\N	\N	\N	\N
2197	\N	\N	\N	\N	\N	\N
2198	\N	\N	\N	\N	\N	\N
2199	\N	\N	\N	\N	\N	\N
2200	\N	\N	\N	\N	\N	\N
2201	\N	\N	\N	\N	\N	\N
2202	\N	\N	\N	\N	\N	\N
2203	\N	\N	\N	\N	\N	\N
2204	\N	\N	\N	\N	\N	\N
2205	\N	\N	\N	\N	\N	\N
2206	\N	\N	\N	\N	\N	\N
2207	\N	\N	\N	\N	\N	\N
2208	\N	\N	\N	\N	\N	\N
2209	\N	\N	\N	\N	\N	\N
2210	\N	\N	\N	\N	\N	\N
2211	\N	\N	\N	\N	\N	\N
2212	\N	\N	\N	\N	\N	\N
2213	\N	\N	\N	\N	\N	\N
2214	\N	\N	\N	\N	\N	\N
2215	\N	\N	\N	\N	\N	\N
2216	\N	\N	\N	\N	\N	\N
2217	\N	\N	\N	\N	\N	\N
2218	\N	\N	\N	\N	\N	\N
2219	\N	\N	\N	\N	\N	\N
2220	\N	\N	\N	\N	\N	\N
2221	\N	\N	\N	\N	\N	\N
2222	\N	\N	\N	\N	\N	\N
2223	\N	\N	\N	\N	\N	\N
2224	\N	\N	\N	\N	\N	\N
2225	\N	\N	\N	\N	\N	\N
2226	\N	\N	\N	\N	\N	\N
2227	\N	\N	\N	\N	\N	\N
2228	\N	\N	\N	\N	\N	\N
2229	\N	\N	\N	\N	\N	\N
2230	\N	\N	\N	\N	\N	\N
2231	\N	\N	\N	\N	\N	\N
2232	\N	\N	\N	\N	\N	\N
2233	\N	\N	\N	\N	\N	\N
2234	\N	\N	\N	\N	\N	\N
2235	\N	\N	\N	\N	\N	\N
2236	\N	\N	\N	\N	\N	\N
2237	\N	\N	\N	\N	\N	\N
2238	\N	\N	\N	\N	\N	\N
2239	\N	\N	\N	\N	\N	\N
2240	\N	\N	\N	\N	\N	\N
2241	\N	\N	\N	\N	\N	\N
2242	\N	\N	\N	\N	\N	\N
2243	\N	\N	\N	\N	\N	\N
2244	\N	\N	\N	\N	\N	\N
2245	\N	\N	\N	\N	\N	\N
2246	\N	\N	\N	\N	\N	\N
2247	\N	\N	\N	\N	\N	\N
2248	\N	\N	\N	\N	\N	\N
2249	\N	\N	\N	\N	\N	\N
2250	\N	\N	\N	\N	\N	\N
2251	\N	\N	\N	\N	\N	\N
2252	\N	\N	\N	\N	\N	\N
2253	\N	\N	\N	\N	\N	\N
2254	\N	\N	\N	\N	\N	\N
2255	\N	\N	\N	\N	\N	\N
2256	\N	\N	\N	\N	\N	\N
2257	\N	\N	\N	\N	\N	\N
2258	\N	\N	\N	\N	\N	\N
2259	\N	\N	\N	\N	\N	\N
2260	\N	\N	\N	\N	\N	\N
2261	\N	\N	\N	\N	\N	\N
2262	\N	\N	\N	\N	\N	\N
2263	\N	\N	\N	\N	\N	\N
2264	\N	\N	\N	\N	\N	\N
2265	\N	\N	\N	\N	\N	\N
2266	\N	\N	\N	\N	\N	\N
2267	\N	\N	\N	\N	\N	\N
2268	\N	\N	\N	\N	\N	\N
2269	\N	\N	\N	\N	\N	\N
2270	\N	\N	\N	\N	\N	\N
2271	\N	\N	\N	\N	\N	\N
2272	\N	\N	\N	\N	\N	\N
2273	\N	\N	\N	\N	\N	\N
2274	\N	\N	\N	\N	\N	\N
2275	\N	\N	\N	\N	\N	\N
2276	\N	\N	\N	\N	\N	\N
2277	\N	\N	\N	\N	\N	\N
2278	\N	\N	\N	\N	\N	\N
2279	\N	\N	\N	\N	\N	\N
2280	\N	\N	\N	\N	\N	\N
2281	\N	\N	\N	\N	\N	\N
2282	\N	\N	\N	\N	\N	\N
2283	\N	\N	\N	\N	\N	\N
2284	\N	\N	\N	\N	\N	\N
2285	\N	\N	\N	\N	\N	\N
2286	\N	\N	\N	\N	\N	\N
2287	\N	\N	\N	\N	\N	\N
2288	\N	\N	\N	\N	\N	\N
2289	\N	\N	\N	\N	\N	\N
2290	\N	\N	\N	\N	\N	\N
2291	\N	\N	\N	\N	\N	\N
2292	\N	\N	\N	\N	\N	\N
2293	\N	\N	\N	\N	\N	\N
2294	\N	\N	\N	\N	\N	\N
2295	\N	\N	\N	\N	\N	\N
2296	\N	\N	\N	\N	\N	\N
2297	\N	\N	\N	\N	\N	\N
2298	\N	\N	\N	\N	\N	\N
2299	\N	\N	\N	\N	\N	\N
2300	\N	\N	\N	\N	\N	\N
2301	\N	\N	\N	\N	\N	\N
2302	\N	\N	\N	\N	\N	\N
2303	\N	\N	\N	\N	\N	\N
2304	\N	\N	\N	\N	\N	\N
2305	\N	\N	\N	\N	\N	\N
2306	\N	\N	\N	\N	\N	\N
2307	\N	\N	\N	\N	\N	\N
2308	\N	\N	\N	\N	\N	\N
2309	\N	\N	\N	\N	\N	\N
2310	\N	\N	\N	\N	\N	\N
2311	\N	\N	\N	\N	\N	\N
2312	\N	\N	\N	\N	\N	\N
2313	\N	\N	\N	\N	\N	\N
2314	\N	\N	\N	\N	\N	\N
2315	\N	\N	\N	\N	\N	\N
2316	\N	\N	\N	\N	\N	\N
2317	\N	\N	\N	\N	\N	\N
2318	\N	\N	\N	\N	\N	\N
2319	\N	\N	\N	\N	\N	\N
2320	\N	\N	\N	\N	\N	\N
2321	\N	\N	\N	\N	\N	\N
2322	\N	\N	\N	\N	\N	\N
2323	\N	\N	\N	\N	\N	\N
2324	\N	\N	\N	\N	\N	\N
2325	\N	\N	\N	\N	\N	\N
2326	\N	\N	\N	\N	\N	\N
2327	\N	\N	\N	\N	\N	\N
2328	\N	\N	\N	\N	\N	\N
2329	\N	\N	\N	\N	\N	\N
2330	\N	\N	\N	\N	\N	\N
2331	\N	\N	\N	\N	\N	\N
2332	\N	\N	\N	\N	\N	\N
2333	\N	\N	\N	\N	\N	\N
2334	\N	\N	\N	\N	\N	\N
2335	\N	\N	\N	\N	\N	\N
2336	\N	\N	\N	\N	\N	\N
2337	\N	\N	\N	\N	\N	\N
2338	\N	\N	\N	\N	\N	\N
2339	\N	\N	\N	\N	\N	\N
2340	\N	\N	\N	\N	\N	\N
2341	\N	\N	\N	\N	\N	\N
2342	\N	\N	\N	\N	\N	\N
2343	\N	\N	\N	\N	\N	\N
2344	\N	\N	\N	\N	\N	\N
2345	\N	\N	\N	\N	\N	\N
2346	\N	\N	\N	\N	\N	\N
2347	\N	\N	\N	\N	\N	\N
2348	\N	\N	\N	\N	\N	\N
2349	\N	\N	\N	\N	\N	\N
2350	\N	\N	\N	\N	\N	\N
2351	\N	\N	\N	\N	\N	\N
2352	\N	\N	\N	\N	\N	\N
2353	\N	\N	\N	\N	\N	\N
2354	\N	\N	\N	\N	\N	\N
2355	\N	\N	\N	\N	\N	\N
2356	\N	\N	\N	\N	\N	\N
2357	\N	\N	\N	\N	\N	\N
2358	\N	\N	\N	\N	\N	\N
2359	\N	\N	\N	\N	\N	\N
2360	\N	\N	\N	\N	\N	\N
2361	\N	\N	\N	\N	\N	\N
2362	\N	\N	\N	\N	\N	\N
2363	\N	\N	\N	\N	\N	\N
2364	\N	\N	\N	\N	\N	\N
2365	\N	\N	\N	\N	\N	\N
2366	\N	\N	\N	\N	\N	\N
2367	\N	\N	\N	\N	\N	\N
2368	\N	\N	\N	\N	\N	\N
2369	\N	\N	\N	\N	\N	\N
2370	\N	\N	\N	\N	\N	\N
2371	\N	\N	\N	\N	\N	\N
2372	\N	\N	\N	\N	\N	\N
2373	\N	\N	\N	\N	\N	\N
2374	\N	\N	\N	\N	\N	\N
2375	\N	\N	\N	\N	\N	\N
2376	\N	\N	\N	\N	\N	\N
2377	\N	\N	\N	\N	\N	\N
2378	\N	\N	\N	\N	\N	\N
2379	\N	\N	\N	\N	\N	\N
2380	\N	\N	\N	\N	\N	\N
2381	\N	\N	\N	\N	\N	\N
2382	\N	\N	\N	\N	\N	\N
2383	\N	\N	\N	\N	\N	\N
2384	\N	\N	\N	\N	\N	\N
2385	\N	\N	\N	\N	\N	\N
2386	\N	\N	\N	\N	\N	\N
2387	\N	\N	\N	\N	\N	\N
2388	\N	\N	\N	\N	\N	\N
2389	\N	\N	\N	\N	\N	\N
2390	\N	\N	\N	\N	\N	\N
2391	\N	\N	\N	\N	\N	\N
2392	\N	\N	\N	\N	\N	\N
2393	\N	\N	\N	\N	\N	\N
2394	\N	\N	\N	\N	\N	\N
2395	\N	\N	\N	\N	\N	\N
2396	\N	\N	\N	\N	\N	\N
2397	\N	\N	\N	\N	\N	\N
2398	\N	\N	\N	\N	\N	\N
2399	\N	\N	\N	\N	\N	\N
2400	\N	\N	\N	\N	\N	\N
2401	\N	\N	\N	\N	\N	\N
2402	\N	\N	\N	\N	\N	\N
2403	\N	\N	\N	\N	\N	\N
2404	\N	\N	\N	\N	\N	\N
2405	\N	\N	\N	\N	\N	\N
2406	\N	\N	\N	\N	\N	\N
2407	\N	\N	\N	\N	\N	\N
2408	\N	\N	\N	\N	\N	\N
2409	\N	\N	\N	\N	\N	\N
2410	\N	\N	\N	\N	\N	\N
2411	\N	\N	\N	\N	\N	\N
2412	\N	\N	\N	\N	\N	\N
2413	\N	\N	\N	\N	\N	\N
2414	\N	\N	\N	\N	\N	\N
2415	\N	\N	\N	\N	\N	\N
2416	\N	\N	\N	\N	\N	\N
2417	\N	\N	\N	\N	\N	\N
2418	\N	\N	\N	\N	\N	\N
2419	\N	\N	\N	\N	\N	\N
2420	\N	\N	\N	\N	\N	\N
2421	\N	\N	\N	\N	\N	\N
2422	\N	\N	\N	\N	\N	\N
2423	\N	\N	\N	\N	\N	\N
2424	\N	\N	\N	\N	\N	\N
2425	\N	\N	\N	\N	\N	\N
2426	\N	\N	\N	\N	\N	\N
2427	\N	\N	\N	\N	\N	\N
2428	\N	\N	\N	\N	\N	\N
2429	\N	\N	\N	\N	\N	\N
2430	\N	\N	\N	\N	\N	\N
2431	\N	\N	\N	\N	\N	\N
2432	\N	\N	\N	\N	\N	\N
2433	\N	\N	\N	\N	\N	\N
2434	\N	\N	\N	\N	\N	\N
2435	\N	\N	\N	\N	\N	\N
2436	\N	\N	\N	\N	\N	\N
2437	\N	\N	\N	\N	\N	\N
2438	\N	\N	\N	\N	\N	\N
2439	\N	\N	\N	\N	\N	\N
2440	\N	\N	\N	\N	\N	\N
2441	\N	\N	\N	\N	\N	\N
2442	\N	\N	\N	\N	\N	\N
2443	\N	\N	\N	\N	\N	\N
2444	\N	\N	\N	\N	\N	\N
2445	\N	\N	\N	\N	\N	\N
2446	\N	\N	\N	\N	\N	\N
2447	\N	\N	\N	\N	\N	\N
2448	\N	\N	\N	\N	\N	\N
2449	\N	\N	\N	\N	\N	\N
2450	\N	\N	\N	\N	\N	\N
2451	\N	\N	\N	\N	\N	\N
2452	\N	\N	\N	\N	\N	\N
2453	\N	\N	\N	\N	\N	\N
2454	\N	\N	\N	\N	\N	\N
2455	\N	\N	\N	\N	\N	\N
2456	\N	\N	\N	\N	\N	\N
2457	\N	\N	\N	\N	\N	\N
2458	\N	\N	\N	\N	\N	\N
2459	\N	\N	\N	\N	\N	\N
2460	\N	\N	\N	\N	\N	\N
2461	\N	\N	\N	\N	\N	\N
2462	\N	\N	\N	\N	\N	\N
2463	\N	\N	\N	\N	\N	\N
2464	\N	\N	\N	\N	\N	\N
2465	\N	\N	\N	\N	\N	\N
2466	\N	\N	\N	\N	\N	\N
2467	\N	\N	\N	\N	\N	\N
2468	\N	\N	\N	\N	\N	\N
2469	\N	\N	\N	\N	\N	\N
2470	\N	\N	\N	\N	\N	\N
2471	\N	\N	\N	\N	\N	\N
2472	\N	\N	\N	\N	\N	\N
2473	\N	\N	\N	\N	\N	\N
2474	\N	\N	\N	\N	\N	\N
2475	\N	\N	\N	\N	\N	\N
2476	\N	\N	\N	\N	\N	\N
2477	\N	\N	\N	\N	\N	\N
2478	\N	\N	\N	\N	\N	\N
2479	\N	\N	\N	\N	\N	\N
2480	\N	\N	\N	\N	\N	\N
2481	\N	\N	\N	\N	\N	\N
2482	\N	\N	\N	\N	\N	\N
2483	\N	\N	\N	\N	\N	\N
2484	\N	\N	\N	\N	\N	\N
2485	\N	\N	\N	\N	\N	\N
2486	\N	\N	\N	\N	\N	\N
2487	\N	\N	\N	\N	\N	\N
2488	\N	\N	\N	\N	\N	\N
2489	\N	\N	\N	\N	\N	\N
2490	\N	\N	\N	\N	\N	\N
2491	\N	\N	\N	\N	\N	\N
2492	\N	\N	\N	\N	\N	\N
2493	\N	\N	\N	\N	\N	\N
2494	\N	\N	\N	\N	\N	\N
2495	\N	\N	\N	\N	\N	\N
2496	\N	\N	\N	\N	\N	\N
2497	\N	\N	\N	\N	\N	\N
2498	\N	\N	\N	\N	\N	\N
2499	\N	\N	\N	\N	\N	\N
2500	\N	\N	\N	\N	\N	\N
2501	\N	\N	\N	\N	\N	\N
2502	\N	\N	\N	\N	\N	\N
2503	\N	\N	\N	\N	\N	\N
2504	\N	\N	\N	\N	\N	\N
2505	\N	\N	\N	\N	\N	\N
2506	\N	\N	\N	\N	\N	\N
2507	\N	\N	\N	\N	\N	\N
2508	\N	\N	\N	\N	\N	\N
2509	\N	\N	\N	\N	\N	\N
2510	\N	\N	\N	\N	\N	\N
2511	\N	\N	\N	\N	\N	\N
2512	\N	\N	\N	\N	\N	\N
2513	\N	\N	\N	\N	\N	\N
2514	\N	\N	\N	\N	\N	\N
2515	\N	\N	\N	\N	\N	\N
2516	\N	\N	\N	\N	\N	\N
2517	\N	\N	\N	\N	\N	\N
2518	\N	\N	\N	\N	\N	\N
2519	\N	\N	\N	\N	\N	\N
2520	\N	\N	\N	\N	\N	\N
2521	\N	\N	\N	\N	\N	\N
2522	\N	\N	\N	\N	\N	\N
2523	\N	\N	\N	\N	\N	\N
2524	\N	\N	\N	\N	\N	\N
2525	\N	\N	\N	\N	\N	\N
2526	\N	\N	\N	\N	\N	\N
2527	\N	\N	\N	\N	\N	\N
2528	\N	\N	\N	\N	\N	\N
2529	\N	\N	\N	\N	\N	\N
2530	\N	\N	\N	\N	\N	\N
2531	\N	\N	\N	\N	\N	\N
2532	\N	\N	\N	\N	\N	\N
2533	\N	\N	\N	\N	\N	\N
2534	\N	\N	\N	\N	\N	\N
2535	\N	\N	\N	\N	\N	\N
2536	\N	\N	\N	\N	\N	\N
2537	\N	\N	\N	\N	\N	\N
2538	\N	\N	\N	\N	\N	\N
2539	\N	\N	\N	\N	\N	\N
2540	\N	\N	\N	\N	\N	\N
2541	\N	\N	\N	\N	\N	\N
2542	\N	\N	\N	\N	\N	\N
2543	\N	\N	\N	\N	\N	\N
2544	\N	\N	\N	\N	\N	\N
2545	\N	\N	\N	\N	\N	\N
2546	\N	\N	\N	\N	\N	\N
2547	\N	\N	\N	\N	\N	\N
2548	\N	\N	\N	\N	\N	\N
2549	\N	\N	\N	\N	\N	\N
2550	\N	\N	\N	\N	\N	\N
2551	\N	\N	\N	\N	\N	\N
2552	\N	\N	\N	\N	\N	\N
2553	\N	\N	\N	\N	\N	\N
2554	\N	\N	\N	\N	\N	\N
2555	\N	\N	\N	\N	\N	\N
2556	\N	\N	\N	\N	\N	\N
2557	\N	\N	\N	\N	\N	\N
2558	\N	\N	\N	\N	\N	\N
2559	\N	\N	\N	\N	\N	\N
2560	\N	\N	\N	\N	\N	\N
2561	\N	\N	\N	\N	\N	\N
2562	\N	\N	\N	\N	\N	\N
2563	\N	\N	\N	\N	\N	\N
2564	\N	\N	\N	\N	\N	\N
2565	\N	\N	\N	\N	\N	\N
2566	\N	\N	\N	\N	\N	\N
2567	\N	\N	\N	\N	\N	\N
2568	\N	\N	\N	\N	\N	\N
2569	\N	\N	\N	\N	\N	\N
2570	\N	\N	\N	\N	\N	\N
2571	\N	\N	\N	\N	\N	\N
2572	\N	\N	\N	\N	\N	\N
2573	\N	\N	\N	\N	\N	\N
2574	\N	\N	\N	\N	\N	\N
2575	\N	\N	\N	\N	\N	\N
2576	\N	\N	\N	\N	\N	\N
2577	\N	\N	\N	\N	\N	\N
2578	\N	\N	\N	\N	\N	\N
2579	\N	\N	\N	\N	\N	\N
2580	\N	\N	\N	\N	\N	\N
2581	\N	\N	\N	\N	\N	\N
2582	\N	\N	\N	\N	\N	\N
2583	\N	\N	\N	\N	\N	\N
2584	\N	\N	\N	\N	\N	\N
2585	\N	\N	\N	\N	\N	\N
2586	\N	\N	\N	\N	\N	\N
2587	\N	\N	\N	\N	\N	\N
2588	\N	\N	\N	\N	\N	\N
2589	\N	\N	\N	\N	\N	\N
2590	\N	\N	\N	\N	\N	\N
2591	\N	\N	\N	\N	\N	\N
2592	\N	\N	\N	\N	\N	\N
2593	\N	\N	\N	\N	\N	\N
2594	\N	\N	\N	\N	\N	\N
2595	\N	\N	\N	\N	\N	\N
2596	\N	\N	\N	\N	\N	\N
2597	\N	\N	\N	\N	\N	\N
2598	\N	\N	\N	\N	\N	\N
2599	\N	\N	\N	\N	\N	\N
2600	\N	\N	\N	\N	\N	\N
2601	\N	\N	\N	\N	\N	\N
2602	\N	\N	\N	\N	\N	\N
2603	\N	\N	\N	\N	\N	\N
2604	\N	\N	\N	\N	\N	\N
2605	\N	\N	\N	\N	\N	\N
2606	\N	\N	\N	\N	\N	\N
2607	\N	\N	\N	\N	\N	\N
2608	\N	\N	\N	\N	\N	\N
2609	\N	\N	\N	\N	\N	\N
2610	\N	\N	\N	\N	\N	\N
2611	\N	\N	\N	\N	\N	\N
2612	\N	\N	\N	\N	\N	\N
2613	\N	\N	\N	\N	\N	\N
2614	\N	\N	\N	\N	\N	\N
2615	\N	\N	\N	\N	\N	\N
2616	\N	\N	\N	\N	\N	\N
2617	\N	\N	\N	\N	\N	\N
2618	\N	\N	\N	\N	\N	\N
2619	\N	\N	\N	\N	\N	\N
2620	\N	\N	\N	\N	\N	\N
2621	\N	\N	\N	\N	\N	\N
2622	\N	\N	\N	\N	\N	\N
2623	\N	\N	\N	\N	\N	\N
2624	\N	\N	\N	\N	\N	\N
2625	\N	\N	\N	\N	\N	\N
2626	\N	\N	\N	\N	\N	\N
2627	\N	\N	\N	\N	\N	\N
2628	\N	\N	\N	\N	\N	\N
2629	\N	\N	\N	\N	\N	\N
2630	\N	\N	\N	\N	\N	\N
2631	\N	\N	\N	\N	\N	\N
2632	\N	\N	\N	\N	\N	\N
2633	\N	\N	\N	\N	\N	\N
2634	\N	\N	\N	\N	\N	\N
2635	\N	\N	\N	\N	\N	\N
2636	\N	\N	\N	\N	\N	\N
2637	\N	\N	\N	\N	\N	\N
2638	\N	\N	\N	\N	\N	\N
2639	\N	\N	\N	\N	\N	\N
2640	\N	\N	\N	\N	\N	\N
2641	\N	\N	\N	\N	\N	\N
2642	\N	\N	\N	\N	\N	\N
2643	\N	\N	\N	\N	\N	\N
2644	\N	\N	\N	\N	\N	\N
2645	\N	\N	\N	\N	\N	\N
2646	\N	\N	\N	\N	\N	\N
2647	\N	\N	\N	\N	\N	\N
2648	\N	\N	\N	\N	\N	\N
2649	\N	\N	\N	\N	\N	\N
2650	\N	\N	\N	\N	\N	\N
2651	\N	\N	\N	\N	\N	\N
2652	\N	\N	\N	\N	\N	\N
2653	\N	\N	\N	\N	\N	\N
2654	\N	\N	\N	\N	\N	\N
2655	\N	\N	\N	\N	\N	\N
2656	\N	\N	\N	\N	\N	\N
2657	\N	\N	\N	\N	\N	\N
2658	\N	\N	\N	\N	\N	\N
2659	\N	\N	\N	\N	\N	\N
2660	\N	\N	\N	\N	\N	\N
2661	\N	\N	\N	\N	\N	\N
2662	\N	\N	\N	\N	\N	\N
2663	\N	\N	\N	\N	\N	\N
2664	\N	\N	\N	\N	\N	\N
2665	\N	\N	\N	\N	\N	\N
2666	\N	\N	\N	\N	\N	\N
2667	\N	\N	\N	\N	\N	\N
2668	\N	\N	\N	\N	\N	\N
2669	\N	\N	\N	\N	\N	\N
2670	\N	\N	\N	\N	\N	\N
2671	\N	\N	\N	\N	\N	\N
2672	\N	\N	\N	\N	\N	\N
2673	\N	\N	\N	\N	\N	\N
2674	\N	\N	\N	\N	\N	\N
2675	\N	\N	\N	\N	\N	\N
2676	\N	\N	\N	\N	\N	\N
2677	\N	\N	\N	\N	\N	\N
2678	\N	\N	\N	\N	\N	\N
2679	\N	\N	\N	\N	\N	\N
2680	\N	\N	\N	\N	\N	\N
2681	\N	\N	\N	\N	\N	\N
2682	\N	\N	\N	\N	\N	\N
2683	\N	\N	\N	\N	\N	\N
2684	\N	\N	\N	\N	\N	\N
2685	\N	\N	\N	\N	\N	\N
2686	\N	\N	\N	\N	\N	\N
2687	\N	\N	\N	\N	\N	\N
2688	\N	\N	\N	\N	\N	\N
2689	\N	\N	\N	\N	\N	\N
2690	\N	\N	\N	\N	\N	\N
2691	\N	\N	\N	\N	\N	\N
2692	\N	\N	\N	\N	\N	\N
2693	\N	\N	\N	\N	\N	\N
2694	\N	\N	\N	\N	\N	\N
2695	\N	\N	\N	\N	\N	\N
2696	\N	\N	\N	\N	\N	\N
2697	\N	\N	\N	\N	\N	\N
2698	\N	\N	\N	\N	\N	\N
2699	\N	\N	\N	\N	\N	\N
2700	\N	\N	\N	\N	\N	\N
2701	\N	\N	\N	\N	\N	\N
2702	\N	\N	\N	\N	\N	\N
2703	\N	\N	\N	\N	\N	\N
2704	\N	\N	\N	\N	\N	\N
2705	\N	\N	\N	\N	\N	\N
2706	\N	\N	\N	\N	\N	\N
2707	\N	\N	\N	\N	\N	\N
2708	\N	\N	\N	\N	\N	\N
2709	\N	\N	\N	\N	\N	\N
2710	\N	\N	\N	\N	\N	\N
2711	\N	\N	\N	\N	\N	\N
2712	\N	\N	\N	\N	\N	\N
2713	\N	\N	\N	\N	\N	\N
2714	\N	\N	\N	\N	\N	\N
2715	\N	\N	\N	\N	\N	\N
2716	\N	\N	\N	\N	\N	\N
2717	\N	\N	\N	\N	\N	\N
2718	\N	\N	\N	\N	\N	\N
2719	\N	\N	\N	\N	\N	\N
2720	\N	\N	\N	\N	\N	\N
2721	\N	\N	\N	\N	\N	\N
2722	\N	\N	\N	\N	\N	\N
2723	\N	\N	\N	\N	\N	\N
2724	\N	\N	\N	\N	\N	\N
2725	\N	\N	\N	\N	\N	\N
2726	\N	\N	\N	\N	\N	\N
2727	\N	\N	\N	\N	\N	\N
2728	\N	\N	\N	\N	\N	\N
2729	\N	\N	\N	\N	\N	\N
2730	\N	\N	\N	\N	\N	\N
2731	\N	\N	\N	\N	\N	\N
2732	\N	\N	\N	\N	\N	\N
2733	\N	\N	\N	\N	\N	\N
2734	\N	\N	\N	\N	\N	\N
2735	\N	\N	\N	\N	\N	\N
2736	\N	\N	\N	\N	\N	\N
2737	\N	\N	\N	\N	\N	\N
2738	\N	\N	\N	\N	\N	\N
2739	\N	\N	\N	\N	\N	\N
2740	\N	\N	\N	\N	\N	\N
2741	\N	\N	\N	\N	\N	\N
2742	\N	\N	\N	\N	\N	\N
2743	\N	\N	\N	\N	\N	\N
2744	\N	\N	\N	\N	\N	\N
2745	\N	\N	\N	\N	\N	\N
2746	\N	\N	\N	\N	\N	\N
2747	\N	\N	\N	\N	\N	\N
2748	\N	\N	\N	\N	\N	\N
2749	\N	\N	\N	\N	\N	\N
2750	\N	\N	\N	\N	\N	\N
2751	\N	\N	\N	\N	\N	\N
2752	\N	\N	\N	\N	\N	\N
2753	\N	\N	\N	\N	\N	\N
2754	\N	\N	\N	\N	\N	\N
2755	\N	\N	\N	\N	\N	\N
2756	\N	\N	\N	\N	\N	\N
2757	\N	\N	\N	\N	\N	\N
2758	\N	\N	\N	\N	\N	\N
2759	\N	\N	\N	\N	\N	\N
2760	\N	\N	\N	\N	\N	\N
2761	\N	\N	\N	\N	\N	\N
2762	\N	\N	\N	\N	\N	\N
2763	\N	\N	\N	\N	\N	\N
2764	\N	\N	\N	\N	\N	\N
2765	\N	\N	\N	\N	\N	\N
2766	\N	\N	\N	\N	\N	\N
2767	\N	\N	\N	\N	\N	\N
2768	\N	\N	\N	\N	\N	\N
2769	\N	\N	\N	\N	\N	\N
2770	\N	\N	\N	\N	\N	\N
2771	\N	\N	\N	\N	\N	\N
2772	\N	\N	\N	\N	\N	\N
2773	\N	\N	\N	\N	\N	\N
2774	\N	\N	\N	\N	\N	\N
2775	\N	\N	\N	\N	\N	\N
2776	\N	\N	\N	\N	\N	\N
2777	\N	\N	\N	\N	\N	\N
2778	\N	\N	\N	\N	\N	\N
2779	\N	\N	\N	\N	\N	\N
2780	\N	\N	\N	\N	\N	\N
2781	\N	\N	\N	\N	\N	\N
2782	\N	\N	\N	\N	\N	\N
2783	\N	\N	\N	\N	\N	\N
2784	\N	\N	\N	\N	\N	\N
2785	\N	\N	\N	\N	\N	\N
2786	\N	\N	\N	\N	\N	\N
2787	\N	\N	\N	\N	\N	\N
2788	\N	\N	\N	\N	\N	\N
2789	\N	\N	\N	\N	\N	\N
2790	\N	\N	\N	\N	\N	\N
2791	\N	\N	\N	\N	\N	\N
2792	\N	\N	\N	\N	\N	\N
2793	\N	\N	\N	\N	\N	\N
2794	\N	\N	\N	\N	\N	\N
2795	\N	\N	\N	\N	\N	\N
2796	\N	\N	\N	\N	\N	\N
2797	\N	\N	\N	\N	\N	\N
2798	\N	\N	\N	\N	\N	\N
2799	\N	\N	\N	\N	\N	\N
2800	\N	\N	\N	\N	\N	\N
2801	\N	\N	\N	\N	\N	\N
2802	\N	\N	\N	\N	\N	\N
2803	\N	\N	\N	\N	\N	\N
2804	\N	\N	\N	\N	\N	\N
2805	\N	\N	\N	\N	\N	\N
2806	\N	\N	\N	\N	\N	\N
2807	\N	\N	\N	\N	\N	\N
2808	\N	\N	\N	\N	\N	\N
2809	\N	\N	\N	\N	\N	\N
2810	\N	\N	\N	\N	\N	\N
2811	\N	\N	\N	\N	\N	\N
2812	\N	\N	\N	\N	\N	\N
2813	\N	\N	\N	\N	\N	\N
2814	\N	\N	\N	\N	\N	\N
2815	\N	\N	\N	\N	\N	\N
2816	\N	\N	\N	\N	\N	\N
2817	\N	\N	\N	\N	\N	\N
2818	\N	\N	\N	\N	\N	\N
2819	\N	\N	\N	\N	\N	\N
2820	\N	\N	\N	\N	\N	\N
2821	\N	\N	\N	\N	\N	\N
2822	\N	\N	\N	\N	\N	\N
2823	\N	\N	\N	\N	\N	\N
2824	\N	\N	\N	\N	\N	\N
2825	\N	\N	\N	\N	\N	\N
2826	\N	\N	\N	\N	\N	\N
2827	\N	\N	\N	\N	\N	\N
2828	\N	\N	\N	\N	\N	\N
2829	\N	\N	\N	\N	\N	\N
2830	\N	\N	\N	\N	\N	\N
2831	\N	\N	\N	\N	\N	\N
2832	\N	\N	\N	\N	\N	\N
2833	\N	\N	\N	\N	\N	\N
2834	\N	\N	\N	\N	\N	\N
2835	\N	\N	\N	\N	\N	\N
2836	\N	\N	\N	\N	\N	\N
2837	\N	\N	\N	\N	\N	\N
2838	\N	\N	\N	\N	\N	\N
2839	\N	\N	\N	\N	\N	\N
2840	\N	\N	\N	\N	\N	\N
2841	\N	\N	\N	\N	\N	\N
2842	\N	\N	\N	\N	\N	\N
2843	\N	\N	\N	\N	\N	\N
2844	\N	\N	\N	\N	\N	\N
2845	\N	\N	\N	\N	\N	\N
2846	\N	\N	\N	\N	\N	\N
2847	\N	\N	\N	\N	\N	\N
2848	\N	\N	\N	\N	\N	\N
2849	\N	\N	\N	\N	\N	\N
2850	\N	\N	\N	\N	\N	\N
2851	\N	\N	\N	\N	\N	\N
2852	\N	\N	\N	\N	\N	\N
2853	\N	\N	\N	\N	\N	\N
2854	\N	\N	\N	\N	\N	\N
2855	\N	\N	\N	\N	\N	\N
2856	\N	\N	\N	\N	\N	\N
2857	\N	\N	\N	\N	\N	\N
2858	\N	\N	\N	\N	\N	\N
2859	\N	\N	\N	\N	\N	\N
2860	\N	\N	\N	\N	\N	\N
2861	\N	\N	\N	\N	\N	\N
2862	\N	\N	\N	\N	\N	\N
2863	\N	\N	\N	\N	\N	\N
2864	\N	\N	\N	\N	\N	\N
2865	\N	\N	\N	\N	\N	\N
2866	\N	\N	\N	\N	\N	\N
2867	\N	\N	\N	\N	\N	\N
2868	\N	\N	\N	\N	\N	\N
2869	\N	\N	\N	\N	\N	\N
2870	\N	\N	\N	\N	\N	\N
2871	\N	\N	\N	\N	\N	\N
2872	\N	\N	\N	\N	\N	\N
2873	\N	\N	\N	\N	\N	\N
2874	\N	\N	\N	\N	\N	\N
2875	\N	\N	\N	\N	\N	\N
2876	\N	\N	\N	\N	\N	\N
2877	\N	\N	\N	\N	\N	\N
2878	\N	\N	\N	\N	\N	\N
2879	\N	\N	\N	\N	\N	\N
2880	\N	\N	\N	\N	\N	\N
2881	\N	\N	\N	\N	\N	\N
2882	\N	\N	\N	\N	\N	\N
2883	\N	\N	\N	\N	\N	\N
2884	\N	\N	\N	\N	\N	\N
2885	\N	\N	\N	\N	\N	\N
2886	\N	\N	\N	\N	\N	\N
2887	\N	\N	\N	\N	\N	\N
2888	\N	\N	\N	\N	\N	\N
2889	\N	\N	\N	\N	\N	\N
2890	\N	\N	\N	\N	\N	\N
2891	\N	\N	\N	\N	\N	\N
2892	\N	\N	\N	\N	\N	\N
2893	\N	\N	\N	\N	\N	\N
2894	\N	\N	\N	\N	\N	\N
2895	\N	\N	\N	\N	\N	\N
2896	\N	\N	\N	\N	\N	\N
2897	\N	\N	\N	\N	\N	\N
2898	\N	\N	\N	\N	\N	\N
2899	\N	\N	\N	\N	\N	\N
2900	\N	\N	\N	\N	\N	\N
2901	\N	\N	\N	\N	\N	\N
2902	\N	\N	\N	\N	\N	\N
2903	\N	\N	\N	\N	\N	\N
2904	\N	\N	\N	\N	\N	\N
2905	\N	\N	\N	\N	\N	\N
2906	\N	\N	\N	\N	\N	\N
2907	\N	\N	\N	\N	\N	\N
2908	\N	\N	\N	\N	\N	\N
2909	\N	\N	\N	\N	\N	\N
2910	\N	\N	\N	\N	\N	\N
2911	\N	\N	\N	\N	\N	\N
2912	\N	\N	\N	\N	\N	\N
2913	\N	\N	\N	\N	\N	\N
2914	\N	\N	\N	\N	\N	\N
2915	\N	\N	\N	\N	\N	\N
2916	\N	\N	\N	\N	\N	\N
2917	\N	\N	\N	\N	\N	\N
2918	\N	\N	\N	\N	\N	\N
2919	\N	\N	\N	\N	\N	\N
2920	\N	\N	\N	\N	\N	\N
2921	\N	\N	\N	\N	\N	\N
2922	\N	\N	\N	\N	\N	\N
2923	\N	\N	\N	\N	\N	\N
2924	\N	\N	\N	\N	\N	\N
2925	\N	\N	\N	\N	\N	\N
2926	\N	\N	\N	\N	\N	\N
2927	\N	\N	\N	\N	\N	\N
2928	\N	\N	\N	\N	\N	\N
2929	\N	\N	\N	\N	\N	\N
2930	\N	\N	\N	\N	\N	\N
2931	\N	\N	\N	\N	\N	\N
2932	\N	\N	\N	\N	\N	\N
2933	\N	\N	\N	\N	\N	\N
2934	\N	\N	\N	\N	\N	\N
2935	\N	\N	\N	\N	\N	\N
2936	\N	\N	\N	\N	\N	\N
2937	\N	\N	\N	\N	\N	\N
2938	\N	\N	\N	\N	\N	\N
2939	\N	\N	\N	\N	\N	\N
2940	\N	\N	\N	\N	\N	\N
2941	\N	\N	\N	\N	\N	\N
2942	\N	\N	\N	\N	\N	\N
2943	\N	\N	\N	\N	\N	\N
2944	\N	\N	\N	\N	\N	\N
2945	\N	\N	\N	\N	\N	\N
2946	\N	\N	\N	\N	\N	\N
2947	\N	\N	\N	\N	\N	\N
2948	\N	\N	\N	\N	\N	\N
2949	\N	\N	\N	\N	\N	\N
2950	\N	\N	\N	\N	\N	\N
2951	\N	\N	\N	\N	\N	\N
2952	\N	\N	\N	\N	\N	\N
2953	\N	\N	\N	\N	\N	\N
2954	\N	\N	\N	\N	\N	\N
2955	\N	\N	\N	\N	\N	\N
2956	\N	\N	\N	\N	\N	\N
2957	\N	\N	\N	\N	\N	\N
2958	\N	\N	\N	\N	\N	\N
2959	\N	\N	\N	\N	\N	\N
2960	\N	\N	\N	\N	\N	\N
2961	\N	\N	\N	\N	\N	\N
2962	\N	\N	\N	\N	\N	\N
2963	\N	\N	\N	\N	\N	\N
2964	\N	\N	\N	\N	\N	\N
2965	\N	\N	\N	\N	\N	\N
2966	\N	\N	\N	\N	\N	\N
2967	\N	\N	\N	\N	\N	\N
2968	\N	\N	\N	\N	\N	\N
2969	\N	\N	\N	\N	\N	\N
2970	\N	\N	\N	\N	\N	\N
2971	\N	\N	\N	\N	\N	\N
2972	\N	\N	\N	\N	\N	\N
2973	\N	\N	\N	\N	\N	\N
2974	\N	\N	\N	\N	\N	\N
2975	\N	\N	\N	\N	\N	\N
2976	\N	\N	\N	\N	\N	\N
2977	\N	\N	\N	\N	\N	\N
2978	\N	\N	\N	\N	\N	\N
2979	\N	\N	\N	\N	\N	\N
2980	\N	\N	\N	\N	\N	\N
2981	\N	\N	\N	\N	\N	\N
2982	\N	\N	\N	\N	\N	\N
2983	\N	\N	\N	\N	\N	\N
2984	\N	\N	\N	\N	\N	\N
2985	\N	\N	\N	\N	\N	\N
2986	\N	\N	\N	\N	\N	\N
2987	\N	\N	\N	\N	\N	\N
2988	\N	\N	\N	\N	\N	\N
2989	\N	\N	\N	\N	\N	\N
2990	\N	\N	\N	\N	\N	\N
2991	\N	\N	\N	\N	\N	\N
2992	\N	\N	\N	\N	\N	\N
2993	\N	\N	\N	\N	\N	\N
2994	\N	\N	\N	\N	\N	\N
2995	\N	\N	\N	\N	\N	\N
2996	\N	\N	\N	\N	\N	\N
2997	\N	\N	\N	\N	\N	\N
2998	\N	\N	\N	\N	\N	\N
2999	\N	\N	\N	\N	\N	\N
3000	\N	\N	\N	\N	\N	\N
3001	\N	\N	\N	\N	\N	\N
3002	\N	\N	\N	\N	\N	\N
3003	\N	\N	\N	\N	\N	\N
3004	\N	\N	\N	\N	\N	\N
3005	\N	\N	\N	\N	\N	\N
3006	\N	\N	\N	\N	\N	\N
3007	\N	\N	\N	\N	\N	\N
3008	\N	\N	\N	\N	\N	\N
3009	\N	\N	\N	\N	\N	\N
3010	\N	\N	\N	\N	\N	\N
3011	\N	\N	\N	\N	\N	\N
3012	\N	\N	\N	\N	\N	\N
3013	\N	\N	\N	\N	\N	\N
3014	\N	\N	\N	\N	\N	\N
3015	\N	\N	\N	\N	\N	\N
3016	\N	\N	\N	\N	\N	\N
3017	\N	\N	\N	\N	\N	\N
3018	\N	\N	\N	\N	\N	\N
3019	\N	\N	\N	\N	\N	\N
3020	\N	\N	\N	\N	\N	\N
3021	\N	\N	\N	\N	\N	\N
3022	\N	\N	\N	\N	\N	\N
3023	\N	\N	\N	\N	\N	\N
3024	\N	\N	\N	\N	\N	\N
3025	\N	\N	\N	\N	\N	\N
3026	\N	\N	\N	\N	\N	\N
3027	\N	\N	\N	\N	\N	\N
3028	\N	\N	\N	\N	\N	\N
3029	\N	\N	\N	\N	\N	\N
3030	\N	\N	\N	\N	\N	\N
3031	\N	\N	\N	\N	\N	\N
3032	\N	\N	\N	\N	\N	\N
3033	\N	\N	\N	\N	\N	\N
3034	\N	\N	\N	\N	\N	\N
3035	\N	\N	\N	\N	\N	\N
3036	\N	\N	\N	\N	\N	\N
3037	\N	\N	\N	\N	\N	\N
3038	\N	\N	\N	\N	\N	\N
3039	\N	\N	\N	\N	\N	\N
3040	\N	\N	\N	\N	\N	\N
3041	\N	\N	\N	\N	\N	\N
3042	\N	\N	\N	\N	\N	\N
3043	\N	\N	\N	\N	\N	\N
3044	\N	\N	\N	\N	\N	\N
3045	\N	\N	\N	\N	\N	\N
3046	\N	\N	\N	\N	\N	\N
3047	\N	\N	\N	\N	\N	\N
3048	\N	\N	\N	\N	\N	\N
3049	\N	\N	\N	\N	\N	\N
3050	\N	\N	\N	\N	\N	\N
3051	\N	\N	\N	\N	\N	\N
3052	\N	\N	\N	\N	\N	\N
3053	\N	\N	\N	\N	\N	\N
3054	\N	\N	\N	\N	\N	\N
3055	\N	\N	\N	\N	\N	\N
3056	\N	\N	\N	\N	\N	\N
3057	\N	\N	\N	\N	\N	\N
3058	\N	\N	\N	\N	\N	\N
3059	\N	\N	\N	\N	\N	\N
3060	\N	\N	\N	\N	\N	\N
3061	\N	\N	\N	\N	\N	\N
3062	\N	\N	\N	\N	\N	\N
3063	\N	\N	\N	\N	\N	\N
3064	\N	\N	\N	\N	\N	\N
3065	\N	\N	\N	\N	\N	\N
3066	\N	\N	\N	\N	\N	\N
3067	\N	\N	\N	\N	\N	\N
3068	\N	\N	\N	\N	\N	\N
3069	\N	\N	\N	\N	\N	\N
3070	\N	\N	\N	\N	\N	\N
3071	\N	\N	\N	\N	\N	\N
3072	\N	\N	\N	\N	\N	\N
3073	\N	\N	\N	\N	\N	\N
3074	\N	\N	\N	\N	\N	\N
3075	\N	\N	\N	\N	\N	\N
3076	\N	\N	\N	\N	\N	\N
3077	\N	\N	\N	\N	\N	\N
3078	\N	\N	\N	\N	\N	\N
3079	\N	\N	\N	\N	\N	\N
3080	\N	\N	\N	\N	\N	\N
3081	\N	\N	\N	\N	\N	\N
3082	\N	\N	\N	\N	\N	\N
3083	\N	\N	\N	\N	\N	\N
3084	\N	\N	\N	\N	\N	\N
3085	\N	\N	\N	\N	\N	\N
3086	\N	\N	\N	\N	\N	\N
3087	\N	\N	\N	\N	\N	\N
3088	\N	\N	\N	\N	\N	\N
3089	\N	\N	\N	\N	\N	\N
3090	\N	\N	\N	\N	\N	\N
3091	\N	\N	\N	\N	\N	\N
3092	\N	\N	\N	\N	\N	\N
3093	\N	\N	\N	\N	\N	\N
3094	\N	\N	\N	\N	\N	\N
3095	\N	\N	\N	\N	\N	\N
3096	\N	\N	\N	\N	\N	\N
3097	\N	\N	\N	\N	\N	\N
3098	\N	\N	\N	\N	\N	\N
3099	\N	\N	\N	\N	\N	\N
3100	\N	\N	\N	\N	\N	\N
3101	\N	\N	\N	\N	\N	\N
3102	\N	\N	\N	\N	\N	\N
3103	\N	\N	\N	\N	\N	\N
3104	\N	\N	\N	\N	\N	\N
3105	\N	\N	\N	\N	\N	\N
3106	\N	\N	\N	\N	\N	\N
3107	\N	\N	\N	\N	\N	\N
3108	\N	\N	\N	\N	\N	\N
3109	\N	\N	\N	\N	\N	\N
3110	\N	\N	\N	\N	\N	\N
3111	\N	\N	\N	\N	\N	\N
3112	\N	\N	\N	\N	\N	\N
3113	\N	\N	\N	\N	\N	\N
3114	\N	\N	\N	\N	\N	\N
3115	\N	\N	\N	\N	\N	\N
3116	\N	\N	\N	\N	\N	\N
3117	\N	\N	\N	\N	\N	\N
3118	\N	\N	\N	\N	\N	\N
3119	\N	\N	\N	\N	\N	\N
3120	\N	\N	\N	\N	\N	\N
3121	\N	\N	\N	\N	\N	\N
3122	\N	\N	\N	\N	\N	\N
3123	\N	\N	\N	\N	\N	\N
3124	\N	\N	\N	\N	\N	\N
3125	\N	\N	\N	\N	\N	\N
3126	\N	\N	\N	\N	\N	\N
3127	\N	\N	\N	\N	\N	\N
3128	\N	\N	\N	\N	\N	\N
3129	\N	\N	\N	\N	\N	\N
3130	\N	\N	\N	\N	\N	\N
3131	\N	\N	\N	\N	\N	\N
3132	\N	\N	\N	\N	\N	\N
3133	\N	\N	\N	\N	\N	\N
3134	\N	\N	\N	\N	\N	\N
3135	\N	\N	\N	\N	\N	\N
3136	\N	\N	\N	\N	\N	\N
3137	\N	\N	\N	\N	\N	\N
3138	\N	\N	\N	\N	\N	\N
3139	\N	\N	\N	\N	\N	\N
3140	\N	\N	\N	\N	\N	\N
3141	\N	\N	\N	\N	\N	\N
3142	\N	\N	\N	\N	\N	\N
3143	\N	\N	\N	\N	\N	\N
3144	\N	\N	\N	\N	\N	\N
3145	\N	\N	\N	\N	\N	\N
3146	\N	\N	\N	\N	\N	\N
3147	\N	\N	\N	\N	\N	\N
3148	\N	\N	\N	\N	\N	\N
3149	\N	\N	\N	\N	\N	\N
3150	\N	\N	\N	\N	\N	\N
3151	\N	\N	\N	\N	\N	\N
3152	\N	\N	\N	\N	\N	\N
3153	\N	\N	\N	\N	\N	\N
3154	\N	\N	\N	\N	\N	\N
3155	\N	\N	\N	\N	\N	\N
3156	\N	\N	\N	\N	\N	\N
3157	\N	\N	\N	\N	\N	\N
3158	\N	\N	\N	\N	\N	\N
3159	\N	\N	\N	\N	\N	\N
3160	\N	\N	\N	\N	\N	\N
3161	\N	\N	\N	\N	\N	\N
3162	\N	\N	\N	\N	\N	\N
3163	\N	\N	\N	\N	\N	\N
3164	\N	\N	\N	\N	\N	\N
3165	\N	\N	\N	\N	\N	\N
3166	\N	\N	\N	\N	\N	\N
3167	\N	\N	\N	\N	\N	\N
3168	\N	\N	\N	\N	\N	\N
3169	\N	\N	\N	\N	\N	\N
3170	\N	\N	\N	\N	\N	\N
3171	\N	\N	\N	\N	\N	\N
3172	\N	\N	\N	\N	\N	\N
3173	\N	\N	\N	\N	\N	\N
3174	\N	\N	\N	\N	\N	\N
3175	\N	\N	\N	\N	\N	\N
3176	\N	\N	\N	\N	\N	\N
3177	\N	\N	\N	\N	\N	\N
3178	\N	\N	\N	\N	\N	\N
3179	\N	\N	\N	\N	\N	\N
3180	\N	\N	\N	\N	\N	\N
3181	\N	\N	\N	\N	\N	\N
3182	\N	\N	\N	\N	\N	\N
3183	\N	\N	\N	\N	\N	\N
3184	\N	\N	\N	\N	\N	\N
3185	\N	\N	\N	\N	\N	\N
3186	\N	\N	\N	\N	\N	\N
3187	\N	\N	\N	\N	\N	\N
3188	\N	\N	\N	\N	\N	\N
3189	\N	\N	\N	\N	\N	\N
3190	\N	\N	\N	\N	\N	\N
3191	\N	\N	\N	\N	\N	\N
3192	\N	\N	\N	\N	\N	\N
3193	\N	\N	\N	\N	\N	\N
3194	\N	\N	\N	\N	\N	\N
3195	\N	\N	\N	\N	\N	\N
3196	\N	\N	\N	\N	\N	\N
3197	\N	\N	\N	\N	\N	\N
3198	\N	\N	\N	\N	\N	\N
3199	\N	\N	\N	\N	\N	\N
3200	\N	\N	\N	\N	\N	\N
3201	\N	\N	\N	\N	\N	\N
3202	\N	\N	\N	\N	\N	\N
3203	\N	\N	\N	\N	\N	\N
3204	\N	\N	\N	\N	\N	\N
3205	\N	\N	\N	\N	\N	\N
3206	\N	\N	\N	\N	\N	\N
3207	\N	\N	\N	\N	\N	\N
3208	\N	\N	\N	\N	\N	\N
3209	\N	\N	\N	\N	\N	\N
3210	\N	\N	\N	\N	\N	\N
3211	\N	\N	\N	\N	\N	\N
3212	\N	\N	\N	\N	\N	\N
3213	\N	\N	\N	\N	\N	\N
3214	\N	\N	\N	\N	\N	\N
3215	\N	\N	\N	\N	\N	\N
3216	\N	\N	\N	\N	\N	\N
3217	\N	\N	\N	\N	\N	\N
3218	\N	\N	\N	\N	\N	\N
3219	\N	\N	\N	\N	\N	\N
3220	\N	\N	\N	\N	\N	\N
3221	\N	\N	\N	\N	\N	\N
3222	\N	\N	\N	\N	\N	\N
3223	\N	\N	\N	\N	\N	\N
3224	\N	\N	\N	\N	\N	\N
3225	\N	\N	\N	\N	\N	\N
3226	\N	\N	\N	\N	\N	\N
3227	\N	\N	\N	\N	\N	\N
3228	\N	\N	\N	\N	\N	\N
3229	\N	\N	\N	\N	\N	\N
3230	\N	\N	\N	\N	\N	\N
3231	\N	\N	\N	\N	\N	\N
3232	\N	\N	\N	\N	\N	\N
3233	\N	\N	\N	\N	\N	\N
3234	\N	\N	\N	\N	\N	\N
3235	\N	\N	\N	\N	\N	\N
3236	\N	\N	\N	\N	\N	\N
3237	\N	\N	\N	\N	\N	\N
3238	\N	\N	\N	\N	\N	\N
3239	\N	\N	\N	\N	\N	\N
3240	\N	\N	\N	\N	\N	\N
3241	\N	\N	\N	\N	\N	\N
3242	\N	\N	\N	\N	\N	\N
3243	\N	\N	\N	\N	\N	\N
3244	\N	\N	\N	\N	\N	\N
3245	\N	\N	\N	\N	\N	\N
3246	\N	\N	\N	\N	\N	\N
3247	\N	\N	\N	\N	\N	\N
3248	\N	\N	\N	\N	\N	\N
3249	\N	\N	\N	\N	\N	\N
3250	\N	\N	\N	\N	\N	\N
3251	\N	\N	\N	\N	\N	\N
3252	\N	\N	\N	\N	\N	\N
3253	\N	\N	\N	\N	\N	\N
3254	\N	\N	\N	\N	\N	\N
3255	\N	\N	\N	\N	\N	\N
3256	\N	\N	\N	\N	\N	\N
3257	\N	\N	\N	\N	\N	\N
3258	\N	\N	\N	\N	\N	\N
3259	\N	\N	\N	\N	\N	\N
3260	\N	\N	\N	\N	\N	\N
3261	\N	\N	\N	\N	\N	\N
3262	\N	\N	\N	\N	\N	\N
3263	\N	\N	\N	\N	\N	\N
3264	\N	\N	\N	\N	\N	\N
3265	\N	\N	\N	\N	\N	\N
3266	\N	\N	\N	\N	\N	\N
3267	\N	\N	\N	\N	\N	\N
3268	\N	\N	\N	\N	\N	\N
3269	\N	\N	\N	\N	\N	\N
3270	\N	\N	\N	\N	\N	\N
3271	\N	\N	\N	\N	\N	\N
3272	\N	\N	\N	\N	\N	\N
3273	\N	\N	\N	\N	\N	\N
3274	\N	\N	\N	\N	\N	\N
3275	\N	\N	\N	\N	\N	\N
3276	\N	\N	\N	\N	\N	\N
3277	\N	\N	\N	\N	\N	\N
3278	\N	\N	\N	\N	\N	\N
3279	\N	\N	\N	\N	\N	\N
3280	\N	\N	\N	\N	\N	\N
3281	\N	\N	\N	\N	\N	\N
3282	\N	\N	\N	\N	\N	\N
3283	\N	\N	\N	\N	\N	\N
3284	\N	\N	\N	\N	\N	\N
3285	\N	\N	\N	\N	\N	\N
3286	\N	\N	\N	\N	\N	\N
3287	\N	\N	\N	\N	\N	\N
3288	\N	\N	\N	\N	\N	\N
3289	\N	\N	\N	\N	\N	\N
3290	\N	\N	\N	\N	\N	\N
3291	\N	\N	\N	\N	\N	\N
3292	\N	\N	\N	\N	\N	\N
3293	\N	\N	\N	\N	\N	\N
3294	\N	\N	\N	\N	\N	\N
3295	\N	\N	\N	\N	\N	\N
3296	\N	\N	\N	\N	\N	\N
3297	\N	\N	\N	\N	\N	\N
3298	\N	\N	\N	\N	\N	\N
3299	\N	\N	\N	\N	\N	\N
3300	\N	\N	\N	\N	\N	\N
3301	\N	\N	\N	\N	\N	\N
3302	\N	\N	\N	\N	\N	\N
3303	\N	\N	\N	\N	\N	\N
3304	\N	\N	\N	\N	\N	\N
3305	\N	\N	\N	\N	\N	\N
3306	\N	\N	\N	\N	\N	\N
3307	\N	\N	\N	\N	\N	\N
3308	\N	\N	\N	\N	\N	\N
3309	\N	\N	\N	\N	\N	\N
3310	\N	\N	\N	\N	\N	\N
3311	\N	\N	\N	\N	\N	\N
3312	\N	\N	\N	\N	\N	\N
3313	\N	\N	\N	\N	\N	\N
3314	\N	\N	\N	\N	\N	\N
3315	\N	\N	\N	\N	\N	\N
3316	\N	\N	\N	\N	\N	\N
3317	\N	\N	\N	\N	\N	\N
3318	\N	\N	\N	\N	\N	\N
3319	\N	\N	\N	\N	\N	\N
3320	\N	\N	\N	\N	\N	\N
3321	\N	\N	\N	\N	\N	\N
3322	\N	\N	\N	\N	\N	\N
3323	\N	\N	\N	\N	\N	\N
3324	\N	\N	\N	\N	\N	\N
3325	\N	\N	\N	\N	\N	\N
3326	\N	\N	\N	\N	\N	\N
3327	\N	\N	\N	\N	\N	\N
3328	\N	\N	\N	\N	\N	\N
3329	\N	\N	\N	\N	\N	\N
3330	\N	\N	\N	\N	\N	\N
3331	\N	\N	\N	\N	\N	\N
3332	\N	\N	\N	\N	\N	\N
3333	\N	\N	\N	\N	\N	\N
3334	\N	\N	\N	\N	\N	\N
3335	\N	\N	\N	\N	\N	\N
3336	\N	\N	\N	\N	\N	\N
3337	\N	\N	\N	\N	\N	\N
3338	\N	\N	\N	\N	\N	\N
3339	\N	\N	\N	\N	\N	\N
3340	\N	\N	\N	\N	\N	\N
3341	\N	\N	\N	\N	\N	\N
3342	\N	\N	\N	\N	\N	\N
3343	\N	\N	\N	\N	\N	\N
3344	\N	\N	\N	\N	\N	\N
3345	\N	\N	\N	\N	\N	\N
3346	\N	\N	\N	\N	\N	\N
3347	\N	\N	\N	\N	\N	\N
3348	\N	\N	\N	\N	\N	\N
3349	\N	\N	\N	\N	\N	\N
3350	\N	\N	\N	\N	\N	\N
3351	\N	\N	\N	\N	\N	\N
3352	\N	\N	\N	\N	\N	\N
3353	\N	\N	\N	\N	\N	\N
3354	\N	\N	\N	\N	\N	\N
3355	\N	\N	\N	\N	\N	\N
3356	\N	\N	\N	\N	\N	\N
3357	\N	\N	\N	\N	\N	\N
3358	\N	\N	\N	\N	\N	\N
3359	\N	\N	\N	\N	\N	\N
3360	\N	\N	\N	\N	\N	\N
3361	\N	\N	\N	\N	\N	\N
3362	\N	\N	\N	\N	\N	\N
3363	\N	\N	\N	\N	\N	\N
3364	\N	\N	\N	\N	\N	\N
3365	\N	\N	\N	\N	\N	\N
3366	\N	\N	\N	\N	\N	\N
3367	\N	\N	\N	\N	\N	\N
3368	\N	\N	\N	\N	\N	\N
3369	\N	\N	\N	\N	\N	\N
3370	\N	\N	\N	\N	\N	\N
3371	\N	\N	\N	\N	\N	\N
3372	\N	\N	\N	\N	\N	\N
3373	\N	\N	\N	\N	\N	\N
3374	\N	\N	\N	\N	\N	\N
3375	\N	\N	\N	\N	\N	\N
3376	\N	\N	\N	\N	\N	\N
3377	\N	\N	\N	\N	\N	\N
3378	\N	\N	\N	\N	\N	\N
3379	\N	\N	\N	\N	\N	\N
3380	\N	\N	\N	\N	\N	\N
3381	\N	\N	\N	\N	\N	\N
3382	\N	\N	\N	\N	\N	\N
3383	\N	\N	\N	\N	\N	\N
3384	\N	\N	\N	\N	\N	\N
3385	\N	\N	\N	\N	\N	\N
3386	\N	\N	\N	\N	\N	\N
3387	\N	\N	\N	\N	\N	\N
3388	\N	\N	\N	\N	\N	\N
3389	\N	\N	\N	\N	\N	\N
3390	\N	\N	\N	\N	\N	\N
3391	\N	\N	\N	\N	\N	\N
3392	\N	\N	\N	\N	\N	\N
3393	\N	\N	\N	\N	\N	\N
3394	\N	\N	\N	\N	\N	\N
3395	\N	\N	\N	\N	\N	\N
3396	\N	\N	\N	\N	\N	\N
3397	\N	\N	\N	\N	\N	\N
3398	\N	\N	\N	\N	\N	\N
3399	\N	\N	\N	\N	\N	\N
3400	\N	\N	\N	\N	\N	\N
3401	\N	\N	\N	\N	\N	\N
3402	\N	\N	\N	\N	\N	\N
3403	\N	\N	\N	\N	\N	\N
3404	\N	\N	\N	\N	\N	\N
3405	\N	\N	\N	\N	\N	\N
3406	\N	\N	\N	\N	\N	\N
3407	\N	\N	\N	\N	\N	\N
3408	\N	\N	\N	\N	\N	\N
3409	\N	\N	\N	\N	\N	\N
3410	\N	\N	\N	\N	\N	\N
3411	\N	\N	\N	\N	\N	\N
3412	\N	\N	\N	\N	\N	\N
3413	\N	\N	\N	\N	\N	\N
3414	\N	\N	\N	\N	\N	\N
3415	\N	\N	\N	\N	\N	\N
3416	\N	\N	\N	\N	\N	\N
3417	\N	\N	\N	\N	\N	\N
3418	\N	\N	\N	\N	\N	\N
3419	\N	\N	\N	\N	\N	\N
3420	\N	\N	\N	\N	\N	\N
3421	\N	\N	\N	\N	\N	\N
3422	\N	\N	\N	\N	\N	\N
3423	\N	\N	\N	\N	\N	\N
3424	\N	\N	\N	\N	\N	\N
3425	\N	\N	\N	\N	\N	\N
3426	\N	\N	\N	\N	\N	\N
3427	\N	\N	\N	\N	\N	\N
3428	\N	\N	\N	\N	\N	\N
3429	\N	\N	\N	\N	\N	\N
3430	\N	\N	\N	\N	\N	\N
3431	\N	\N	\N	\N	\N	\N
3432	\N	\N	\N	\N	\N	\N
3433	\N	\N	\N	\N	\N	\N
3434	\N	\N	\N	\N	\N	\N
3435	\N	\N	\N	\N	\N	\N
3436	\N	\N	\N	\N	\N	\N
3437	\N	\N	\N	\N	\N	\N
3438	\N	\N	\N	\N	\N	\N
3439	\N	\N	\N	\N	\N	\N
3440	\N	\N	\N	\N	\N	\N
3441	\N	\N	\N	\N	\N	\N
3442	\N	\N	\N	\N	\N	\N
3443	\N	\N	\N	\N	\N	\N
3444	\N	\N	\N	\N	\N	\N
3445	\N	\N	\N	\N	\N	\N
3446	\N	\N	\N	\N	\N	\N
3447	\N	\N	\N	\N	\N	\N
3448	\N	\N	\N	\N	\N	\N
3449	\N	\N	\N	\N	\N	\N
3450	\N	\N	\N	\N	\N	\N
3451	\N	\N	\N	\N	\N	\N
3452	\N	\N	\N	\N	\N	\N
3453	\N	\N	\N	\N	\N	\N
3454	\N	\N	\N	\N	\N	\N
3455	\N	\N	\N	\N	\N	\N
3456	\N	\N	\N	\N	\N	\N
3457	\N	\N	\N	\N	\N	\N
3458	\N	\N	\N	\N	\N	\N
3459	\N	\N	\N	\N	\N	\N
3460	\N	\N	\N	\N	\N	\N
3461	\N	\N	\N	\N	\N	\N
3462	\N	\N	\N	\N	\N	\N
3463	\N	\N	\N	\N	\N	\N
3464	\N	\N	\N	\N	\N	\N
3465	\N	\N	\N	\N	\N	\N
3466	\N	\N	\N	\N	\N	\N
3467	\N	\N	\N	\N	\N	\N
3468	\N	\N	\N	\N	\N	\N
3469	\N	\N	\N	\N	\N	\N
3470	\N	\N	\N	\N	\N	\N
3471	\N	\N	\N	\N	\N	\N
3472	\N	\N	\N	\N	\N	\N
3473	\N	\N	\N	\N	\N	\N
3474	\N	\N	\N	\N	\N	\N
3475	\N	\N	\N	\N	\N	\N
3476	\N	\N	\N	\N	\N	\N
3477	\N	\N	\N	\N	\N	\N
3478	\N	\N	\N	\N	\N	\N
3479	\N	\N	\N	\N	\N	\N
3480	\N	\N	\N	\N	\N	\N
3481	\N	\N	\N	\N	\N	\N
3482	\N	\N	\N	\N	\N	\N
3483	\N	\N	\N	\N	\N	\N
3484	\N	\N	\N	\N	\N	\N
3485	\N	\N	\N	\N	\N	\N
3486	\N	\N	\N	\N	\N	\N
3487	\N	\N	\N	\N	\N	\N
3488	\N	\N	\N	\N	\N	\N
3489	\N	\N	\N	\N	\N	\N
3490	\N	\N	\N	\N	\N	\N
3491	\N	\N	\N	\N	\N	\N
3492	\N	\N	\N	\N	\N	\N
3493	\N	\N	\N	\N	\N	\N
3494	\N	\N	\N	\N	\N	\N
3495	\N	\N	\N	\N	\N	\N
3496	\N	\N	\N	\N	\N	\N
3497	\N	\N	\N	\N	\N	\N
3498	\N	\N	\N	\N	\N	\N
3499	\N	\N	\N	\N	\N	\N
3500	\N	\N	\N	\N	\N	\N
3501	\N	\N	\N	\N	\N	\N
3502	\N	\N	\N	\N	\N	\N
3503	\N	\N	\N	\N	\N	\N
3504	\N	\N	\N	\N	\N	\N
3505	\N	\N	\N	\N	\N	\N
3506	\N	\N	\N	\N	\N	\N
3507	\N	\N	\N	\N	\N	\N
3508	\N	\N	\N	\N	\N	\N
3509	\N	\N	\N	\N	\N	\N
3510	\N	\N	\N	\N	\N	\N
3511	\N	\N	\N	\N	\N	\N
3512	\N	\N	\N	\N	\N	\N
3513	\N	\N	\N	\N	\N	\N
3514	\N	\N	\N	\N	\N	\N
3515	\N	\N	\N	\N	\N	\N
3516	\N	\N	\N	\N	\N	\N
3517	\N	\N	\N	\N	\N	\N
3518	\N	\N	\N	\N	\N	\N
3519	\N	\N	\N	\N	\N	\N
3520	\N	\N	\N	\N	\N	\N
3521	\N	\N	\N	\N	\N	\N
3522	\N	\N	\N	\N	\N	\N
3523	\N	\N	\N	\N	\N	\N
3524	\N	\N	\N	\N	\N	\N
3525	\N	\N	\N	\N	\N	\N
3526	\N	\N	\N	\N	\N	\N
3527	\N	\N	\N	\N	\N	\N
3528	\N	\N	\N	\N	\N	\N
3529	\N	\N	\N	\N	\N	\N
3530	\N	\N	\N	\N	\N	\N
3531	\N	\N	\N	\N	\N	\N
3532	\N	\N	\N	\N	\N	\N
3533	\N	\N	\N	\N	\N	\N
3534	\N	\N	\N	\N	\N	\N
3535	\N	\N	\N	\N	\N	\N
3536	\N	\N	\N	\N	\N	\N
3537	\N	\N	\N	\N	\N	\N
3538	\N	\N	\N	\N	\N	\N
3539	\N	\N	\N	\N	\N	\N
3540	\N	\N	\N	\N	\N	\N
3541	\N	\N	\N	\N	\N	\N
3542	\N	\N	\N	\N	\N	\N
3543	\N	\N	\N	\N	\N	\N
3544	\N	\N	\N	\N	\N	\N
3545	\N	\N	\N	\N	\N	\N
3546	\N	\N	\N	\N	\N	\N
3547	\N	\N	\N	\N	\N	\N
3548	\N	\N	\N	\N	\N	\N
3549	\N	\N	\N	\N	\N	\N
3550	\N	\N	\N	\N	\N	\N
3551	\N	\N	\N	\N	\N	\N
3552	\N	\N	\N	\N	\N	\N
3553	\N	\N	\N	\N	\N	\N
3554	\N	\N	\N	\N	\N	\N
3555	\N	\N	\N	\N	\N	\N
3556	\N	\N	\N	\N	\N	\N
3557	\N	\N	\N	\N	\N	\N
3558	\N	\N	\N	\N	\N	\N
3559	\N	\N	\N	\N	\N	\N
3560	\N	\N	\N	\N	\N	\N
3561	\N	\N	\N	\N	\N	\N
3562	\N	\N	\N	\N	\N	\N
3563	\N	\N	\N	\N	\N	\N
3564	\N	\N	\N	\N	\N	\N
3565	\N	\N	\N	\N	\N	\N
3566	\N	\N	\N	\N	\N	\N
3567	\N	\N	\N	\N	\N	\N
3568	\N	\N	\N	\N	\N	\N
3569	\N	\N	\N	\N	\N	\N
3570	\N	\N	\N	\N	\N	\N
3571	\N	\N	\N	\N	\N	\N
3572	\N	\N	\N	\N	\N	\N
3573	\N	\N	\N	\N	\N	\N
3574	\N	\N	\N	\N	\N	\N
3575	\N	\N	\N	\N	\N	\N
3576	\N	\N	\N	\N	\N	\N
3577	\N	\N	\N	\N	\N	\N
3578	\N	\N	\N	\N	\N	\N
3579	\N	\N	\N	\N	\N	\N
3580	\N	\N	\N	\N	\N	\N
3581	\N	\N	\N	\N	\N	\N
3582	\N	\N	\N	\N	\N	\N
3583	\N	\N	\N	\N	\N	\N
3584	\N	\N	\N	\N	\N	\N
3585	\N	\N	\N	\N	\N	\N
3586	\N	\N	\N	\N	\N	\N
3587	\N	\N	\N	\N	\N	\N
3588	\N	\N	\N	\N	\N	\N
3589	\N	\N	\N	\N	\N	\N
3590	\N	\N	\N	\N	\N	\N
3591	\N	\N	\N	\N	\N	\N
3592	\N	\N	\N	\N	\N	\N
3593	\N	\N	\N	\N	\N	\N
3594	\N	\N	\N	\N	\N	\N
3595	\N	\N	\N	\N	\N	\N
3596	\N	\N	\N	\N	\N	\N
3597	\N	\N	\N	\N	\N	\N
3598	\N	\N	\N	\N	\N	\N
3599	\N	\N	\N	\N	\N	\N
3600	\N	\N	\N	\N	\N	\N
3601	\N	\N	\N	\N	\N	\N
3602	\N	\N	\N	\N	\N	\N
3603	\N	\N	\N	\N	\N	\N
3604	\N	\N	\N	\N	\N	\N
3605	\N	\N	\N	\N	\N	\N
3606	\N	\N	\N	\N	\N	\N
3607	\N	\N	\N	\N	\N	\N
3608	\N	\N	\N	\N	\N	\N
3609	\N	\N	\N	\N	\N	\N
3610	\N	\N	\N	\N	\N	\N
3611	\N	\N	\N	\N	\N	\N
3612	\N	\N	\N	\N	\N	\N
3613	\N	\N	\N	\N	\N	\N
3614	\N	\N	\N	\N	\N	\N
3615	\N	\N	\N	\N	\N	\N
3616	\N	\N	\N	\N	\N	\N
3617	\N	\N	\N	\N	\N	\N
3618	\N	\N	\N	\N	\N	\N
3619	\N	\N	\N	\N	\N	\N
3620	\N	\N	\N	\N	\N	\N
3621	\N	\N	\N	\N	\N	\N
3622	\N	\N	\N	\N	\N	\N
3623	\N	\N	\N	\N	\N	\N
3624	\N	\N	\N	\N	\N	\N
3625	\N	\N	\N	\N	\N	\N
3626	\N	\N	\N	\N	\N	\N
3627	\N	\N	\N	\N	\N	\N
3628	\N	\N	\N	\N	\N	\N
3629	\N	\N	\N	\N	\N	\N
3630	\N	\N	\N	\N	\N	\N
3631	\N	\N	\N	\N	\N	\N
3632	\N	\N	\N	\N	\N	\N
3633	\N	\N	\N	\N	\N	\N
3634	\N	\N	\N	\N	\N	\N
3635	\N	\N	\N	\N	\N	\N
3636	\N	\N	\N	\N	\N	\N
3637	\N	\N	\N	\N	\N	\N
3638	\N	\N	\N	\N	\N	\N
3639	\N	\N	\N	\N	\N	\N
3640	\N	\N	\N	\N	\N	\N
3641	\N	\N	\N	\N	\N	\N
3642	\N	\N	\N	\N	\N	\N
3643	\N	\N	\N	\N	\N	\N
3644	\N	\N	\N	\N	\N	\N
3645	\N	\N	\N	\N	\N	\N
3646	\N	\N	\N	\N	\N	\N
3647	\N	\N	\N	\N	\N	\N
3648	\N	\N	\N	\N	\N	\N
3649	\N	\N	\N	\N	\N	\N
3650	\N	\N	\N	\N	\N	\N
3651	\N	\N	\N	\N	\N	\N
3652	\N	\N	\N	\N	\N	\N
3653	\N	\N	\N	\N	\N	\N
3654	\N	\N	\N	\N	\N	\N
3655	\N	\N	\N	\N	\N	\N
3656	\N	\N	\N	\N	\N	\N
3657	\N	\N	\N	\N	\N	\N
3658	\N	\N	\N	\N	\N	\N
3659	\N	\N	\N	\N	\N	\N
3660	\N	\N	\N	\N	\N	\N
3661	\N	\N	\N	\N	\N	\N
3662	\N	\N	\N	\N	\N	\N
3663	\N	\N	\N	\N	\N	\N
3664	\N	\N	\N	\N	\N	\N
3665	\N	\N	\N	\N	\N	\N
3666	\N	\N	\N	\N	\N	\N
3667	\N	\N	\N	\N	\N	\N
3668	\N	\N	\N	\N	\N	\N
3669	\N	\N	\N	\N	\N	\N
3670	\N	\N	\N	\N	\N	\N
3671	\N	\N	\N	\N	\N	\N
3672	\N	\N	\N	\N	\N	\N
3673	\N	\N	\N	\N	\N	\N
3674	\N	\N	\N	\N	\N	\N
3675	\N	\N	\N	\N	\N	\N
3676	\N	\N	\N	\N	\N	\N
3677	\N	\N	\N	\N	\N	\N
3678	\N	\N	\N	\N	\N	\N
3679	\N	\N	\N	\N	\N	\N
3680	\N	\N	\N	\N	\N	\N
3681	\N	\N	\N	\N	\N	\N
3682	\N	\N	\N	\N	\N	\N
3683	\N	\N	\N	\N	\N	\N
3684	\N	\N	\N	\N	\N	\N
3685	\N	\N	\N	\N	\N	\N
3686	\N	\N	\N	\N	\N	\N
3687	\N	\N	\N	\N	\N	\N
3688	\N	\N	\N	\N	\N	\N
3689	\N	\N	\N	\N	\N	\N
3690	\N	\N	\N	\N	\N	\N
3691	\N	\N	\N	\N	\N	\N
3692	\N	\N	\N	\N	\N	\N
3693	\N	\N	\N	\N	\N	\N
3694	\N	\N	\N	\N	\N	\N
3695	\N	\N	\N	\N	\N	\N
3696	\N	\N	\N	\N	\N	\N
3697	\N	\N	\N	\N	\N	\N
3698	\N	\N	\N	\N	\N	\N
3699	\N	\N	\N	\N	\N	\N
3700	\N	\N	\N	\N	\N	\N
3701	\N	\N	\N	\N	\N	\N
3702	\N	\N	\N	\N	\N	\N
3703	\N	\N	\N	\N	\N	\N
3704	\N	\N	\N	\N	\N	\N
3705	\N	\N	\N	\N	\N	\N
3706	\N	\N	\N	\N	\N	\N
3707	\N	\N	\N	\N	\N	\N
3708	\N	\N	\N	\N	\N	\N
3709	\N	\N	\N	\N	\N	\N
3710	\N	\N	\N	\N	\N	\N
3711	\N	\N	\N	\N	\N	\N
3712	\N	\N	\N	\N	\N	\N
3713	\N	\N	\N	\N	\N	\N
3714	\N	\N	\N	\N	\N	\N
3715	\N	\N	\N	\N	\N	\N
3716	\N	\N	\N	\N	\N	\N
3717	\N	\N	\N	\N	\N	\N
3718	\N	\N	\N	\N	\N	\N
3719	\N	\N	\N	\N	\N	\N
3720	\N	\N	\N	\N	\N	\N
3721	\N	\N	\N	\N	\N	\N
3722	\N	\N	\N	\N	\N	\N
3723	\N	\N	\N	\N	\N	\N
3724	\N	\N	\N	\N	\N	\N
3725	\N	\N	\N	\N	\N	\N
3726	\N	\N	\N	\N	\N	\N
3727	\N	\N	\N	\N	\N	\N
3728	\N	\N	\N	\N	\N	\N
3729	\N	\N	\N	\N	\N	\N
3730	\N	\N	\N	\N	\N	\N
3731	\N	\N	\N	\N	\N	\N
3732	\N	\N	\N	\N	\N	\N
3733	\N	\N	\N	\N	\N	\N
3734	\N	\N	\N	\N	\N	\N
3735	\N	\N	\N	\N	\N	\N
3736	\N	\N	\N	\N	\N	\N
3737	\N	\N	\N	\N	\N	\N
3738	\N	\N	\N	\N	\N	\N
3739	\N	\N	\N	\N	\N	\N
3740	\N	\N	\N	\N	\N	\N
3741	\N	\N	\N	\N	\N	\N
3742	\N	\N	\N	\N	\N	\N
3743	\N	\N	\N	\N	\N	\N
3744	\N	\N	\N	\N	\N	\N
3745	\N	\N	\N	\N	\N	\N
3746	\N	\N	\N	\N	\N	\N
3747	\N	\N	\N	\N	\N	\N
3748	\N	\N	\N	\N	\N	\N
3749	\N	\N	\N	\N	\N	\N
3750	\N	\N	\N	\N	\N	\N
3751	\N	\N	\N	\N	\N	\N
3752	\N	\N	\N	\N	\N	\N
3753	\N	\N	\N	\N	\N	\N
3754	\N	\N	\N	\N	\N	\N
3755	\N	\N	\N	\N	\N	\N
3756	\N	\N	\N	\N	\N	\N
3757	\N	\N	\N	\N	\N	\N
3758	\N	\N	\N	\N	\N	\N
3759	\N	\N	\N	\N	\N	\N
3760	\N	\N	\N	\N	\N	\N
3761	\N	\N	\N	\N	\N	\N
3762	\N	\N	\N	\N	\N	\N
3763	\N	\N	\N	\N	\N	\N
3764	\N	\N	\N	\N	\N	\N
3765	\N	\N	\N	\N	\N	\N
3766	\N	\N	\N	\N	\N	\N
3767	\N	\N	\N	\N	\N	\N
3768	\N	\N	\N	\N	\N	\N
3769	\N	\N	\N	\N	\N	\N
3770	\N	\N	\N	\N	\N	\N
3771	\N	\N	\N	\N	\N	\N
3772	\N	\N	\N	\N	\N	\N
3773	\N	\N	\N	\N	\N	\N
3774	\N	\N	\N	\N	\N	\N
3775	\N	\N	\N	\N	\N	\N
3776	\N	\N	\N	\N	\N	\N
3777	\N	\N	\N	\N	\N	\N
3778	\N	\N	\N	\N	\N	\N
3779	\N	\N	\N	\N	\N	\N
3780	\N	\N	\N	\N	\N	\N
3781	\N	\N	\N	\N	\N	\N
3782	\N	\N	\N	\N	\N	\N
3783	\N	\N	\N	\N	\N	\N
3784	\N	\N	\N	\N	\N	\N
3785	\N	\N	\N	\N	\N	\N
3786	\N	\N	\N	\N	\N	\N
3787	\N	\N	\N	\N	\N	\N
3788	\N	\N	\N	\N	\N	\N
3789	\N	\N	\N	\N	\N	\N
3790	\N	\N	\N	\N	\N	\N
3791	\N	\N	\N	\N	\N	\N
3792	\N	\N	\N	\N	\N	\N
3793	\N	\N	\N	\N	\N	\N
3794	\N	\N	\N	\N	\N	\N
3795	\N	\N	\N	\N	\N	\N
3796	\N	\N	\N	\N	\N	\N
3797	\N	\N	\N	\N	\N	\N
3798	\N	\N	\N	\N	\N	\N
3799	\N	\N	\N	\N	\N	\N
3800	\N	\N	\N	\N	\N	\N
3801	\N	\N	\N	\N	\N	\N
3802	\N	\N	\N	\N	\N	\N
3803	\N	\N	\N	\N	\N	\N
3804	\N	\N	\N	\N	\N	\N
3805	\N	\N	\N	\N	\N	\N
3806	\N	\N	\N	\N	\N	\N
3807	\N	\N	\N	\N	\N	\N
3808	\N	\N	\N	\N	\N	\N
3809	\N	\N	\N	\N	\N	\N
3810	\N	\N	\N	\N	\N	\N
3811	\N	\N	\N	\N	\N	\N
3812	\N	\N	\N	\N	\N	\N
3813	\N	\N	\N	\N	\N	\N
3814	\N	\N	\N	\N	\N	\N
3815	\N	\N	\N	\N	\N	\N
3816	\N	\N	\N	\N	\N	\N
3817	\N	\N	\N	\N	\N	\N
3818	\N	\N	\N	\N	\N	\N
3819	\N	\N	\N	\N	\N	\N
3820	\N	\N	\N	\N	\N	\N
3821	\N	\N	\N	\N	\N	\N
3822	\N	\N	\N	\N	\N	\N
3823	\N	\N	\N	\N	\N	\N
3824	\N	\N	\N	\N	\N	\N
3825	\N	\N	\N	\N	\N	\N
3826	\N	\N	\N	\N	\N	\N
3827	\N	\N	\N	\N	\N	\N
3828	\N	\N	\N	\N	\N	\N
3829	\N	\N	\N	\N	\N	\N
3830	\N	\N	\N	\N	\N	\N
3831	\N	\N	\N	\N	\N	\N
3832	\N	\N	\N	\N	\N	\N
3833	\N	\N	\N	\N	\N	\N
3834	\N	\N	\N	\N	\N	\N
3835	\N	\N	\N	\N	\N	\N
3836	\N	\N	\N	\N	\N	\N
3837	\N	\N	\N	\N	\N	\N
3838	\N	\N	\N	\N	\N	\N
3839	\N	\N	\N	\N	\N	\N
3840	\N	\N	\N	\N	\N	\N
3841	\N	\N	\N	\N	\N	\N
3842	\N	\N	\N	\N	\N	\N
3843	\N	\N	\N	\N	\N	\N
3844	\N	\N	\N	\N	\N	\N
3845	\N	\N	\N	\N	\N	\N
3846	\N	\N	\N	\N	\N	\N
3847	\N	\N	\N	\N	\N	\N
3848	\N	\N	\N	\N	\N	\N
3849	\N	\N	\N	\N	\N	\N
3850	\N	\N	\N	\N	\N	\N
3851	\N	\N	\N	\N	\N	\N
3852	\N	\N	\N	\N	\N	\N
3853	\N	\N	\N	\N	\N	\N
3854	\N	\N	\N	\N	\N	\N
3855	\N	\N	\N	\N	\N	\N
3856	\N	\N	\N	\N	\N	\N
3857	\N	\N	\N	\N	\N	\N
3858	\N	\N	\N	\N	\N	\N
3859	\N	\N	\N	\N	\N	\N
3860	\N	\N	\N	\N	\N	\N
3861	\N	\N	\N	\N	\N	\N
3862	\N	\N	\N	\N	\N	\N
3863	\N	\N	\N	\N	\N	\N
3864	\N	\N	\N	\N	\N	\N
3865	\N	\N	\N	\N	\N	\N
3866	\N	\N	\N	\N	\N	\N
3867	\N	\N	\N	\N	\N	\N
3868	\N	\N	\N	\N	\N	\N
3869	\N	\N	\N	\N	\N	\N
3870	\N	\N	\N	\N	\N	\N
3871	\N	\N	\N	\N	\N	\N
3872	\N	\N	\N	\N	\N	\N
3873	\N	\N	\N	\N	\N	\N
3874	\N	\N	\N	\N	\N	\N
3875	\N	\N	\N	\N	\N	\N
3876	\N	\N	\N	\N	\N	\N
3877	\N	\N	\N	\N	\N	\N
3878	\N	\N	\N	\N	\N	\N
3879	\N	\N	\N	\N	\N	\N
3880	\N	\N	\N	\N	\N	\N
3881	\N	\N	\N	\N	\N	\N
3882	\N	\N	\N	\N	\N	\N
3883	\N	\N	\N	\N	\N	\N
3884	\N	\N	\N	\N	\N	\N
3885	\N	\N	\N	\N	\N	\N
3886	\N	\N	\N	\N	\N	\N
3887	\N	\N	\N	\N	\N	\N
3888	\N	\N	\N	\N	\N	\N
3889	\N	\N	\N	\N	\N	\N
3890	\N	\N	\N	\N	\N	\N
3891	\N	\N	\N	\N	\N	\N
3892	\N	\N	\N	\N	\N	\N
3893	\N	\N	\N	\N	\N	\N
3894	\N	\N	\N	\N	\N	\N
3895	\N	\N	\N	\N	\N	\N
3896	\N	\N	\N	\N	\N	\N
3897	\N	\N	\N	\N	\N	\N
3898	\N	\N	\N	\N	\N	\N
3899	\N	\N	\N	\N	\N	\N
3900	\N	\N	\N	\N	\N	\N
3901	\N	\N	\N	\N	\N	\N
3902	\N	\N	\N	\N	\N	\N
3903	\N	\N	\N	\N	\N	\N
3904	\N	\N	\N	\N	\N	\N
3905	\N	\N	\N	\N	\N	\N
3906	\N	\N	\N	\N	\N	\N
3907	\N	\N	\N	\N	\N	\N
3908	\N	\N	\N	\N	\N	\N
3909	\N	\N	\N	\N	\N	\N
3910	\N	\N	\N	\N	\N	\N
3911	\N	\N	\N	\N	\N	\N
3912	\N	\N	\N	\N	\N	\N
3913	\N	\N	\N	\N	\N	\N
3914	\N	\N	\N	\N	\N	\N
3915	\N	\N	\N	\N	\N	\N
3916	\N	\N	\N	\N	\N	\N
3917	\N	\N	\N	\N	\N	\N
3918	\N	\N	\N	\N	\N	\N
3919	\N	\N	\N	\N	\N	\N
3920	\N	\N	\N	\N	\N	\N
3921	\N	\N	\N	\N	\N	\N
3922	\N	\N	\N	\N	\N	\N
3923	\N	\N	\N	\N	\N	\N
3924	\N	\N	\N	\N	\N	\N
3925	\N	\N	\N	\N	\N	\N
3926	\N	\N	\N	\N	\N	\N
3927	\N	\N	\N	\N	\N	\N
3928	\N	\N	\N	\N	\N	\N
3929	\N	\N	\N	\N	\N	\N
3930	\N	\N	\N	\N	\N	\N
3931	\N	\N	\N	\N	\N	\N
3932	\N	\N	\N	\N	\N	\N
3933	\N	\N	\N	\N	\N	\N
3934	\N	\N	\N	\N	\N	\N
3935	\N	\N	\N	\N	\N	\N
3936	\N	\N	\N	\N	\N	\N
3937	\N	\N	\N	\N	\N	\N
3938	\N	\N	\N	\N	\N	\N
3939	\N	\N	\N	\N	\N	\N
3940	\N	\N	\N	\N	\N	\N
3941	\N	\N	\N	\N	\N	\N
3942	\N	\N	\N	\N	\N	\N
3943	\N	\N	\N	\N	\N	\N
3944	\N	\N	\N	\N	\N	\N
3945	\N	\N	\N	\N	\N	\N
3946	\N	\N	\N	\N	\N	\N
3947	\N	\N	\N	\N	\N	\N
3948	\N	\N	\N	\N	\N	\N
3949	\N	\N	\N	\N	\N	\N
3950	\N	\N	\N	\N	\N	\N
3951	\N	\N	\N	\N	\N	\N
3952	\N	\N	\N	\N	\N	\N
3953	\N	\N	\N	\N	\N	\N
3954	\N	\N	\N	\N	\N	\N
3955	\N	\N	\N	\N	\N	\N
3956	90	\N	\N	\N	\N	\N
3957	90	\N	\N	\N	\N	\N
3958	90	\N	\N	\N	\N	\N
3959	90	\N	\N	\N	\N	\N
3960	90	\N	\N	\N	\N	\N
3961	90	\N	\N	\N	\N	\N
3962	90	\N	\N	\N	\N	\N
3963	90	\N	\N	\N	\N	\N
3964	\N	\N	\N	\N	\N	\N
3965	\N	\N	\N	\N	\N	\N
3966	\N	\N	\N	\N	\N	\N
3967	\N	\N	\N	\N	\N	\N
3968	\N	\N	\N	\N	\N	\N
3969	\N	\N	\N	\N	\N	\N
3970	\N	\N	\N	\N	\N	\N
3971	\N	\N	\N	\N	\N	\N
3972	\N	\N	\N	\N	\N	\N
3973	\N	\N	\N	\N	\N	\N
3974	\N	\N	\N	\N	\N	\N
3975	\N	\N	\N	\N	\N	\N
3976	\N	\N	\N	\N	\N	\N
3977	\N	\N	\N	\N	\N	\N
3978	\N	\N	\N	\N	\N	\N
3979	\N	\N	\N	\N	\N	\N
3980	\N	\N	\N	\N	\N	\N
3981	\N	\N	\N	\N	\N	\N
3982	\N	\N	\N	\N	\N	\N
3983	\N	\N	\N	\N	\N	\N
3984	\N	\N	\N	\N	\N	\N
3985	\N	\N	\N	\N	\N	\N
3986	\N	\N	\N	\N	\N	\N
3987	\N	\N	\N	\N	\N	\N
3988	\N	\N	\N	\N	\N	\N
3989	\N	\N	\N	\N	\N	\N
3990	\N	\N	\N	\N	\N	\N
3991	\N	\N	\N	\N	\N	\N
3992	\N	\N	\N	\N	\N	\N
3993	\N	\N	\N	\N	\N	\N
3994	\N	\N	\N	\N	\N	\N
3995	\N	\N	\N	\N	\N	\N
3996	\N	\N	\N	\N	\N	\N
3997	\N	\N	\N	\N	\N	\N
3998	\N	\N	\N	\N	\N	\N
3999	\N	\N	\N	\N	\N	\N
4000	\N	\N	\N	\N	\N	\N
4001	\N	\N	\N	\N	\N	\N
4002	\N	\N	\N	\N	\N	\N
4003	\N	\N	\N	\N	\N	\N
4004	\N	\N	\N	\N	\N	\N
4005	\N	\N	\N	\N	\N	\N
4006	\N	\N	\N	\N	\N	\N
4007	\N	\N	\N	\N	\N	\N
4008	\N	\N	\N	\N	\N	\N
4009	\N	\N	\N	\N	\N	\N
4010	\N	\N	\N	\N	\N	\N
4011	\N	\N	\N	\N	\N	\N
4012	\N	\N	\N	\N	\N	\N
4013	\N	\N	\N	\N	\N	\N
4014	\N	\N	\N	\N	\N	\N
4015	\N	\N	\N	\N	\N	\N
4016	\N	\N	\N	\N	\N	\N
4017	\N	\N	\N	\N	\N	\N
4018	\N	\N	\N	\N	\N	\N
4019	\N	\N	\N	\N	\N	\N
4020	\N	\N	\N	\N	\N	\N
4021	\N	\N	\N	\N	\N	\N
4022	\N	\N	\N	\N	\N	\N
4023	\N	\N	\N	\N	\N	\N
4024	\N	\N	\N	\N	\N	\N
4025	\N	\N	\N	\N	\N	\N
4026	\N	\N	\N	\N	\N	\N
4027	\N	\N	\N	\N	\N	\N
4028	\N	\N	\N	\N	\N	\N
4029	\N	\N	\N	\N	\N	\N
4030	\N	\N	\N	\N	\N	\N
4031	\N	\N	\N	\N	\N	\N
4032	\N	\N	\N	\N	\N	\N
4033	\N	\N	\N	\N	\N	\N
4034	\N	\N	\N	\N	\N	\N
4035	\N	\N	\N	\N	\N	\N
4036	\N	\N	\N	\N	\N	\N
4037	\N	\N	\N	\N	\N	\N
4038	\N	\N	\N	\N	\N	\N
4039	\N	\N	\N	\N	\N	\N
4040	\N	\N	\N	\N	\N	\N
4041	\N	\N	\N	\N	\N	\N
4042	\N	\N	\N	\N	\N	\N
4043	\N	\N	\N	\N	\N	\N
4044	\N	\N	\N	\N	\N	\N
4045	\N	\N	\N	\N	\N	\N
4046	\N	\N	\N	\N	\N	\N
4047	\N	\N	\N	\N	\N	\N
4048	\N	\N	\N	\N	\N	\N
4049	\N	\N	\N	\N	\N	\N
4050	\N	\N	\N	\N	\N	\N
4051	\N	\N	\N	\N	\N	\N
4052	\N	\N	\N	\N	\N	\N
4053	\N	\N	\N	\N	\N	\N
4054	\N	\N	\N	\N	\N	\N
4055	\N	\N	\N	\N	\N	\N
4056	\N	\N	\N	\N	\N	\N
4057	\N	\N	\N	\N	\N	\N
4058	\N	\N	\N	\N	\N	\N
4059	\N	\N	\N	\N	\N	\N
4060	\N	\N	\N	\N	\N	\N
4061	\N	\N	\N	\N	\N	\N
4062	\N	\N	\N	\N	\N	\N
4063	\N	\N	\N	\N	\N	\N
4064	\N	\N	\N	\N	\N	\N
4065	\N	\N	\N	\N	\N	\N
4066	\N	\N	\N	\N	\N	\N
4067	\N	\N	\N	\N	\N	\N
4068	\N	\N	\N	\N	\N	\N
4069	\N	\N	\N	\N	\N	\N
4070	\N	\N	\N	\N	\N	\N
4071	\N	\N	\N	\N	\N	\N
4072	\N	\N	\N	\N	\N	\N
4073	\N	\N	\N	\N	\N	\N
4074	\N	\N	\N	\N	\N	\N
4075	\N	\N	\N	\N	\N	\N
4076	\N	\N	\N	\N	\N	\N
4077	\N	\N	\N	\N	\N	\N
4078	\N	\N	\N	\N	\N	\N
4079	\N	\N	\N	\N	\N	\N
4080	\N	\N	\N	\N	\N	\N
4081	\N	\N	\N	\N	\N	\N
4082	\N	\N	\N	\N	\N	\N
4083	\N	\N	\N	\N	\N	\N
4084	\N	\N	\N	\N	\N	\N
4085	\N	\N	\N	\N	\N	\N
4086	\N	\N	\N	\N	\N	\N
4087	\N	\N	\N	\N	\N	\N
4088	\N	\N	\N	\N	\N	\N
4089	\N	\N	\N	\N	\N	\N
4090	\N	\N	\N	\N	\N	\N
4091	\N	\N	\N	\N	\N	\N
4092	\N	\N	\N	\N	\N	\N
4093	\N	\N	\N	\N	\N	\N
4094	\N	\N	\N	\N	\N	\N
4095	\N	\N	\N	\N	\N	\N
4096	\N	\N	\N	\N	\N	\N
4097	\N	\N	\N	\N	\N	\N
4098	\N	\N	\N	\N	\N	\N
4099	\N	\N	\N	\N	\N	\N
4100	\N	\N	\N	\N	\N	\N
4101	\N	\N	\N	\N	\N	\N
4102	\N	\N	\N	\N	\N	\N
4103	\N	\N	\N	\N	\N	\N
4104	\N	\N	\N	\N	\N	\N
4105	\N	\N	\N	\N	\N	\N
4106	\N	\N	\N	\N	\N	\N
4107	\N	\N	\N	\N	\N	\N
4108	\N	\N	\N	\N	\N	\N
4109	\N	\N	\N	\N	\N	\N
4110	\N	\N	\N	\N	\N	\N
4111	\N	\N	\N	\N	\N	\N
4112	\N	\N	\N	\N	\N	\N
4113	\N	\N	\N	\N	\N	\N
4114	\N	\N	\N	\N	\N	\N
4115	\N	\N	\N	\N	\N	\N
4116	\N	\N	\N	\N	\N	\N
4117	\N	\N	\N	\N	\N	\N
4118	\N	\N	\N	\N	\N	\N
4119	\N	\N	\N	\N	\N	\N
4120	\N	\N	\N	\N	\N	\N
4121	\N	\N	\N	\N	\N	\N
4122	\N	\N	\N	\N	\N	\N
4123	\N	\N	\N	\N	\N	\N
4124	\N	\N	\N	\N	\N	\N
4125	\N	\N	\N	\N	\N	\N
4126	\N	\N	\N	\N	\N	\N
4127	\N	\N	\N	\N	\N	\N
4128	\N	\N	\N	\N	\N	\N
4129	\N	\N	\N	\N	\N	\N
4130	\N	\N	\N	\N	\N	\N
4131	\N	\N	\N	\N	\N	\N
4132	\N	\N	\N	\N	\N	\N
4133	\N	\N	\N	\N	\N	\N
4134	\N	\N	\N	\N	\N	\N
4135	\N	\N	\N	\N	\N	\N
4136	\N	\N	\N	\N	\N	\N
4137	\N	\N	\N	\N	\N	\N
4138	\N	\N	\N	\N	\N	\N
4139	\N	\N	\N	\N	\N	\N
4140	\N	\N	\N	\N	\N	\N
4141	\N	\N	\N	\N	\N	\N
4142	\N	\N	\N	\N	\N	\N
4143	\N	\N	\N	\N	\N	\N
4144	\N	\N	\N	\N	\N	\N
4145	\N	\N	\N	\N	\N	\N
4146	\N	\N	\N	\N	\N	\N
4147	\N	\N	\N	\N	\N	\N
4148	\N	\N	\N	\N	\N	\N
4149	\N	\N	\N	\N	\N	\N
4150	\N	\N	\N	\N	\N	\N
4151	\N	\N	\N	\N	\N	\N
4152	\N	\N	\N	\N	\N	\N
4153	\N	\N	\N	\N	\N	\N
4154	\N	\N	\N	\N	\N	\N
4155	\N	\N	\N	\N	\N	\N
4156	\N	\N	\N	\N	\N	\N
4157	\N	\N	\N	\N	\N	\N
4158	\N	\N	\N	\N	\N	\N
4159	\N	\N	\N	\N	\N	\N
4160	\N	\N	\N	\N	\N	\N
4161	\N	\N	\N	\N	\N	\N
4162	\N	\N	\N	\N	\N	\N
4163	\N	\N	\N	\N	\N	\N
4164	\N	\N	\N	\N	\N	\N
4165	\N	\N	\N	\N	\N	\N
4166	\N	\N	\N	\N	\N	\N
4167	\N	\N	\N	\N	\N	\N
4168	\N	\N	\N	\N	\N	\N
4169	\N	\N	\N	\N	\N	\N
4170	\N	\N	\N	\N	\N	\N
4171	\N	\N	\N	\N	\N	\N
4172	\N	\N	\N	\N	\N	\N
4173	\N	\N	\N	\N	\N	\N
4174	\N	\N	\N	\N	\N	\N
4175	\N	\N	\N	\N	\N	\N
4176	\N	\N	\N	\N	\N	\N
4177	\N	\N	\N	\N	\N	\N
4178	\N	\N	\N	\N	\N	\N
4179	\N	\N	\N	\N	\N	\N
4180	\N	\N	\N	\N	\N	\N
4181	\N	\N	\N	\N	\N	\N
4182	\N	\N	\N	\N	\N	\N
4183	\N	\N	\N	\N	\N	\N
4184	\N	\N	\N	\N	\N	\N
4185	\N	\N	\N	\N	\N	\N
4186	\N	\N	\N	\N	\N	\N
4187	\N	\N	\N	\N	\N	\N
4188	\N	\N	\N	\N	\N	\N
4189	\N	\N	\N	\N	\N	\N
4190	\N	\N	\N	\N	\N	\N
4191	\N	\N	\N	\N	\N	\N
4192	\N	\N	\N	\N	\N	\N
4193	\N	\N	\N	\N	\N	\N
4194	\N	\N	\N	\N	\N	\N
4195	\N	\N	\N	\N	\N	\N
4196	\N	\N	\N	\N	\N	\N
4197	\N	\N	\N	\N	\N	\N
4198	\N	\N	\N	\N	\N	\N
4199	\N	\N	\N	\N	\N	\N
4200	\N	\N	\N	\N	\N	\N
4201	\N	\N	\N	\N	\N	\N
4202	\N	\N	\N	\N	\N	\N
4203	\N	\N	\N	\N	\N	\N
4204	\N	\N	\N	\N	\N	\N
4205	\N	\N	\N	\N	\N	\N
4206	\N	\N	\N	\N	\N	\N
4207	\N	\N	\N	\N	\N	\N
4208	\N	\N	\N	\N	\N	\N
4209	\N	\N	\N	\N	\N	\N
4210	\N	\N	\N	\N	\N	\N
4211	\N	\N	\N	\N	\N	\N
4212	\N	\N	\N	\N	\N	\N
4213	\N	\N	\N	\N	\N	\N
4214	\N	\N	\N	\N	\N	\N
4215	\N	\N	\N	\N	\N	\N
4216	\N	\N	\N	\N	\N	\N
4217	\N	\N	\N	\N	\N	\N
4218	\N	\N	\N	\N	\N	\N
4219	\N	\N	\N	\N	\N	\N
4220	\N	\N	\N	\N	\N	\N
4221	\N	\N	\N	\N	\N	\N
4222	\N	\N	\N	\N	\N	\N
4223	\N	\N	\N	\N	\N	\N
4224	\N	\N	\N	\N	\N	\N
4225	\N	\N	\N	\N	\N	\N
4226	\N	\N	3	\N	\N	\N
4227	\N	\N	3	\N	\N	\N
4228	\N	\N	3	\N	\N	\N
4229	\N	\N	3	\N	\N	\N
4230	\N	\N	3	\N	\N	\N
4231	\N	\N	3	\N	\N	\N
4232	\N	\N	3	\N	\N	\N
4233	\N	\N	3	\N	\N	\N
4234	\N	\N	3	\N	\N	\N
4235	\N	\N	\N	\N	\N	\N
4236	\N	\N	\N	\N	\N	\N
4237	\N	\N	\N	\N	\N	\N
4238	\N	\N	\N	\N	\N	\N
4239	\N	\N	\N	\N	\N	\N
4240	\N	\N	\N	\N	\N	\N
4241	\N	\N	\N	\N	\N	\N
4242	\N	\N	\N	\N	\N	\N
4243	\N	\N	\N	\N	\N	\N
4244	\N	\N	\N	\N	\N	\N
4245	\N	\N	\N	\N	\N	\N
4246	\N	\N	\N	\N	\N	\N
4247	\N	\N	\N	\N	\N	\N
4248	\N	\N	\N	\N	\N	\N
4249	\N	\N	\N	\N	\N	\N
4250	\N	\N	\N	\N	\N	\N
4251	\N	\N	\N	\N	\N	\N
4252	\N	\N	\N	\N	\N	\N
4253	\N	\N	\N	\N	\N	\N
4254	\N	\N	\N	\N	\N	\N
4255	\N	\N	\N	\N	\N	\N
4256	\N	\N	\N	\N	\N	\N
4257	\N	\N	\N	\N	\N	\N
4258	\N	\N	\N	\N	\N	\N
4259	\N	\N	\N	\N	\N	\N
4260	\N	\N	\N	\N	\N	\N
4261	\N	\N	\N	\N	\N	\N
4262	\N	\N	\N	\N	\N	\N
4263	\N	\N	\N	\N	\N	\N
4264	\N	\N	\N	\N	\N	\N
4265	\N	\N	\N	\N	\N	\N
4266	\N	\N	\N	\N	\N	\N
4267	\N	\N	\N	\N	\N	\N
4268	\N	\N	\N	\N	\N	\N
4269	\N	\N	\N	\N	\N	\N
4270	\N	\N	\N	\N	\N	\N
4271	\N	\N	\N	\N	\N	\N
4272	\N	\N	\N	\N	\N	\N
4273	\N	\N	\N	\N	\N	\N
4274	\N	\N	\N	\N	\N	\N
4275	\N	\N	\N	\N	\N	\N
4276	\N	\N	\N	\N	\N	\N
4277	\N	\N	\N	\N	\N	\N
4278	\N	\N	\N	\N	\N	\N
4279	\N	\N	\N	\N	\N	\N
4280	\N	\N	\N	\N	\N	\N
4281	\N	\N	\N	\N	\N	\N
4282	\N	\N	\N	\N	\N	\N
4283	\N	\N	\N	\N	\N	\N
4284	\N	\N	\N	\N	\N	\N
4285	\N	\N	\N	\N	\N	\N
4286	\N	\N	\N	\N	\N	\N
4287	\N	\N	\N	\N	\N	\N
4288	\N	\N	\N	\N	\N	\N
4289	\N	\N	\N	\N	\N	\N
4290	\N	\N	\N	\N	\N	\N
4291	\N	\N	\N	\N	\N	\N
4292	\N	\N	\N	\N	\N	\N
4293	\N	\N	\N	\N	\N	\N
4294	\N	\N	\N	\N	\N	\N
4295	\N	\N	\N	\N	\N	\N
4296	\N	\N	\N	\N	\N	\N
4297	\N	\N	\N	\N	\N	\N
4298	\N	\N	\N	\N	\N	\N
4299	\N	\N	\N	\N	\N	\N
4300	\N	\N	\N	\N	\N	\N
4301	\N	\N	\N	\N	\N	\N
4302	\N	\N	\N	\N	\N	\N
4303	\N	\N	\N	\N	\N	\N
4304	\N	\N	\N	\N	\N	\N
4305	\N	\N	\N	\N	\N	\N
4306	\N	\N	\N	\N	\N	\N
4307	\N	\N	\N	\N	\N	\N
4308	\N	\N	\N	\N	\N	\N
4309	\N	\N	\N	\N	\N	\N
4310	\N	\N	\N	\N	\N	\N
4311	\N	\N	\N	\N	\N	\N
4312	\N	\N	\N	\N	\N	\N
4313	\N	\N	\N	\N	\N	\N
4314	\N	\N	\N	\N	\N	\N
4315	\N	\N	\N	\N	\N	\N
4316	\N	\N	\N	\N	\N	\N
4317	\N	\N	\N	\N	\N	\N
4318	\N	\N	\N	\N	\N	\N
4319	\N	\N	\N	\N	\N	\N
4320	\N	\N	\N	\N	\N	\N
4321	\N	\N	\N	\N	\N	\N
4322	\N	\N	\N	\N	\N	\N
4323	\N	\N	\N	\N	\N	\N
4324	\N	\N	\N	\N	\N	\N
4325	\N	\N	\N	\N	\N	\N
4326	\N	\N	\N	\N	\N	\N
4327	\N	\N	\N	\N	\N	\N
4328	\N	\N	\N	\N	\N	\N
4329	\N	\N	\N	\N	\N	\N
4330	\N	\N	\N	\N	\N	\N
4331	\N	\N	\N	\N	\N	\N
4332	\N	\N	\N	\N	\N	\N
4333	\N	\N	\N	\N	\N	\N
4334	\N	\N	\N	\N	\N	\N
4335	\N	\N	\N	\N	\N	\N
4336	\N	\N	\N	\N	\N	\N
4337	\N	\N	\N	\N	\N	\N
4338	\N	\N	\N	\N	\N	\N
4339	\N	\N	\N	\N	\N	\N
4340	\N	\N	\N	\N	\N	\N
4341	\N	\N	\N	\N	\N	\N
4342	\N	\N	\N	\N	\N	\N
4343	\N	\N	\N	\N	\N	\N
4344	\N	\N	\N	\N	\N	\N
4345	\N	\N	\N	\N	\N	\N
4346	\N	\N	\N	\N	\N	\N
4347	\N	\N	\N	\N	\N	\N
4348	\N	\N	\N	\N	\N	\N
4349	\N	\N	\N	\N	\N	\N
4350	\N	\N	\N	\N	\N	\N
4351	\N	\N	\N	\N	\N	\N
4352	\N	\N	\N	\N	\N	\N
4353	\N	\N	\N	\N	\N	\N
4354	\N	\N	\N	\N	\N	\N
4355	\N	\N	\N	\N	\N	\N
4356	\N	\N	\N	\N	\N	\N
4357	\N	\N	\N	\N	\N	\N
4358	\N	\N	\N	\N	\N	\N
4359	\N	\N	\N	\N	\N	\N
4360	\N	\N	\N	\N	\N	\N
4361	\N	\N	\N	\N	\N	\N
4362	\N	\N	\N	\N	\N	\N
4363	\N	\N	\N	\N	\N	\N
4364	\N	\N	\N	\N	\N	\N
4365	\N	\N	\N	\N	\N	\N
4366	\N	\N	\N	\N	\N	\N
4367	\N	\N	\N	\N	\N	\N
4368	\N	\N	\N	\N	\N	\N
4369	\N	\N	\N	\N	\N	\N
4370	\N	\N	\N	\N	\N	\N
4371	\N	\N	\N	\N	\N	\N
4372	\N	\N	\N	\N	\N	\N
4373	\N	\N	\N	\N	\N	\N
4374	\N	\N	\N	\N	\N	\N
4375	\N	\N	\N	\N	\N	\N
4376	\N	\N	\N	\N	\N	\N
4377	\N	\N	\N	\N	\N	\N
4378	\N	\N	\N	\N	\N	\N
4379	\N	\N	\N	\N	\N	\N
4380	\N	\N	\N	\N	\N	\N
4381	\N	\N	\N	\N	\N	\N
4382	\N	\N	\N	\N	\N	\N
4383	\N	\N	\N	\N	\N	\N
4384	\N	\N	\N	\N	\N	\N
4385	\N	\N	\N	\N	\N	\N
4386	\N	\N	\N	\N	\N	\N
4387	\N	\N	\N	\N	\N	\N
4388	\N	\N	\N	\N	\N	\N
4389	\N	\N	\N	\N	\N	\N
4390	\N	\N	\N	\N	\N	\N
4391	\N	\N	\N	\N	\N	\N
4392	\N	\N	\N	\N	\N	\N
4393	\N	\N	\N	\N	\N	\N
4394	\N	\N	\N	\N	\N	\N
4395	\N	\N	\N	\N	\N	\N
4396	\N	\N	\N	\N	\N	\N
4397	\N	\N	\N	\N	\N	\N
4398	\N	\N	\N	\N	\N	\N
4399	\N	\N	\N	\N	\N	\N
4400	\N	\N	\N	\N	\N	\N
4401	\N	\N	\N	\N	\N	\N
4402	\N	\N	\N	\N	\N	\N
4403	\N	\N	\N	\N	\N	\N
4404	\N	\N	\N	\N	\N	\N
4405	\N	\N	\N	\N	\N	\N
4406	\N	\N	\N	\N	\N	\N
4407	\N	\N	\N	\N	\N	\N
4408	\N	\N	\N	\N	\N	\N
4409	\N	\N	\N	\N	\N	\N
4410	\N	\N	\N	\N	\N	\N
4411	\N	\N	\N	\N	\N	\N
4412	\N	\N	\N	\N	\N	\N
4413	\N	\N	\N	\N	\N	\N
4414	\N	\N	\N	\N	\N	\N
4415	\N	\N	\N	\N	\N	\N
4416	\N	\N	\N	\N	\N	\N
4417	\N	\N	\N	\N	\N	\N
4418	\N	\N	\N	\N	\N	\N
4419	\N	\N	\N	\N	\N	\N
4420	\N	\N	\N	\N	\N	\N
4421	\N	\N	\N	\N	\N	\N
4422	\N	\N	\N	\N	\N	\N
4423	\N	\N	\N	\N	\N	\N
4424	\N	\N	\N	\N	\N	\N
4425	\N	\N	\N	\N	\N	\N
4426	\N	\N	\N	\N	\N	\N
4427	\N	\N	\N	\N	\N	\N
4428	\N	\N	\N	\N	\N	\N
4429	\N	\N	\N	\N	\N	\N
4430	\N	\N	\N	\N	\N	\N
4431	\N	\N	\N	\N	\N	\N
4432	\N	\N	\N	\N	\N	\N
4433	\N	\N	\N	\N	\N	\N
4434	\N	\N	\N	\N	\N	\N
4435	\N	\N	\N	\N	\N	\N
4436	\N	\N	\N	\N	\N	\N
4437	\N	\N	\N	\N	\N	\N
4438	\N	\N	\N	\N	\N	\N
4439	\N	\N	\N	\N	\N	\N
4440	\N	\N	\N	\N	\N	\N
4441	\N	\N	\N	\N	\N	\N
4442	\N	\N	\N	\N	\N	\N
4443	\N	\N	\N	\N	\N	\N
4444	\N	\N	\N	\N	\N	\N
4445	\N	\N	\N	\N	\N	\N
4446	\N	\N	\N	\N	\N	\N
4447	\N	\N	\N	\N	\N	\N
4448	\N	\N	\N	\N	\N	\N
4449	\N	\N	\N	\N	\N	\N
4450	\N	\N	\N	\N	\N	\N
4451	\N	\N	\N	\N	\N	\N
4452	\N	\N	\N	\N	\N	\N
4453	\N	\N	\N	\N	\N	\N
4454	\N	\N	\N	\N	\N	\N
4455	\N	\N	\N	\N	\N	\N
4456	\N	\N	\N	\N	\N	\N
4457	\N	\N	\N	\N	\N	\N
4458	\N	\N	\N	\N	\N	\N
4459	\N	\N	\N	\N	\N	\N
4460	\N	\N	\N	\N	\N	\N
4461	\N	\N	\N	\N	\N	\N
4462	\N	\N	\N	\N	\N	\N
4463	\N	\N	\N	\N	\N	\N
4464	\N	\N	\N	\N	\N	\N
4465	\N	\N	\N	\N	\N	\N
4466	\N	\N	\N	\N	\N	\N
4467	\N	\N	\N	\N	\N	\N
4468	\N	\N	\N	\N	\N	\N
4469	\N	\N	\N	\N	\N	\N
4470	\N	\N	\N	\N	\N	\N
4471	\N	\N	\N	\N	\N	\N
4472	\N	\N	\N	\N	\N	\N
4473	\N	\N	\N	\N	\N	\N
4474	\N	\N	\N	\N	\N	\N
4475	\N	\N	\N	\N	\N	\N
4476	\N	\N	\N	\N	\N	\N
4477	\N	\N	\N	\N	\N	\N
4478	\N	\N	\N	\N	\N	\N
4479	\N	\N	\N	\N	\N	\N
4480	\N	\N	\N	\N	\N	\N
4481	\N	\N	\N	\N	\N	\N
4482	\N	\N	\N	\N	\N	\N
4483	\N	\N	\N	\N	\N	\N
4484	\N	\N	\N	\N	\N	\N
4485	\N	\N	\N	\N	\N	\N
4486	\N	\N	\N	\N	\N	\N
4487	\N	\N	\N	\N	\N	\N
4488	\N	\N	\N	\N	\N	\N
4489	\N	\N	\N	\N	\N	\N
4490	\N	\N	\N	\N	\N	\N
4491	\N	\N	\N	\N	\N	\N
4492	\N	\N	\N	\N	\N	\N
4493	\N	\N	\N	\N	\N	\N
4494	\N	\N	\N	\N	\N	\N
4495	\N	\N	\N	\N	\N	\N
4496	\N	\N	\N	\N	\N	\N
4497	\N	\N	\N	\N	\N	\N
4498	\N	\N	\N	\N	\N	\N
4499	\N	\N	\N	\N	\N	\N
4500	\N	\N	\N	\N	\N	\N
4501	\N	\N	\N	\N	\N	\N
4502	\N	\N	\N	\N	\N	\N
4503	\N	\N	\N	\N	\N	\N
4504	\N	\N	\N	\N	\N	\N
4505	\N	\N	\N	\N	\N	\N
4506	\N	\N	\N	\N	\N	\N
4507	\N	\N	\N	\N	\N	\N
4508	\N	\N	\N	\N	\N	\N
4509	\N	\N	\N	\N	\N	\N
4510	\N	\N	\N	\N	\N	\N
4511	\N	\N	\N	\N	\N	\N
4512	\N	\N	\N	\N	\N	\N
4513	\N	\N	\N	\N	\N	\N
4514	\N	\N	\N	\N	\N	\N
4515	\N	\N	\N	\N	\N	\N
4516	\N	\N	\N	\N	\N	\N
4517	\N	\N	\N	\N	\N	\N
4518	\N	\N	\N	\N	\N	\N
4519	\N	\N	\N	\N	\N	\N
4520	\N	\N	\N	\N	\N	\N
4521	\N	\N	\N	\N	\N	\N
4522	\N	\N	\N	\N	\N	\N
4523	\N	\N	\N	\N	\N	\N
4524	\N	\N	\N	\N	\N	\N
4525	\N	\N	\N	\N	\N	\N
4526	\N	\N	\N	\N	\N	\N
4527	\N	\N	\N	\N	\N	\N
4528	\N	\N	\N	\N	\N	\N
4529	\N	\N	\N	\N	\N	\N
4530	\N	\N	\N	\N	\N	\N
4531	\N	\N	\N	\N	\N	\N
4532	\N	\N	\N	\N	\N	\N
4533	\N	\N	\N	\N	\N	\N
4534	\N	\N	\N	\N	\N	\N
4535	\N	\N	\N	\N	\N	\N
4536	\N	\N	\N	\N	\N	\N
4537	\N	\N	\N	\N	\N	\N
4538	\N	\N	\N	\N	\N	\N
4539	\N	\N	\N	\N	\N	\N
4540	\N	\N	\N	\N	\N	\N
4541	\N	\N	\N	\N	\N	\N
4542	\N	\N	\N	\N	\N	\N
4543	\N	\N	\N	\N	\N	\N
4544	\N	\N	\N	\N	\N	\N
4545	\N	\N	\N	\N	\N	\N
4546	\N	\N	\N	\N	\N	\N
4547	\N	\N	\N	\N	\N	\N
4548	\N	\N	\N	\N	\N	\N
4549	\N	\N	\N	\N	\N	\N
4550	\N	\N	\N	\N	\N	\N
4551	\N	\N	\N	\N	\N	\N
4552	\N	\N	\N	\N	\N	\N
4553	\N	\N	\N	\N	\N	\N
4554	\N	\N	\N	\N	\N	\N
4555	\N	\N	\N	\N	\N	\N
4556	NaN	NaN	NaN	NaN	NaN	NaN
4557	NaN	NaN	NaN	NaN	NaN	NaN
4558	NaN	NaN	3	NaN	NaN	NaN
4559	NaN	NaN	3	NaN	NaN	NaN
4560	NaN	NaN	3	NaN	NaN	NaN
4561	NaN	NaN	3	NaN	NaN	NaN
4562	NaN	NaN	3	NaN	NaN	NaN
4563	NaN	NaN	3	NaN	NaN	NaN
4564	NaN	NaN	3	NaN	NaN	NaN
4565	NaN	NaN	3	NaN	NaN	NaN
4566	NaN	NaN	3	NaN	NaN	NaN
4567	NaN	NaN	3	NaN	NaN	NaN
4568	NaN	NaN	3	NaN	NaN	NaN
4569	NaN	NaN	NaN	NaN	NaN	NaN
4570	NaN	NaN	NaN	NaN	NaN	NaN
4571	NaN	NaN	NaN	NaN	NaN	NaN
4572	NaN	NaN	NaN	NaN	NaN	NaN
4573	NaN	NaN	NaN	NaN	NaN	NaN
4574	NaN	NaN	NaN	NaN	NaN	NaN
4575	NaN	NaN	NaN	NaN	NaN	NaN
4576	NaN	NaN	NaN	NaN	NaN	NaN
4577	NaN	NaN	NaN	NaN	NaN	NaN
4578	NaN	NaN	NaN	NaN	NaN	NaN
4579	NaN	NaN	NaN	NaN	NaN	NaN
4580	NaN	NaN	NaN	NaN	NaN	NaN
4581	NaN	NaN	NaN	NaN	NaN	NaN
4582	NaN	NaN	NaN	NaN	NaN	NaN
4583	NaN	NaN	NaN	NaN	NaN	NaN
4584	NaN	NaN	NaN	NaN	NaN	NaN
4585	NaN	NaN	NaN	NaN	NaN	NaN
4586	NaN	NaN	NaN	NaN	NaN	NaN
4587	NaN	NaN	NaN	NaN	NaN	NaN
4588	NaN	NaN	NaN	NaN	NaN	NaN
4589	NaN	NaN	NaN	NaN	NaN	NaN
4590	NaN	NaN	NaN	NaN	NaN	NaN
4591	NaN	NaN	NaN	NaN	NaN	NaN
4592	NaN	NaN	NaN	NaN	NaN	NaN
4593	NaN	NaN	NaN	NaN	NaN	NaN
4594	NaN	NaN	NaN	NaN	NaN	NaN
4595	NaN	NaN	NaN	NaN	NaN	NaN
4596	NaN	NaN	NaN	NaN	NaN	NaN
4597	NaN	NaN	NaN	NaN	NaN	NaN
4598	NaN	NaN	NaN	NaN	NaN	NaN
4599	NaN	NaN	NaN	NaN	NaN	NaN
4600	NaN	NaN	NaN	NaN	NaN	NaN
4601	NaN	NaN	NaN	NaN	NaN	NaN
4602	NaN	NaN	NaN	NaN	NaN	NaN
4603	NaN	NaN	NaN	NaN	NaN	NaN
4604	NaN	NaN	NaN	NaN	NaN	NaN
4605	NaN	NaN	NaN	NaN	NaN	NaN
4606	NaN	NaN	NaN	NaN	NaN	NaN
4607	NaN	NaN	NaN	NaN	NaN	NaN
4608	NaN	NaN	NaN	NaN	NaN	NaN
4609	NaN	NaN	NaN	NaN	NaN	NaN
4610	NaN	NaN	NaN	NaN	NaN	NaN
4611	NaN	NaN	NaN	NaN	NaN	NaN
4612	NaN	NaN	NaN	NaN	NaN	NaN
4613	NaN	NaN	NaN	NaN	NaN	NaN
4614	NaN	NaN	NaN	NaN	NaN	NaN
4615	NaN	NaN	NaN	NaN	NaN	NaN
4616	NaN	NaN	NaN	NaN	NaN	NaN
4617	NaN	NaN	NaN	NaN	NaN	NaN
4618	NaN	NaN	NaN	NaN	NaN	NaN
4619	NaN	NaN	NaN	NaN	NaN	NaN
4620	NaN	NaN	NaN	NaN	NaN	NaN
4621	NaN	NaN	NaN	NaN	NaN	NaN
4622	NaN	NaN	NaN	NaN	NaN	NaN
4623	NaN	NaN	NaN	NaN	NaN	NaN
4624	NaN	NaN	NaN	NaN	NaN	NaN
4625	NaN	NaN	NaN	NaN	NaN	NaN
4626	NaN	NaN	NaN	NaN	NaN	NaN
4627	NaN	NaN	NaN	NaN	NaN	NaN
4628	NaN	NaN	NaN	NaN	NaN	NaN
4629	NaN	NaN	NaN	NaN	NaN	NaN
4630	NaN	NaN	NaN	NaN	NaN	NaN
5130	\N	\N	\N	\N	\N	\N
4631	NaN	NaN	NaN	NaN	NaN	NaN
4632	NaN	NaN	NaN	NaN	NaN	NaN
4633	NaN	NaN	NaN	NaN	NaN	NaN
4634	NaN	NaN	NaN	NaN	NaN	NaN
4635	NaN	NaN	NaN	NaN	NaN	NaN
4636	NaN	NaN	NaN	NaN	NaN	NaN
4637	NaN	NaN	NaN	NaN	NaN	NaN
4638	NaN	NaN	NaN	NaN	NaN	NaN
4639	NaN	NaN	NaN	NaN	NaN	NaN
4640	NaN	NaN	NaN	NaN	NaN	NaN
4641	NaN	NaN	NaN	NaN	NaN	NaN
4642	NaN	NaN	NaN	NaN	NaN	NaN
4643	NaN	NaN	NaN	NaN	NaN	NaN
4644	NaN	NaN	NaN	NaN	NaN	NaN
4645	NaN	NaN	NaN	NaN	NaN	NaN
4646	NaN	NaN	NaN	NaN	NaN	NaN
4647	NaN	NaN	NaN	NaN	NaN	NaN
4648	NaN	NaN	NaN	NaN	NaN	NaN
4649	NaN	NaN	NaN	NaN	NaN	NaN
4650	NaN	NaN	NaN	NaN	NaN	NaN
4651	NaN	NaN	NaN	NaN	NaN	NaN
4652	NaN	NaN	NaN	NaN	NaN	NaN
4653	NaN	NaN	NaN	NaN	NaN	NaN
4654	NaN	NaN	NaN	NaN	NaN	NaN
4655	NaN	NaN	NaN	NaN	NaN	NaN
4656	NaN	NaN	NaN	NaN	NaN	NaN
4657	NaN	NaN	NaN	NaN	NaN	NaN
4658	NaN	NaN	NaN	NaN	NaN	NaN
4659	NaN	NaN	NaN	NaN	NaN	NaN
4660	NaN	NaN	NaN	NaN	NaN	NaN
4661	NaN	NaN	NaN	NaN	NaN	NaN
4662	NaN	NaN	NaN	NaN	NaN	NaN
4663	NaN	NaN	NaN	NaN	NaN	NaN
4664	NaN	NaN	NaN	NaN	NaN	NaN
4665	NaN	NaN	NaN	NaN	NaN	NaN
4666	NaN	NaN	NaN	NaN	NaN	NaN
4667	NaN	NaN	NaN	NaN	NaN	NaN
4668	NaN	NaN	NaN	NaN	NaN	NaN
4669	NaN	NaN	NaN	NaN	NaN	NaN
4670	NaN	NaN	NaN	NaN	NaN	NaN
4671	NaN	NaN	NaN	NaN	NaN	NaN
4672	NaN	NaN	NaN	NaN	NaN	NaN
4673	NaN	NaN	NaN	NaN	NaN	NaN
4674	NaN	NaN	NaN	NaN	NaN	NaN
4675	NaN	NaN	NaN	NaN	NaN	NaN
4676	NaN	NaN	NaN	NaN	NaN	NaN
4677	NaN	NaN	NaN	NaN	NaN	NaN
4678	NaN	NaN	NaN	NaN	NaN	NaN
4679	NaN	NaN	NaN	NaN	NaN	NaN
4680	NaN	NaN	NaN	NaN	NaN	NaN
4681	NaN	NaN	NaN	NaN	NaN	NaN
4682	NaN	NaN	NaN	NaN	NaN	NaN
4683	NaN	NaN	NaN	NaN	NaN	NaN
4684	NaN	NaN	NaN	NaN	NaN	NaN
4685	NaN	NaN	NaN	NaN	NaN	NaN
4686	NaN	NaN	NaN	NaN	NaN	NaN
4687	NaN	NaN	NaN	NaN	NaN	NaN
4688	NaN	NaN	NaN	NaN	NaN	NaN
4689	NaN	NaN	NaN	NaN	NaN	NaN
4690	NaN	NaN	NaN	NaN	NaN	NaN
4691	NaN	NaN	NaN	NaN	NaN	NaN
4692	NaN	NaN	NaN	NaN	NaN	NaN
4693	NaN	NaN	NaN	NaN	NaN	NaN
4694	NaN	NaN	NaN	NaN	NaN	NaN
4695	NaN	NaN	NaN	NaN	NaN	NaN
4696	NaN	NaN	NaN	NaN	NaN	NaN
4697	NaN	NaN	NaN	NaN	NaN	NaN
4698	NaN	NaN	NaN	NaN	NaN	NaN
4699	NaN	NaN	NaN	NaN	NaN	NaN
4700	NaN	NaN	NaN	NaN	NaN	NaN
4701	NaN	NaN	NaN	NaN	NaN	NaN
4702	NaN	NaN	NaN	NaN	NaN	NaN
4703	NaN	NaN	NaN	NaN	NaN	NaN
4704	NaN	NaN	NaN	NaN	NaN	NaN
4705	NaN	NaN	NaN	NaN	NaN	NaN
4706	NaN	NaN	NaN	NaN	NaN	NaN
4707	NaN	NaN	NaN	NaN	NaN	NaN
4708	NaN	NaN	NaN	NaN	NaN	NaN
4709	NaN	NaN	NaN	NaN	NaN	NaN
4710	NaN	NaN	NaN	NaN	NaN	NaN
4711	NaN	NaN	NaN	NaN	NaN	NaN
4712	NaN	NaN	NaN	NaN	NaN	NaN
4713	NaN	NaN	NaN	NaN	NaN	NaN
4714	NaN	NaN	NaN	NaN	NaN	NaN
4715	NaN	NaN	NaN	NaN	NaN	NaN
4716	NaN	NaN	NaN	NaN	NaN	NaN
4717	NaN	NaN	NaN	NaN	NaN	NaN
4718	NaN	NaN	NaN	NaN	NaN	NaN
4719	NaN	NaN	NaN	NaN	NaN	NaN
4720	NaN	NaN	NaN	NaN	NaN	NaN
4721	NaN	NaN	NaN	NaN	NaN	NaN
4722	NaN	NaN	NaN	NaN	NaN	NaN
4723	NaN	NaN	NaN	NaN	NaN	NaN
4724	NaN	NaN	NaN	NaN	NaN	NaN
4725	NaN	NaN	NaN	NaN	NaN	NaN
4726	NaN	NaN	NaN	NaN	NaN	NaN
4727	NaN	NaN	NaN	NaN	NaN	NaN
4728	NaN	NaN	NaN	NaN	NaN	NaN
4729	NaN	NaN	NaN	NaN	NaN	NaN
4730	NaN	NaN	NaN	NaN	NaN	NaN
4731	NaN	NaN	NaN	NaN	NaN	NaN
4732	NaN	NaN	NaN	NaN	NaN	NaN
4733	NaN	NaN	NaN	NaN	NaN	NaN
4734	NaN	NaN	NaN	NaN	NaN	NaN
4735	NaN	NaN	NaN	NaN	NaN	NaN
4736	NaN	NaN	NaN	NaN	NaN	NaN
4737	NaN	NaN	NaN	NaN	NaN	NaN
4738	NaN	NaN	NaN	NaN	NaN	NaN
4739	NaN	NaN	NaN	NaN	NaN	NaN
4740	NaN	NaN	NaN	NaN	NaN	NaN
4741	NaN	NaN	NaN	NaN	NaN	NaN
4742	NaN	NaN	NaN	NaN	NaN	NaN
4743	NaN	NaN	NaN	NaN	NaN	NaN
4744	NaN	NaN	NaN	NaN	NaN	NaN
4745	NaN	NaN	NaN	NaN	NaN	NaN
4746	NaN	NaN	NaN	NaN	NaN	NaN
4747	NaN	NaN	NaN	NaN	NaN	NaN
4748	NaN	NaN	NaN	NaN	NaN	NaN
4749	NaN	NaN	NaN	NaN	NaN	NaN
4750	NaN	NaN	NaN	NaN	NaN	NaN
4751	NaN	NaN	NaN	NaN	NaN	NaN
4752	NaN	NaN	NaN	NaN	NaN	NaN
4753	NaN	NaN	NaN	NaN	NaN	NaN
4754	NaN	NaN	NaN	NaN	NaN	NaN
4755	NaN	NaN	NaN	NaN	NaN	NaN
4756	NaN	NaN	NaN	NaN	NaN	NaN
4757	NaN	NaN	NaN	NaN	NaN	NaN
4758	NaN	NaN	NaN	NaN	NaN	NaN
4759	NaN	NaN	NaN	NaN	NaN	NaN
4760	NaN	NaN	NaN	NaN	NaN	NaN
4761	NaN	NaN	NaN	NaN	NaN	NaN
4762	NaN	NaN	NaN	NaN	NaN	NaN
4763	NaN	NaN	NaN	NaN	NaN	NaN
4764	NaN	NaN	NaN	NaN	NaN	NaN
4765	NaN	NaN	NaN	NaN	NaN	NaN
4766	NaN	NaN	NaN	NaN	NaN	NaN
4767	NaN	NaN	NaN	NaN	NaN	NaN
4768	NaN	NaN	NaN	NaN	NaN	NaN
4769	NaN	NaN	NaN	NaN	NaN	NaN
4770	NaN	NaN	NaN	NaN	NaN	NaN
4771	NaN	NaN	NaN	NaN	NaN	NaN
4772	NaN	NaN	NaN	NaN	NaN	NaN
4773	NaN	NaN	NaN	NaN	NaN	NaN
4774	NaN	NaN	NaN	NaN	NaN	NaN
4775	NaN	NaN	NaN	NaN	NaN	NaN
4776	NaN	NaN	NaN	NaN	NaN	NaN
4777	NaN	NaN	NaN	NaN	NaN	NaN
4778	NaN	NaN	NaN	NaN	NaN	NaN
4779	NaN	NaN	NaN	NaN	NaN	NaN
4780	NaN	NaN	NaN	NaN	NaN	NaN
4781	NaN	NaN	NaN	NaN	NaN	NaN
4782	NaN	NaN	NaN	NaN	NaN	NaN
4783	NaN	NaN	NaN	NaN	NaN	NaN
4784	NaN	NaN	NaN	NaN	NaN	NaN
4785	NaN	NaN	NaN	NaN	NaN	NaN
4786	NaN	NaN	NaN	NaN	NaN	NaN
4787	NaN	NaN	NaN	NaN	NaN	NaN
4788	NaN	NaN	NaN	NaN	NaN	NaN
4789	NaN	NaN	NaN	NaN	NaN	NaN
4790	NaN	NaN	NaN	NaN	NaN	NaN
4791	NaN	NaN	NaN	NaN	NaN	NaN
4792	NaN	NaN	NaN	NaN	NaN	NaN
4793	NaN	NaN	NaN	NaN	NaN	NaN
4794	NaN	NaN	NaN	NaN	NaN	NaN
4795	NaN	NaN	NaN	NaN	NaN	NaN
4796	NaN	NaN	NaN	NaN	NaN	NaN
4797	NaN	NaN	NaN	NaN	NaN	NaN
4798	NaN	NaN	NaN	NaN	NaN	NaN
4799	NaN	NaN	NaN	NaN	NaN	NaN
4800	NaN	NaN	NaN	NaN	NaN	NaN
4801	NaN	NaN	NaN	NaN	NaN	NaN
4802	NaN	NaN	NaN	NaN	NaN	NaN
4803	NaN	NaN	NaN	NaN	NaN	NaN
4804	NaN	NaN	NaN	NaN	NaN	NaN
4805	NaN	NaN	NaN	NaN	NaN	NaN
4806	NaN	NaN	NaN	NaN	NaN	NaN
4807	NaN	NaN	NaN	NaN	NaN	NaN
4808	NaN	NaN	NaN	NaN	NaN	NaN
4809	NaN	NaN	NaN	NaN	NaN	NaN
4810	NaN	NaN	NaN	NaN	NaN	NaN
4811	NaN	NaN	NaN	NaN	NaN	NaN
4812	NaN	NaN	NaN	NaN	NaN	NaN
4813	NaN	NaN	NaN	NaN	NaN	NaN
4814	NaN	NaN	NaN	NaN	NaN	NaN
4815	NaN	NaN	NaN	NaN	NaN	NaN
4816	NaN	NaN	NaN	NaN	NaN	NaN
4817	NaN	NaN	NaN	NaN	NaN	NaN
4818	NaN	NaN	NaN	NaN	NaN	NaN
4819	NaN	NaN	NaN	NaN	NaN	NaN
4820	NaN	NaN	NaN	NaN	NaN	NaN
4821	NaN	NaN	NaN	NaN	NaN	NaN
4822	NaN	NaN	NaN	NaN	NaN	NaN
4823	NaN	NaN	NaN	NaN	NaN	NaN
4824	NaN	NaN	NaN	NaN	NaN	NaN
4825	NaN	NaN	NaN	NaN	NaN	NaN
4826	NaN	NaN	NaN	NaN	NaN	NaN
4827	NaN	NaN	NaN	NaN	NaN	NaN
4828	NaN	NaN	NaN	NaN	NaN	NaN
4829	NaN	NaN	NaN	NaN	NaN	NaN
4830	NaN	NaN	NaN	NaN	NaN	NaN
4831	NaN	NaN	NaN	NaN	NaN	NaN
4832	NaN	NaN	NaN	NaN	NaN	NaN
4833	NaN	NaN	NaN	NaN	NaN	NaN
4834	NaN	NaN	NaN	NaN	NaN	NaN
4835	NaN	NaN	NaN	NaN	NaN	NaN
4836	NaN	NaN	NaN	NaN	NaN	NaN
4837	NaN	NaN	NaN	NaN	NaN	NaN
4838	NaN	NaN	NaN	NaN	NaN	NaN
4839	NaN	NaN	NaN	NaN	NaN	NaN
4840	NaN	NaN	NaN	NaN	NaN	NaN
4841	NaN	NaN	NaN	NaN	NaN	NaN
4842	NaN	NaN	NaN	NaN	NaN	NaN
4843	NaN	NaN	NaN	NaN	NaN	NaN
4844	NaN	NaN	NaN	NaN	NaN	NaN
4845	NaN	NaN	NaN	NaN	NaN	NaN
4846	NaN	NaN	NaN	NaN	NaN	NaN
4847	NaN	NaN	NaN	NaN	NaN	NaN
4848	NaN	NaN	NaN	NaN	NaN	NaN
4849	NaN	NaN	NaN	NaN	NaN	NaN
4850	NaN	NaN	NaN	NaN	NaN	NaN
4851	NaN	NaN	NaN	NaN	NaN	NaN
4852	NaN	NaN	NaN	NaN	NaN	NaN
4853	NaN	NaN	NaN	NaN	NaN	NaN
4854	NaN	NaN	NaN	NaN	NaN	NaN
4855	NaN	NaN	NaN	NaN	NaN	NaN
4856	NaN	NaN	NaN	NaN	NaN	NaN
4857	NaN	NaN	NaN	NaN	NaN	NaN
4858	NaN	NaN	NaN	NaN	NaN	NaN
4859	NaN	NaN	NaN	NaN	NaN	NaN
4860	NaN	NaN	NaN	NaN	NaN	NaN
4861	NaN	NaN	NaN	NaN	NaN	NaN
4862	NaN	NaN	NaN	NaN	NaN	NaN
4863	NaN	NaN	NaN	NaN	NaN	NaN
4864	NaN	NaN	NaN	NaN	NaN	NaN
4865	NaN	NaN	NaN	NaN	NaN	NaN
4866	NaN	NaN	NaN	NaN	NaN	NaN
4867	NaN	NaN	NaN	NaN	NaN	NaN
4868	NaN	NaN	NaN	NaN	NaN	NaN
4869	NaN	NaN	NaN	NaN	NaN	NaN
4870	NaN	NaN	NaN	NaN	NaN	NaN
4871	NaN	NaN	NaN	NaN	NaN	NaN
4872	NaN	NaN	NaN	NaN	NaN	NaN
4873	NaN	NaN	NaN	NaN	NaN	NaN
4874	NaN	NaN	NaN	NaN	NaN	NaN
4875	NaN	NaN	NaN	NaN	NaN	NaN
4876	NaN	NaN	NaN	NaN	NaN	NaN
4877	NaN	NaN	NaN	NaN	NaN	NaN
4878	NaN	NaN	NaN	NaN	NaN	NaN
4879	NaN	NaN	NaN	NaN	NaN	NaN
4880	NaN	NaN	NaN	NaN	NaN	NaN
4881	NaN	NaN	NaN	NaN	NaN	NaN
4882	NaN	NaN	NaN	NaN	NaN	NaN
4883	NaN	NaN	NaN	NaN	NaN	NaN
4884	NaN	NaN	NaN	NaN	NaN	NaN
4885	NaN	NaN	NaN	NaN	NaN	NaN
4886	NaN	NaN	NaN	NaN	NaN	NaN
4887	NaN	NaN	NaN	NaN	NaN	NaN
4888	NaN	NaN	NaN	NaN	NaN	NaN
4889	NaN	NaN	NaN	NaN	NaN	NaN
4890	NaN	NaN	NaN	NaN	NaN	NaN
4891	NaN	NaN	NaN	NaN	NaN	NaN
4892	NaN	NaN	NaN	NaN	NaN	NaN
4893	NaN	NaN	NaN	NaN	NaN	NaN
4894	NaN	NaN	NaN	NaN	NaN	NaN
4895	NaN	NaN	NaN	NaN	NaN	NaN
4896	NaN	NaN	NaN	NaN	NaN	NaN
4897	NaN	NaN	NaN	NaN	NaN	NaN
4898	NaN	NaN	NaN	NaN	NaN	NaN
4899	NaN	NaN	NaN	NaN	NaN	NaN
4900	NaN	NaN	NaN	NaN	NaN	NaN
4901	NaN	NaN	NaN	NaN	NaN	NaN
4902	NaN	NaN	NaN	NaN	NaN	NaN
4903	NaN	NaN	NaN	NaN	NaN	NaN
4904	NaN	NaN	NaN	NaN	NaN	NaN
4905	NaN	NaN	NaN	NaN	NaN	NaN
4906	NaN	NaN	NaN	NaN	NaN	NaN
4907	NaN	NaN	NaN	NaN	NaN	NaN
4908	NaN	NaN	NaN	NaN	NaN	NaN
4909	NaN	NaN	NaN	NaN	NaN	NaN
4910	NaN	NaN	NaN	NaN	NaN	NaN
4911	NaN	NaN	NaN	NaN	NaN	NaN
4912	NaN	NaN	NaN	NaN	NaN	NaN
4913	NaN	NaN	NaN	NaN	NaN	NaN
4914	NaN	NaN	NaN	NaN	NaN	NaN
4915	NaN	NaN	NaN	NaN	NaN	NaN
4916	NaN	NaN	NaN	NaN	NaN	NaN
4917	NaN	NaN	NaN	NaN	NaN	NaN
4918	NaN	NaN	NaN	NaN	NaN	NaN
4919	NaN	NaN	NaN	NaN	NaN	NaN
4920	NaN	NaN	NaN	NaN	NaN	NaN
4921	NaN	NaN	NaN	NaN	NaN	NaN
4922	NaN	NaN	NaN	NaN	NaN	NaN
4923	NaN	NaN	NaN	NaN	NaN	NaN
4924	NaN	NaN	NaN	NaN	NaN	NaN
4925	NaN	NaN	NaN	NaN	NaN	NaN
4926	NaN	NaN	NaN	NaN	NaN	NaN
4927	NaN	NaN	NaN	NaN	NaN	NaN
4928	NaN	NaN	NaN	NaN	NaN	NaN
4929	NaN	NaN	NaN	NaN	NaN	NaN
4930	NaN	NaN	NaN	NaN	NaN	NaN
4931	NaN	NaN	NaN	NaN	NaN	NaN
4932	NaN	NaN	NaN	NaN	NaN	NaN
4933	NaN	NaN	NaN	NaN	NaN	NaN
4934	NaN	NaN	NaN	NaN	NaN	NaN
4935	NaN	NaN	NaN	NaN	NaN	NaN
4936	\N	\N	\N	\N	\N	\N
4937	\N	\N	\N	\N	\N	\N
4938	\N	\N	\N	\N	\N	\N
4939	\N	\N	\N	\N	\N	\N
4940	\N	\N	\N	\N	\N	\N
4941	\N	\N	\N	\N	\N	\N
4942	\N	\N	\N	\N	\N	\N
4943	\N	\N	\N	\N	\N	\N
4944	\N	\N	\N	\N	\N	\N
4945	\N	\N	\N	\N	\N	\N
4946	\N	\N	\N	\N	\N	\N
4947	\N	\N	\N	\N	\N	\N
4948	\N	\N	\N	\N	\N	\N
4949	\N	\N	\N	\N	\N	\N
4950	\N	\N	\N	\N	\N	\N
4951	\N	\N	\N	\N	\N	\N
4952	\N	\N	\N	\N	\N	\N
4953	\N	\N	\N	\N	\N	\N
4954	\N	\N	\N	\N	\N	\N
4955	\N	\N	\N	\N	\N	\N
4956	\N	\N	\N	\N	\N	\N
4957	\N	\N	\N	\N	\N	\N
4958	\N	\N	\N	\N	\N	\N
4959	\N	\N	\N	\N	\N	\N
4960	\N	\N	\N	\N	\N	\N
4961	\N	\N	\N	\N	\N	\N
4962	\N	\N	\N	\N	\N	\N
4963	\N	\N	\N	\N	\N	\N
4964	\N	\N	\N	\N	\N	\N
4965	\N	\N	\N	\N	\N	\N
4966	\N	\N	\N	\N	\N	\N
4967	\N	\N	\N	\N	\N	\N
4968	\N	\N	\N	\N	\N	\N
4969	\N	\N	\N	\N	\N	\N
4970	\N	\N	\N	\N	\N	\N
4971	\N	\N	\N	\N	\N	\N
4972	\N	\N	\N	\N	\N	\N
4973	\N	\N	\N	\N	\N	\N
4974	\N	\N	\N	\N	\N	\N
4975	\N	\N	\N	\N	\N	\N
4976	\N	\N	\N	\N	\N	\N
4977	\N	\N	\N	\N	\N	\N
4978	\N	\N	\N	\N	\N	\N
4979	\N	\N	\N	\N	\N	\N
4980	\N	\N	\N	\N	\N	\N
4981	\N	\N	\N	\N	\N	\N
4982	\N	\N	\N	\N	\N	\N
4983	\N	\N	\N	\N	\N	\N
4984	\N	\N	\N	\N	\N	\N
4985	\N	\N	\N	\N	\N	\N
4986	\N	\N	\N	\N	\N	\N
4987	\N	\N	\N	\N	\N	\N
4988	\N	\N	\N	\N	\N	\N
4989	\N	\N	\N	\N	\N	\N
4990	\N	\N	\N	\N	\N	\N
4991	\N	\N	\N	\N	\N	\N
4992	\N	\N	\N	\N	\N	\N
4993	\N	\N	\N	\N	\N	\N
4994	\N	\N	\N	\N	\N	\N
4995	\N	\N	\N	\N	\N	\N
4996	\N	\N	\N	\N	\N	\N
4997	\N	\N	\N	\N	\N	\N
4998	\N	\N	\N	\N	\N	\N
4999	\N	\N	\N	\N	\N	\N
5000	\N	\N	\N	\N	\N	\N
5001	\N	\N	\N	\N	\N	\N
5002	\N	\N	\N	\N	\N	\N
5003	\N	\N	\N	\N	\N	\N
5004	\N	\N	\N	\N	\N	\N
5005	\N	\N	\N	\N	\N	\N
5006	\N	\N	\N	\N	\N	\N
5007	\N	\N	\N	\N	\N	\N
5008	\N	\N	\N	\N	\N	\N
5009	\N	\N	\N	\N	\N	\N
5010	\N	\N	\N	\N	\N	\N
5011	\N	\N	\N	\N	\N	\N
5012	\N	\N	\N	\N	\N	\N
5013	\N	\N	\N	\N	\N	\N
5014	\N	\N	\N	\N	\N	\N
5015	\N	\N	\N	\N	\N	\N
5016	\N	\N	\N	\N	\N	\N
5017	\N	\N	\N	\N	\N	\N
5018	\N	\N	\N	\N	\N	\N
5019	\N	\N	\N	\N	\N	\N
5020	\N	\N	\N	\N	\N	\N
5021	\N	\N	\N	\N	\N	\N
5022	\N	\N	\N	\N	\N	\N
5023	\N	\N	\N	\N	\N	\N
5024	\N	\N	\N	\N	\N	\N
5025	\N	\N	\N	\N	\N	\N
5026	\N	\N	\N	\N	\N	\N
5027	\N	\N	\N	\N	\N	\N
5028	\N	\N	\N	\N	\N	\N
5029	\N	\N	\N	\N	\N	\N
5030	\N	\N	\N	\N	\N	\N
5031	\N	\N	\N	\N	\N	\N
5032	\N	\N	\N	\N	\N	\N
5033	\N	\N	\N	\N	\N	\N
5034	\N	\N	\N	\N	\N	\N
5035	\N	\N	\N	\N	\N	\N
5036	\N	\N	\N	\N	\N	\N
5037	\N	\N	\N	\N	\N	\N
5038	\N	\N	\N	\N	\N	\N
5039	\N	\N	\N	\N	\N	\N
5040	\N	\N	\N	\N	\N	\N
5041	\N	\N	\N	\N	\N	\N
5042	\N	\N	\N	\N	\N	\N
5043	\N	\N	\N	\N	\N	\N
5044	\N	\N	\N	\N	\N	\N
5045	\N	\N	\N	\N	\N	\N
5046	\N	\N	\N	\N	\N	\N
5047	\N	\N	\N	\N	\N	\N
5048	\N	\N	\N	\N	\N	\N
5049	\N	\N	\N	\N	\N	\N
5050	\N	\N	\N	\N	\N	\N
5051	\N	\N	\N	\N	\N	\N
5052	\N	\N	\N	\N	\N	\N
5053	\N	\N	\N	\N	\N	\N
5054	\N	\N	\N	\N	\N	\N
5055	\N	\N	\N	\N	\N	\N
5056	\N	\N	\N	\N	\N	\N
5057	\N	\N	\N	\N	\N	\N
5058	\N	\N	\N	\N	\N	\N
5059	\N	\N	\N	\N	\N	\N
5060	\N	\N	\N	\N	\N	\N
5061	\N	\N	\N	\N	\N	\N
5062	\N	\N	\N	\N	\N	\N
5063	\N	\N	\N	\N	\N	\N
5064	\N	\N	\N	\N	\N	\N
5065	\N	\N	\N	\N	\N	\N
5066	\N	\N	\N	\N	\N	\N
5067	\N	\N	\N	\N	\N	\N
5068	\N	\N	\N	\N	\N	\N
5069	\N	\N	\N	\N	\N	\N
5070	\N	\N	\N	\N	\N	\N
5071	\N	\N	\N	\N	\N	\N
5072	\N	\N	\N	\N	\N	\N
5073	\N	\N	\N	\N	\N	\N
5074	\N	\N	\N	\N	\N	\N
5075	\N	\N	\N	\N	\N	\N
5076	\N	\N	\N	\N	\N	\N
5077	\N	\N	\N	\N	\N	\N
5078	\N	\N	\N	\N	\N	\N
5079	\N	\N	\N	\N	\N	\N
5080	\N	\N	\N	\N	\N	\N
5081	\N	\N	\N	\N	\N	\N
5082	\N	\N	\N	\N	\N	\N
5083	\N	\N	\N	\N	\N	\N
5084	\N	\N	\N	\N	\N	\N
5085	\N	\N	\N	\N	\N	\N
5086	\N	\N	\N	\N	\N	\N
5087	\N	\N	\N	\N	\N	\N
5088	\N	\N	\N	\N	\N	\N
5089	\N	\N	\N	\N	\N	\N
5090	\N	\N	\N	\N	\N	\N
5091	\N	\N	\N	\N	\N	\N
5092	\N	\N	\N	\N	\N	\N
5093	\N	\N	\N	\N	\N	\N
5094	\N	\N	\N	\N	\N	\N
5095	\N	\N	\N	\N	\N	\N
5096	\N	\N	\N	\N	\N	\N
5097	\N	\N	\N	\N	\N	\N
5098	\N	\N	\N	\N	\N	\N
5099	\N	\N	\N	\N	\N	\N
5100	\N	\N	\N	\N	\N	\N
5101	\N	\N	\N	\N	\N	\N
5102	\N	\N	\N	\N	\N	\N
5103	\N	\N	\N	\N	\N	\N
5104	\N	\N	\N	\N	\N	\N
5105	\N	\N	\N	\N	\N	\N
5106	\N	\N	\N	\N	\N	\N
5107	\N	\N	\N	\N	\N	\N
5108	\N	\N	\N	\N	\N	\N
5109	\N	\N	\N	\N	\N	\N
5110	\N	\N	\N	\N	\N	\N
5111	\N	\N	\N	\N	\N	\N
5112	\N	\N	\N	\N	\N	\N
5113	\N	\N	\N	\N	\N	\N
5114	\N	\N	\N	\N	\N	\N
5115	\N	\N	\N	\N	\N	\N
5116	\N	\N	\N	\N	\N	\N
5117	\N	\N	\N	\N	\N	\N
5118	\N	\N	\N	\N	\N	\N
5119	\N	\N	\N	\N	\N	\N
5120	\N	\N	\N	\N	\N	\N
5121	\N	\N	\N	\N	\N	\N
5122	\N	\N	\N	\N	\N	\N
5123	\N	\N	\N	\N	\N	\N
5124	\N	\N	\N	\N	\N	\N
5125	\N	\N	\N	\N	\N	\N
5126	\N	\N	\N	\N	\N	\N
5127	\N	\N	\N	\N	\N	\N
5128	\N	\N	\N	\N	\N	\N
5129	\N	\N	\N	\N	\N	\N
5131	\N	\N	\N	\N	\N	\N
5132	\N	\N	\N	\N	\N	\N
5133	\N	\N	\N	\N	\N	\N
5134	\N	\N	\N	\N	\N	\N
5135	\N	\N	\N	\N	\N	\N
5136	\N	\N	\N	\N	\N	\N
5137	\N	\N	\N	\N	\N	\N
5138	\N	\N	\N	\N	\N	\N
5139	\N	\N	\N	\N	\N	\N
5140	\N	\N	\N	\N	\N	\N
5141	\N	\N	\N	\N	\N	\N
5142	\N	\N	\N	\N	\N	\N
5143	\N	\N	\N	\N	\N	\N
5144	\N	\N	\N	\N	\N	\N
5145	\N	\N	\N	\N	\N	\N
5146	\N	\N	\N	\N	\N	\N
5147	\N	\N	\N	\N	\N	\N
5148	\N	\N	\N	\N	\N	\N
5149	\N	\N	\N	\N	\N	\N
5150	\N	\N	\N	\N	\N	\N
5151	\N	\N	\N	\N	\N	\N
5152	\N	\N	\N	\N	\N	\N
5153	\N	\N	\N	\N	\N	\N
5154	\N	\N	\N	\N	\N	\N
5155	\N	\N	\N	\N	\N	\N
5156	\N	\N	\N	\N	\N	\N
5157	\N	\N	\N	\N	\N	\N
5158	\N	\N	\N	\N	\N	\N
5159	\N	\N	\N	\N	\N	\N
5160	\N	\N	\N	\N	\N	\N
5161	\N	\N	\N	\N	\N	\N
5162	\N	\N	\N	\N	\N	\N
5163	\N	\N	\N	\N	\N	\N
5164	\N	\N	\N	\N	\N	\N
5165	\N	\N	\N	\N	\N	\N
5166	\N	\N	\N	\N	\N	\N
5167	\N	\N	\N	\N	\N	\N
5168	\N	\N	\N	\N	\N	\N
5169	\N	\N	\N	\N	\N	\N
5170	\N	\N	\N	\N	\N	\N
5171	\N	\N	\N	\N	\N	\N
5172	\N	\N	\N	\N	\N	\N
5173	\N	\N	\N	\N	\N	\N
5174	\N	\N	\N	\N	\N	\N
5175	\N	\N	\N	\N	\N	\N
5176	\N	\N	\N	\N	\N	\N
5177	\N	\N	\N	\N	\N	\N
5178	\N	\N	\N	\N	\N	\N
5179	\N	\N	\N	\N	\N	\N
5180	\N	\N	\N	\N	\N	\N
5181	\N	\N	\N	\N	\N	\N
5182	\N	\N	\N	\N	\N	\N
5183	\N	\N	\N	\N	\N	\N
5184	\N	\N	\N	\N	\N	\N
5185	\N	\N	\N	\N	\N	\N
5186	\N	\N	\N	\N	\N	\N
5187	\N	\N	\N	\N	\N	\N
5188	\N	\N	\N	\N	\N	\N
5189	\N	\N	\N	\N	\N	\N
5190	\N	\N	\N	\N	\N	\N
5191	\N	\N	\N	\N	\N	\N
5192	\N	\N	\N	\N	\N	\N
5193	\N	\N	\N	\N	\N	\N
5194	\N	\N	\N	\N	\N	\N
5195	\N	\N	\N	\N	\N	\N
5196	\N	\N	\N	\N	\N	\N
5197	\N	\N	\N	\N	\N	\N
5198	\N	\N	\N	\N	\N	\N
5199	\N	\N	\N	\N	\N	\N
5200	\N	\N	\N	\N	\N	\N
5201	\N	\N	\N	\N	\N	\N
5202	\N	\N	\N	\N	\N	\N
5203	\N	\N	\N	\N	\N	\N
5204	\N	\N	\N	\N	\N	\N
5205	\N	\N	\N	\N	\N	\N
5206	\N	\N	\N	\N	\N	\N
5207	\N	\N	\N	\N	\N	\N
5208	\N	\N	\N	\N	\N	\N
5209	\N	\N	\N	\N	\N	\N
5210	\N	\N	\N	\N	\N	\N
5211	\N	\N	\N	\N	\N	\N
5212	\N	\N	\N	\N	\N	\N
5213	\N	\N	\N	\N	\N	\N
5214	\N	\N	\N	\N	\N	\N
5215	\N	\N	\N	\N	\N	\N
5216	\N	\N	\N	\N	\N	\N
5217	\N	\N	\N	\N	\N	\N
5218	\N	\N	\N	\N	\N	\N
5219	\N	\N	\N	\N	\N	\N
5220	\N	\N	\N	\N	\N	\N
5221	\N	\N	\N	\N	\N	\N
5222	\N	\N	\N	\N	\N	\N
5223	\N	\N	\N	\N	\N	\N
5224	\N	\N	\N	\N	\N	\N
5225	\N	\N	\N	\N	\N	\N
5226	\N	\N	\N	\N	\N	\N
5227	\N	\N	\N	\N	\N	\N
5228	\N	\N	\N	\N	\N	\N
5229	\N	\N	\N	\N	\N	\N
5230	\N	\N	\N	\N	\N	\N
5231	\N	\N	\N	\N	\N	\N
5232	\N	\N	\N	\N	\N	\N
5233	\N	\N	\N	\N	\N	\N
5234	\N	\N	\N	\N	\N	\N
5235	\N	\N	\N	\N	\N	\N
5236	\N	\N	\N	\N	\N	\N
5237	\N	\N	\N	\N	\N	\N
5238	\N	\N	\N	\N	\N	\N
5239	\N	\N	\N	\N	\N	\N
5240	\N	\N	\N	\N	\N	\N
5241	\N	\N	\N	\N	\N	\N
5242	\N	\N	\N	\N	\N	\N
5243	\N	\N	\N	\N	\N	\N
5244	\N	\N	\N	\N	\N	\N
5245	\N	\N	\N	\N	\N	\N
5246	\N	\N	\N	\N	\N	\N
5247	\N	\N	\N	\N	\N	\N
5248	\N	\N	\N	\N	\N	\N
5249	\N	\N	\N	\N	\N	\N
5250	\N	\N	\N	\N	\N	\N
5251	\N	\N	\N	\N	\N	\N
5252	\N	\N	\N	\N	\N	\N
5253	\N	\N	\N	\N	\N	\N
5254	\N	\N	\N	\N	\N	\N
5255	\N	\N	\N	\N	\N	\N
5256	\N	\N	\N	\N	\N	\N
5257	\N	\N	\N	\N	\N	\N
5258	\N	\N	\N	\N	\N	\N
5259	\N	\N	\N	\N	\N	\N
5260	\N	\N	\N	\N	\N	\N
5261	\N	\N	\N	\N	\N	\N
5262	\N	\N	\N	\N	\N	\N
5263	\N	\N	\N	\N	\N	\N
5264	\N	\N	\N	\N	\N	\N
5265	\N	\N	\N	\N	\N	\N
5266	\N	\N	\N	\N	\N	\N
5267	\N	\N	\N	\N	\N	\N
5268	\N	\N	\N	\N	\N	\N
5269	\N	\N	\N	\N	\N	\N
5270	\N	\N	\N	\N	\N	\N
5271	\N	\N	\N	\N	\N	\N
5272	\N	\N	\N	\N	\N	\N
5273	\N	\N	\N	\N	\N	\N
5274	\N	\N	\N	\N	\N	\N
5275	\N	\N	\N	\N	\N	\N
5276	\N	\N	\N	\N	\N	\N
5277	\N	\N	\N	\N	\N	\N
5278	\N	\N	\N	\N	\N	\N
5279	\N	\N	\N	\N	\N	\N
5280	\N	\N	\N	\N	\N	\N
5281	\N	\N	\N	\N	\N	\N
5282	\N	\N	\N	\N	\N	\N
5283	\N	\N	\N	\N	\N	\N
5284	\N	\N	\N	\N	\N	\N
5285	\N	\N	\N	\N	\N	\N
5286	\N	\N	\N	\N	\N	\N
5287	\N	\N	\N	\N	\N	\N
5288	\N	\N	\N	\N	\N	\N
5289	\N	\N	\N	\N	\N	\N
5290	\N	\N	\N	\N	\N	\N
5291	\N	\N	\N	\N	\N	\N
5292	\N	\N	\N	\N	\N	\N
5293	\N	\N	\N	\N	\N	\N
5294	\N	\N	\N	\N	\N	\N
5295	\N	\N	\N	\N	\N	\N
5296	\N	\N	\N	\N	\N	\N
5297	\N	\N	\N	\N	\N	\N
5298	\N	\N	\N	\N	\N	\N
5299	\N	\N	\N	\N	\N	\N
5300	\N	\N	\N	\N	\N	\N
5301	\N	\N	\N	\N	\N	\N
5302	\N	\N	\N	\N	\N	\N
5303	\N	\N	\N	\N	\N	\N
5304	\N	\N	\N	\N	\N	\N
5305	\N	\N	\N	\N	\N	\N
5306	\N	\N	\N	\N	\N	\N
5307	\N	\N	\N	\N	\N	\N
5308	\N	\N	\N	\N	\N	\N
5309	\N	\N	\N	\N	\N	\N
5310	\N	\N	\N	\N	\N	\N
5311	\N	\N	\N	\N	\N	\N
5312	\N	\N	\N	\N	\N	\N
5313	\N	\N	\N	\N	\N	\N
5314	\N	\N	\N	\N	\N	\N
5315	\N	\N	\N	\N	\N	\N
5316	\N	\N	\N	\N	\N	\N
5317	\N	\N	\N	\N	\N	\N
5318	\N	\N	\N	\N	\N	\N
5319	\N	\N	\N	\N	\N	\N
5320	\N	\N	\N	\N	\N	\N
5321	\N	\N	\N	\N	\N	\N
5322	\N	\N	\N	\N	\N	\N
5323	\N	\N	\N	\N	\N	\N
5324	\N	\N	\N	\N	\N	\N
5325	\N	\N	\N	\N	\N	\N
5326	\N	\N	\N	\N	\N	\N
5327	\N	\N	\N	\N	\N	\N
5328	\N	\N	\N	\N	\N	\N
5329	\N	\N	\N	\N	\N	\N
5330	\N	\N	\N	\N	\N	\N
5331	\N	\N	\N	\N	\N	\N
5332	\N	\N	\N	\N	\N	\N
5333	\N	\N	\N	\N	\N	\N
5334	\N	\N	\N	\N	\N	\N
5335	\N	\N	\N	\N	\N	\N
5336	\N	\N	\N	\N	\N	\N
5337	\N	\N	\N	\N	\N	\N
5338	\N	\N	\N	\N	\N	\N
5339	\N	\N	\N	\N	\N	\N
5340	\N	\N	\N	\N	\N	\N
5341	\N	\N	\N	\N	\N	\N
5342	\N	\N	\N	\N	\N	\N
5343	\N	\N	\N	\N	\N	\N
5344	\N	\N	\N	\N	\N	\N
5345	\N	\N	\N	\N	\N	\N
5346	\N	\N	\N	\N	\N	\N
5347	\N	\N	\N	\N	\N	\N
5348	\N	\N	\N	\N	\N	\N
5349	\N	\N	\N	\N	\N	\N
5350	\N	\N	\N	\N	\N	\N
5351	\N	\N	\N	\N	\N	\N
5352	\N	\N	\N	\N	\N	\N
5353	\N	\N	\N	\N	\N	\N
5354	\N	\N	\N	\N	\N	\N
5355	\N	\N	\N	\N	\N	\N
5356	\N	\N	\N	\N	\N	\N
5357	\N	\N	\N	\N	\N	\N
5358	\N	\N	\N	\N	\N	\N
5359	\N	\N	\N	\N	\N	\N
5360	\N	\N	\N	\N	\N	\N
5361	\N	\N	\N	\N	\N	\N
5362	\N	\N	\N	\N	\N	\N
5363	\N	\N	\N	\N	\N	\N
5364	\N	\N	\N	\N	\N	\N
5365	\N	\N	\N	\N	\N	\N
5366	\N	\N	\N	\N	\N	\N
5367	\N	\N	\N	\N	\N	\N
5368	\N	\N	\N	\N	\N	\N
5369	\N	\N	\N	\N	\N	\N
5370	\N	\N	\N	\N	\N	\N
5371	\N	\N	\N	\N	\N	\N
5372	\N	\N	\N	\N	\N	\N
5373	\N	\N	\N	\N	\N	\N
5374	\N	\N	\N	\N	\N	\N
5375	\N	\N	\N	\N	\N	\N
5376	\N	\N	\N	\N	\N	\N
5377	\N	\N	\N	\N	\N	\N
5378	\N	\N	\N	\N	\N	\N
5379	\N	\N	\N	\N	\N	\N
5380	\N	\N	\N	\N	\N	\N
5381	\N	\N	\N	\N	\N	\N
5382	\N	\N	\N	\N	\N	\N
5383	\N	\N	\N	\N	\N	\N
5384	\N	\N	\N	\N	\N	\N
5385	\N	\N	\N	\N	\N	\N
5386	\N	\N	\N	\N	\N	\N
5387	\N	\N	\N	\N	\N	\N
5388	\N	\N	\N	\N	\N	\N
5389	\N	\N	\N	\N	\N	\N
5390	\N	\N	\N	\N	\N	\N
5391	\N	\N	\N	\N	\N	\N
5392	\N	\N	\N	\N	\N	\N
5393	\N	\N	\N	\N	\N	\N
5394	\N	\N	\N	\N	\N	\N
5395	\N	\N	\N	\N	\N	\N
5396	\N	\N	\N	\N	\N	\N
5397	\N	\N	\N	\N	\N	\N
5398	\N	\N	\N	\N	\N	\N
5399	\N	\N	\N	\N	\N	\N
5400	\N	\N	\N	\N	\N	\N
5401	\N	\N	\N	\N	\N	\N
5402	\N	\N	\N	\N	\N	\N
5403	\N	\N	\N	\N	\N	\N
5404	\N	\N	\N	\N	\N	\N
5405	\N	\N	\N	\N	\N	\N
5406	\N	\N	\N	\N	\N	\N
5407	\N	\N	\N	\N	\N	\N
5408	\N	\N	\N	\N	\N	\N
5409	\N	\N	\N	\N	\N	\N
5410	\N	\N	\N	\N	\N	\N
5411	\N	\N	\N	\N	\N	\N
5412	\N	\N	\N	\N	\N	\N
5413	\N	\N	\N	\N	\N	\N
5414	\N	\N	\N	\N	\N	\N
5415	\N	\N	\N	\N	\N	\N
5416	\N	\N	\N	\N	\N	\N
5417	\N	\N	\N	\N	\N	\N
5418	\N	\N	\N	\N	\N	\N
5419	\N	\N	\N	\N	\N	\N
5420	\N	\N	\N	\N	\N	\N
5421	\N	\N	\N	\N	\N	\N
5422	\N	\N	\N	\N	\N	\N
5423	\N	\N	\N	\N	\N	\N
5424	\N	\N	\N	\N	\N	\N
5425	\N	\N	\N	\N	\N	\N
5426	\N	\N	\N	\N	\N	\N
5427	\N	\N	\N	\N	\N	\N
5428	\N	\N	\N	\N	\N	\N
5429	\N	\N	\N	\N	\N	\N
5430	\N	\N	\N	\N	\N	\N
5431	\N	\N	\N	\N	\N	\N
5432	\N	\N	\N	\N	\N	\N
5433	\N	\N	\N	\N	\N	\N
5434	\N	\N	\N	\N	\N	\N
5435	\N	\N	\N	\N	\N	\N
5436	\N	\N	\N	\N	\N	\N
5437	\N	\N	\N	\N	\N	\N
5438	\N	\N	\N	\N	\N	\N
5439	\N	\N	\N	\N	\N	\N
5440	\N	\N	\N	\N	\N	\N
5441	\N	\N	\N	\N	\N	\N
5442	\N	\N	\N	\N	\N	\N
5443	\N	\N	\N	\N	\N	\N
5444	\N	\N	\N	\N	\N	\N
5445	\N	\N	\N	\N	\N	\N
5446	\N	\N	\N	\N	\N	\N
5447	\N	\N	\N	\N	\N	\N
5448	\N	\N	\N	\N	\N	\N
5449	\N	\N	\N	\N	\N	\N
5450	\N	\N	\N	\N	\N	\N
5451	\N	\N	\N	\N	\N	\N
5452	\N	\N	\N	\N	\N	\N
5453	\N	\N	\N	\N	\N	\N
5454	\N	\N	\N	\N	\N	\N
5455	\N	\N	\N	\N	\N	\N
5456	\N	\N	\N	\N	\N	\N
5457	\N	\N	\N	\N	\N	\N
5458	\N	\N	\N	\N	\N	\N
5459	\N	\N	\N	\N	\N	\N
5460	\N	\N	\N	\N	\N	\N
5461	\N	\N	\N	\N	\N	\N
5462	\N	\N	\N	\N	\N	\N
5463	\N	\N	\N	\N	\N	\N
5464	\N	\N	\N	\N	\N	\N
5465	\N	\N	\N	\N	\N	\N
5466	\N	\N	\N	\N	\N	\N
5467	\N	\N	\N	\N	\N	\N
5468	\N	\N	\N	\N	\N	\N
5469	\N	\N	\N	\N	\N	\N
5470	\N	\N	\N	\N	\N	\N
5471	\N	\N	\N	\N	\N	\N
5472	\N	\N	\N	\N	\N	\N
5473	\N	\N	\N	\N	\N	\N
5474	\N	\N	\N	\N	\N	\N
5475	\N	\N	\N	\N	\N	\N
5476	\N	\N	\N	\N	\N	\N
5477	\N	\N	\N	\N	\N	\N
5478	\N	\N	\N	\N	\N	\N
5479	\N	\N	\N	\N	\N	\N
5480	\N	\N	\N	\N	\N	\N
5481	\N	\N	\N	\N	\N	\N
5482	\N	\N	\N	\N	\N	\N
5483	\N	\N	\N	\N	\N	\N
5484	\N	\N	\N	\N	\N	\N
5485	\N	\N	\N	\N	\N	\N
5486	\N	\N	\N	\N	\N	\N
5487	\N	\N	\N	\N	\N	\N
5488	\N	\N	\N	\N	\N	\N
5489	\N	\N	\N	\N	\N	\N
5490	\N	\N	\N	\N	\N	\N
5491	\N	\N	\N	\N	\N	\N
5492	\N	\N	\N	\N	\N	\N
5493	\N	\N	\N	\N	\N	\N
5494	\N	\N	\N	\N	\N	\N
5495	\N	\N	\N	\N	\N	\N
5496	\N	\N	\N	\N	\N	\N
5497	\N	\N	\N	\N	\N	\N
5498	\N	\N	\N	\N	\N	\N
5499	\N	\N	\N	\N	\N	\N
5500	\N	\N	\N	\N	\N	\N
5501	\N	\N	\N	\N	\N	\N
5502	\N	\N	\N	\N	\N	\N
5503	\N	\N	\N	\N	\N	\N
5504	\N	\N	\N	\N	\N	\N
5505	\N	\N	\N	\N	\N	\N
5506	\N	\N	\N	\N	\N	\N
5507	\N	\N	\N	\N	\N	\N
5508	\N	\N	\N	\N	\N	\N
5509	\N	\N	\N	\N	\N	\N
5510	\N	\N	\N	\N	\N	\N
5511	\N	\N	\N	\N	\N	\N
5512	\N	\N	\N	\N	\N	\N
5513	\N	\N	\N	\N	\N	\N
5514	\N	\N	\N	\N	\N	\N
5515	\N	\N	\N	\N	\N	\N
5516	\N	\N	\N	\N	\N	\N
5517	\N	\N	\N	\N	\N	\N
5518	\N	\N	\N	\N	\N	\N
5519	\N	\N	\N	\N	\N	\N
5520	\N	\N	\N	\N	\N	\N
5521	\N	\N	\N	\N	\N	\N
5522	\N	\N	\N	\N	\N	\N
5523	\N	\N	\N	\N	\N	\N
5524	\N	\N	\N	\N	\N	\N
5525	\N	\N	\N	\N	\N	\N
5526	\N	\N	\N	\N	\N	\N
5527	\N	\N	\N	\N	\N	\N
5528	\N	\N	\N	\N	\N	\N
5529	\N	\N	\N	\N	\N	\N
5530	\N	\N	\N	\N	\N	\N
5531	\N	\N	\N	\N	\N	\N
5532	\N	\N	\N	\N	\N	\N
5533	\N	\N	\N	\N	\N	\N
5534	\N	\N	\N	\N	\N	\N
5535	\N	\N	\N	\N	\N	\N
5536	\N	\N	\N	\N	\N	\N
5537	\N	\N	\N	\N	\N	\N
5538	\N	\N	\N	\N	\N	\N
5539	\N	\N	\N	\N	\N	\N
5540	\N	\N	\N	\N	\N	\N
5541	\N	\N	\N	\N	\N	\N
5542	\N	\N	\N	\N	\N	\N
5543	\N	\N	\N	\N	\N	\N
5544	\N	\N	\N	\N	\N	\N
5545	\N	\N	\N	\N	\N	\N
5546	\N	\N	\N	\N	\N	\N
5547	\N	\N	\N	\N	\N	\N
5548	\N	\N	\N	\N	\N	\N
5549	\N	\N	\N	\N	\N	\N
5550	\N	\N	\N	\N	\N	\N
5551	\N	\N	\N	\N	\N	\N
5552	\N	\N	\N	\N	\N	\N
5553	\N	\N	\N	\N	\N	\N
5554	\N	\N	\N	\N	\N	\N
5555	\N	\N	\N	\N	\N	\N
5556	\N	\N	\N	\N	\N	\N
5557	\N	\N	\N	\N	\N	\N
5558	\N	\N	\N	\N	\N	\N
5559	\N	\N	\N	\N	\N	\N
5560	\N	\N	\N	\N	\N	\N
5561	\N	\N	\N	\N	\N	\N
5562	\N	\N	\N	\N	\N	\N
5563	\N	\N	\N	\N	\N	\N
5564	\N	\N	\N	\N	\N	\N
5565	\N	\N	\N	\N	\N	\N
5566	\N	\N	\N	\N	\N	\N
5567	\N	\N	\N	\N	\N	\N
5568	\N	\N	\N	\N	\N	\N
5569	\N	\N	\N	\N	\N	\N
5570	\N	\N	\N	\N	\N	\N
5571	\N	\N	\N	\N	\N	\N
5572	\N	\N	\N	\N	\N	\N
5573	\N	\N	\N	\N	\N	\N
5574	\N	\N	\N	\N	\N	\N
5575	\N	\N	\N	\N	\N	\N
5576	\N	\N	\N	\N	\N	\N
5577	\N	\N	\N	\N	\N	\N
5578	\N	\N	\N	\N	\N	\N
5579	\N	\N	\N	\N	\N	\N
5580	\N	\N	\N	\N	\N	\N
5581	\N	\N	\N	\N	\N	\N
5582	\N	\N	\N	\N	\N	\N
5583	\N	\N	\N	\N	\N	\N
5584	\N	\N	\N	\N	\N	\N
5585	\N	\N	\N	\N	\N	\N
5586	\N	\N	\N	\N	\N	\N
5587	\N	\N	\N	\N	\N	\N
5588	\N	\N	\N	\N	\N	\N
5589	\N	\N	\N	\N	\N	\N
5590	\N	\N	\N	\N	\N	\N
5591	\N	\N	\N	\N	\N	\N
5592	\N	\N	\N	\N	\N	\N
5593	\N	\N	\N	\N	\N	\N
5594	\N	\N	\N	\N	\N	\N
5595	\N	\N	\N	\N	\N	\N
5596	\N	\N	\N	\N	\N	\N
5597	\N	\N	\N	\N	\N	\N
5598	\N	\N	\N	\N	\N	\N
5599	\N	\N	\N	\N	\N	\N
5600	\N	\N	\N	\N	\N	\N
5601	\N	\N	\N	\N	\N	\N
5602	\N	\N	\N	\N	\N	\N
5603	\N	\N	\N	\N	\N	\N
5604	\N	\N	\N	\N	\N	\N
5605	\N	\N	\N	\N	\N	\N
5606	\N	\N	\N	\N	\N	\N
5607	\N	\N	\N	\N	\N	\N
5608	\N	\N	\N	\N	\N	\N
5609	\N	\N	\N	\N	\N	\N
5610	\N	\N	\N	\N	\N	\N
5611	\N	\N	\N	\N	\N	\N
5612	\N	\N	\N	\N	\N	\N
5613	\N	\N	\N	\N	\N	\N
5614	\N	\N	\N	\N	\N	\N
\.


--
-- Data for Name: species; Type: TABLE DATA; Schema: public; Owner: nmo
--

COPY public.species (id, name) FROM stdin;
11	rat
15	mouse
16	human
17	zebrafish
\.


--
-- Data for Name: staining; Type: TABLE DATA; Schema: public; Owner: nmo
--

COPY public.staining (id, name) FROM stdin;
10	Fiddlers Green
14	Golgi-Cox
15	neurobiotin
16	Not reported
17	immunostaining
18	biotinylated dextran amine
19	green fluorescent protein
20	biocytin
21	sulforhodamine 101
22	Streptavidin-Alexa Fluor 488
23	td Tomato fluorescent protein
\.


--
-- Data for Name: strain; Type: TABLE DATA; Schema: public; Owner: nmo
--

COPY public.strain (id, name, species_id) FROM stdin;
10	Wistar	11
14	C57BL/6J	15
15	CX3CR1gpf/+	15
16	CD1	15
17	C57BL/6	15
18	CXCR4-EGFP	15
19	Ai9	15
20	NDNF-cre	15
21	NPY-hrGFP x NDNF-cre	15
22	Not applicable	16
23	Sprague-Dawley	11
24	mikre oko (mok m632)	17
25	wild type	17
26	dctn1b	17
27	dctn1b x mikre oko (mok m632)	17
28	ale oko (jj50)	17
29	C57BL/6 SST-Cre +/- iDTR +/-	15
30	Tg(KalTA4u508)u508Tg, Tg(elavl3:H2B-GCaMP6s)jf5Tg	17
32	TgKalTA4u508u508Tg, Tgelavl3:H2B-GCaMP6sjf5Tg	17
33	Tg\\(KalTA4u508\\)u508Tg, Tg\\(elavl3:H2B-GCaMP6s\\)jf5Tg	17
\.


--
-- Name: archive_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nmo
--

SELECT pg_catalog.setval('public.archive_id_seq', 90, true);


--
-- Name: celltype_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nmo
--

SELECT pg_catalog.setval('public.celltype_id_seq', 111, true);


--
-- Name: expcond_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nmo
--

SELECT pg_catalog.setval('public.expcond_id_seq', 49, true);


--
-- Name: export_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nmo
--

SELECT pg_catalog.setval('public.export_id_seq', 1114, true);


--
-- Name: ingested_archives_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nmo
--

SELECT pg_catalog.setval('public.ingested_archives_id_seq', 325, true);


--
-- Name: ingestion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nmo
--

SELECT pg_catalog.setval('public.ingestion_id_seq', 44757, true);


--
-- Name: measurements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nmo
--

SELECT pg_catalog.setval('public.measurements_id_seq', 5639, true);


--
-- Name: neuron_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nmo
--

SELECT pg_catalog.setval('public.neuron_id_seq', 4714, true);


--
-- Name: neuron_segment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nmo
--

SELECT pg_catalog.setval('public.neuron_segment_id_seq', 1, false);


--
-- Name: neuron_structure_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nmo
--

SELECT pg_catalog.setval('public.neuron_structure_id_seq', 1322, true);


--
-- Name: originalformat_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nmo
--

SELECT pg_catalog.setval('public.originalformat_id_seq', 20, true);


--
-- Name: publication_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nmo
--

SELECT pg_catalog.setval('public.publication_id_seq', 32, true);


--
-- Name: pvec_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nmo
--

SELECT pg_catalog.setval('public.pvec_id_seq', 107, true);


--
-- Name: region_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nmo
--

SELECT pg_catalog.setval('public.region_id_seq', 115, true);


--
-- Name: shrinkagevalue_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nmo
--

SELECT pg_catalog.setval('public.shrinkagevalue_id_seq', 5614, true);


--
-- Name: species_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nmo
--

SELECT pg_catalog.setval('public.species_id_seq', 17, true);


--
-- Name: staining_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nmo
--

SELECT pg_catalog.setval('public.staining_id_seq', 23, true);


--
-- Name: strain_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nmo
--

SELECT pg_catalog.setval('public.strain_id_seq', 33, true);


--
-- Name: archive archive_pkey; Type: CONSTRAINT; Schema: public; Owner: nmo
--

ALTER TABLE ONLY public.archive
    ADD CONSTRAINT archive_pkey PRIMARY KEY (id);


--
-- Name: celltype celltype_pkey; Type: CONSTRAINT; Schema: public; Owner: nmo
--

ALTER TABLE ONLY public.celltype
    ADD CONSTRAINT celltype_pkey PRIMARY KEY (id);


--
-- Name: expcond expcond_ix1; Type: CONSTRAINT; Schema: public; Owner: nmo
--

ALTER TABLE ONLY public.expcond
    ADD CONSTRAINT expcond_ix1 UNIQUE (id);


--
-- Name: expcond experimentcondition_pkey; Type: CONSTRAINT; Schema: public; Owner: nmo
--

ALTER TABLE ONLY public.expcond
    ADD CONSTRAINT experimentcondition_pkey PRIMARY KEY (id);


--
-- Name: ingested_archives ingested_archives_pkey; Type: CONSTRAINT; Schema: public; Owner: nmo
--

ALTER TABLE ONLY public.ingested_archives
    ADD CONSTRAINT ingested_archives_pkey PRIMARY KEY (id);


--
-- Name: ingestion ingestion_neuron_id_ingestion_date_key; Type: CONSTRAINT; Schema: public; Owner: nmo
--

ALTER TABLE ONLY public.ingestion
    ADD CONSTRAINT ingestion_neuron_id_ingestion_date_key UNIQUE (neuron_id, ingestion_date);


--
-- Name: ingestion ingestion_pkey; Type: CONSTRAINT; Schema: public; Owner: nmo
--

ALTER TABLE ONLY public.ingestion
    ADD CONSTRAINT ingestion_pkey PRIMARY KEY (id);


--
-- Name: measurements measurements_pkey; Type: CONSTRAINT; Schema: public; Owner: nmo
--

ALTER TABLE ONLY public.measurements
    ADD CONSTRAINT measurements_pkey PRIMARY KEY (id);


--
-- Name: neuron neuron_ix1; Type: CONSTRAINT; Schema: public; Owner: nmo
--

ALTER TABLE ONLY public.neuron
    ADD CONSTRAINT neuron_ix1 UNIQUE (name);


--
-- Name: neuron neuron_ix2; Type: CONSTRAINT; Schema: public; Owner: nmo
--

ALTER TABLE ONLY public.neuron
    ADD CONSTRAINT neuron_ix2 UNIQUE (oldid);


--
-- Name: neuron_segment neuron_segment_pkey; Type: CONSTRAINT; Schema: public; Owner: nmo
--

ALTER TABLE ONLY public.neuron_segment
    ADD CONSTRAINT neuron_segment_pkey PRIMARY KEY (id);


--
-- Name: neuron_structure neuron_structure_pkey; Type: CONSTRAINT; Schema: public; Owner: nmo
--

ALTER TABLE ONLY public.neuron_structure
    ADD CONSTRAINT neuron_structure_pkey PRIMARY KEY (id);


--
-- Name: originalformat originalformat_pkey; Type: CONSTRAINT; Schema: public; Owner: nmo
--

ALTER TABLE ONLY public.originalformat
    ADD CONSTRAINT originalformat_pkey PRIMARY KEY (id);


--
-- Name: neuron pk; Type: CONSTRAINT; Schema: public; Owner: nmo
--

ALTER TABLE ONLY public.neuron
    ADD CONSTRAINT pk PRIMARY KEY (id);


--
-- Name: publication publication_ix1; Type: CONSTRAINT; Schema: public; Owner: nmo
--

ALTER TABLE ONLY public.publication
    ADD CONSTRAINT publication_ix1 UNIQUE (pmid);


--
-- Name: publication publication_ix2; Type: CONSTRAINT; Schema: public; Owner: nmo
--

ALTER TABLE ONLY public.publication
    ADD CONSTRAINT publication_ix2 UNIQUE (doi);


--
-- Name: publication publication_pkey; Type: CONSTRAINT; Schema: public; Owner: nmo
--

ALTER TABLE ONLY public.publication
    ADD CONSTRAINT publication_pkey PRIMARY KEY (id);


--
-- Name: pvec pvec_pkey; Type: CONSTRAINT; Schema: public; Owner: nmo
--

ALTER TABLE ONLY public.pvec
    ADD CONSTRAINT pvec_pkey PRIMARY KEY (id);


--
-- Name: region region_ix1; Type: CONSTRAINT; Schema: public; Owner: nmo
--

ALTER TABLE ONLY public.region
    ADD CONSTRAINT region_ix1 UNIQUE (path);


--
-- Name: region region_pkey; Type: CONSTRAINT; Schema: public; Owner: nmo
--

ALTER TABLE ONLY public.region
    ADD CONSTRAINT region_pkey PRIMARY KEY (id);


--
-- Name: shrinkagevalue shrinkagevalue_pkey; Type: CONSTRAINT; Schema: public; Owner: nmo
--

ALTER TABLE ONLY public.shrinkagevalue
    ADD CONSTRAINT shrinkagevalue_pkey PRIMARY KEY (id);


--
-- Name: species species_pkey; Type: CONSTRAINT; Schema: public; Owner: nmo
--

ALTER TABLE ONLY public.species
    ADD CONSTRAINT species_pkey PRIMARY KEY (id);


--
-- Name: staining staining_ix1; Type: CONSTRAINT; Schema: public; Owner: nmo
--

ALTER TABLE ONLY public.staining
    ADD CONSTRAINT staining_ix1 UNIQUE (id);


--
-- Name: staining staining_pkey; Type: CONSTRAINT; Schema: public; Owner: nmo
--

ALTER TABLE ONLY public.staining
    ADD CONSTRAINT staining_pkey PRIMARY KEY (id);


--
-- Name: strain strain_pkey; Type: CONSTRAINT; Schema: public; Owner: nmo
--

ALTER TABLE ONLY public.strain
    ADD CONSTRAINT strain_pkey PRIMARY KEY (id);


--
-- Name: export export_fk1; Type: FK CONSTRAINT; Schema: public; Owner: nmo
--

ALTER TABLE ONLY public.export
    ADD CONSTRAINT export_fk1 FOREIGN KEY (neuron_id) REFERENCES public.neuron(id);


--
-- Name: ingestion ingestion_fk1; Type: FK CONSTRAINT; Schema: public; Owner: nmo
--

ALTER TABLE ONLY public.ingestion
    ADD CONSTRAINT ingestion_fk1 FOREIGN KEY (neuron_id) REFERENCES public.neuron(id) ON DELETE CASCADE;


--
-- Name: neuron neuron_fk1; Type: FK CONSTRAINT; Schema: public; Owner: nmo
--

ALTER TABLE ONLY public.neuron
    ADD CONSTRAINT neuron_fk1 FOREIGN KEY (archive_id) REFERENCES public.archive(id) ON DELETE CASCADE;


--
-- Name: neuron neuron_fk10; Type: FK CONSTRAINT; Schema: public; Owner: nmo
--

ALTER TABLE ONLY public.neuron
    ADD CONSTRAINT neuron_fk10 FOREIGN KEY (staining_id) REFERENCES public.staining(id);


--
-- Name: neuron neuron_fk11; Type: FK CONSTRAINT; Schema: public; Owner: nmo
--

ALTER TABLE ONLY public.neuron
    ADD CONSTRAINT neuron_fk11 FOREIGN KEY (strain_id) REFERENCES public.strain(id);


--
-- Name: neuron neuron_fk2; Type: FK CONSTRAINT; Schema: public; Owner: nmo
--

ALTER TABLE ONLY public.neuron
    ADD CONSTRAINT neuron_fk2 FOREIGN KEY (region_id) REFERENCES public.region(id);


--
-- Name: neuron neuron_fk3; Type: FK CONSTRAINT; Schema: public; Owner: nmo
--

ALTER TABLE ONLY public.neuron
    ADD CONSTRAINT neuron_fk3 FOREIGN KEY (celltype_id) REFERENCES public.celltype(id);


--
-- Name: neuron neuron_fk4; Type: FK CONSTRAINT; Schema: public; Owner: nmo
--

ALTER TABLE ONLY public.neuron
    ADD CONSTRAINT neuron_fk4 FOREIGN KEY (publication_id) REFERENCES public.publication(id);


--
-- Name: neuron neuron_fk5; Type: FK CONSTRAINT; Schema: public; Owner: nmo
--

ALTER TABLE ONLY public.neuron
    ADD CONSTRAINT neuron_fk5 FOREIGN KEY (expcond_id) REFERENCES public.expcond(id);


--
-- Name: neuron neuron_fk7; Type: FK CONSTRAINT; Schema: public; Owner: nmo
--

ALTER TABLE ONLY public.neuron
    ADD CONSTRAINT neuron_fk7 FOREIGN KEY (summary_meas_id) REFERENCES public.measurements(id);


--
-- Name: neuron neuron_fk8; Type: FK CONSTRAINT; Schema: public; Owner: nmo
--

ALTER TABLE ONLY public.neuron
    ADD CONSTRAINT neuron_fk8 FOREIGN KEY (originalformat_id) REFERENCES public.originalformat(id);


--
-- Name: neuron neuron_fk9; Type: FK CONSTRAINT; Schema: public; Owner: nmo
--

ALTER TABLE ONLY public.neuron
    ADD CONSTRAINT neuron_fk9 FOREIGN KEY (shrinkagevalue_id) REFERENCES public.shrinkagevalue(id);


--
-- Name: neuron_segment neuronsegment_fk1; Type: FK CONSTRAINT; Schema: public; Owner: nmo
--

ALTER TABLE ONLY public.neuron_segment
    ADD CONSTRAINT neuronsegment_fk1 FOREIGN KEY (neuron_id) REFERENCES public.neuron(id);


--
-- Name: neuron_structure neuronstructure_fk2; Type: FK CONSTRAINT; Schema: public; Owner: nmo
--

ALTER TABLE ONLY public.neuron_structure
    ADD CONSTRAINT neuronstructure_fk2 FOREIGN KEY (measurements_id) REFERENCES public.measurements(id);


--
-- Name: neuron_structure neuronstructure_fk3; Type: FK CONSTRAINT; Schema: public; Owner: nmo
--

ALTER TABLE ONLY public.neuron_structure
    ADD CONSTRAINT neuronstructure_fk3 FOREIGN KEY (neuron_id) REFERENCES public.neuron(id) ON DELETE CASCADE;


--
-- Name: publication publication_fk1; Type: FK CONSTRAINT; Schema: public; Owner: nmo
--

ALTER TABLE ONLY public.publication
    ADD CONSTRAINT publication_fk1 FOREIGN KEY (species_id) REFERENCES public.species(id);


--
-- Name: pvec pvec_fk1; Type: FK CONSTRAINT; Schema: public; Owner: nmo
--

ALTER TABLE ONLY public.pvec
    ADD CONSTRAINT pvec_fk1 FOREIGN KEY (neuron_id) REFERENCES public.neuron(id) ON DELETE CASCADE;


--
-- Name: strain strain_fk1; Type: FK CONSTRAINT; Schema: public; Owner: nmo
--

ALTER TABLE ONLY public.strain
    ADD CONSTRAINT strain_fk1 FOREIGN KEY (species_id) REFERENCES public.species(id);


--
-- Name: DATABASE nmo; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON DATABASE nmo TO nmo;
GRANT ALL ON DATABASE nmo TO webuser;


--
-- PostgreSQL database dump complete
--

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2 (Ubuntu 12.2-4)
-- Dumped by pg_dump version 12.2 (Ubuntu 12.2-4)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: ltree; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS ltree WITH SCHEMA public;


--
-- Name: EXTENSION ltree; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION ltree IS 'data type for hierarchical tree-like structures';


--
-- Name: status_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.status_type AS ENUM (
    'ready',
    'read',
    'error',
    'ingested',
    'partial'
);


ALTER TYPE public.status_type OWNER TO postgres;

--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA public TO webuser;


--
-- Name: FUNCTION lquery_in(cstring); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.lquery_in(cstring) TO webuser;


--
-- Name: FUNCTION lquery_out(public.lquery); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.lquery_out(public.lquery) TO webuser;


--
-- Name: FUNCTION ltree_in(cstring); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltree_in(cstring) TO webuser;


--
-- Name: FUNCTION ltree_out(public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltree_out(public.ltree) TO webuser;


--
-- Name: FUNCTION ltree_gist_in(cstring); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltree_gist_in(cstring) TO webuser;


--
-- Name: FUNCTION ltree_gist_out(public.ltree_gist); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltree_gist_out(public.ltree_gist) TO webuser;


--
-- Name: FUNCTION ltxtq_in(cstring); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltxtq_in(cstring) TO webuser;


--
-- Name: FUNCTION ltxtq_out(public.ltxtquery); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltxtq_out(public.ltxtquery) TO webuser;


--
-- Name: FUNCTION _lt_q_regex(public.ltree[], public.lquery[]); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public._lt_q_regex(public.ltree[], public.lquery[]) TO webuser;


--
-- Name: FUNCTION _lt_q_rregex(public.lquery[], public.ltree[]); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public._lt_q_rregex(public.lquery[], public.ltree[]) TO webuser;


--
-- Name: FUNCTION _ltq_extract_regex(public.ltree[], public.lquery); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public._ltq_extract_regex(public.ltree[], public.lquery) TO webuser;


--
-- Name: FUNCTION _ltq_regex(public.ltree[], public.lquery); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public._ltq_regex(public.ltree[], public.lquery) TO webuser;


--
-- Name: FUNCTION _ltq_rregex(public.lquery, public.ltree[]); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public._ltq_rregex(public.lquery, public.ltree[]) TO webuser;


--
-- Name: FUNCTION _ltree_compress(internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public._ltree_compress(internal) TO webuser;


--
-- Name: FUNCTION _ltree_consistent(internal, public.ltree[], smallint, oid, internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public._ltree_consistent(internal, public.ltree[], smallint, oid, internal) TO webuser;


--
-- Name: FUNCTION _ltree_extract_isparent(public.ltree[], public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public._ltree_extract_isparent(public.ltree[], public.ltree) TO webuser;


--
-- Name: FUNCTION _ltree_extract_risparent(public.ltree[], public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public._ltree_extract_risparent(public.ltree[], public.ltree) TO webuser;


--
-- Name: FUNCTION _ltree_isparent(public.ltree[], public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public._ltree_isparent(public.ltree[], public.ltree) TO webuser;


--
-- Name: FUNCTION _ltree_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public._ltree_penalty(internal, internal, internal) TO webuser;


--
-- Name: FUNCTION _ltree_picksplit(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public._ltree_picksplit(internal, internal) TO webuser;


--
-- Name: FUNCTION _ltree_r_isparent(public.ltree, public.ltree[]); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public._ltree_r_isparent(public.ltree, public.ltree[]) TO webuser;


--
-- Name: FUNCTION _ltree_r_risparent(public.ltree, public.ltree[]); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public._ltree_r_risparent(public.ltree, public.ltree[]) TO webuser;


--
-- Name: FUNCTION _ltree_risparent(public.ltree[], public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public._ltree_risparent(public.ltree[], public.ltree) TO webuser;


--
-- Name: FUNCTION _ltree_same(public.ltree_gist, public.ltree_gist, internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public._ltree_same(public.ltree_gist, public.ltree_gist, internal) TO webuser;


--
-- Name: FUNCTION _ltree_union(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public._ltree_union(internal, internal) TO webuser;


--
-- Name: FUNCTION _ltxtq_exec(public.ltree[], public.ltxtquery); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public._ltxtq_exec(public.ltree[], public.ltxtquery) TO webuser;


--
-- Name: FUNCTION _ltxtq_extract_exec(public.ltree[], public.ltxtquery); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public._ltxtq_extract_exec(public.ltree[], public.ltxtquery) TO webuser;


--
-- Name: FUNCTION _ltxtq_rexec(public.ltxtquery, public.ltree[]); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public._ltxtq_rexec(public.ltxtquery, public.ltree[]) TO webuser;


--
-- Name: FUNCTION index(public.ltree, public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.index(public.ltree, public.ltree) TO webuser;


--
-- Name: FUNCTION index(public.ltree, public.ltree, integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.index(public.ltree, public.ltree, integer) TO webuser;


--
-- Name: FUNCTION lca(public.ltree[]); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.lca(public.ltree[]) TO webuser;


--
-- Name: FUNCTION lca(public.ltree, public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.lca(public.ltree, public.ltree) TO webuser;


--
-- Name: FUNCTION lca(public.ltree, public.ltree, public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.lca(public.ltree, public.ltree, public.ltree) TO webuser;


--
-- Name: FUNCTION lca(public.ltree, public.ltree, public.ltree, public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.lca(public.ltree, public.ltree, public.ltree, public.ltree) TO webuser;


--
-- Name: FUNCTION lca(public.ltree, public.ltree, public.ltree, public.ltree, public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.lca(public.ltree, public.ltree, public.ltree, public.ltree, public.ltree) TO webuser;


--
-- Name: FUNCTION lca(public.ltree, public.ltree, public.ltree, public.ltree, public.ltree, public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.lca(public.ltree, public.ltree, public.ltree, public.ltree, public.ltree, public.ltree) TO webuser;


--
-- Name: FUNCTION lca(public.ltree, public.ltree, public.ltree, public.ltree, public.ltree, public.ltree, public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.lca(public.ltree, public.ltree, public.ltree, public.ltree, public.ltree, public.ltree, public.ltree) TO webuser;


--
-- Name: FUNCTION lca(public.ltree, public.ltree, public.ltree, public.ltree, public.ltree, public.ltree, public.ltree, public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.lca(public.ltree, public.ltree, public.ltree, public.ltree, public.ltree, public.ltree, public.ltree, public.ltree) TO webuser;


--
-- Name: FUNCTION lt_q_regex(public.ltree, public.lquery[]); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.lt_q_regex(public.ltree, public.lquery[]) TO webuser;


--
-- Name: FUNCTION lt_q_rregex(public.lquery[], public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.lt_q_rregex(public.lquery[], public.ltree) TO webuser;


--
-- Name: FUNCTION ltq_regex(public.ltree, public.lquery); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltq_regex(public.ltree, public.lquery) TO webuser;


--
-- Name: FUNCTION ltq_rregex(public.lquery, public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltq_rregex(public.lquery, public.ltree) TO webuser;


--
-- Name: FUNCTION ltree2text(public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltree2text(public.ltree) TO webuser;


--
-- Name: FUNCTION ltree_addltree(public.ltree, public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltree_addltree(public.ltree, public.ltree) TO webuser;


--
-- Name: FUNCTION ltree_addtext(public.ltree, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltree_addtext(public.ltree, text) TO webuser;


--
-- Name: FUNCTION ltree_cmp(public.ltree, public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltree_cmp(public.ltree, public.ltree) TO webuser;


--
-- Name: FUNCTION ltree_compress(internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltree_compress(internal) TO webuser;


--
-- Name: FUNCTION ltree_consistent(internal, public.ltree, smallint, oid, internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltree_consistent(internal, public.ltree, smallint, oid, internal) TO webuser;


--
-- Name: FUNCTION ltree_decompress(internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltree_decompress(internal) TO webuser;


--
-- Name: FUNCTION ltree_eq(public.ltree, public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltree_eq(public.ltree, public.ltree) TO webuser;


--
-- Name: FUNCTION ltree_ge(public.ltree, public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltree_ge(public.ltree, public.ltree) TO webuser;


--
-- Name: FUNCTION ltree_gt(public.ltree, public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltree_gt(public.ltree, public.ltree) TO webuser;


--
-- Name: FUNCTION ltree_isparent(public.ltree, public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltree_isparent(public.ltree, public.ltree) TO webuser;


--
-- Name: FUNCTION ltree_le(public.ltree, public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltree_le(public.ltree, public.ltree) TO webuser;


--
-- Name: FUNCTION ltree_lt(public.ltree, public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltree_lt(public.ltree, public.ltree) TO webuser;


--
-- Name: FUNCTION ltree_ne(public.ltree, public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltree_ne(public.ltree, public.ltree) TO webuser;


--
-- Name: FUNCTION ltree_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltree_penalty(internal, internal, internal) TO webuser;


--
-- Name: FUNCTION ltree_picksplit(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltree_picksplit(internal, internal) TO webuser;


--
-- Name: FUNCTION ltree_risparent(public.ltree, public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltree_risparent(public.ltree, public.ltree) TO webuser;


--
-- Name: FUNCTION ltree_same(public.ltree_gist, public.ltree_gist, internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltree_same(public.ltree_gist, public.ltree_gist, internal) TO webuser;


--
-- Name: FUNCTION ltree_textadd(text, public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltree_textadd(text, public.ltree) TO webuser;


--
-- Name: FUNCTION ltree_union(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltree_union(internal, internal) TO webuser;


--
-- Name: FUNCTION ltreeparentsel(internal, oid, internal, integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltreeparentsel(internal, oid, internal, integer) TO webuser;


--
-- Name: FUNCTION ltxtq_exec(public.ltree, public.ltxtquery); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltxtq_exec(public.ltree, public.ltxtquery) TO webuser;


--
-- Name: FUNCTION ltxtq_rexec(public.ltxtquery, public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltxtq_rexec(public.ltxtquery, public.ltree) TO webuser;


--
-- Name: FUNCTION nlevel(public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.nlevel(public.ltree) TO webuser;


--
-- Name: FUNCTION subltree(public.ltree, integer, integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.subltree(public.ltree, integer, integer) TO webuser;


--
-- Name: FUNCTION subpath(public.ltree, integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.subpath(public.ltree, integer) TO webuser;


--
-- Name: FUNCTION subpath(public.ltree, integer, integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.subpath(public.ltree, integer, integer) TO webuser;


--
-- Name: FUNCTION text2ltree(text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.text2ltree(text) TO webuser;


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--

