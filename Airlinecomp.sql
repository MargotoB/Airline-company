CREATE DATABASE airline_bd;
USE airline_bd;

-- ex.1

CREATE TABLE airports(
	airportID INT AUTO_INCREMENT PRIMARY KEY, 
    name VARCHAR(50) NOT NULL,  
    location VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL
);

CREATE TABLE airplanes(
	airplaneID INT AUTO_INCREMENT PRIMARY KEY,
    model VARCHAR(50) NOT NULL,
    capacity INT NOT NULL CHECK (capacity > 0)
);

CREATE TABLE crewRoles(
	roleID INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE crewMembers(
	crewmemberID INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    roleID INT NOT NULL,
    FOREIGN KEY(roleID) REFERENCES crewRoles(roleID) ON DELETE CASCADE
);

CREATE TABLE flights(
	flightID INT AUTO_INCREMENT PRIMARY KEY,
    date DATE NOT NULL,
    time TIME NOT NULL,
    duration INT NOT NULL CHECK(duration>0),
    airplaneID INT NOT NULL,
    arrivalAirportID INT NOT NULL,
    departureAirportID INT NOT NULL,
    FOREIGN KEY(airplaneID) REFERENCES airplanes(airplaneID) ON DELETE CASCADE,
    FOREIGN KEY(arrivalAirportID) REFERENCES airports(airportID) ON DELETE CASCADE,
    FOREIGN KEY(departureAirportID) REFERENCES airports(airportID) ON DELETE CASCADE,
    CHECK (arrivalAirportID <> departureAirportID)
);

CREATE TABLE flightCrew(
	flightID INT,
    crewmemberID INT,
    PRIMARY KEY(flightID, crewmemberID), 
    FOREIGN KEY(flightID) REFERENCES flights(flightID) ON DELETE CASCADE,
    FOREIGN KEY(crewmemberID) REFERENCES crewmembers(crewmemberID) ON DELETE CASCADE
);

CREATE TABLE mealTypes(
	mealTypeID INT AUTO_INCREMENT PRIMARY KEY,
    meal_description VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE meals(
	flightID INT,
    mealTypeID INT,
    PRIMARY KEY(flightID, mealTypeID),
    FOREIGN KEY(flightID) REFERENCES flights(flightID) ON DELETE CASCADE,
    FOREIGN KEY(mealTypeID) REFERENCES mealTypes(mealTypeID) ON DELETE CASCADE
);

CREATE TABLE pilotSchedule(
	scheduleID INT AUTO_INCREMENT PRIMARY KEY,
    shift_start TIME NOT NULL,
    shift_end TIME NOT NULL,
    crewmemberID INT NOT NULL,
    flightID INT NOT NULL,
    FOREIGN KEY(crewmemberID) REFERENCES crewMembers(crewmemberID) ON DELETE CASCADE,
    FOREIGN KEY(flightID) REFERENCES flights(flightID) ON DELETE CASCADE,
	CHECK(shift_start<>shift_end)
);

INSERT INTO airports(name, location, country) VALUES
('Sofia Airport', 'Sofia', 'Bulgaria'),
('Heathrow Airport', 'London', 'UK'),
('Charles de Gaulle', 'Paris', 'France'),
('Frankfurt Airport', 'Frankfurt', 'Germany'),
('Madrid-Barajas', 'Madrid', 'Spain'),
('JFK Airport', 'New York', 'USA'),
('Dubai International', 'Dubai', 'UAE'),
('Changi Airport', 'Singapore', 'Singapore'),
('Tokyo Haneda', 'Tokyo', 'Japan'),
('Sydney Kingsford Smith', 'Sydney', 'Australia');

INSERT INTO airplanes(model, capacity) VALUES
('Boeing 737', 180), 
('Airbus A320', 160),
('Boeing 747', 400),
('Airbus A380', 500),
('Embraer E190', 100),
('Bombardier CRJ900', 90),
('Boeing 777', 396),
('Airbus A350', 440),
('Cessna 208', 12),
('ATR 72', 78);

INSERT INTO crewroles(role_name) VALUES
('Pilot'),
('Co-Pilot'),
('Flight Attendant'),
('Chief Flight Attendant'),
('Navigator'),
('Engineer'),
('Loadmaster'),
('Dispatcher'),
('Security Officer'),
('Medical Crew');

INSERT INTO crewmembers(name, roleID) VALUES
('Ivan Petrov', 1),
('Peter Dimitrov', 2),
('Maria Georgieva', 3),
('John Smith', 4),
('Alice Brown', 5),
('Carlos Fernandez', 6),
('Yuki Tanaka', 7),
('Mohammed Al-Farsi', 8),
('Emma Wilson', 9),
('David Kim', 10);

INSERT INTO flights (date, time, duration, airplaneID, arrivalAirportID, departureAirportID) VALUES
('2025-03-10', '08:00:00', 180, 1, 2, 1),
('2025-03-11', '10:30:00', 220, 2, 3, 1),
('2025-03-12', '12:45:00', 300, 3, 4, 2),
('2025-03-13', '14:15:00', 150, 4, 5, 3),
('2025-03-14', '16:00:00', 120, 5, 6, 4),
('2025-03-15', '18:30:00', 200, 6, 7, 5),
('2025-03-16', '20:45:00', 240, 7, 8, 6),
('2025-03-17', '22:00:00', 270, 8, 9, 7),
('2025-03-18', '23:30:00', 180, 9, 10, 8),
('2025-03-19', '06:15:00', 160, 10, 1, 9);

INSERT INTO flightCrew (flightID, crewmemberID) VALUES
(1, 1), (1, 3), (1, 5),
(2, 2), (2, 4), (2, 6),
(3, 1), (3, 7), (3, 9),
(4, 2), (4, 8), (4, 10);

INSERT INTO mealTypes (meal_description) VALUES
('Vegetarian Meal'),
('Chicken Meal'),
('Beef Meal'),
('Seafood Meal'),
('Vegan Meal'),
('Gluten-Free Meal'),
('Salad Meal'),
('Pasta Meal'),
('Fruit Platter'),
('Kids Meal');

INSERT INTO meals (flightID, mealTypeID) VALUES
(1, 1), (1, 2), (1, 3),
(2, 4), (2, 5), (2, 6),
(3, 7), (3, 8), (3, 9),
(4, 10), (4, 1), (4, 2);

INSERT INTO pilotSchedule (shift_start, shift_end, crewmemberID, flightID) VALUES
('08:00:00', '12:00:00', 1, 1),
('10:00:00', '14:00:00', 2, 2),
('12:00:00', '16:00:00', 3, 3),
('14:00:00', '18:00:00', 4, 4),
('16:00:00', '20:00:00', 5, 5),
('18:00:00', '22:00:00', 6, 6),
('20:00:00', '00:00:00', 7, 7),
('22:00:00', '02:00:00', 8, 8),
('06:00:00', '10:00:00', 9, 9),
('08:00:00', '12:00:00', 10, 10);

-- ex.2
SELECT * FROM flights
WHERE duration>180;

-- ex.3 
SELECT arrivalAirportID AS destination, COUNT(*) AS flight_count
FROM flights
GROUP BY arrivalAirportID;

-- ex.4
SELECT cm.name AS name, cr.role_name AS role_name
FROM crewmembers AS cm
INNER JOIN crewroles AS cr ON cm.roleID = cr.roleID;

-- ex.5
SELECT cm.crewmemberID, cm.name, ps.scheduleID, ps.shift_start, ps.shift_end
FROM crewmembers AS cm
LEFT OUTER JOIN pilotschedule AS ps ON cm.crewmemberID = ps.crewmemberID;

-- ex. 6
SELECT cm.name, cr.role_name 
FROM crewmembers AS cm
JOIN crewroles AS cr ON cm.roleID = cr.roleID
WHERE cm.crewmemberID IN (SELECT crewmemberID FROM flightcrew WHERE flightID = 1);

-- ex.7 
SELECT ps.shift_start, ps.shift_end, COUNT(ps.crewmemberID) AS pilot_count, 
       GROUP_CONCAT(cm.name SEPARATOR ', ') AS pilots
FROM pilotSchedule AS ps
JOIN crewMembers AS cm ON ps.crewmemberID = cm.crewmemberID
GROUP BY ps.shift_start, ps.shift_end
ORDER BY ps.shift_start;

-- ex.8
CREATE TABLE flight_log(
	logID INT AUTO_INCREMENT PRIMARY KEY,
    flightID INT,
    duration INT,
    log_message VARCHAR(150),
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
); 

DELIMITER //
CREATE TRIGGER long_flight_alert 
AFTER INSERT ON flights
FOR EACH ROW
BEGIN
	IF NEW.duration>600 THEN 
		INSERT INTO flight_log(flightID, duration, log_message)
		VALUES (
			NEW.flightID,
            NEW.duration,
            'Warning! Flight duration exceeds 10 hours!'
        );
	END IF;
END;
// DELIMITER ;

INSERT INTO flights (date, time, duration, airplaneID, arrivalAirportID, departureAirportID)
VALUES ('2025-04-10', '15:00:00', 650, 1, 3, 2);
INSERT INTO flights (date, time, duration, airplaneID, arrivalAirportID, departureAirportID)
VALUES ('2025-04-17', '09:00:00', 200, 5, 4, 3);


SELECT * FROM flight_log;

-- ex.9
DELIMITER //
CREATE PROCEDURE CategorizeAirplanesByCapacity()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE air_id INT;
    DECLARE air_model VARCHAR(50);
    DECLARE air_capacity INT;
    DECLARE capacity_category VARCHAR(10);

    DECLARE airpl_cursor CURSOR FOR
        SELECT airplaneID, model, capacity FROM airplanes;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
	DROP TEMPORARY TABLE IF EXISTS airplane_capacity_report;
    CREATE TEMPORARY TABLE airplane_capacity_report (
        airplaneID INT,
        model VARCHAR(50),
        capacity INT,
        capacity_category VARCHAR(10)
    );
    
    OPEN airpl_cursor;
    read_loop: LOOP
        FETCH airpl_cursor INTO air_id, air_model, air_capacity;
        IF done THEN
            LEAVE read_loop;
        END IF;

        IF air_capacity < 100 THEN
            SET capacity_category = 'Small';
        ELSEIF air_capacity BETWEEN 100 AND 300 THEN
            SET capacity_category = 'Medium';
        ELSE
            SET capacity_category = 'Large';
        END IF;

        INSERT INTO airplane_capacity_report (airplaneID, model, capacity, capacity_category)
        VALUES (air_id, air_model, air_capacity, capacity_category);
    END LOOP;
    CLOSE airpl_cursor;
END;
//
DELIMITER ;
    
CALL CategorizeAirplanesByCapacity();
SELECT * FROM airplane_capacity_report;