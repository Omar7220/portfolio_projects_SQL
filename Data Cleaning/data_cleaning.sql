select * from  nashvilleHousing ;


--standrize the date format 

Alter table nashvilleHousing 
add sales_date_new_format date

update nashvilleHousing
set sales_date_new_format = convert(date,SaleDate)

select sales_date_new_format , Convert(date,saleDate) 
from nashvilleHousing


--populate property address data (some parcellIDs has null addresses )


select a.ParcelID , a.propertyAddress , b.ParcelID , b.propertyAddress 
from nashvilleHousing a 
join nashvilleHousing b 
on a.ParcelID = b.ParcelID 
and a.UniqueID <> b.UniqueID 
where a.propertyAddress is null

update a 
set propertyAddress = ISnull(a.propertyAddress,b.propertyAddress) 
from nashvilleHousing a 
join nashvilleHousing b 
on a.ParcelID = b.ParcelID 
and a.UniqueID <> b.UniqueID 
where a.propertyAddress is null



--convert the address format into individual columns (add , city , sate)

select substring (propertyAddress , 1 , CHARINDEX(',',propertyAddress)-1) as  address , 
SUBSTRING(propertyAddress , CHARINDEX(',',propertyAddress)+1,len(propertyAddress ))
from nashvilleHousing


Alter table nashvilleHousing 
add newaddress_format nvarchar(255)

update nashvilleHousing
set newAddress_format = substring (propertyAddress , 1 , CHARINDEX(',',propertyAddress)-1)

Alter table nashvilleHousing 
add newaCity_format nvarchar(255)

update nashvilleHousing
set newaCity_format = SUBSTRING(propertyAddress , CHARINDEX(',',propertyAddress)+1,len(propertyAddress ))


select newaCity_format , newAddress_format from nashvilleHousing 



--separate the owner address 

select owneraddress from nashvilleHousing

select PARSENAME(replace(owneraddress , ',' , '.' ) , 3 ) ,
       PARSENAME(replace(owneraddress , ',' , '.' ) , 2 ) ,
       PARSENAME(replace(owneraddress , ',' , '.' ) , 1 )
from nashvilleHousing


Alter table nashvilleHousing 
add ownersplit_Address nvarchar(255)

update nashvilleHousing
set ownersplit_Address = PARSENAME(replace(owneraddress , ',' , '.' ) , 3 )

Alter table nashvilleHousing 
add ownersplit_City nvarchar(255)

update nashvilleHousing
set ownersplit_City = PARSENAME(replace(owneraddress , ',' , '.' ) , 2 )

Alter table nashvilleHousing 
add ownersplit_State nvarchar(255)

update nashvilleHousing
set ownersplit_State = PARSENAME(replace(owneraddress , ',' , '.' ) , 1 )


select ownersplit_Address , ownersplit_City , ownersplit_State from nashvilleHousing


--change Y and N into Yes and No in "sold as vacant" 

select SoldAsVacant ,
case when SoldAsVacant = 'Y' then 'Yes'
            when SoldAsVacant = 'N' then 'No'
			else SoldAsVacant
			End           
from nashvilleHousing


update nashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
            when SoldAsVacant = 'N' then 'No'
			else SoldAsVacant
			End 


select SoldAsVacant  , count(SoldAsVacant)  
from nashvilleHousing
group by SoldAsVacant 
order by 2 



--remove duplicates 

with rownum_CTE as (
select * , 
ROW_NUMBER() over (
partition by parcelID ,
			 saleprice,
			 saleDate,
			 legalReference,
			 propertyAddress
			 order by uniqueID 
) row_num

from nashvilleHousing

)

select * from rownum_CTE
where row_num > 1 


--delete the columns that been updated 

alter table nashvilleHousing 
drop column propertyAddress , owneraddress 

alter table nashvilleHousing 
drop column saledate 

