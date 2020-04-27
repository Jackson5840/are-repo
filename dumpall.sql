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
ALTER ROLE nmo WITH NOSUPERUSER INHERIT NOCREATEROLE CREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'md5e0ea2c23131188579c5d8476f96b4f6b';
CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS;






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

-- Dumped from database version 12.2 (Ubuntu 12.2-2.pgdg19.10+1)
-- Dumped by pg_dump version 12.2 (Ubuntu 12.2-2.pgdg19.10+1)

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

-- Dumped from database version 12.2 (Ubuntu 12.2-2.pgdg19.10+1)
-- Dumped by pg_dump version 12.2 (Ubuntu 12.2-2.pgdg19.10+1)

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
    'Y'
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
    'incomplete',
    'moderate',
    'complete'
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
-- Name: gender_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.gender_type AS ENUM (
    'F',
    'H',
    'M',
    'M/F',
    'NR'
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
    'not reported',
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
    'not reported',
    'not applicable'
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
    'not reported',
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
    'whole mount'
);


ALTER TYPE public.slicing_direction_type OWNER TO postgres;

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
	                       insert into celltype(name,path) values (celltype_names[counter],text2ltree(ancPath));
	               END IF;
                        
                END LOOP;
        
	END IF;
	
	
	

COMMIT;
END;
 END;
$$;


ALTER PROCEDURE public.ingest_celltype(celltype_names text[], a_celltype_path character varying) OWNER TO nmo;

--
-- Name: ingest_data(character varying, character varying, character varying, character varying, character varying, public.age_type, integer, integer, date, date, double precision, public.objective_type, character varying, public.protocol_type, public.slicing_direction_type, double precision, character varying, character varying, boolean, public.shrinkage_type, public.age_scale_type, public.gender_type, double precision, double precision, double precision, double precision, text, integer, character varying, integer, integer, character varying, integer); Type: PROCEDURE; Schema: public; Owner: nmo
--

CREATE PROCEDURE public.ingest_data(neuron_name character varying, archive_name character varying, archive_url character varying, a_species character varying, a_expcond character varying, a_age public.age_type, a_region_id integer, a_celltype_id integer, a_depositiondate date, a_uploaddate date, magnification double precision, objective public.objective_type, a_originalformat character varying, protocol public.protocol_type, a_slicing_direction public.slicing_direction_type, slicingthickness double precision, a_staining character varying, a_strain character varying, has_soma boolean, shrinkage public.shrinkage_type, age_scale public.age_scale_type, gender public.gender_type, max_age double precision, min_age double precision, min_weight double precision, max_weight double precision, note text, a_pmid integer, a_doi character varying, a_summary_meas_id integer, a_shrinkagevalue_id integer, a_url_reference character varying, INOUT a_neuron_id integer)
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
	
	
	INSERT INTO neuron(name,archive_id,age,region_id,celltype_id,depositiondate,uploaddate,publication_id,expcond_id,magnification,summary_meas_id,objective,originalformat_id,protocol,slicing_direction,slicingthickness,staining_id,shrinkage,shrinkagevalue_id,age_scale,gender,max_age,min_age,min_weight,max_weight,note,url_reference) 
	VALUES(neuron_name, a_archive_id,
		a_age,a_celltype_id,a_region_id, a_depositiondate, a_uploaddate, a_publication_id, a_expcond_id, magnification, a_summary_meas_id, objective, a_originalformat_id, protocol, a_slicing_direction, slicingthickness, a_staining_id, shrinkage, a_shrinkagevalue_id, age_scale, gender, max_age,min_age,min_weight,max_weight,note, a_url_reference);
        select neuron.id into a_neuron_id from neuron where neuron.name = neuron_name;

COMMIT;
END;
 END;
$$;


ALTER PROCEDURE public.ingest_data(neuron_name character varying, archive_name character varying, archive_url character varying, a_species character varying, a_expcond character varying, a_age public.age_type, a_region_id integer, a_celltype_id integer, a_depositiondate date, a_uploaddate date, magnification double precision, objective public.objective_type, a_originalformat character varying, protocol public.protocol_type, a_slicing_direction public.slicing_direction_type, slicingthickness double precision, a_staining character varying, a_strain character varying, has_soma boolean, shrinkage public.shrinkage_type, age_scale public.age_scale_type, gender public.gender_type, max_age double precision, min_age double precision, min_weight double precision, max_weight double precision, note text, a_pmid integer, a_doi character varying, a_summary_meas_id integer, a_shrinkagevalue_id integer, a_url_reference character varying, INOUT a_neuron_id integer) OWNER TO nmo;

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
	                       insert into region(name,path) values (reg_names[counter],text2ltree(ancPath));
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
-- Name: ingestion; Type: TABLE; Schema: public; Owner: nmo
--

