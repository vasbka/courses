CREATE TABLE IF NOT EXISTS `enrollee` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `firstName` VARCHAR(30) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NOT NULL,
    `lastName` VARCHAR(30) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NOT NULL,
    `login` VARCHAR(30) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NOT NULL,
    `password` VARCHAR(25) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NOT NULL,
    `email` VARCHAR(55) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NOT NULL,
    `additional` TEXT(1000) NOT NULL,
    `creationDate` DATE NOT NULL,
    `city` VARCHAR(45) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `login_UNIQUE` (`login` ASC),
    UNIQUE INDEX `email_UNIQUE` (`email` ASC),
    UNIQUE INDEX `id_UNIQUE` (`id` ASC)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS `subject` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NOT NULL,
    `subjecttypeId` VARCHAR(20) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NOT NULL,
    `description` TEXT(300) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NOT NULL,
    `dateOfAdded` DATE NULL,
    `popularity` FLOAT(5,2) NULL,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `id_UNIQUE` (`id` ASC)
)
ENGINE = InnoDB
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
ENGINE = InnoDB
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
    UNIQUE INDEX `id_UNIQUE` (`id` ASC)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


CREATE TABLE IF NOT EXISTS `enrolleeSubject` (
    `point` FLOAT NOT NULL,
    `enrolleeId` INT UNSIGNED NOT NULL,
    `subjectId` INT UNSIGNED NOT NULL,
    PRIMARY KEY (`enrolleeId`,`subjectId`),
    INDEX `fk_enrolleeSubject_enrollee_idx` (`enrolleeId` ASC),
    INDEX `fk_enrolleeSubject_subject_idx` (`subjectId` ASC),
    CONSTRAINT `fk_enrolleeSubject_enrollee1`
    FOREIGN KEY (`enrolleeId`)
    REFERENCES `enrollee` (`id`)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT `fk_enrolleeSubject_subject1`
    FOREIGN KEY (`subjectId`)
    REFERENCES `subject` (`id`)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS `facultySubject` (
    `coefficient` FLOAT NOT NULL,
    `facultyId` INT UNSIGNED NOT NULL,
    `subjectId` INT UNSIGNED NOT NULL,
    PRIMARY KEY (`facultyId`, `subjectId`),
    INDEX `fk_facultySubject_faculty1_idx` (`facultyId` ASC),
    INDEX `fk_facultySubject_subject1_idx` (`subjectId` ASC),
    CONSTRAINT `fk_facultySubject_faculty1`
        FOREIGN KEY (`facultyId`)
        REFERENCES `faculty` (`id`)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT `fk_facultySubject_subject1`
        FOREIGN KEY (`subjectId`)
        REFERENCES `subject` (`id`)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS `request` (
    `averageScore` FLOAT NOT NULL,
    `facultyId` INT UNSIGNED NOT NULL,
    `enrolleeId` INT UNSIGNED NOT NULL,
    PRIMARY KEY (`facultyId`, `enrolleeId`),
    INDEX `fk_request_faculty1_idx` (`facultyId` ASC),
    INDEX `fk_request_enrollee1_idx` (`enrolleeId` ASC),
    CONSTRAINT `fk_request_faculty1`
    FOREIGN KEY (`facultyId`)
    REFERENCES `faculty` (`id`)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT `fk_request_enrollee1`
    FOREIGN KEY (`enrolleeId`)
    REFERENCES `enrollee` (`id`)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS `statementRequest` (
    `enrolleeId` INT UNSIGNED NOT NULL,
    `facultyId` INT UNSIGNED NOT NULL,
    `statementId` INT UNSIGNED NOT NULL,
    PRIMARY KEY (`statementId`, `enrolleeId`,`facultyId`),
    INDEX `fk_statementRequest_enrollee_idx` (`enrolleeId` ASC),
    INDEX `fk_statementRequest_faculty_idx` (`facultyId` ASC),
    INDEX `fk_statementRequest_statement_idx` (`statementId` ASC),
    CONSTRAINT `fk_statementRequest_request`
    FOREIGN KEY (`enrolleeId`,`facultyId`)
    REFERENCES `request` (`enrolleeId`,`facultyId`)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT `fk_statementRequest_statement`
    FOREIGN KEY (`statementId`)
    REFERENCES `statement` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;
