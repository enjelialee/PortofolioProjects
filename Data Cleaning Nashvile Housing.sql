SELECT *
FROM nashville_housing
;

-- Standarize Date Format

SELECT str_to_date(SaleDate, '%d/%m/%Y')
FROM nashville_housing
;

UPDATE nashville_housing
SET SaleDate = str_to_date(SaleDate, '%d/%m/%Y')
;

ALTER TABLE nashville_housing
MODIFY COLUMN SaleDate
date
;


-- Populate Property Address Data

SELECT *
from nashville_housing
where PropertyAddress = ''
order by ParcelID
;

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress # ifnull(a.PropertyAddress, b.PropertyAddress) ap
FROM nashville_housing a
JOIN nashville_housing b
  ON a.ParcelID = b.ParcelID
  AND a.UniqueID != b.UniqueID
WHERE a.PropertyAddress = '' AND b.PropertyAddress != ''
;


UPDATE nashville_housing a
JOIN nashville_housing b
  ON a.ParcelID = b.ParcelID
  AND a.UniqueID != b.UniqueID
SET a.PropertyAddress = b.PropertyAddress
WHERE a.PropertyAddress = '' AND b.PropertyAddress != ''
;


-- Breaking out Address into individual columns (Address, city, state)

SELECT *
FROM nashville_housing
;

SELECT PropertyAddress,
SUBSTRING(PropertyAddress, 1, instr(PropertyAddress, ',') - 1) address,
SUBSTRING(PropertyAddress, instr(PropertyAddress, ',') + 1) city
FROM nashville_housing
;

ALTER TABLE nashville_housing
ADD COLUMN PropertySplitAddress
varchar(250)
;

ALTER TABLE nashville_housing
ADD COLUMN PropertySplitCity
varchar(250)
;

UPDATE nashville_housing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, instr(PropertyAddress, ',') - 1)
;

UPDATE nashville_housing
SET PropertySplitCity = SUBSTRING(PropertyAddress, instr(PropertyAddress, ',') + 1)
;

SELECT OwnerAddress
FROM nashville_housing
;

SELECT OwnerAddress,
SUBSTRING_INDEX(OwnerAddress, ',', 1) address,
SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1) city,
SUBSTRING_INDEX(OwnerAddress, ',', -1) state
FROM nashville_housing
;

ALTER TABLE nashville_housing
ADD COLUMN OwnerSplitAddress
varchar(250)
;

ALTER TABLE nashville_housing
ADD COLUMN OwnerSplitCity
varchar(250)
;

ALTER TABLE nashville_housing
ADD COLUMN OwnerSplitState
varchar(250)
;

UPDATE nashville_housing
SET OwnerSplitAddress = SUBSTRING_INDEX(OwnerAddress, ',', 1)
;

UPDATE nashville_housing
SET OwnerSplitCity = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1)
;

UPDATE nashville_housing
SET OwnerSplitState = SUBSTRING_INDEX(OwnerAddress, ',', -1)
;

SELECT *
FROM nashville_housing
;


-- Change Y and N to Yes and No in 'Sold as Vacant' Column

SELECT DISTINCT (SoldAsVacant), count(SoldAsVacant)
FROM nashville_housing
GROUP BY SoldAsVacant
;

SELECT SoldAsVacant,
CASE
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
    WHEN SoldAsVacant = 'N' THEN 'No'
    ELSE SoldAsVacant
END Yesno
FROM nashville_housing
WHERE SoldAsVacant = 'Y' OR SoldAsVacant = 'N'
;


-- Remove Duplicates
SELECT DISTINCT ParcelID, LandUse,  PropertyAddress, SaleDate, SalePrice, LegalReference, SoldAsVacant, OwnerName, OwnerAddress, Acreage, TaxDistrict, LandValue, BuildingValue, TotalValue, YearBuilt, Bedrooms, FullBath, HalfBath, PropertySplitAddress, PropertySplitCity, OwnerSplitAddress, OwnerSplitCity, OwnerSplitState
FROM nashville_housing
#GROUP BY ParcelID
#ORDER BY 1
#ORDER BY 5, 2 #ParcelID, PropertyAddress, SalePrice, LegalReference, SaleDate
;

WITH CTE AS (
SELECT *, ROW_NUMBER() OVER(PARTITION BY ParcelID, PropertyAddress, SaleDate, SalePrice, LegalReference, SoldAsVacant, OwnerName, OwnerAddress, Acreage, TaxDistrict, LandValue, BuildingValue, TotalValue, YearBuilt, Bedrooms, FullBath, HalfBath, PropertySplitAddress, PropertySplitCity, OwnerSplitAddress, OwnerSplitCity, OwnerSplitState) ranc
FROM nashville_housing
)
DELETE 
FROM a
USING nashville_housing a
JOIN CTE b
	ON a.UniqueID = b.UniqueID
WHERE b.ranc > 1
;


-- Delete Unused Columns

SELECT *
FROM nashville_housing
;

ALTER TABLE nashville_housing
DROP COLUMN OwnerAddress
;

ALTER TABLE nashville_housing
DROP COLUMN PropertyAddress
;

ALTER TABLE nashville_housing
DROP COLUMN TaxDistrict
;

-- Standarize the saleprice

SELECT SalePrice, TRIM(SalePrice)
FROM nashville_housing
WHERE SalePrice != ''
ORDER BY SalePrice
;