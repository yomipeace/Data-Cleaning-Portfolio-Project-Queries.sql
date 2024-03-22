Select *
From [Portfolio Project].dbo.Nashvillehousing


--standard Date Format

Select saleDateConverted, CONVERT(Date,SaleDate)
From [Portfolio Project].dbo.Nashvillehousing


Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)


ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


--Populate Property Address data

Select *
From [Portfolio Project].dbo.Nashvillehousing
--Where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Portfolio Project].dbo.Nashvillehousing a
JOIN [Portfolio Project].dbo.Nashvillehousing b
  on a.ParcelID = b.ParcelID
  AND a. [UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Portfolio Project].dbo.Nashvillehousing a
JOIN [Portfolio Project].dbo.Nashvillehousing b
  on a.ParcelID = b.ParcelID
  AND a. [UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null



--Breaking out Address into Individual Columns(Address,City, State)

Select *
From [Portfolio Project].dbo.Nashvillehousing
--Where PropertyAddress is null
order by ParcelID

Select
SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) as Address


From [Portfolio Project].dbo.Nashvillehousing


ALTER TABLE Nashvillehousing
Add PropertySplitAddress nvarchar(255);

Update Nashvillehousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE Nashvillehousing
Add PropertySplitCity nvarchar(255);

Update Nashvillehousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))


Select *
From [Portfolio Project].dbo.Nashvillehousing







Select OwnerAddress
From [Portfolio Project].dbo.Nashvillehousing

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
from [Portfolio Project].dbo.Nashvillehousing





ALTER TABLE Nashvillehousing
Add OwnerSplitAddresses Nvarchar(255);

Update Nashvillehousing
SET OwnerSplitAddresses = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE Nashvillehousing
Add OwnerSplitCity nvarchar(255);

Update Nashvillehousing
SET PropertySplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE Nashvillehousing
Add OwnerSplitState nvarchar(255);

Update Nashvillehousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


Select *
From [Portfolio Project].dbo.Nashvillehousing




--Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
from [Portfolio Project].dbo.Nashvillehousing
Group by SoldAsVacant
order by 2


Select SoldAsVacant
, CASE When SoldAsvacant = 'Y' THEN 'YES'
       When SoldAsvacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END
from [Portfolio Project].dbo.Nashvillehousing


Update Nashvillehousing
SET SoldAsvacant = CASE When SoldAsvacant = 'Y' THEN 'YES'
       When SoldAsvacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END
	   from [Portfolio Project].dbo.Nashvillehousing




	 --Remove Duplicates

WITH RowNumCTE AS(
 Select *,
     ROW_NUMBER() OVER (
	 PARTITION BY ParcelID,
	              PropertySPlitAddress,
			      SalePrice,
			      SaleDate,
			      LegalReference
			      ORDER BY
			          UniqueID
			          ) row_num
from [Portfolio Project].dbo.Nashvillehousing
--order by ParcelID
)
 Select *
From RowNumCTE
Where row_num > 1
Order by PropertySPlitAddress



 Select *
 from [Portfolio Project].dbo.Nashvillehousing



--Delete Unused Columns ( Cleaning DATA )

 Select *
 from [Portfolio Project].dbo.Nashvillehousing

ALTER TABLE [Portfolio Project].dbo.Nashvillehousing
DROP COLUMN OwnerSPlitAddress, FullBath, PropertySPlitAddress

