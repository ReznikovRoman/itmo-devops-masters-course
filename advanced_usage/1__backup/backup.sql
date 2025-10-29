--
-- PostgreSQL database dump
--

\restrict NdTyidWJL6zHrG6Pyg8pYFTnaRvt28NnLl3HcewFfdhbubt0syhKkG0M2OmeOet

-- Dumped from database version 15.14 (Debian 15.14-1.pgdg13+1)
-- Dumped by pg_dump version 15.14 (Debian 15.14-1.pgdg13+1)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: products; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.products (
    id integer NOT NULL,
    name character varying(50),
    price numeric
);


ALTER TABLE public.products OWNER TO "user";

--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: user
--

CREATE SEQUENCE public.products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.products_id_seq OWNER TO "user";

--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;


--
-- Name: products id; Type: DEFAULT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.products (id, name, price) FROM stdin;
1	Product A	10.99
2	Product B	20.50
3	Product C	15.00
\.


--
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user
--

SELECT pg_catalog.setval('public.products_id_seq', 3, true);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

\unrestrict NdTyidWJL6zHrG6Pyg8pYFTnaRvt28NnLl3HcewFfdhbubt0syhKkG0M2OmeOet

