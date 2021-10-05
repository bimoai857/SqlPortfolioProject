select * from PortfolioProject2.dbo.NashvilleHousing;

--Converting the saleDate column to a standard format.
alter table PortfolioProject2.dbo.NashvilleHousing
add saleDateConverted date;

update PortfolioProject2.dbo.NashvilleHousing set saleDateConverted=convert(date,saleDate);

select saleDateConverted from PortfolioProject2.dbo.NashvilleHousing;


--Populating PropertyAddress
select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress from PortfolioProject2.dbo.NashvilleHousing a
join PortfolioProject2.dbo.NashvilleHousing b on a.ParcelID=b.ParcelID AND a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null;

update a 
SET a.PropertyAddress= ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject2.dbo.NashvilleHousing a
join PortfolioProject2.dbo.NashvilleHousing b on a.ParcelID=b.ParcelID AND a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null;

--Breaking out address into individual columns(Address, City, State)
--propertyAddress
alter table PortfolioProject2.dbo.NashvilleHousing
add PropertySplitAddress NVARCHAR(255);

update PortfolioProject2.dbo.NashvilleHousing set PropertySplitAddress=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1);


alter table PortfolioProject2.dbo.NashvilleHousing
add PropertySplitCity NVARCHAR(255);



update PortfolioProject2.dbo.NashvilleHousing set PropertySplitCity=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress));



--OwnerAddress
alter table PortfolioProject2.dbo.NashvilleHousing
add OwnerSplitAddress NVARCHAR(255);

update PortfolioProject2.dbo.NashvilleHousing set OwnerSplitAddress=parsename(replace(OwnerAddress,',','.'),3);


alter table PortfolioProject2.dbo.NashvilleHousing
add OwnerSplitCity NVARCHAR(255);

update PortfolioProject2.dbo.NashvilleHousing set OwnerSplitCity=parsename(replace(OwnerAddress,',','.'),2);


alter table PortfolioProject2.dbo.NashvilleHousing
add OwnerSplitState NVARCHAR(255);

update PortfolioProject2.dbo.NashvilleHousing set OwnerSplitState=parsename(replace(OwnerAddress,',','.'),1);




update PortfolioProject2.dbo.NashvilleHousing set SoldAsVacant=
CASE when SoldAsVacant='Y' then 'Yes'
     when  SoldAsVacant='N' then 'No'
	 else  SoldAsVacant
	 END

--Removing Duplicates

WITH RowNumCTE AS(

SELECT * ,
 ROW_NUMBER() OVER(
 PARTITION BY ParcelID,PropertyAddress,SaleDate,LegalReference ORDER BY UniqueID) row_num
FROM PortfolioProject2.dbo.NashvilleHousing
)

--DELETE from RowNumCTE where row_num>1

select * from RowNumCTE where row_num>1
order by PropertyAddress


--Delete Unused Columns
alter table PortfolioProject2.dbo.NashvilleHousing
drop column OwnerAddress,TaxDistrict,PropertyAddress,SaleDate

select * from PortfolioProject2.dbo.NashvilleHousing;