CREATE TABLE public.ingestion (
    id integer NOT NULL,
    neuron_id integer,
    ingestion_date date,
    status integer,
    warnings text,
    errors text,
    premessage text
);


ALTER TABLE public.ingestion OWNER TO nmo;

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
    partition_assymetry double precision,
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
    magnification double precision,
    summary_meas_id integer,
    objective public.objective_type,
    originalformat_id integer,
    slicing_direction public.slicing_direction_type,
    slicingthickness double precision,
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
    oldid integer
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
    domain public.domain_type NOT NULL
);


ALTER TABLE public.neuron_structure OWNER TO nmo;

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
    reported_val double precision,
    reported_xy double precision,
    reported_z double precision,
    corrected_val double precision,
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
\.


--
-- Data for Name: celltype; Type: TABLE DATA; Schema: public; Owner: nmo
--

COPY public.celltype (id, name, path) FROM stdin;
1	testreg	C.D
3	'testG'	G
4	'testH'	G.H
5	'testI'	G.H.I
6	'testI'	G.H.J
28	'test1'	test1
29	'Not ported'	test1.Not_ported
30	'Not  reported'	test1.Not_ported.Not__reported
31	'test4'	test1.Not_ported.Not__reported.test4
\.


--
-- Data for Name: expcond; Type: TABLE DATA; Schema: public; Owner: nmo
--

COPY public.expcond (id, name) FROM stdin;
31	gruesome
\.


--
-- Data for Name: ingestion; Type: TABLE DATA; Schema: public; Owner: nmo
--

COPY public.ingestion (id, neuron_id, ingestion_date, status, warnings, errors, premessage) FROM stdin;
\.


--
-- Data for Name: measurements; Type: TABLE DATA; Schema: public; Owner: nmo
--

COPY public.measurements (id, soma_surface, n_stems, n_bifs, n_branch, width, height, depth, diameter, length, surface, volume, eucdistance, pathdistance, branch_order, contraction, fragmentation, partition_assymetry, pk_classic, bif_ampl_local, bif_ampl_remote, fractal_dim) FROM stdin;
4	103	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
5	103	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
6	103	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\.


--
-- Data for Name: neuron; Type: TABLE DATA; Schema: public; Owner: nmo
--

COPY public.neuron (id, name, archive_id, age, region_id, celltype_id, depositiondate, uploaddate, publication_id, expcond_id, magnification, summary_meas_id, objective, originalformat_id, slicing_direction, slicingthickness, has_soma, shrinkage, shrinkagevalue_id, age_scale, gender, max_age, min_age, min_weight, max_weight, note, url_reference, staining_id, protocol, oldid) FROM stdin;
73	testname	15	adult	1	1	2020-01-01	2020-02-02	25	31	1	5	dry	10	coronal	0.5	\N	not reported	5	D	F	5.2	4.1	6.4	3.5	nice experiment	http://testing.com	10	in vivo	\N
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

COPY public.neuron_structure (id, neuron_id, measurements_id, completeness, domain) FROM stdin;
\.


--
-- Data for Name: originalformat; Type: TABLE DATA; Schema: public; Owner: nmo
--

COPY public.originalformat (id, name, format_type) FROM stdin;
10	DAT	\N
\.


--
-- Data for Name: publication; Type: TABLE DATA; Schema: public; Owner: nmo
--

COPY public.publication (id, pmid, doi, year, journal, title, first_author, last_author, species_id, ocdate, specific_details, related_page, data_status, literature_id, abstract, url) FROM stdin;
25	1111111	doi.org/test/11111	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\.


--
-- Data for Name: region; Type: TABLE DATA; Schema: public; Owner: nmo
--

