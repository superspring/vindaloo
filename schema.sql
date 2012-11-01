--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: postgres
--

CREATE OR REPLACE PROCEDURAL LANGUAGE plpgsql;


ALTER PROCEDURAL LANGUAGE plpgsql OWNER TO postgres;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: base_ingredients; Type: TABLE; Schema: public; Owner: hotteenvindaloos; Tablespace: 
--

CREATE TABLE base_ingredients (
    id integer NOT NULL,
    name character varying,
    active boolean DEFAULT true,
    category integer
);


ALTER TABLE public.base_ingredients OWNER TO hotteenvindaloos;

--
-- Name: base_ingredients_id_seq; Type: SEQUENCE; Schema: public; Owner: hotteenvindaloos
--

CREATE SEQUENCE base_ingredients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.base_ingredients_id_seq OWNER TO hotteenvindaloos;

--
-- Name: base_ingredients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: hotteenvindaloos
--

ALTER SEQUENCE base_ingredients_id_seq OWNED BY base_ingredients.id;


--
-- Name: curry_menus; Type: TABLE; Schema: public; Owner: hotteenvindaloos; Tablespace: 
--

CREATE TABLE curry_menus (
    id integer NOT NULL,
    base_ingredient integer NOT NULL,
    curry_type integer NOT NULL,
    price double precision,
    active boolean,
    reverse_name boolean DEFAULT false
);


ALTER TABLE public.curry_menus OWNER TO hotteenvindaloos;

--
-- Name: curry_menus_id_seq; Type: SEQUENCE; Schema: public; Owner: hotteenvindaloos
--

CREATE SEQUENCE curry_menus_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.curry_menus_id_seq OWNER TO hotteenvindaloos;

--
-- Name: curry_menus_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: hotteenvindaloos
--

ALTER SEQUENCE curry_menus_id_seq OWNED BY curry_menus.id;


--
-- Name: curry_orders; Type: TABLE; Schema: public; Owner: hotteenvindaloos; Tablespace: 
--

CREATE TABLE curry_orders (
    id integer NOT NULL,
    dish integer NOT NULL,
    order_event integer NOT NULL,
    curry_user integer NOT NULL
);


ALTER TABLE public.curry_orders OWNER TO hotteenvindaloos;

--
-- Name: curry_orders_id_seq; Type: SEQUENCE; Schema: public; Owner: hotteenvindaloos
--

CREATE SEQUENCE curry_orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.curry_orders_id_seq OWNER TO hotteenvindaloos;

--
-- Name: curry_orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: hotteenvindaloos
--

ALTER SEQUENCE curry_orders_id_seq OWNED BY curry_orders.id;


--
-- Name: curry_side_order; Type: TABLE; Schema: public; Owner: hotteenvindaloos; Tablespace: 
--

CREATE TABLE curry_side_order (
    id integer NOT NULL,
    side_dish integer NOT NULL,
    order_event integer NOT NULL,
    curry_user integer NOT NULL
);


ALTER TABLE public.curry_side_order OWNER TO hotteenvindaloos;

--
-- Name: curry_side_order_id_seq; Type: SEQUENCE; Schema: public; Owner: hotteenvindaloos
--

CREATE SEQUENCE curry_side_order_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.curry_side_order_id_seq OWNER TO hotteenvindaloos;

--
-- Name: curry_side_order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: hotteenvindaloos
--

ALTER SEQUENCE curry_side_order_id_seq OWNED BY curry_side_order.id;


--
-- Name: curry_types; Type: TABLE; Schema: public; Owner: hotteenvindaloos; Tablespace: 
--

CREATE TABLE curry_types (
    id integer NOT NULL,
    name character varying,
    active boolean
);


ALTER TABLE public.curry_types OWNER TO hotteenvindaloos;

--
-- Name: curry_types_id_seq; Type: SEQUENCE; Schema: public; Owner: hotteenvindaloos
--

CREATE SEQUENCE curry_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.curry_types_id_seq OWNER TO hotteenvindaloos;

--
-- Name: curry_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: hotteenvindaloos
--

ALTER SEQUENCE curry_types_id_seq OWNED BY curry_types.id;


--
-- Name: dish_spiceyness; Type: TABLE; Schema: public; Owner: hotteenvindaloos; Tablespace: 
--

