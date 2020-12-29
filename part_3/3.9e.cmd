 @ECHO OFF
 
sqlcmd -Q "select * from MedicalAppointments.dbo.Illness" -E -W
sqlcmd -Q "select * from MedicalAppointments.dbo.Medicine" -E -W
sqlcmd -Q "select * from MedicalAppointments.dbo.PossibleTreatment" -E -W