Param(
	[Parameter(Position = 0, Mandatory = $true)]
	[String]
	$ProjectName,

    [Parameter(Position = 1, Mandatory = $true)]
	[String]
	$RURL,

    [Parameter(Position = 2, Mandatory = $true)]
	[String]
	$tagv,

    [Parameter(Position = 3, Mandatory = $false)]
	[String]
	$hbranch
)


write-output $ProjectName
write-output $RURL
write-output $tagv
write-output $hbranch




If (!$hbranch) {  
    Write-Host "null $hbranch"
    } else { Write-Host "Not null $hbranch" }
