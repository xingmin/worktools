[CmdletBinding()]
param(
[Parameter(Mandatory=$True)]
[string]$keshi,
[string]$ip
)
if ($ip -eq $null) {
  $ip = wmic /node:localhost NICCONFIG WHERE IPEnabled=true GET IPAddress
}
$ipn4 = "";
if ($ip -match "\d+.\d+.\d+.\d+"){
	$ipn4 = ($ip -split ".")[3];
}else{
    Write-Host "ip error"
	return;
}
wmic computersystem where name="%computername%" call rename "$keshi$ipn4"
wmic computersystem where name="%computername%" call JoinDomainOrWorkgroup "",0,"WorkGroup","",""
wmic computersystem where name="%computername%" call JoinDomainOrWorkgroup "",1,"yszxhis.com","","yszxhis.com\user"