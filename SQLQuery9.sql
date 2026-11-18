--Q01
Begin Transaction 
   Update Patients
   Set Id = 2
   Where Id =1
Commit Transaction

--Q02
Begin Transaction 
  Update Consultants
  Set Salary = 5000
  Where Id = 1
RollBack Transaction

--Q03
Begin Transaction 
  Update Patients
  Set WardId = 3
  Where Id =1

Update Nurses
  Set SupervisedWardId =3
  Where Number =1
Commit Transaction 


--Q04
Begin Transaction 
  Update Patients
  Set WardId = 2
  Where Id =1
Save transaction Patientupdate

update Patients
  Set Name ='Temporary Patient Name'
  Where Id =1
  RollBack Transaction Patientupdate
Commit Transaction 

--Q05
Begin Try 
  Update Consultants
  Set Salary =3000
  Where Id =1
  Commit Transaction
End Try
Begin Catch 
  If @@TRANCOUNT > 0
        Rollback Transaction
Select  ERROR_NUMBER() ,ERROR_MESSAGE()
End Catch

--Q06
Go
Create Or Alter View vw_ConsultantPatientStatistics
As 
  Select C.Name ,C.ID ,C.Salary ,PCA.PatientId ,Count(*) as consultantscount
   From Consultants C
   Join PatientConsultantAssignments PCA On C.Id = PCA.ConsultantId
   Group by  C.Name ,C.ID ,C.Salary ,PCA.PatientId

   --Q07
   Select *
   From vw_ConsultantPatientStatistics
   Where PatientId >5

   --Q08
   Go
   Create Or Alter View vw_IndexedConsultantPatientCount
   With SchemaBinding
   As 
    Select Id ,Salary ,Name , COUNT_BIG(*) As consultantscount
    from dbo.Consultants C
    Group By Id ,Salary, Name

    Create unique Clustered Index IX_vw_IndexedConsultantPatientCount
    on dbo.vw_IndexedConsultantPatientCount(name)

    --Q09
    Select *
    From dbo.vw_IndexedConsultantPatientCount
    Where PatientConsultantAssignments >5

    --Q10
    SELECT 
    name AS ViewName,
    create_date AS CreationDate,
    modify_date AS ModificationDate
FROM sys.views;

--Q11
SELECT definition 
FROM sys.sql_modules 
WHERE object_id = OBJECT_ID('vw_PatientInformation');

--Q12
GO
Create Or Alter View vw_PatientInformation
As
Select ID,  Name,  DOB
FROM Patients

--Q13
Drop view If Exists vw_ConsultantSalary

--Q14
GO
Create or Alter View vw_PatientHospitalReport 
As 
Select P.Id ,P.Name , P.DOB ,W.Name ,C.Name 
From dbo.Patients P
Left join Wards W On W.Id = P.WardId
Left join PatientConsultantAssignments PCA On P.Id =PCA.PatientId
Left join Consultants C On C.Id =PCA.ConsultantId

--Q15
SELECT *
FROM vw_PatientHospitalReport
WHERE C.Name IS NOT NULL

--Q16
SELECT P.Name, W.Name, C.Name
FROM vw_PatientHospitalReport
WHERE W.Name = 'Cardiology'

--Q17
SELECT TOP 1 *
FROM vw_ConsultantPatientStatistics
ORDER BY PatientId DESC;

--Q18
SELECT *
FROM vw_PatientAgeInformation
WHERE Age > 60;

--Q19
SELECT *
FROM vw_ConsultantPatientStatistics
ORDER BY PatientId DESC;

--Q20
SELECT WardName, COUNT(*) AS PatientCount
FROM vw_PatientWardInformation
GROUP BY WardName

--Q21
SELECT 
    sch.name AS SchemaName,
    v.name AS ViewName,
    i.name AS IndexName,
    i.type_desc AS IndexType
FROM sys.indexes i
JOIN sys.views v ON i.object_id = v.object_id
JOIN sys.schemas sch ON v.schema_id = sch.schema_id
WHERE i.index_id > 0