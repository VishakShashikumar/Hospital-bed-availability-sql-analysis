-- ------------------------------------------------------------
-- Identify SICU and ICU bed IDs
-- ------------------------------------------------------------
-- First, check what bed IDs correspond to SICU and ICU
SELECT * 
FROM bed_type
WHERE bed_desc LIKE '%SICU%' OR bed_desc LIKE '%ICU%';

-- ------------------------------------------------------------
-- 10 Hospitals with Highest Licensed SICU Beds
-- ------------------------------------------------------------
SELECT 
    b.business_name,
    SUM(f.license_beds) AS total_sicu_licensed_beds
FROM bed_fact f
JOIN business b ON f.ims_org_id = b.ims_org_id
JOIN bed_type t ON f.bed_id = t.bed_id
WHERE t.bed_desc LIKE '%SICU%'
GROUP BY b.business_name
ORDER BY total_sicu_licensed_beds DESC
LIMIT 10;

-- ------------------------------------------------------------
-- 10 Hospitals with Highest Census SICU Beds
-- ------------------------------------------------------------
SELECT 
    b.business_name,
    SUM(f.census_beds) AS total_sicu_census_beds
FROM bed_fact f
JOIN business b ON f.ims_org_id = b.ims_org_id
JOIN bed_type t ON f.bed_id = t.bed_id
WHERE t.bed_desc LIKE '%SICU%'
GROUP BY b.business_name
ORDER BY total_sicu_census_beds DESC
LIMIT 10;

-- ------------------------------------------------------------
-- 10 Hospitals with Highest Staffed SICU Beds
-- ------------------------------------------------------------
SELECT 
    b.business_name,
    SUM(f.staffed_beds) AS total_sicu_staffed_beds
FROM bed_fact f
JOIN business b ON f.ims_org_id = b.ims_org_id
JOIN bed_type t ON f.bed_id = t.bed_id
WHERE t.bed_desc LIKE '%SICU%'
GROUP BY b.business_name
ORDER BY total_sicu_staffed_beds DESC
LIMIT 10;

-- ------------------------------------------------------------
-- 10 Hospitals with Highest Licensed ICU Beds
-- ------------------------------------------------------------
SELECT 
    b.business_name,
    SUM(f.license_beds) AS total_icu_licensed_beds
FROM bed_fact f
JOIN business b ON f.ims_org_id = b.ims_org_id
JOIN bed_type t ON f.bed_id = t.bed_id
WHERE t.bed_desc LIKE '%ICU%'
GROUP BY b.business_name
ORDER BY total_icu_licensed_beds DESC
LIMIT 10;

-- ------------------------------------------------------------
-- 10 Hospitals with Highest Census ICU Beds
-- ------------------------------------------------------------
SELECT 
    b.business_name,
    SUM(f.census_beds) AS total_icu_census_beds
FROM bed_fact f
JOIN business b ON f.ims_org_id = b.ims_org_id
JOIN bed_type t ON f.bed_id = t.bed_id
WHERE t.bed_desc LIKE '%ICU%'
GROUP BY b.business_name
ORDER BY total_icu_census_beds DESC
LIMIT 10;

-- ------------------------------------------------------------
-- Top 10 Hospitals with Highest Staffed ICU Beds
-- ------------------------------------------------------------
SELECT 
    b.business_name,
    SUM(f.staffed_beds) AS total_icu_staffed_beds
FROM bed_fact f
JOIN business b ON f.ims_org_id = b.ims_org_id
JOIN bed_type t ON f.bed_id = t.bed_id
WHERE t.bed_desc LIKE '%ICU%'
GROUP BY b.business_name
ORDER BY total_icu_staffed_beds DESC
LIMIT 10;














-- ------------------------------------------------------------
-- Final Report:
-- The Top 10 Hospitals with total Licensed, Census,
-- and Staffed Beds for both ICU and SICU categories in a single table
-- ------------------------------------------------------------

SELECT 
    -- Include hospital's unique ID and name for reference
    b.ims_org_id,
    b.business_name,

    -- --------------------------------------------------------
    -- Licensed Bed Counts
    -- ICU Licensed Beds: Includes all ICU but excludes SICU to avoid overlap
    SUM(CASE 
        WHEN t.bed_desc LIKE '%ICU%' AND t.bed_desc NOT LIKE '%SICU%' 
        THEN f.license_beds ELSE 0 END) AS LicBeds_ICU,

    -- SICU Licensed Beds
    SUM(CASE 
        WHEN t.bed_desc LIKE '%SICU%' 
        THEN f.license_beds ELSE 0 END) AS LicBeds_SICU,

    -- --------------------------------------------------------
    -- Census Bed Counts
    -- ICU Census Beds (not SICU)
    SUM(CASE 
        WHEN t.bed_desc LIKE '%ICU%' AND t.bed_desc NOT LIKE '%SICU%' 
        THEN f.census_beds ELSE 0 END) AS CensBeds_ICU,

    -- SICU Census Beds
    SUM(CASE 
        WHEN t.bed_desc LIKE '%SICU%' 
        THEN f.census_beds ELSE 0 END) AS CensBeds_SICU,

    -- --------------------------------------------------------
    -- Staffed Bed Counts
    -- ICU Staffed Beds (not SICU)
    SUM(CASE 
        WHEN t.bed_desc LIKE '%ICU%' AND t.bed_desc NOT LIKE '%SICU%' 
        THEN f.staffed_beds ELSE 0 END) AS StafBeds_ICU,

    -- SICU Staffed Beds
    SUM(CASE 
        WHEN t.bed_desc LIKE '%SICU%' 
        THEN f.staffed_beds ELSE 0 END) AS StafBeds_SICU

-- ------------------------------------------------------------
-- Table Joins to bring together data from facts and dimensions
-- ------------------------------------------------------------
FROM bed_fact f
JOIN business b ON f.ims_org_id = b.ims_org_id       -- Join to hospital information
JOIN bed_type t ON f.bed_id = t.bed_id               -- Join to bed type description

-- Only include rows related to ICU or SICU
WHERE t.bed_desc LIKE '%ICU%'

-- Group data by hospital so each row = one hospital
GROUP BY b.ims_org_id, b.business_name

-- Sort by total licensed beds (ICU + SICU) to get top hospitals
ORDER BY 
    SUM(CASE WHEN t.bed_desc LIKE '%ICU%' THEN f.license_beds ELSE 0 END) +
    SUM(CASE WHEN t.bed_desc LIKE '%SICU%' THEN f.license_beds ELSE 0 END) DESC

-- Only return the Top 10 Hospitals
LIMIT 10;