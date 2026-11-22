--
-- PostgreSQL database dump
--
\connect chat_db
SET ROLE chat_user;
\restrict QAyhabaVBPAcGtb4eH58dlg29WwYZxIaYZR3vmSkudHYebQ9GozvpdXJEPw7DXH

-- Dumped from database version 17.12
-- Dumped by pg_dump version 17.12

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
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
-- Name: chat_account_user; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chat_account_user (
    type character varying(255),
    user_id bigint,
    id bigint NOT NULL,
    CONSTRAINT chat_account_user_type_check CHECK (((type)::text = ANY ((ARRAY['CUSTOMER'::character varying, 'EMPLOYEE'::character varying])::text[])))
);


--
-- Name: chat_guest; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chat_guest (
    email character varying(255),
    gender character varying(255),
    message character varying(255),
    phone character varying(255),
    token character varying(255),
    id bigint NOT NULL,
    CONSTRAINT chat_guest_gender_check CHECK (((gender)::text = ANY ((ARRAY['MALE'::character varying, 'FEMALE'::character varying])::text[])))
);


--
-- Name: chat_message; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chat_message (
    dtype character varying(31) NOT NULL,
    id bigint NOT NULL,
    created_at timestamp(6) without time zone,
    event_type character varying(255),
    content character varying(255),
    room_id bigint,
    target_id bigint,
    sender_id bigint,
    CONSTRAINT chat_message_event_type_check CHECK (((event_type)::text = ANY ((ARRAY['JOIN'::character varying, 'LEAVE'::character varying, 'END'::character varying, 'START'::character varying])::text[])))
);


--
-- Name: chat_message_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chat_message_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chat_participant; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chat_participant (
    id bigint NOT NULL,
    room_id bigint,
    user_id bigint
);


--
-- Name: chat_participant_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chat_participant_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chat_room; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chat_room (
    id bigint NOT NULL,
    active boolean NOT NULL,
    closed_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone,
    close_by_id bigint,
    created_by_id bigint,
    last_message_id bigint
);


--
-- Name: chat_room_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chat_room_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chat_user; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chat_user (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone,
    display_name character varying(255)
);


--
-- Name: chat_user_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chat_user_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chat_account_user chat_account_user_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_account_user
    ADD CONSTRAINT chat_account_user_pkey PRIMARY KEY (id);


--
-- Name: chat_guest chat_guest_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_guest
    ADD CONSTRAINT chat_guest_pkey PRIMARY KEY (id);


--
-- Name: chat_message chat_message_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_message
    ADD CONSTRAINT chat_message_pkey PRIMARY KEY (id);


--
-- Name: chat_participant chat_participant_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_participant
    ADD CONSTRAINT chat_participant_pkey PRIMARY KEY (id);


--
-- Name: chat_room chat_room_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_room
    ADD CONSTRAINT chat_room_pkey PRIMARY KEY (id);


--
-- Name: chat_user chat_user_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_user
    ADD CONSTRAINT chat_user_pkey PRIMARY KEY (id);


--
-- Name: chat_participant uk4d2lr4qe6ambtkc9p90cey7c6; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_participant
    ADD CONSTRAINT uk4d2lr4qe6ambtkc9p90cey7c6 UNIQUE (room_id, user_id);


--
-- Name: chat_room uk9svb24t1ifuuqvdllw219sbw3; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_room
    ADD CONSTRAINT uk9svb24t1ifuuqvdllw219sbw3 UNIQUE (last_message_id);


--
-- Name: chat_account_user ukcd7wmvlp86ytj7tc2ssfqwec7; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_account_user
    ADD CONSTRAINT ukcd7wmvlp86ytj7tc2ssfqwec7 UNIQUE (user_id, type);


--
-- Name: chat_message fk4m8fumcqyek3co8xvj7c9sxh3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_message
    ADD CONSTRAINT fk4m8fumcqyek3co8xvj7c9sxh3 FOREIGN KEY (target_id) REFERENCES public.chat_user(id);


--
-- Name: chat_room fk57nwoc5br9xn9qgwg0aytqpru; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_room
    ADD CONSTRAINT fk57nwoc5br9xn9qgwg0aytqpru FOREIGN KEY (last_message_id) REFERENCES public.chat_message(id);


--
-- Name: chat_account_user fk771ttf2aj43udrxe70n5k75yd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_account_user
    ADD CONSTRAINT fk771ttf2aj43udrxe70n5k75yd FOREIGN KEY (id) REFERENCES public.chat_user(id);


--
-- Name: chat_participant fk77myxe82l15mjf2eto7mabm8b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_participant
    ADD CONSTRAINT fk77myxe82l15mjf2eto7mabm8b FOREIGN KEY (user_id) REFERENCES public.chat_user(id);


--
-- Name: chat_room fk7ofot93b2duux5kmaj7i4ycod; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_room
    ADD CONSTRAINT fk7ofot93b2duux5kmaj7i4ycod FOREIGN KEY (close_by_id) REFERENCES public.chat_account_user(id);


--
-- Name: chat_message fkfvbc4wvhk51y0qtnjrbminxfu; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_message
    ADD CONSTRAINT fkfvbc4wvhk51y0qtnjrbminxfu FOREIGN KEY (room_id) REFERENCES public.chat_room(id);


--
-- Name: chat_room fkh9h1l7xcs7fi6ohmqox5ntjdm; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_room
    ADD CONSTRAINT fkh9h1l7xcs7fi6ohmqox5ntjdm FOREIGN KEY (created_by_id) REFERENCES public.chat_user(id);


--
-- Name: chat_message fkj4cy4e59glbqlca7cx7icp4lr; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_message
    ADD CONSTRAINT fkj4cy4e59glbqlca7cx7icp4lr FOREIGN KEY (sender_id) REFERENCES public.chat_user(id);


--
-- Name: chat_participant fkspomx9tqgkd3ykuqkh7g14b90; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_participant
    ADD CONSTRAINT fkspomx9tqgkd3ykuqkh7g14b90 FOREIGN KEY (room_id) REFERENCES public.chat_room(id);


--
-- Name: chat_guest fktlq5j7lftl3q8lshn7ea3ryxf; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_guest
    ADD CONSTRAINT fktlq5j7lftl3q8lshn7ea3ryxf FOREIGN KEY (id) REFERENCES public.chat_user(id);


--
-- PostgreSQL database dump complete
--

\unrestrict QAyhabaVBPAcGtb4eH58dlg29WwYZxIaYZR3vmSkudHYebQ9GozvpdXJEPw7DXH
RESET ROLE;
