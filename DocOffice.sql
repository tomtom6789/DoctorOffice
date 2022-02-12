create database DocOffice

use DocOffice

create table Person
(PersonID int primary key,
FirstName varchar(50) not null,
LastName varchar(50) not null,
StreetAddress varchar(100) not null,
City varchar(50) not null,
State varchar(50) not null,
Zip varchar(50) not null,
PhoneNumber varchar(50) not null,
SSN varchar(50) not null,)

insert into Person
	Values
		(1, 'Rob', 'Belkin', '1111 E S ST', 'Tacoma', 'WA', '98404', '2222222222', '123121234'),
		(2, 'Will', 'Jones', '2222 E S ST', 'Tacoma', 'WA', '98404', '3333333333', '321323211'),
		(3, 'Sarah', 'Smith', '3333 E S ST', 'Tacoma', 'WA', '98404', '4444444444', '567565678'),
		(4, 'Jame', 'Belkin', '1111 E S ST', 'Tacoma', 'WA', '98404', '2222222222', '123121234'),
		(5, 'Janna', 'Jones', '2222 E S ST', 'Tacoma', 'WA', '98404', '3333333333', '321323211'),
		(6, 'Sandy', 'Belkin', '1111 E S ST', 'Tacoma', 'WA', '98404', '2222222222', '123121234')

Select *
from person 





create table Patient
(PatientID int primary key identity,
SecPhoneNumber varchar(50) not null,
DOB varchar(50) not null,
PersonID int references Person(PersonID))

insert into Patient
	values
		('5555555555', '11/11/1980', 2),
		('6666666666', '11/11/1989', 3),
		('5555555551', '11/11/1980', 5)

Select * From Patient



create table Doctor
(DoctorID varchar(50) primary key,
MedcialDegrees varchar(50),
PersonID int references Person(PersonID))

insert into Doctor
	values
		('RO3283', null, 1),
		('JA1234', null, 4),
		('SA1234', null, 6)

Select * 
From Doctor




create table DoctorSpeciality
(DoctorID varchar(50) references Doctor(DoctorID),
SpecialityID int references Speciality(SpecialityID),
primary key(DoctorID, SpecialityID))

insert into DoctorSpeciality
	values
		('RO3283', 1),
		('JA1234', 2)

Select *
From DoctorSpeciality
		




create table Speciality
(SpecialityID int primary key,
SpecialityName varchar(50) not null)

insert into Speciality
	values
		(1, 'Anesthesioloy'),
		(2, 'Surgeon')

Select *
From Speciality





create table PatientVisit
(VisitID int primary key,
PatientID int references Patient(PatientID),
DoctorID varchar(50) references Doctor(DoctorID),
VisitDate varchar(50) not null,
DocNote varchar(50))

insert into PatientVisit
	values
		(1, 1, 'RO3283', '11/11/2018', null),
		(2, 2, 'RO3283', '11/11/2018', null),
		(3, 3, 'SA1234', '11/11/2018', null)

Select * 
From PatientVisit





create table PVisitTest
(VisitID int references PatientVisit(VisitID),
TestID int references Test(TestID),
primary key(VisitID, TestID))



create table Test
(TestID int primary key,
TestName varchar(50) not null)




create table PVisitPrescription
(VisitID int references PatientVisit(VisitID),
PrescriptionID int references Prescription(PrescriptionID),
primary key(VisitID, PrescriptionID))

insert into PVisitPrescription
	values
		(1, 1),
		(3, 2)
Select *
From PVisitPrescription



create table Prescription
(PrescriptionID int primary key,
PrescriptionName varchar(50) not null)

insert into Prescription
	values 
		(1, 'Panadol'),
		(2, 'Tylenol')

select * 
From Prescription
------------------------------------
/* 2.
Doc Rob Belkin is retiring. We need to inform all his patients, and ask them to select a new doctor.
For this purpose, Create a VIEW that finds the names and Phone numbers of all of Rob's patients.
*/

create view vRobsPatients
as
select FirstName,
	LastName,
	PhoneNumber,
	SecPhoneNumber
