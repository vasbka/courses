CREATE TABLE IF NOT EXISTS `enrollee`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `firstName` VARCHAR(30) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NOT NULL,
    `lastName` VARCHAR(30) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NOT NULL,
    `login` VARCHAR(30) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NOT NULL,
    `password` VARCHAR(25) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NOT NULL,
    `email` VARCHAR(55) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NOT NULL,
    `additional` TEXT(1000) NOT NULL,
    `creationDate` DATE NOT NULL,
    `city` VARCHAR(255) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `login_UNIQUE` (`login` ASC),
    UNIQUE INDEX `email_UNIQUE` (`email` ASC),
    UNIQUE INDEX `id_UNIQUE` (`id` ASC)
)
ENGINE = MyISAM
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS `subject` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NOT NULL,
    `type` VARCHAR(20) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NOT NULL,
    `description` TEXT(300) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NOT NULL,
    `dateOfAdded` DATE NULL,
    `popularity` FLOAT(5,2) NULL,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `id_UNIQUE` (`id` ASC)
)
ENGINE = MyISAM
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS `faculty` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(45) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NOT NULL,
    `generalCount` INT UNSIGNED NOT NULL,
    `budgetCount` INT UNSIGNED NOT NULL,
    `creationDate` DATE NOT NULL,
    `popularity` FLOAT(5,2) NULL,
    `description` TEXT(500) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NULL,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `name_UNIQUE` (`name` ASC)
)
ENGINE = MyISAM
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS `statement` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `date` DATE NOT NULL,
    `count` INT UNSIGNED NULL,
    `averageScore` FLOAT(5,2) NULL,
    `description` TEXT(500) NULL,
    `name` VARCHAR(50) NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `id_UNIQUE` (`id` ASC),
    UNIQUE INDEX `name` (`name`)
)
ENGINE = MyISAM
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS `enrolleeSubject` (
    `point` FLOAT NOT NULL,
    `enrolleeId` INT UNSIGNED NOT NULL,
    `subjectId` INT UNSIGNED NOT NULL,
    PRIMARY KEY (`enrolleeId`,`subjectId`),
    INDEX `fk_enrolleeSubject_enrollee_idx` (`enrolleeId` ASC),
    INDEX `fk_enrolleeSubject_subject_idx` (`subjectId` ASC)
)
ENGINE = MyISAM
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS `facultySubject` (
    `coefficient` FLOAT NOT NULL,
    `facultyId` INT UNSIGNED NOT NULL,
    `subjectId` INT UNSIGNED NOT NULL,
    PRIMARY KEY (`facultyId`, `subjectId`),
    INDEX `fk_facultySubject_faculty1_idx` (`facultyId` ASC),
    INDEX `fk_facultySubject_subject1_idx` (`subjectId` ASC)
)
ENGINE = MyISAM
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS `request` (
    `averageScore` FLOAT NOT NULL,
    `facultyId` INT UNSIGNED NOT NULL,
    `enrolleeId` INT UNSIGNED NOT NULL,
    PRIMARY KEY (`facultyId`, `enrolleeId`),
    INDEX `fk_request_faculty1_idx` (`facultyId` ASC),
    INDEX `fk_request_enrollee1_idx` (`enrolleeId` ASC)
)
ENGINE = MyISAM
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS `statementRequest` (
    `enrolleeId` INT UNSIGNED NOT NULL,
    `facultyId` INT UNSIGNED NOT NULL,
    `statementId` INT UNSIGNED NOT NULL,
    PRIMARY KEY (`statementId`, `enrolleeId`,`facultyId`),
    INDEX `fk_statementRequest_enrollee_idx` (`enrolleeId` ASC),
    INDEX `fk_statementRequest_faculty_idx` (`facultyId` ASC),
    INDEX `fk_statementRequest_statement_idx` (`statementId` ASC)
)
ENGINE = MyISAM
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;



DELIMITER //

CREATE TRIGGER enrollee_delete_restrict_enrolleeSubject BEFORE DELETE ON enrollee
FOR EACH ROW
BEGIN
    IF OLD.id IN (SELECT enrolleeId FROM enrolleeSubject)
        THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'You can`t delete enrollee, who used in subject table.';
    END IF;
