param(
[Parameter(Mandatory=$false)]
[string]$keshi,
[string]$ip
)

if (($ip -eq $null) -or ($ip -eq "")) {
  $ip = (Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE -ComputerName .).IPAddress
}
$ipn4 = "";
if ($ip -match  "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}"){
	$ipn4 = ($ip.split("."))[3];
}else{
    Write-Host "ip error"
	return;
}
if (($keshi -eq $null) -or ($keshi -eq "")){
	Write-Host "usage: -keshi AAA"
}
$csname = $env:COMPUTERNAME;
$cs = Get-wmiobject -Class Win32_ComputerSystem -Filter "name=`"$csname`"";
$rt=0;
if(($rt = ($cs.Rename("$keshi-$ipn4")).ReturnValue) -eq 0) { 
	Write-Host "Rename successfull."
}else{
	Write-Host "Rename failed. Error Code $rt"
}


if(($rt = ($cs.JoinDomainOrWorkgroup("WorkGroup", "", "", "", 0)).ReturnValue) -eq 0) { 
	Write-Host "Join workgroup successfull."
}else{
	Write-Host "Join workgroup failed. Error Code $rt"
}

[int]$trytime=0;
while(($rt = ($cs.JoinDomainOrWorkgroup("yszxhis.com", "", "yszxhis.com\user", "", 1)).ReturnValue) -ne 0){
	$trytime = [int]$trytime+1
	if($trytime -gt 10){
		break;
	}
	Write-Host "Setting the domain failed. Retry $trytime times."
}
if($trytime -lt 10){
	Write-Host "Join domain successfull."
}else{
	Write-Host "Join domain failed.Error Code $rt"
}