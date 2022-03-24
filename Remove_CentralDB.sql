/*  Fork @https://github.com/hyliangca/CentralDB
	By Henry Liang, hyliangca@gmail.com

	To execute from command line :
		sqlcmd -S . -i Remove_CentralDB.sql
*/
USE [msdb]
GO

/* Delete jobs */
IF EXISTS (SELECT job_id FROM msdb.dbo.sysjobs_view WHERE name = N'CentralDB: Baseline Stats')
EXEC sp_delete_job @job_name = N'CentralDB: Baseline Stats' , @delete_unused_schedule=1

IF EXISTS (SELECT job_id FROM msdb.dbo.sysjobs_view WHERE name = N'CentralDB: Server Ping Status')
EXEC sp_delete_job @job_name = N'CentralDB: Server Ping Status' , @delete_unused_schedule=1

IF EXISTS (SELECT job_id FROM msdb.dbo.sysjobs_view WHERE name = N'CentralDB: SQL Server Inventory')
EXEC sp_delete_job @job_name = N'CentralDB: SQL Server Inventory' , @delete_unused_schedule=1

IF EXISTS (SELECT job_id FROM msdb.dbo.sysjobs_view WHERE name = N'CentralDB: Wait Stats')
EXEC sp_delete_job @job_name = N'CentralDB: Wait Stats' , @delete_unused_schedule=1

GO

/* Delete DB */
USE [master]
GO
ALTER DATABASE [CentralDB] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
GO
USE [master]
GO
/****** Object:  Database [CentralDB]    Script Date: 3/24/2022 12:07:53 PM ******/
DROP DATABASE [CentralDB]
GO

