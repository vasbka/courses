CREATE FUNCTION multiply(coef FLOAT, point FLOAT) RETURNS FLOAT
DETERMINISTIC
BEGIN
RETURN coef * point;
END//


CREATE FUNCTION get_faculty_subject_id_by_index(facultyId INT, indx INT) RETURNS INT
DETERMINISTIC
BEGIN
DECLARE subjectIdForReturn INT DEFAULT 0;
SELECT subjectId INTO subjectIdForReturn FROM facultySubject WHERE facultyId = facultyId ORDER BY facultyId LIMIT 1 OFFSET indx;
RETURN subjectIdForReturn;
END//

CREATE FUNCTION get_enrollee_point_by_enrollee_id_subject_id(enrolleeId INT, subjectId INT) RETURNS FLOAT
DETERMINISTIC
BEGIN
DECLARE pnt FLOAT;
SELECT point INTO pnt FROM enrolleeSubject WHERE enrolleeSubject.enrolleeId = enrolleeId AND enrolleeSubject.subjectId = subjectId;
RETURN pnt;
END//

CREATE FUNCTION get_faculty_coef_by_faculty_id_subject_id(facultyId INT, subjectId INT) RETURNS FLOAT
DETERMINISTIC
BEGIN
DECLARE coef FLOAT;
SELECT coefficient INTO coef FROM facultySubject WHERE facultySubject.facultyId = facultyId AND facultySubject.subjectId = subjectId;
RETURN coef;
END//


CREATE FUNCTION get_average_point_for_enrollee_id_faculty_id(enrolleeId INT, facultyId INT) RETURNS FLOAT
DETERMINISTIC
BEGIN
    DECLARE firstPoint FLOAT DEFAULT -1;
    DECLARE secondPoint FLOAT DEFAULT -1;
    DECLARE thirdPoint FLOAT DEFAULT -1;
    DECLARE firstCoef FLOAT DEFAULT -1;
    DECLARE secondCoef FLOAT DEFAULT -1;
    DECLARE thirdCoef FLOAT DEFAULT -1;
    DECLARE avgPoint FLOAT DEFAULT 0;
    SELECT point INTO firstPoint FROM enrolleeSubject WHERE subjectId = get_faculty_subject_id_by_index(facultyId, 0) AND enrolleeId = enrolleeId;
    SELECT point INTO secondPoint FROM enrolleeSubject WHERE subjectId = get_faculty_subject_id_by_index(facultyId, 1) AND enrolleeId = enrolleeId;
    SELECT point INTO thirdPoint FROM enrolleeSubject WHERE subjectId = get_faculty_subject_id_by_index(facultyId, 2) AND enrolleeId = enrolleeId;
    IF firstPoint = -1 OR secondPoint = -1 OR thirdPoint = -1 THEN
        RETURN -1;
    ELSE
        BEGIN
            SELECT coefficient INTO firstCoef FROM facultySubject WHERE facultyId = facultyId AND subjectId = get_faculty_subject_id_by_index(facultyId, 0);
            SELECT coefficient INTO secondCoef FROM facultySubject WHERE facultyId = facultyId AND subjectId = get_faculty_subject_id_by_index(facultyId, 1);
            SELECT coefficient INTO thirdCoef FROM facultySubject WHERE facultyId = facultyId AND subjectId = get_faculty_subject_id_by_index(facultyId, 2);
            SET avgPoint = avgPoint + multiply(firstCoef, firstPoint);
            SET avgPoint = avgPoint + multiply(secondCoef, secondPoint);
            SET avgPoint = avgPoint + multiply(thirdCoef, thirdPoint);
        END;
    END IF;
    RETURN avgPoint;
END//

CREATE PROCEDURE find_by_lastName(IN lastName VARCHAR(50))
BEGIN
    SELECT * FROM enrollee WHERE enrollee.lastName = lastName;
END//

CREATE PROCEDURE add_request(IN enrolleeId INT, IN facultyId INT)
BEGIN
    DECLARE avgPoint FLOAT DEFAULT 0;
    SET avgPoint = get_average_point_for_enrollee_id_faculty_id(enrolleeId, facultyId);
    IF avgPoint = -1 THEN
        SELECT 'Failed';
    ELSE
        INSERT INTO request(enrolleeId, facultyId, averageScore) VALUES (enrolleeId, facultyId, avgPoint);
        SELECT 'Success added';
    END IF;
END//

CREATE PROCEDURE createStatement(IN facultyId INT)
BEGIN
DECLARE averagePoint FLOAT DEFAULT 0;
DECLARE cnt INT DEFAULT 0;
DECLARE facultyName VARCHAR(50);
DECLARE total INT DEFAULT 0;
DECLARE statementId INT;
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    ROLLBACK;
END;
    START TRANSACTION;
        SELECT count(*) INTO cnt FROM request WHERE request.facultyId = facultyId GROUP BY facultyId;
        SELECT generalCount INTO total FROM faculty WHERE faculty.id = facultyId;
        SELECT avg(averageScore) INTO averagePoint FROM request WHERE request.facultyId = facultyId GROUP BY facultyId LIMIT total;
        SELECT name INTO facultyName FROM faculty WHERE faculty.id = facultyId;
        INSERT INTO statement(date, count, averageScore, description, name)
            VALUES (now(), cnt, averagePoint, 'somedescrpition', concat("Statement for ", facultyName));
        SELECT LAST_INSERT_ID() INTO statementId;
        INSERT INTO statementrequest SELECT enrolleeId, facultyId, statementId from request where facultyId = 1;
    COMMIT;
END//

SELECT avg(averageScore) INTO averagePoint FROM request WHERE request.facultyId = facultyId GROUP BY facultyId LIMIT ( SELECT generalCount FROM faculty WHERE faculty.id = facultyId);



CREATE PROCEDURE createStatement(IN facultyId INT)
BEGIN
DECLARE averagePoint FLOAT DEFAULT 0;
DECLARE cnt INT DEFAULT 0;
DECLARE facultyName VARCHAR(50);
DECLARE total INT DEFAULT 0;
DECLARE statementId INT;
DECLARE isExists TINYINT DEFAULT 0;
    SELECT count(*) INTO cnt FROM request WHERE request.facultyId = facultyId GROUP BY facultyId;
    SELECT generalCount INTO total FROM faculty WHERE faculty.id = facultyId;
    SELECT avg(averageScore) INTO averagePoint FROM request WHERE request.facultyId = facultyId GROUP BY facultyId LIMIT total;
    SELECT name INTO facultyName FROM faculty WHERE faculty.id = facultyId;
    INSERT INTO statement(date, count, averageScore, description, name)
        VALUES (now(), cnt, averagePoint, "somedescrpition", concat("Statement for ", facultyName));
    SELECT count(*) INTO isExists FROM statement
    WHERE count = cnt AND averageScore = averagePoint AND description = "somedescrpition";
    IF isExists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Could not create statement for faculty.';
    END IF;
    SELECT LAST_INSERT_ID() INTO statementId;
    INSERT INTO statementrequest SELECT enrolleeId, facultyId, statementId from request where facultyId = 1;
END//

CREATE OR REPLACE VIEW v AS
SELECT firstName, lastName, name, averageScore FROM request
INNER JOIN faculty ON faculty.id = request.facultyId
INNER JOIN enrollee ON enrollee.id = request.enrolleeId;