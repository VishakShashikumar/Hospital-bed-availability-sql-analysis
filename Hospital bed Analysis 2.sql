-- ------------------------------------------------------------
-- Set the database
-- ------------------------------------------------------------
USE MedBedAnalysis;
-- ------------------------------------------------------------
-- Create Dimension Table: business
-- Stores hospital/medical center information
-- ------------------------------------------------------------
CREATE TABLE business (
    ims_org_id VARCHAR(50) PRIMARY KEY,   -- Unique hospital/organization ID
    business_name VARCHAR(255)            -- Name of the hospital
);

-- ------------------------------------------------------------
-- Create Dimension Table: bed_type
-- Stores different types of bed categories (SICU, ICU, etc.)
-- ------------------------------------------------------------
CREATE TABLE bed_type (
    bed_id INT PRIMARY KEY,               -- Unique ID for each bed type
    bed_desc VARCHAR(255)                  -- Description of bed type (e.g., SICU, ICU)
);

-- ------------------------------------------------------------
-- Create Fact Table: bed_fact
-- Stores the number of beds available by type at each hospital
-- ------------------------------------------------------------
CREATE TABLE bed_fact (
    bed_fact_id INT PRIMARY KEY AUTO_INCREMENT,  -- Unique ID for each bed record
    ims_org_id VARCHAR(50),                      -- Foreign Key to business table
    bed_id INT,                                  -- Foreign Key to bed_type table
    license_beds INT,                            -- Number of licensed beds
    census_beds INT,                             -- Number of census beds
    staffed_beds INT,                            -- Number of staffed beds
    FOREIGN KEY (ims_org_id) REFERENCES business(ims_org_id),
    FOREIGN KEY (bed_id) REFERENCES bed_type(bed_id)
);
Select * from bed_type