from Person as Pe inner join Patient as P
	on Pe.PersonID = P.PersonID
	inner join PatientVisit as Pv
	on Pv.PatientID = P.PatientID
where DoctorID = 'RO3283'

select * from vRobsPatients


---------------------------------------------
/* 3.
Create a view which has First Names, Last Names of all doctors who gave out prescription for Panadol
*/
create view vDoctorPanadolPrescription
as
select FirstName,
	LastName
from Person as P inner join Doctor as D
	on P.PersonID = D.PersonID
	inner join PatientVisit as Pv
	on D.DoctorID = Pv.DoctorID
	inner join PVisitPrescription as Pvp
	on Pv.VisitID = Pvp.VisitID
	inner join Prescription as Pr
	on Pvp.PrescriptionID = Pr.PrescriptionID
where PrescriptionName = 'Panadol'

select * from vDoctorPanadolPrescription


-----------------------------------
/* Create a vew which shows the First Name and Last name of all doctors and their specialty */
Create view VDoctorINFO as
Select FirstName, Lastname, Specialityname
From Person as p inner join Doctor as d
on p.PersonID = d.PersonID inner join DoctorSpeciality as ds
on d.DoctorID = ds.DoctorID inner join Speciality as s
on ds.SpecialityID = s.SpecialityID

Select *
from VDoctorINFO




------------------------------------------------------------
/* 5. Modify the view created in Q4 to show the First Name and Last name of all doctors 
and their specialties ALSO include doctors who DO NOT have any specialty*/
select FirstName,
	LastName,
	SpecialityName
from Person as P inner join Doctor as D
	on P.PersonID = D.PersonID
	left outer join DoctorSpeciality as DS
	on D.DoctorID = DS.DoctorID
	left outer join Speciality as S
	on DS.SpecialityID = S.SpecialityID


---------------------------------------
/* 4.
Create a view which Shows the First Name and Last name of all doctors and their specialty�s
*/
Create view AllDoctorVsSpecialty as 
Select Firstname, Lastname, Specialityname 
From Person as P inner join Doctor as D
on P.PersonID = D.PersonID inner join DoctorSpeciality as Ds
on D.DoctorID = Ds.DoctorID inner join Speciality as S
on Ds.SpecialityID = S.SpecialityID 


select * 
from AllDoctorVsSpecialty

--------------------------------
/* 5. Modify the view created in Q4 to show the First Name and Last name of all doctors 
and their specialties ALSO include doctors who DO NOT have any specialty*/
Create view allDoctor as
Select Firstname, LastName, Specialityname
From Person as P inner join Doctor as D 
on p.PersonID = d.PersonID left join DoctorSpeciality as ds 
on d.DoctorID = ds.DoctorID left join Speciality as S
on ds.SpecialityID = s.SpecialityID 

select *
from allDoctor

/* 6.Create a stored procedure that gives Prescription name and the number patients from 
city of Tacoma with that prescription*/
Create proc TacomaPatientPrescription as
Select count(*) as [Number of Patient], PrescriptionName
From Prescription as P inner join PVisitPrescription as PP  
on P.PrescriptionID =  PP.PrescriptionID inner join PatientVisit as PV
on PP.VisitID = PV.VisitID inner join Patient as PT
on PV.PatientID = PT.PatientID inner join Person as PS
on PT.PersonID = PS.PersonID 
where City = 'Tacoma'
Group by PrescriptionName

exec TacomaPatientPrescription


-------------------------------------------------------------------
/* Create a trigger on DoctorSpecialist show that every time a doctor's specialty */
Create trigger tDoctorUpdated
on DoctorSpeciality 
after update, insert
as begin
Select FirstName, SpecialityID
From DoctorSpeciality as DS inner join Doctor as D
on Ds.DoctorID = D.DoctorId inner join Person as P
on D.PersonId = P.PersonId
end 
declare @Fn  varchar(50), @S int
select @Fn = FirstName, @S= SpecialityID
from inserted 
print(@FN)
print(@S)





