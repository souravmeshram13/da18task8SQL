CREATE TABLE Students (
    student_id SERIAL PRIMARY KEY,
    student_name VARCHAR(100),
    department VARCHAR(50),
    year INT
);


CREATE TABLE Grades (
    grade_id SERIAL PRIMARY KEY,
    student_id INT REFERENCES Students(student_id),
    subject VARCHAR(50),
    marks INT
);

CREATE FUNCTION CalculateGrade(student_id INT) RETURNS VARCHAR AS $$
DECLARE avg_marks NUMERIC;
DECLARE grade VARCHAR;
BEGIN
    SELECT AVG(marks) INTO avg_marks FROM Grades WHERE student_id = student_id;
    
    IF avg_marks >= 80 THEN
        grade := 'A';
    ELSIF avg_marks >= 60 THEN
        grade := 'B';
    ELSIF avg_marks >= 40 THEN
        grade := 'C';
    ELSE
        grade := 'D';
    END IF;
    
    RETURN grade;
END;
$$ LANGUAGE plpgsql;


CREATE FUNCTION GetStudentGradeReport(department VARCHAR) RETURNS TABLE (
    student_id INT, name VARCHAR, year INT, subject VARCHAR, marks INT
) AS $$
BEGIN
    RETURN QUERY 
    SELECT s.student_id, s.name, s.year, g.subject, g.marks
    FROM Students s
    JOIN Grades g ON s.student_id = g.student_id
    WHERE s.department = department;
END;
$$ LANGUAGE plpgsql;

INSERT INTO Students (student_name , department, year) VALUES
('Sonia Verma', 'Computer Science', 3),
('Amit Kumar', 'Electrical Engineering', 2),
('Neha Gupta', 'Mechanical Engineering', 4),
('Rohan Das', 'Civil Engineering', 1),
('Priya Sharma', 'Computer Science', 2);

SELECT * FROM  Students

INSERT INTO Grades (student_id, subject, marks) VALUES
(1, 'Database Management', 85),
(2, 'Circuit Analysis', 76),
(3, 'Machine Design', 65),
(4, 'Surveying', 88),
(5, 'Programming', 92);

SELECT * FROM  Grades

TRUNCATE TABLE Students, Grades RESTART IDENTITY;
