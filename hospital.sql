CREATE TABLE Patients (
    patient_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    disease VARCHAR(100),
    admission_date DATE
);

SELECT * FROM Patients

CREATE TABLE Bills (
    bill_id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES Patients(patient_id),
    total_amount NUMERIC(10,2),
    paid_amount NUMERIC(10,2),
    status VARCHAR(20)
);

SELECT * FROM Bills 


CREATE FUNCTION GetOutstandingAmount(patient_id INT) RETURNS NUMERIC AS $$
DECLARE outstanding NUMERIC;
BEGIN
    SELECT (total_amount - paid_amount) INTO outstanding
    FROM Bills WHERE patient_id = patient_id;
    RETURN outstanding;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION GetPatientBillingReport(p_status VARCHAR) RETURNS TABLE (
    patient_id INT, name VARCHAR, disease VARCHAR, total_amount NUMERIC, paid_amount NUMERIC, status VARCHAR
) AS $$
BEGIN
    RETURN QUERY 
    SELECT p.patient_id, p.name, p.disease, b.total_amount, b.paid_amount, b.status
    FROM Patients p
    JOIN Bills b ON p.patient_id = b.patient_id
    WHERE b.status = p_status;
END;
$$ LANGUAGE plpgsql;

INSERT INTO Patients (name, age, disease, admission_date) VALUES
('Raj Mehta', 45, 'Diabetes', '2025-05-20'),
('Anita Rao', 30, 'Flu', '2025-05-23'),
('Vikas Sharma', 62, 'Hypertension', '2025-05-18'),
('Preeti Yadav', 29, 'Migraine', '2025-05-24'),
('Arun Joshi', 55, 'Heart Disease', '2025-05-15');

SELECT * FROM Patients

INSERT INTO Bills (patient_id, total_amount, paid_amount, status) VALUES
(1, 50000.00, 30000.00, 'Unpaid'),
(2, 8000.00, 8000.00, 'Paid'),
(3, 25000.00, 15000.00, 'Unpaid'),
(4, 12000.00, 12000.00, 'Paid'),
(5, 40000.00, 25000.00, 'Unpaid');

SELECT * FROM Bills 