CREATE TABLE dish_spiceyness (
    dish integer NOT NULL,
    spiceyness integer NOT NULL
);


ALTER TABLE public.dish_spiceyness OWNER TO hotteenvindaloos;

--
-- Name: ingredient_category; Type: TABLE; Schema: public; Owner: hotteenvindaloos; Tablespace: 
--

CREATE TABLE ingredient_category (
    id integer NOT NULL,
    name character varying
);


ALTER TABLE public.ingredient_category OWNER TO hotteenvindaloos;

--
-- Name: ingredient_category_id_seq; Type: SEQUENCE; Schema: public; Owner: hotteenvindaloos
--

CREATE SEQUENCE ingredient_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ingredient_category_id_seq OWNER TO hotteenvindaloos;

--
-- Name: ingredient_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: hotteenvindaloos
--

ALTER SEQUENCE ingredient_category_id_seq OWNED BY ingredient_category.id;


--
-- Name: order_events; Type: TABLE; Schema: public; Owner: hotteenvindaloos; Tablespace: 
--

CREATE TABLE order_events (
    id integer NOT NULL,
    event_date date DEFAULT now(),
    orders_open boolean
);


ALTER TABLE public.order_events OWNER TO hotteenvindaloos;

--
-- Name: order_events_id_seq; Type: SEQUENCE; Schema: public; Owner: hotteenvindaloos
--

CREATE SEQUENCE order_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.order_events_id_seq OWNER TO hotteenvindaloos;

--
-- Name: order_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: hotteenvindaloos
--

ALTER SEQUENCE order_events_id_seq OWNED BY order_events.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: hotteenvindaloos; Tablespace: 
--

