--
-- PostgreSQL database dump
--

\restrict RtH119Y2zAf23XBYZ7WJU6WlDvzSPptrwhcvvhhsafgqe8EQCuObUFvViTCm9yv

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
-- Name: auth_token; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_token (
    id bigint NOT NULL,
    expiration_date timestamp(6) without time zone,
    token_value character varying(255),
    type character varying(255),
    user_id bigint,
    CONSTRAINT auth_token_type_check CHECK (((type)::text = ANY ((ARRAY['EMAIL_VERIFICATION'::character varying, 'FORGOT_PASSWORD'::character varying])::text[])))
);


--
-- Name: auth_token_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.auth_token_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: oauth2_authorization; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.oauth2_authorization (
    id character varying(100) NOT NULL,
    registered_client_id character varying(100) NOT NULL,
    principal_name character varying(200) NOT NULL,
    authorization_grant_type character varying(100) NOT NULL,
    authorized_scopes character varying(1000) DEFAULT NULL::character varying,
    attributes text,
    state character varying(500) DEFAULT NULL::character varying,
    authorization_code_value text,
    authorization_code_issued_at timestamp without time zone,
    authorization_code_expires_at timestamp without time zone,
    authorization_code_metadata text,
    access_token_value text,
    access_token_issued_at timestamp without time zone,
    access_token_expires_at timestamp without time zone,
    access_token_metadata text,
    access_token_type character varying(100) DEFAULT NULL::character varying,
    access_token_scopes character varying(1000) DEFAULT NULL::character varying,
    oidc_id_token_value text,
    oidc_id_token_issued_at timestamp without time zone,
    oidc_id_token_expires_at timestamp without time zone,
    oidc_id_token_metadata text,
    refresh_token_value text,
    refresh_token_issued_at timestamp without time zone,
    refresh_token_expires_at timestamp without time zone,
    refresh_token_metadata text,
    user_code_value text,
    user_code_issued_at timestamp without time zone,
    user_code_expires_at timestamp without time zone,
    user_code_metadata text,
    device_code_value text,
    device_code_issued_at timestamp without time zone,
    device_code_expires_at timestamp without time zone,
    device_code_metadata text
);


--
-- Name: oauth_user; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.oauth_user (
    email character varying(255),
    provider character varying(255),
    provider_user_id character varying(255),
    username character varying(255),
    id bigint NOT NULL,
    CONSTRAINT oauth_user_provider_check CHECK (((provider)::text = ANY ((ARRAY['GITHUB'::character varying, 'GOOGLE'::character varying])::text[])))
);


--
-- Name: system_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.system_users (
    email character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    username character varying(255) NOT NULL,
    id bigint NOT NULL
);


--
-- Name: user_permission; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_permission (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone,
    permission character varying(255),
    revoked_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone,
    created_by_id bigint,
    updated_by_id bigint,
    user_id bigint,
    CONSTRAINT user_permission_permission_check CHECK (((permission)::text = ANY ((ARRAY['PRODUCT_MANAGE'::character varying, 'ORDER_MANAGE'::character varying, 'CUSTOMER_MANAGE'::character varying, 'USER_MANAGE'::character varying, 'REPORT_VIEW'::character varying])::text[])))
);


--
-- Name: user_permission_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_permission_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    user_type character varying(31) NOT NULL,
    id bigint NOT NULL,
    avatar_url character varying(255),
    created_at timestamp(6) without time zone,
    display_name character varying(255),
    email_verified boolean NOT NULL,
    is_superuser boolean,
    updated_at timestamp(6) without time zone
);


--
-- Name: users_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auth_token auth_token_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_token
    ADD CONSTRAINT auth_token_pkey PRIMARY KEY (id);


--
-- Name: oauth2_authorization oauth2_authorization_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth2_authorization
    ADD CONSTRAINT oauth2_authorization_pkey PRIMARY KEY (id);


--
-- Name: oauth_user oauth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_user
    ADD CONSTRAINT oauth_user_pkey PRIMARY KEY (id);


--
-- Name: system_users system_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.system_users
    ADD CONSTRAINT system_users_pkey PRIMARY KEY (id);


--
-- Name: auth_token uk476rviwsy3mwitbsrcyidcf8g; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_token
    ADD CONSTRAINT uk476rviwsy3mwitbsrcyidcf8g UNIQUE (token_value, type);


--
-- Name: system_users ukdxy6tf9nvg7o3kd7yfd5j7qiu; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.system_users
    ADD CONSTRAINT ukdxy6tf9nvg7o3kd7yfd5j7qiu UNIQUE (email);


--
-- Name: user_permission uklf47ul5x1gr5ld9jwyi3mmnu9; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_permission
    ADD CONSTRAINT uklf47ul5x1gr5ld9jwyi3mmnu9 UNIQUE (user_id, permission);


--
-- Name: oauth_user uktpswm3oj76nmcifwlo6gnlea4; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_user
    ADD CONSTRAINT uktpswm3oj76nmcifwlo6gnlea4 UNIQUE (provider_user_id, provider);


--
-- Name: system_users uktr0kj1o2dqfwm13a6fvwrg867; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.system_users
    ADD CONSTRAINT uktr0kj1o2dqfwm13a6fvwrg867 UNIQUE (username);


--
-- Name: user_permission user_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_permission
    ADD CONSTRAINT user_permission_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx8gl4m9qpwrrp79it796vw27sv; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx8gl4m9qpwrrp79it796vw27sv ON public.auth_token USING btree (token_value);


--
-- Name: system_users fk1oie6ky7ub3207ruwjf08nimq; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.system_users
    ADD CONSTRAINT fk1oie6ky7ub3207ruwjf08nimq FOREIGN KEY (id) REFERENCES public.users(id);


--
-- Name: user_permission fk4loutdnemk5p25in3xbj02u2k; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_permission
    ADD CONSTRAINT fk4loutdnemk5p25in3xbj02u2k FOREIGN KEY (created_by_id) REFERENCES public.users(id);


--
-- Name: user_permission fkas7dk4c4ekc6xkmla8ajk7nhj; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_permission
    ADD CONSTRAINT fkas7dk4c4ekc6xkmla8ajk7nhj FOREIGN KEY (updated_by_id) REFERENCES public.users(id);


--
-- Name: oauth_user fkaue5xh0pegd259qj0mojwaqq1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_user
    ADD CONSTRAINT fkaue5xh0pegd259qj0mojwaqq1 FOREIGN KEY (id) REFERENCES public.users(id);


--
-- Name: user_permission fkn8ba4v3gvw1d82t3hofelr82t; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_permission
    ADD CONSTRAINT fkn8ba4v3gvw1d82t3hofelr82t FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: auth_token fkohgihldtcbpte27llwmlmf5jf; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_token
    ADD CONSTRAINT fkohgihldtcbpte27llwmlmf5jf FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

\unrestrict RtH119Y2zAf23XBYZ7WJU6WlDvzSPptrwhcvvhhsafgqe8EQCuObUFvViTCm9yv

