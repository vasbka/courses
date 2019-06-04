

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