COPY public.region (id, name, path) FROM stdin;
1	testregion	A.B
2	test2	A.B.C
3	test3	A
4	'testE'	E
5	'testF'	EF
10	'testG'	G
11	'testH'	G.H
13	'testI'	G.H.I
14	'testI'	G.H.J
47	'test1'	test1
\.


--
-- Data for Name: shrinkagevalue; Type: TABLE DATA; Schema: public; Owner: nmo
--

COPY public.shrinkagevalue (id, reported_val, reported_xy, reported_z, corrected_val, corrected_xy, corrected_z) FROM stdin;
4	0.75	\N	\N	\N	\N	\N
5	0.75	\N	\N	\N	\N	\N
6	0.75	\N	\N	\N	\N	\N
\.


--
-- Data for Name: species; Type: TABLE DATA; Schema: public; Owner: nmo
--

COPY public.species (id, name) FROM stdin;
11	rat
\.


--
-- Data for Name: staining; Type: TABLE DATA; Schema: public; Owner: nmo
--

COPY public.staining (id, name) FROM stdin;
10	Fiddlers Green
\.


--
-- Data for Name: strain; Type: TABLE DATA; Schema: public; Owner: nmo
--

COPY public.strain (id, name, species_id) FROM stdin;
10	Wistar	11
\.


--
-- Name: archive_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nmo
--

SELECT pg_catalog.setval('public.archive_id_seq', 15, true);


--
-- Name: celltype_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nmo
--

SELECT pg_catalog.setval('public.celltype_id_seq', 31, true);


--
-- Name: expcond_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nmo
--

SELECT pg_catalog.setval('public.expcond_id_seq', 31, true);


--
-- Name: measurements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nmo
--

SELECT pg_catalog.setval('public.measurements_id_seq', 6, true);


--
-- Name: neuron_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nmo
--

SELECT pg_catalog.setval('public.neuron_id_seq', 74, true);


--
-- Name: neuron_segment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nmo
--

SELECT pg_catalog.setval('public.neuron_segment_id_seq', 1, false);


--
-- Name: originalformat_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nmo
--

SELECT pg_catalog.setval('public.originalformat_id_seq', 10, true);


--
-- Name: publication_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nmo
--

SELECT pg_catalog.setval('public.publication_id_seq', 25, true);


--
-- Name: region_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nmo
--

SELECT pg_catalog.setval('public.region_id_seq', 47, true);


--
-- Name: shrinkagevalue_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nmo
--

SELECT pg_catalog.setval('public.shrinkagevalue_id_seq', 6, true);


--
-- Name: species_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nmo
--

SELECT pg_catalog.setval('public.species_id_seq', 11, true);


--
-- Name: staining_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nmo
--

SELECT pg_catalog.setval('public.staining_id_seq', 10, true);


--
-- Name: strain_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nmo
--

SELECT pg_catalog.setval('public.strain_id_seq', 10, true);


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
-- Name: neuron_structure neuronstructure_fk1; Type: FK CONSTRAINT; Schema: public; Owner: nmo
--

ALTER TABLE ONLY public.neuron_structure
    ADD CONSTRAINT neuronstructure_fk1 FOREIGN KEY (neuron_id) REFERENCES public.neuron(id);


--
-- Name: neuron_structure neuronstructure_fk2; Type: FK CONSTRAINT; Schema: public; Owner: nmo
--

ALTER TABLE ONLY public.neuron_structure
    ADD CONSTRAINT neuronstructure_fk2 FOREIGN KEY (measurements_id) REFERENCES public.measurements(id);


--
-- Name: publication publication_fk1; Type: FK CONSTRAINT; Schema: public; Owner: nmo
--

ALTER TABLE ONLY public.publication
    ADD CONSTRAINT publication_fk1 FOREIGN KEY (species_id) REFERENCES public.species(id);


--
-- Name: strain strain_fk1; Type: FK CONSTRAINT; Schema: public; Owner: nmo
--

ALTER TABLE ONLY public.strain
    ADD CONSTRAINT strain_fk1 FOREIGN KEY (species_id) REFERENCES public.species(id);


--
-- Name: DATABASE nmo; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON DATABASE nmo TO nmo;


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

-- Dumped from database version 12.2 (Ubuntu 12.2-2.pgdg19.10+1)
-- Dumped by pg_dump version 12.2 (Ubuntu 12.2-2.pgdg19.10+1)

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
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--

