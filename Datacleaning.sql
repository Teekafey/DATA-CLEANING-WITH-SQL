-- Viewing the Data
SELECT *
FROM customer_demographics 
ORDER BY customer_name;

-- Dropping Columns 
ALTER TABLE customer_demographics
DROP (address2, locality, driver_license);

-- Splitting customer_names to first and last names
ALTER TABLE customer_demographics
ADD first_name varchar(30);

ALTER TABLE customer_demographics
ADD last_name varchar(30);

UPDATE customer_demographics
SET first_name = SUBSTR(customer_name, 1, INSTR(customer_name, ' ') -1) ;

UPDATE customer_demographics
SET last_name = SUBSTR(customer_name, INSTR(customer_name, ' ') +1) ;

ALTER TABLE customer_demographics
DROP COLUMN customer_name;

SELECT * 
FROM customer_demographics
ORDER BY first_name;

-- Trimming spaces in address and adding commas
SELECT TRIM(address1)
FROM customer_demographics;

UPDATE customer_demographics 
SET address1 = replace(address1, '  ', ' ');

UPDATE customer_demographics 
SET address1 = 
       (SUBSTR(address1, 1, INSTR(address1, ' ') - 1) || ', ' || SUBSTR(address1, INSTR(address1, ' ') + 1));

/*Changing Country Names to Coutry Codes and 
Coutry Codes to Nationality 
for better data presentation and readability
*/
UPDATE customer_demographics
SET country_code =
  CASE  WHEN country_code = 'Australia' THEN 'AU'
        WHEN country_code = 'Canada' THEN 'CA'
        WHEN country_code = 'Germany' THEN 'DE'
        WHEN country_code = 'Spain' THEN 'ES'
        WHEN country_code = 'France' THEN 'FR'
        WHEN country_code = 'Italy' THEN 'IT'
        WHEN country_code = 'United States' THEN 'USA'
        ELSE country_code
  END,
  nationality =
  CASE  WHEN nationality = 'AU' THEN 'Austraian'
        WHEN nationality = 'CA' THEN 'Canadian'
        WHEN nationality = 'DE' THEN 'German'
        WHEN nationality = 'ES' THEN 'Spainish'
        WHEN nationality = 'FR' THEN 'French'
        WHEN nationality = 'IT' THEN 'Italian'
        WHEN nationality = 'USA' THEN 'American'
        ELSE nationality 
  END;

-- Consistency of Email Addresses, Phone Numbers and Credit Card Types
UPDATE customer_demographics
SET email_address = lower(email_address); 

UPDATE customer_demographics
SET email_address = replace(email_address, '.', '');

UPDATE customer_demographics
SET email_address = 
  CASE WHEN LENGTH(email_address) >= 3 THEN
    REPLACE(email_address, SUBSTR(email_address, -3), '.' || SUBSTR(email_address, -3))
  ELSE email_address
END;
  
-- Phone number
SELECT TRIM (phone_number)
FROM customer_demographics;

UPDATE customer_demographics
SET phone_number = REPLACE(phone_number, ' ', '-');

UPDATE customer_demographics
SET phone_number = REPLACE(phone_number, '.', '-');

-- Credit card type
UPDATE customer_demographics
SET creditcard_type = REPLACE(creditcard_type, 'jcb', 'JCB');

-- The Ages are not consistent
UPDATE customer_demographics
SET age = REPLACE(age, 'age-', '');

-- Standardize Date Formats
UPDATE customer_demogrpahics
SET customer_deographics = TO_DATE(order_date, 'DD-MM-YYYY');

-- Checking for Duplicates
SELECT COUNT(DISTINCT *)
FROM customer_demographics;
-- there are 194 distinct values

-- Deleting 6 Duplicates
DELETE FROM customer_demographics
WHERE ROWID NOT IN(
  SELECT MIN(rowid)
  FROM customer_demographics
  GROUP BY customer_id
  );
  
--Drop Colmns that are not needed
ALTER TABLE customer_demographics
DROP (address2, postal_code_plus4);

-- Change column name
ALTER TABLE customer_demographics
rename column address1 to address;


-- we need a primary key
ALTER TABLE customer_demographics
ADD CONSTRAINT cust_id_pk PRIMARY KEY (customer_id);

--viewing the data
SELECT * 
FROM customer_demographics
ORDER BY customer_id;
-----