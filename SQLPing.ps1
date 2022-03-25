param(
	[string]$SQLInst="localhost",
	[string]$Centraldb="CentralDB"
	)
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO') | out-null
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.ConnectionInfo') | out-null
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SqlWmiManagement') | out-null

Write-Output "Connectting to [$Centraldb]@{$SQLInst}"

$cn = new-object system.data.sqlclient.sqlconnection("server=$SQLInst;database=$CentralDB;Integrated Security=true;");
$cn.Open()
$cmd = $cn.CreateCommand()
# Fetch Server list into the Data source from Srv.ServerList Table from CentralDB
$query = "SELECT DISTINCT ServerName, InstanceName FROM [Svr].[ServerList] WHERE   SQLPing = 'True' AND (PingSnooze IS NULL OR PingSnooze <= GETDATE()) AND ((MaintStart IS NULL) or (MaintEnd IS NULL) or (GETDATE() NOT BETWEEN MaintStart AND MaintEnd ))"
$cmd.CommandText = $query
$reader = $cmd.ExecuteReader()
while($reader.Read()) {
 
   	# Get ServerName and InstanceName from CentralDB
	$server = $reader['ServerName']
	$instance = $reader['InstanceName']
	#Increase the Count if you are having timeout and getting false positives
	if(test-connection -computername $Server -count 3 -delay 1 -quiet)
	{
		# Check SQL Services are running or not
        Write-Host "Able to ping $server"

		$res = new-object Microsoft.SqlServer.Management.Common.ServerConnection($instance)
		$resp = $false
			if ($res.ProcessID -ne $null) {
			       $resp = $true
    		}

    		If (!$resp) {
                   Write-Host "Not able to login to $instance"
		           #Send-MailMessage -To "Them@mycompany.com" -From "Me@myCompany.com" -SmtpServer "exchangeServer.myCompany.com" -Subject "CentralDB: Unable to connect to $instance" -body "Unable to connect to $instance Instance. Please make sure if you are able to RDP to the box and Check SQL Services. "
		    }
            else { Write-Host "Able to login to $instance"}


	}
	else {
		#Send-MailMessage -To "Them@mycompany.com" -From "Me@myCompany.com" -SmtpServer "exchangeServer.myCompany.com" -Subject "CentralDB: Unable to ping $server" -body "Unable to ping $server Server. Please make sure if you are able to RDP to the box and Check SQL Services. "
	}  	
}


