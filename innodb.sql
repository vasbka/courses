CREATE SCHEMA IF NOT EXISTS `admissionsBoardInnoDb` DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;;

USE `admissionsBoardInnoDb`;

CREATE TABLE IF NOT EXISTS `admissionsBoardInno`.`City` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NOT NULL,
  `area` FLOAT(10, 2) UNSIGNED NOT NULL,
  `description` TEXT(500) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NOT NULLk,
  `creationDate` DATE NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS `admissionsBoardInno`.`enrollee` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `firstName` VARCHAR(30) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NOT NULL,
  `lastName` VARCHAR(30) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NOT NULL,
  `login` VARCHAR(30) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NOT NULL,
  `password` VARCHAR(25) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NOT NULL,
  `email` VARCHAR(55) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NOT NULL,
  `additional` TEXT(1000) NOT NULL,
  `creationDate` DATE NOT NULL,
  `cityId` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `login_UNIQUE` (`login` ASC),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `fk_enrollee_city_index` (`cityId` ASC),
  CONSTRAINT `fk_enrollee_city`
    FOREIGN KEY (`cityId`)
    REFERENCES `admissionsBoardInnoDb`.`City` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS `admissionsBoardInno`.`subjectType` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(20) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS `admissionsBoardInno`.`subject` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NOT NULL,
  `subjecttypeId` INT UNSIGNED NOT NULL,
  `description` TEXT(300) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NOT NULL,
  `anyDate` DATE NULL,
  `popularity` FLOAT(4,2) NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC),
  INDEX `fk_subject_subjectType1_idx` (`subjecttypeId` ASC),
  CONSTRAINT `fk_subject_subjectType1`
    FOREIGN KEY (`subjecttypeId`)
    REFERENCES `admissionsBoardInno`.`subjectType` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;



-- -----------------------------------------------------
-- Table `admissionsBoardInno`.`faculty`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `admissionsBoardInno`.`faculty` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NOT NULL,
  `generalCount` INT UNSIGNED NOT NULL,
  `budgetCount` INT UNSIGNED NOT NULL,
  `creationDate` DATE NOT NULL,
  `popularity` FLOAT(4,2) NULL,
  `description` TEXT(500) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name_UNIQUE` (`id` ASC),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;





-- Table `admissionsBoardInno`.`statement`
CREATE TABLE IF NOT EXISTS `admissionsBoardInno`.`statement` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL,
  `popularity` FLOAT(4,2) NULL,
  `description` TEXT(500) NULL,
  `someName` VARCHAR(50) NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS `admissionsBoardInno`.`enrolleeSubject` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `point` FLOAT NOT NULL,
  `enrolleId` INT UNSIGNED NOT NULL,
  `subjectId` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `fk_enrolleeSubject_enrollee_idx` (`enrolleId` ASC),
  INDEX `fk_enrolleeSubject_subject1_idx` (`subjectId` ASC),
  CONSTRAINT `fk_enrolleeSubject_enrollee`
    FOREIGN KEY (`enrolleId`)
    REFERENCES `admissionsBoardInno`.`enrollee` (`id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_enrolleeSubject_subject1`
    FOREIGN KEY (`subjectId`)
    REFERENCES `admissionsBoardInno`.`subject` (`id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;



-- -----------------------------------------------------
-- Table `admissionsBoardInno`.`facultySubject`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `admissionsBoardInno`.`facultySubject` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `coefficient` FLOAT NULL,
  `faculytId` INT UNSIGNED NOT NULL,
  `subjectId` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `fk_facultySubject_faculty1_idx` (`faculytId` ASC),
  INDEX `fk_facultySubject_subject1_idx` (`subjectId` ASC),
  CONSTRAINT `fk_facultySubject_faculty1`
    FOREIGN KEY (`faculytId`)
    REFERENCES `admissionsBoardInno`.`faculty` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_facultySubject_subject1`
    FOREIGN KEY (`subjectId`)
    REFERENCES `admissionsBoardInno`.`subject` (`id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;
-- -----------------------------------------------------
-- Table `admissionsBoardInno`.`request`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `admissionsBoardInno`.`request` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `averageScore` FLOAT NOT NULL,
  `facultyId` INT UNSIGNED NOT NULL,
  `enrolleeId` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `fk_request_faculty1_idx` (`facultyId` ASC),
  INDEX `fk_request_enrollee1_idx` (`enrolleeId` ASC),
  CONSTRAINT `fk_request_faculty1`
    FOREIGN KEY (`facultyId`)
    REFERENCES `admissionsBoardInno`.`faculty` (`id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_request_enrollee1`
    FOREIGN KEY (`enrolleeId`)
    REFERENCES `admissionsBoardInno`.`enrollee` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;






-- -----------------------------------------------------
-- Table `admissionsBoardInno`.`statementRequest`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `admissionsBoardInno`.`statementRequest` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `request_id` INT UNSIGNED NOT NULL,
  `statement_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `fk_statementRequest_request1_idx` (`request_id` ASC),
  INDEX `fk_statementRequest_statement1_idx` (`statement_id` ASC),
  CONSTRAINT `fk_statementRequest_request1`
    FOREIGN KEY (`request_id`)
    REFERENCES `admissionsBoardInno`.`request` (`id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_statementRequest_statement1`
    FOREIGN KEY (`statement_id`)
    REFERENCES `admissionsBoardInno`.`statement` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;
