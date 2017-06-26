
CREATE TABLE public.db_entidade
(
  tipo character varying(31) NOT NULL,
  id bigint NOT NULL,
  atualizado_em timestamp without time zone,
  cnpj character varying(14),
  criado_em timestamp without time zone,
  numero character varying(255),
  versao bigint,
  cpf character varying(11),
  CONSTRAINT db_entidade_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);

CREATE SEQUENCE public.sequencia_relatorio
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;

CREATE SEQUENCE public.sequencia_parametros
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;

CREATE TABLE public.db_parametros_relatorio
(
  id bigint NOT NULL DEFAULT nextval('sequencia_parametros'::regclass),
  cnh character varying(255),
  cnpj character varying(255),
  cpf character varying(255),
  datadenascimento character varying(255),
  digitorg character varying(255),
  estadocivil character varying(255),
  estadoexpedicaorg character varying(255),
  nome character varying(255),
  rg character varying(255),
  sexo character varying(255),
  CONSTRAINT db_parametros_relatorio_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);

CREATE TABLE public.db_relatorio
(
  id bigint NOT NULL DEFAULT nextval('sequencia_relatorio'::regclass),
  atualizado_em timestamp without time zone,
  criado_em timestamp without time zone,
  identificao_relatorio character varying(60),
  status character varying(255),
  id_entidade bigint,
  id_usuario bigint,
  id_parametros_relatorio bigint,
  CONSTRAINT db_relatorio_pkey PRIMARY KEY (id),
  CONSTRAINT fk_relatorio_entidade FOREIGN KEY (id_entidade)
      REFERENCES public.db_entidade (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_relatorio_parametros FOREIGN KEY (id_parametros_relatorio)
      REFERENCES public.db_parametros_relatorio (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);

CREATE SEQUENCE public.sequencia_dados_receita
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
  
CREATE TABLE public.db_dados_receita
(
  id bigint NOT NULL DEFAULT nextval('sequencia_dados_receita'::regclass),
  ano_obito character varying(10),
  anterior_1990 character varying(25),
  cpf character varying(20),
  data_nascimento character varying(20),
  digito_verificador character varying(5),
  nome character varying(255),
  id_entidade bigint,
  CONSTRAINT db_dados_receita_pkey PRIMARY KEY (id),
  CONSTRAINT fk_dados_entidade FOREIGN KEY (id_entidade)
      REFERENCES public.db_entidade (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);

CREATE INDEX idx_entidade_cpf on db_entidade (cpf);

CREATE OR REPLACE FUNCTION function_busca_pessoa_por_cpf(
    IN parametro_usuario bigint,
    IN numero_cpf text)
  RETURNS TABLE(cpf character varying, nome_completo text, ultima_atualizacao timestamp without time zone) AS
$BODY$
BEGIN
   RETURN QUERY

	SELECT
		DISTINCT ON (cpf)
		COALESCE(
		  cast(regexp_replace(e.cpf, '[^0-9]*', '', 'g') as varchar),
		  cast(regexp_replace(pr.cpf, '[^0-9]*', '', 'g') as varchar),
		  'Nao encontrado'
		) AS cpf,
		UPPER(
			COALESCE(
			  dr.nome,
			  pr.nome,
			  'Nao encontrado'
			)
		) AS nome_completo,
		COALESCE (r.atualizado_em, r.criado_em) AS ultima_atualizacao

	FROM db_entidade e

	INNER JOIN db_relatorio r
	ON r.id_entidade = e.id

	LEFT OUTER JOIN db_parametros_relatorio pr
	ON r.id_parametros_relatorio = pr.id

	LEFT OUTER JOIN db_dados_receita dr
	ON e.id = dr.id_entidade
	
	WHERE
		AND (regexp_replace(e.cpf, '[^0-9]*', '', 'g') = numero_cpf 
		OR regexp_replace(pr.cpf, '[^0-9]*', '', 'g') = numero_cpf )
	AND r.id_usuario = parametro_usuario;

END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;


