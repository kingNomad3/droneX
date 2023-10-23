--select * from drone

CREATE OR REPLACE PROCEDURE add_drone_acquisition(
model_name drone_model.name%TYPE,
serial_drone drone.serial_number%TYPE, --DRONE TAG(drone.drone_tag%TYPE) OU DRONE SERIAL NUMBER (drone.serial_number%TYPE)
registering_employee employee.ssn%TYPE, 
registering_timestamp drone_state.start_date_time%TYPE, 
receiving_employee employee.ssn%TYPE, 
receiving_date drone.acquisition_date%TYPE, 
unpacking_employee employee.ssn%TYPE)
LANGUAGE PLPGSQL 
AS 
$$

BEGIN
END
$$;