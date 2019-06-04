

DELIMITER //

CREATE TRIGGER city_delete_restrict BEFORE DELETE ON city
FOR EACH ROW
BEGIN
    IF OLD.id IN (SELECT cityId FROM enrollee)
        THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'You can`t delete city, which used in enrollee table.';
    END IF;
END;//

CREATE TRIGGER city_update_after AFTER UPDATE ON city
FOR EACH ROW
BEGIN
  UPDATE enrollee SET cityid = NEW.id WHERE cityid = OLD.id;
END;//


CREATE TRIGGER subject_type_delete_restrict_subject BEFORE DELETE ON subjectType
FOR EACH ROW
BEGIN
    IF OLD.id IN (SELECT subjecttypeId FROM subject)
        THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'You can`t delete subject type, which used in subject table.';
    END IF;
END;//

CREATE TRIGGER subject_type_update_cascade_subject AFTER UPDATE ON subjectType
FOR EACH ROW
BEGIN
    UPDATE subject SET subjecttypeId = NEW.id WHERE subjecttypeId = OLD.id;
END;//

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