END;//

CREATE TRIGGER enrollee_update_cascade_enrolleeSubject AFTER UPDATE ON enrollee
FOR EACH ROW
BEGIN
   UPDATE enrolleeSubject SET enrolleeId = NEW.id WHERE enrolleeId = OLD.id;
END;//

CREATE TRIGGER subject_delete_restrict_enrolleeSubject BEFORE DELETE ON subject
FOR EACH ROW
BEGIN
    IF OLD.id IN (SELECT subjectId FROM enrolleeSubject)
        THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'You can`t delete enrollee, who used in subject table.';
    END IF;
END;//

CREATE TRIGGER subject_update_cascade_enrolleeSubject AFTER UPDATE ON subject
FOR EACH ROW
BEGIN
   UPDATE enrolleeSubject SET subjectId = NEW.id WHERE subjectId = OLD.id;
END;//

CREATE TRIGGER subject_delete_restrict_facultySubject BEFORE DELETE ON subject
FOR EACH ROW
BEGIN
    IF OLD.id IN (SELECT subjectId FROM facultySubject)
        THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'You can`t delete enrollee, who used in subject table.';
    END IF;
END;//

CREATE TRIGGER subject_update_cascade_facultySubject AFTER UPDATE ON subject
FOR EACH ROW
BEGIN
   UPDATE facultySubject SET subjectId = NEW.id WHERE subjectId = OLD.id;
END;//

CREATE TRIGGER faculty_delete_restrict_facultySubject BEFORE DELETE ON faculty
FOR EACH ROW
BEGIN
    IF OLD.id IN (SELECT subjectId FROM facultySubject)
        THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'You can`t delete enrollee, who used in subject table.';
    END IF;
END;//

CREATE TRIGGER faculty_update_cascade_facultySubject AFTER UPDATE ON faculty
FOR EACH ROW
BEGIN
   UPDATE facultySubject SET facultyId = NEW.id WHERE facultyId = OLD.id;
END;//


CREATE TRIGGER enrollee_delete_restrict_request BEFORE DELETE ON enrollee
FOR EACH ROW
BEGIN
   IF OLD.id IN (SELECT enrolleeId FROM request)
        THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'You can`t delete enrollee, who has at least one request.';
    END IF;
END;//

CREATE TRIGGER enrollee_update_cascade_request AFTER UPDATE ON enrollee
FOR EACH ROW
BEGIN
    UPDATE request SET enrolleeId = NEW.id WHERE enrolleeId = OLD.id;
END;//

CREATE TRIGGER faculty_delete_restrict_request BEFORE DELETE ON faculty
FOR EACH ROW
BEGIN
    IF OLD.id IN (SELECT enrolleeId FROM request)
        THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'You can`t delete faculty, which has at least one request.';
    END IF;
END;//

CREATE TRIGGER faculty_update_cascade_request AFTER UPDATE ON faculty
FOR EACH ROW
BEGIN
    UPDATE request SET facultyId = NEW.id WHERE facultyId = OLD.id;
END;//



CREATE TRIGGER request_delete_restrict_statementRequest BEFORE DELETE ON request
FOR EACH ROW
BEGIN
    IF (SELECT statementId FROM statementRequest WHERE enrolleeId = OLD.enrolleeId AND facultyId = OLD.facultyId) IS NOT NULL
        THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'You can`t delete request, which used in any statement.';
    END IF;
END;//

CREATE TRIGGER request_update_cascade_statementRequest AFTER UPDATE ON request
FOR EACH ROW
BEGIN
    UPDATE statementRequest SET enrolleeId = NEW.enrolleeId, facultyId = NEW.facultyId
    WHERE enrolleeId = OLD.enrolleeId AND facultyId = OLD.facultyId;
END;//

CREATE TRIGGER statement_delete_cascade_statementRequest AFTER DELETE ON statement
FOR EACH ROW
BEGIN
    DELETE FROM statementRequest WHERE statementId = OLD.id;
END;//

CREATE TRIGGER statement_update_cascade_statementRequest AFTER UPDATE ON statement
FOR EACH ROW
BEGIN
    UPDATE statementRequest SET statementId = NEW.id WHERE statementId = OLD.id;
END;//


