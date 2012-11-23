--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

--
-- Name: base_ingredients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: hotteenvindaloos
--

SELECT pg_catalog.setval('base_ingredients_id_seq', 10, true);


--
-- Name: curry_menus_id_seq; Type: SEQUENCE SET; Schema: public; Owner: hotteenvindaloos
--

SELECT pg_catalog.setval('curry_menus_id_seq', 95, true);


--
-- Name: curry_orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: hotteenvindaloos
--

SELECT pg_catalog.setval('curry_orders_id_seq', 234, true);


--
-- Name: curry_side_order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: hotteenvindaloos
--

SELECT pg_catalog.setval('curry_side_order_id_seq', 60, true);


--
-- Name: curry_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: hotteenvindaloos
--

SELECT pg_catalog.setval('curry_types_id_seq', 9, true);


--
-- Name: ingredient_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: hotteenvindaloos
--

SELECT pg_catalog.setval('ingredient_category_id_seq', 4, true);


--
-- Name: order_events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: hotteenvindaloos
--

SELECT pg_catalog.setval('order_events_id_seq', 40, true);


--
-- Name: payment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: hotteenvindaloos
--

SELECT pg_catalog.setval('payment_id_seq', 121, true);


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: hotteenvindaloos
--

SELECT pg_catalog.setval('roles_id_seq', 2, true);


--
-- Name: side_dishes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: hotteenvindaloos
--

SELECT pg_catalog.setval('side_dishes_id_seq', 4, true);


--
-- Name: spiceyness_id_seq; Type: SEQUENCE SET; Schema: public; Owner: hotteenvindaloos
--