CREATE TABLE roles (
    id integer NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE public.roles OWNER TO hotteenvindaloos;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: hotteenvindaloos
--

CREATE SEQUENCE roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.roles_id_seq OWNER TO hotteenvindaloos;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: hotteenvindaloos
--

ALTER SEQUENCE roles_id_seq OWNED BY roles.id;


--
-- Name: side_dishes; Type: TABLE; Schema: public; Owner: hotteenvindaloos; Tablespace: 
--

CREATE TABLE side_dishes (
    id integer NOT NULL,
    name character varying NOT NULL,
    active boolean DEFAULT true
);


ALTER TABLE public.side_dishes OWNER TO hotteenvindaloos;

--
-- Name: side_dishes_id_seq; Type: SEQUENCE; Schema: public; Owner: hotteenvindaloos
--

CREATE SEQUENCE side_dishes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.side_dishes_id_seq OWNER TO hotteenvindaloos;

--
-- Name: side_dishes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: hotteenvindaloos
--

ALTER SEQUENCE side_dishes_id_seq OWNED BY side_dishes.id;


--
-- Name: spiceyness; Type: TABLE; Schema: public; Owner: hotteenvindaloos; Tablespace: 
--

CREATE TABLE spiceyness (
    id integer NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE public.spiceyness OWNER TO hotteenvindaloos;

--
-- Name: spiceyness_id_seq; Type: SEQUENCE; Schema: public; Owner: hotteenvindaloos
--

CREATE SEQUENCE spiceyness_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.spiceyness_id_seq OWNER TO hotteenvindaloos;

--
-- Name: spiceyness_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: hotteenvindaloos
--

ALTER SEQUENCE spiceyness_id_seq OWNED BY spiceyness.id;


--
-- Name: user_roles; Type: TABLE; Schema: public; Owner: hotteenvindaloos; Tablespace: 
--

CREATE TABLE user_roles (
    curry_user integer NOT NULL,
    user_role integer NOT NULL
);


ALTER TABLE public.user_roles OWNER TO hotteenvindaloos;

--
-- Name: users; Type: TABLE; Schema: public; Owner: hotteenvindaloos; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    first_name character varying NOT NULL,
    surname character varying NOT NULL,
    email character varying NOT NULL,
    active boolean DEFAULT true,
    receive_email boolean DEFAULT false,
    password character varying NOT NULL,
    balance double precision,
    create_date date DEFAULT now() NOT NULL
);


ALTER TABLE public.users OWNER TO hotteenvindaloos;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: hotteenvindaloos
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO hotteenvindaloos;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: hotteenvindaloos
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: hotteenvindaloos
--

ALTER TABLE ONLY base_ingredients ALTER COLUMN id SET DEFAULT nextval('base_ingredients_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: hotteenvindaloos
--

ALTER TABLE ONLY curry_menus ALTER COLUMN id SET DEFAULT nextval('curry_menus_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: hotteenvindaloos
--

ALTER TABLE ONLY curry_orders ALTER COLUMN id SET DEFAULT nextval('curry_orders_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: hotteenvindaloos
--

ALTER TABLE ONLY curry_side_order ALTER COLUMN id SET DEFAULT nextval('curry_side_order_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: hotteenvindaloos
--

ALTER TABLE ONLY curry_types ALTER COLUMN id SET DEFAULT nextval('curry_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: hotteenvindaloos
--

ALTER TABLE ONLY ingredient_category ALTER COLUMN id SET DEFAULT nextval('ingredient_category_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: hotteenvindaloos
--

ALTER TABLE ONLY order_events ALTER COLUMN id SET DEFAULT nextval('order_events_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: hotteenvindaloos
--

ALTER TABLE ONLY roles ALTER COLUMN id SET DEFAULT nextval('roles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: hotteenvindaloos
--

ALTER TABLE ONLY side_dishes ALTER COLUMN id SET DEFAULT nextval('side_dishes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: hotteenvindaloos
--

ALTER TABLE ONLY spiceyness ALTER COLUMN id SET DEFAULT nextval('spiceyness_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: hotteenvindaloos
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: base_ingredients_pkey; Type: CONSTRAINT; Schema: public; Owner: hotteenvindaloos; Tablespace: 
--

ALTER TABLE ONLY base_ingredients
    ADD CONSTRAINT base_ingredients_pkey PRIMARY KEY (id);


--
-- Name: curry_menus_pkey; Type: CONSTRAINT; Schema: public; Owner: hotteenvindaloos; Tablespace: 
--

ALTER TABLE ONLY curry_menus
    ADD CONSTRAINT curry_menus_pkey PRIMARY KEY (id);


--
-- Name: curry_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: hotteenvindaloos; Tablespace: 
--

ALTER TABLE ONLY curry_orders
    ADD CONSTRAINT curry_orders_pkey PRIMARY KEY (id);


--
-- Name: curry_side_order_pkey; Type: CONSTRAINT; Schema: public; Owner: hotteenvindaloos; Tablespace: 
--

ALTER TABLE ONLY curry_side_order
    ADD CONSTRAINT curry_side_order_pkey PRIMARY KEY (id);


--
-- Name: curry_types_pkey; Type: CONSTRAINT; Schema: public; Owner: hotteenvindaloos; Tablespace: 
--

ALTER TABLE ONLY curry_types
    ADD CONSTRAINT curry_types_pkey PRIMARY KEY (id);


--
-- Name: ingredient_category_name_key; Type: CONSTRAINT; Schema: public; Owner: hotteenvindaloos; Tablespace: 
--

ALTER TABLE ONLY ingredient_category
    ADD CONSTRAINT ingredient_category_name_key UNIQUE (name);


--
-- Name: ingredient_category_pkey; Type: CONSTRAINT; Schema: public; Owner: hotteenvindaloos; Tablespace: 
--

ALTER TABLE ONLY ingredient_category
    ADD CONSTRAINT ingredient_category_pkey PRIMARY KEY (id);


--
-- Name: order_events_pkey; Type: CONSTRAINT; Schema: public; Owner: hotteenvindaloos; Tablespace: 
--

ALTER TABLE ONLY order_events
    ADD CONSTRAINT order_events_pkey PRIMARY KEY (id);


--
-- Name: order_unique; Type: CONSTRAINT; Schema: public; Owner: hotteenvindaloos; Tablespace: 
--

ALTER TABLE ONLY order_events
    ADD CONSTRAINT order_unique UNIQUE (event_date, orders_open);


--
-- Name: roles_name_key; Type: CONSTRAINT; Schema: public; Owner: hotteenvindaloos; Tablespace: 
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_name_key UNIQUE (name);


--
-- Name: roles_pkey; Type: CONSTRAINT; Schema: public; Owner: hotteenvindaloos; Tablespace: 
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: side_dishes_name_key; Type: CONSTRAINT; Schema: public; Owner: hotteenvindaloos; Tablespace: 
--

ALTER TABLE ONLY side_dishes
    ADD CONSTRAINT side_dishes_name_key UNIQUE (name);


--
-- Name: side_dishes_pkey; Type: CONSTRAINT; Schema: public; Owner: hotteenvindaloos; Tablespace: 
--

ALTER TABLE ONLY side_dishes
    ADD CONSTRAINT side_dishes_pkey PRIMARY KEY (id);


--
-- Name: spiceyness_pkey; Type: CONSTRAINT; Schema: public; Owner: hotteenvindaloos; Tablespace: 
--

ALTER TABLE ONLY spiceyness
    ADD CONSTRAINT spiceyness_pkey PRIMARY KEY (id);


--
-- Name: user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: hotteenvindaloos; Tablespace: 
--

ALTER TABLE ONLY user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (curry_user, user_role);


--
-- Name: users_email_key; Type: CONSTRAINT; Schema: public; Owner: hotteenvindaloos; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: hotteenvindaloos; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: base_ingredients_category_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hotteenvindaloos
--

ALTER TABLE ONLY base_ingredients
    ADD CONSTRAINT base_ingredients_category_fkey FOREIGN KEY (category) REFERENCES ingredient_category(id);


--
-- Name: curry_menus_base_ingredient_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hotteenvindaloos
--

ALTER TABLE ONLY curry_menus
    ADD CONSTRAINT curry_menus_base_ingredient_fkey FOREIGN KEY (base_ingredient) REFERENCES base_ingredients(id) ON DELETE CASCADE;


--
-- Name: curry_menus_curry_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hotteenvindaloos
--

ALTER TABLE ONLY curry_menus
    ADD CONSTRAINT curry_menus_curry_type_fkey FOREIGN KEY (curry_type) REFERENCES curry_types(id) ON DELETE CASCADE;


--
-- Name: curry_orders_curry_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hotteenvindaloos
--

ALTER TABLE ONLY curry_orders
    ADD CONSTRAINT curry_orders_curry_user_fkey FOREIGN KEY (curry_user) REFERENCES users(id);


--
-- Name: curry_orders_dish_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hotteenvindaloos
--

ALTER TABLE ONLY curry_orders
    ADD CONSTRAINT curry_orders_dish_fkey FOREIGN KEY (dish) REFERENCES curry_menus(id);


--
-- Name: curry_orders_order_event_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hotteenvindaloos
--

ALTER TABLE ONLY curry_orders
    ADD CONSTRAINT curry_orders_order_event_fkey FOREIGN KEY (order_event) REFERENCES order_events(id);


--
-- Name: curry_side_order_curry_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hotteenvindaloos
--

ALTER TABLE ONLY curry_side_order
    ADD CONSTRAINT curry_side_order_curry_user_fkey FOREIGN KEY (curry_user) REFERENCES users(id);


--
-- Name: curry_side_order_order_event_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hotteenvindaloos
--

ALTER TABLE ONLY curry_side_order
    ADD CONSTRAINT curry_side_order_order_event_fkey FOREIGN KEY (order_event) REFERENCES order_events(id);


--
-- Name: curry_side_order_side_dish_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hotteenvindaloos
--

ALTER TABLE ONLY curry_side_order
    ADD CONSTRAINT curry_side_order_side_dish_fkey FOREIGN KEY (side_dish) REFERENCES side_dishes(id);


--
-- Name: dish_spiceyness_dish_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hotteenvindaloos
--

ALTER TABLE ONLY dish_spiceyness
    ADD CONSTRAINT dish_spiceyness_dish_fkey FOREIGN KEY (dish) REFERENCES curry_menus(id);


--
-- Name: dish_spiceyness_spiceyness_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hotteenvindaloos
--

ALTER TABLE ONLY dish_spiceyness
    ADD CONSTRAINT dish_spiceyness_spiceyness_fkey FOREIGN KEY (spiceyness) REFERENCES spiceyness(id);


--
-- Name: user_roles_curry_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hotteenvindaloos
--

ALTER TABLE ONLY user_roles
    ADD CONSTRAINT user_roles_curry_user_fkey FOREIGN KEY (curry_user) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: user_roles_user_role_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hotteenvindaloos
--

ALTER TABLE ONLY user_roles
    ADD CONSTRAINT user_roles_user_role_fkey FOREIGN KEY (user_role) REFERENCES roles(id) ON DELETE CASCADE;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

