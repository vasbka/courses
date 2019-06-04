ALTER TABLE `enrollee`
ADD FULLTEXT INDEX `additionalFullText`
(`additional` ASC);

ALTER TABLE `subject`
ADD FULLTEXT INDEX `subjectDescriptionFullText`
(`description` ASC);

ALTER TABLE `faculty`
ADD FULLTEXT INDEX `facultyDescriptionFullText`
(`description` ASC);

ALTER TABLE `statement`
ADD FULLTEXT INDEX `statementDescriptionFullText`
(`description` ASC);