SELECT pg_catalog.setval('spiceyness_id_seq', 3, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: hotteenvindaloos
--

SELECT pg_catalog.setval('users_id_seq', 11, true);


--
-- Data for Name: ingredient_category; Type: TABLE DATA; Schema: public; Owner: hotteenvindaloos
--

COPY ingredient_category (id, name) FROM stdin;
1	Lamb
2	Beef
3	Chicken
4	Vegetable
\.


--
-- Data for Name: base_ingredients; Type: TABLE DATA; Schema: public; Owner: hotteenvindaloos
--

COPY base_ingredients (id, name, active, category, link) FROM stdin;
4	Vegetable	t	4	vegetable
10	Dal	t	4	dal
1	Chicken	t	3	chicken
2	Beef	t	2	beef
3	Lamb	t	1	lamb
9	Aloo	t	4	aloo
\.


--
-- Data for Name: curry_types; Type: TABLE DATA; Schema: public; Owner: hotteenvindaloos
--

COPY curry_types (id, name, active, link) FROM stdin;
9	Rogan Josh	\N	rogan-josh
1	Curry	\N	curry
4	Makhani	\N	makhani
6	Korma	\N	korma
8	Lavabdar	\N	lavabdar
3	Tikka Masala	\N	tikka-masala
5	Butter	\N	butter
2	Madras	\N	madras
7	Vindaloo	\N	vindaloo
\.


--
-- Data for Name: curry_menus; Type: TABLE DATA; Schema: public; Owner: hotteenvindaloos
--

COPY curry_menus (id, base_ingredient, curry_type, price, active, reverse_name) FROM stdin;
85	3	9	11	t	f
82	2	1	11	t	f
78	1	1	11	t	f
80	1	7	11	t	f
84	1	5	11	t	f
87	1	8	11	t	f
86	10	4	10	t	f
81	9	4	10	t	f
89	3	6	11	t	f
90	3	7	11	t	f
91	4	8	10	t	f
92	1	6	11	t	f
93	4	6	10	t	f
79	2	6	11	t	f
83	3	1	11	t	f
\.


--
-- Data for Name: order_events; Type: TABLE DATA; Schema: public; Owner: hotteenvindaloos
--

COPY order_events (id, event_date, orders_open) FROM stdin;
40	2012-11-24	t
\.


--
-- Data for Name: spiceyness; Type: TABLE DATA; Schema: public; Owner: hotteenvindaloos
--

COPY spiceyness (id, name) FROM stdin;
1	mild
2	medium
3	hot
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: hotteenvindaloos
--

COPY users (id, first_name, surname, email, active, receive_email, password, balance, create_date, nickname) FROM stdin;
7	Wratchet	Mobile	test2@test.com	t	t	$2a$04$ThDwaSjPZ0S0LhbjblX1M.qpgLTM38ZebrcHBrfAxLT6bAq76IqtW	0	2012-11-06	\N
9	Iron	Hide	test5@test.com	t	t	$2a$04$K0vkRyytURfTLR/mRl/vYeMKOPraaBfH1O9u4S6INycNWP8nSs5Nu	0	2012-11-06	\N
6	Bob	Megatrono	test4@test.com	t	t	$2a$04$R1fhKxS3RSjlKxXPbhK0auqNnbao3WTdQ/tIo.k..fe5NbnWBLeCK	0	2012-11-06	\N
1	Admin	McAdminson	admin@user.com	t	t	$2a$04$Yha0T1PiLRHpLhSvb1W3QOIaA5z8A6QHq7Dr8o5ff6NAhIAoxTdfK	11	2012-10-21	\N
2	Jim	Beam	test6@test.com	t	t	$2a$04$XUrtOxjCTibtKhfQSyvoPuLg69aU1zvlHhpdfiKMs42vo6ySUcMwu	0	2012-10-22	\N
11	Testy	McTesterson	test7@test.com	t	t	$2a$04$WUazQkevaVnXKhHxOVPiMOAr/n3Mq5h2067xtKEsb1S6YUxJLgvRq	0	2012-11-15	\N
8	Ima	Adminow	test1@test.com	t	f	$2a$04$PD.0QCHmUCuwLBbpQzTOL.hM2S1rG5dhwYMSF8pbRlS5pDTPE2jX2	0	2012-11-06	\N
4	Louis	Charles	test3@test.com	t	f	$2a$04$L1X3JxffZy3DLRayQTbLbejhUk0ukHmTxBhg5raxBaNX.tD9Y.jey	0	2012-11-05	\N
5	Trav	Holton	user@info.com	t	t	$2a$04$XyasWUbELEjLMBevPhLPSOUShEp9gxsyMlQSRL/cxVHBAickwhtRW	0	2012-11-05	\N
\.


--
-- Data for Name: curry_orders; Type: TABLE DATA; Schema: public; Owner: hotteenvindaloos
--

COPY curry_orders (id, dish, order_event, curry_user, spiceyness) FROM stdin;
234	89	40	1	2
\.


--
-- Data for Name: side_dishes; Type: TABLE DATA; Schema: public; Owner: hotteenvindaloos
--

COPY side_dishes (id, name, active, link, price) FROM stdin;
3	Chicken fingers	f	chicken-fingers	\N
2	Onion Baji	f	onion-baji	1
1	Garlic Naan	t	garlic-naan	1
4	Pampadoms	t	pampadoms	2
\.


--
-- Data for Name: curry_side_order; Type: TABLE DATA; Schema: public; Owner: hotteenvindaloos
--

COPY curry_side_order (id, side_dish, order_event, curry_user) FROM stdin;
\.


--
-- Data for Name: dish_spiceyness; Type: TABLE DATA; Schema: public; Owner: hotteenvindaloos
--

COPY dish_spiceyness (dish, spiceyness) FROM stdin;
85	3
85	2
85	1
82	3
82	2
82	1
78	3
78	2
78	1
80	3
80	2
84	3
84	2
84	1
87	3
87	2
87	1
86	3
86	2
86	1
81	3
81	2
81	1
89	3
89	2
89	1
90	3
90	2
90	1
91	3
91	2
91	1
92	3
92	2
92	1
93	3
93	2
93	1
79	3
79	2
79	1
83	3
83	2
83	1
\.


--
-- Data for Name: payment; Type: TABLE DATA; Schema: public; Owner: hotteenvindaloos
--

COPY payment (id, curry_user, payment, payment_date) FROM stdin;
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: hotteenvindaloos
--

COPY roles (id, name) FROM stdin;
1	user
2	admin
\.


--
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: hotteenvindaloos
--

COPY user_roles (curry_user, user_role) FROM stdin;
5	1
5	2
7	1
8	1
4	1
1	1
1	2
6	1
9	1
11	1
2	2
2	1
\.


--
-- PostgreSQL database dump complete
--

