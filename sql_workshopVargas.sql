-- CREACION DE BASE DE DATOS Y TABLAS
-- TU FONDO

CREATE DATABASE workshopVargas;

USE workshopVargas;

CREATE TABLE IF NOT EXISTS workshopVargas.dominios (
	dominio VARCHAR(30),
    abreviatura VARCHAR(6),
    significado VARCHAR(60)     
);
CREATE TABLE IF NOT EXISTS workshopVargas.usuarios (
	cod_usuario VARCHAR(6) NOT NULL,
    n_usuario VARCHAR(45) NOT NULL,
    o_clave VARCHAR(6) NOT NULL,     
    i_activo VARCHAR(1) NOT NULL,     
    id INT NOT NULL,     
    PRIMARY KEY (cod_usuario)
);
CREATE TABLE IF NOT EXISTS workshopVargas.contabilidad (
	k_codcon VARCHAR(16) NOT NULL,
    n_codcon VARCHAR(45) NOT NULL,
    i_natura VARCHAR(1) NOT NULL,
    cod_usuario VARCHAR(6) NOT NULL,
    PRIMARY KEY (k_codcon),
    CONSTRAINT fk_usuarios FOREIGN KEY (cod_usuario) REFERENCES usuarios (cod_usuario) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS workshopVargas.tipo_documentos (
	doc_ref VARCHAR(3) NOT NULL,
    n_doc_ref VARCHAR(60) NOT NULL,
    tipo_documento VARCHAR(3) NOT NULL,
    i_efecto VARCHAR(1) NOT NULL,
    PRIMARY KEY (doc_ref)
);
CREATE TABLE IF NOT EXISTS workshopVargas.modalidades_cred (
	cod_modalidad VARCHAR(3) NOT NULL,
    n_modalidad VARCHAR(60) NOT NULL,
    i_activo VARCHAR(1) NOT NULL,
    PRIMARY KEY (cod_modalidad)
);
CREATE TABLE IF NOT EXISTS workshopVargas.tipoaso (
	tipo_aso VARCHAR(3) NOT NULL,
    n_tipoaso VARCHAR(50) NOT NULL,
    i_activo VARCHAR(1) NOT NULL,
    PRIMARY KEY (tipo_aso)
);
CREATE TABLE IF NOT EXISTS workshopVargas.pais (
	cod_pais VARCHAR(3) NOT NULL,
    n_pais VARCHAR(100) NOT NULL,
    PRIMARY KEY (cod_pais)
);
CREATE TABLE IF NOT EXISTS workshopVargas.ciudad (
	cod_ciudad VARCHAR(3) NOT NULL,
    n_ciudad VARCHAR(50) NOT NULL,
    cod_pais VARCHAR(3) NOT NULL,
    PRIMARY KEY (cod_ciudad),
    CONSTRAINT fk_ciudad_pais FOREIGN KEY (cod_pais) REFERENCES pais (cod_pais) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS workshopVargas.cliente (
	id INT AUTO_INCREMENT,
    numdoc VARCHAR(50) NOT NULL,
    i_tipdoc VARCHAR(1) NOT NULL,
    n_apell1 VARCHAR(50) NOT NULL,
    n_apell2 VARCHAR(50) NOT NULL,
    n_nombr1 VARCHAR(50) NOT NULL,
    n_nombr2 VARCHAR(50) NOT NULL,
    n_razons VARCHAR(50),
    i_sexo VARCHAR(1) NOT NULL,
    f_nacimi DATE,
    cod_pais_nacimi VARCHAR(3) NOT NULL,
    cod_ciudad_nacimi VARCHAR(8) NOT NULL,
    cod_usuario VARCHAR(6) NOT NULL,
    PRIMARY KEY (id),
    INDEX idx_documento (numdoc),
    CONSTRAINT fk_cliente_pais FOREIGN KEY (cod_pais_nacimi) REFERENCES pais (cod_pais) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_cliente_ciudad FOREIGN KEY (cod_ciudad_nacimi) REFERENCES ciudad (cod_ciudad) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_cliente_usuario FOREIGN KEY (cod_usuario) REFERENCES usuarios (cod_usuario) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS workshopVargas.direcciones (
	serie INT AUTO_INCREMENT,
    id INT NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    i_direccion VARCHAR(1) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    cod_pais VARCHAR(3) NOT NULL,
    cod_ciudad VARCHAR(8) NOT NULL,
    email VARCHAR(50) NOT NULL,
    PRIMARY KEY (serie),
    CONSTRAINT fk_cliente_direccion FOREIGN KEY (id) REFERENCES cliente (id) ON DELETE RESTRICT ON UPDATE CASCADE   
);
CREATE TABLE IF NOT EXISTS workshopVargas.empresas (
	id_nomina VARCHAR(3) NOT NULL,
    n_nomina VARCHAR(50) NOT NULL,
    i_periodicidad VARCHAR(1) NOT NULL,
    i_activo VARCHAR(1) NOT NULL,
    id INT NOT NULL,     
    PRIMARY KEY (id_nomina),
    CONSTRAINT fk_empresa_cliente FOREIGN KEY (id) REFERENCES cliente (id) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS workshopVargas.asociados (
	id INT,
    numdoc VARCHAR(50) NOT NULL,
    nombres VARCHAR(200) NOT NULL,
    n_razons VARCHAR(200),
    f_afiliacion DATE NOT NULL,
    tipo_aso VARCHAR(3) NOT NULL,
    id_nomina VARCHAR(3) NOT NULL,
    i_periodicidad VARCHAR(1) NOT NULL,
    salario INT NOT NULL,
    PRIMARY KEY (id),
    INDEX idx_nombres (nombres),
    INDEX idx_docu (numdoc),
    CONSTRAINT fk_asociado_cliente_num FOREIGN KEY (numdoc) REFERENCES cliente (numdoc) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_asociado_empresa FOREIGN KEY (id_nomina) REFERENCES empresas (id_nomina) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_asociado_tipoaso FOREIGN KEY (tipo_aso) REFERENCES tipoaso (tipo_aso) ON DELETE RESTRICT ON UPDATE CASCADE
    );

CREATE TABLE IF NOT EXISTS workshopVargas.ahorros (
	id_ahorro INT AUTO_INCREMENT,
    doc_ref INT NOT NULL,
    id INT NOT NULL,     
    i_periodicidad VARCHAR(1) NOT NULL,
    valor_aporte NUMERIC NOT NULL,
    porcentaje_aporte INT,
    saldo_aporte NUMERIC,
    PRIMARY KEY (id_ahorro),
    CONSTRAINT fk_ahorro_id FOREIGN KEY (id) REFERENCES asociados (id) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS workshopVargas.credito (
	cod_credito INT AUTO_INCREMENT,
    id INT NOT NULL,     
    doc_ref VARCHAR(3) NOT NULL,
    fecha_credito DATE,
    cod_modalidad VARCHAR(3) NOT NULL,
    valor_credito NUMERIC NOT NULL,
    valor_cuota NUMERIC NOT NULL,
    plazo INT,
    saldo_credito INT,
    INDEX idx_credito (cod_credito),
    PRIMARY KEY (cod_credito),
    CONSTRAINT fk_credito_asociado FOREIGN KEY (id) REFERENCES asociados (id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_credito_modalidad FOREIGN KEY (cod_modalidad) REFERENCES modalidades_cred (cod_modalidad) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS workshopVargas.det_contable (
	serie INT AUTO_INCREMENT,
    tipo_documento VARCHAR(3) NOT NULL,
    k_codcon VARCHAR(16) NOT NULL,
    k_ano YEAR NOT NULL,
    cod_credito INT,
    id_ahorro INT,
    n_movimi VARCHAR(40) NOT NULL,
    cr_peso NUMERIC NOT NULL,
    db_peso NUMERIC NOT NULL,
    f_movimi DATE NOT NULL,
    i_anulado VARCHAR(1),
    INDEX idx_k_numdoc (serie),
    PRIMARY KEY (serie),
    CONSTRAINT fk_det_contable_contabilidad FOREIGN KEY (k_codcon) REFERENCES contabilidad (k_codcon) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_det_contable_ahorros FOREIGN KEY (id_ahorro) REFERENCES ahorros (id_ahorro) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_det_contable_credito FOREIGN KEY (cod_credito) REFERENCES credito (cod_credito) ON DELETE RESTRICT ON UPDATE CASCADE
);
    