function Get-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$DirectoryName,

		[parameter(Mandatory = $true)]
		[System.String]
		$AccountName,

		[ValidateSet("Allow")]
		[System.String]
		$Action = "Allow",

		[parameter(Mandatory = $true)]
		[ValidateSet("Full Control","Modify","Read & Execute","Read Only","Write Only")]
		[System.String]
		$Permission
	)

	#Write-Verbose "Use this cmdlet to deliver information about command processing."

	#Write-Debug "Use this cmdlet to write debug information while troubleshooting."

	$returnValue = @{
		DirectoryName = $DirectoryName
		AccountName = $AccountName
		Action = $Action
		Permission = $Permission
	}

	$returnValue
}


function Set-TargetResource
{
	[CmdletBinding()]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$DirectoryName,

		[parameter(Mandatory = $true)]
		[System.String]
		$AccountName,

		[ValidateSet("Allow")]
		[System.String]
		$Action = "Allow",

		[parameter(Mandatory = $true)]
		[ValidateSet("Full Control","Modify","Read & Execute","Read Only","Write Only")]
		[System.String]
		$Permission
	)

	#Write-Verbose "Use this cmdlet to deliver information about command processing."

	#Write-Debug "Use this cmdlet to write debug information while troubleshooting."

	#Include this line if the resource requires a system reboot.
	#$global:DSCMachineStatus = 1

    $Perm = Get-PermissionAbbreviation $Permission

    switch ($Action)
    {
        "Allow"
        {
            icacls $DirectoryName /grant "${AccountName}:(OI)(CI)$Perm"
            Write-Verbose "Set Grant permission for $AccountName to $Permission."
        }

        #Not implemented
        "Deny"
        {
            #icacls $DirectoryName /deny "${AccountName}:(OI)(CI)$Perm"
            throw "Deny permission not implemented"
        }
    }
}


function Test-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$DirectoryName,

		[parameter(Mandatory = $true)]
		[System.String]
		$AccountName,

		[ValidateSet("Allow")]
		[System.String]
		$Action = "Allow",

		[parameter(Mandatory = $true)]
		[ValidateSet("Full Control","Modify","Read & Execute","Read Only","Write Only")]
		[System.String]
		$Permission
	)
    
    $Perm = Get-PermissionAbbreviation $Permission

    $CurrentPermissions = icacls $DirectoryName 
    Write-Debug "Current permissions for directory ($DirectoryName) have a length of $($CurrentPermissions.Length) and are: $CurrentPermissions." 

    $UserPermissions = $CurrentPermissions | Select-String -Pattern "$AccountName"
    Write-Debug "Permissions that are applicable for $AccountName have a length of $($UserPermissions.Length) are: $UserPermissions."
     
    $MatchPermission = $UserPermissions | Select-String -Pattern "($Perm)"
    Write-Debug "Permissions for user $AccountName that match '$Perm' have a length of $($MatchPermission.Length) are: $MatchPermission."

    if($MatchPermission.Length -eq 0)
    {
        Write-Verbose "Grant permission of '$Permission' for '$AccountName' does not currently exist so will be set."
        return $false
    }
    else
    {
        Write-Verbose "Grant permission of '$Permission' for '$AccountName' already exists so will not be set."
        return $true
    }
}

function Get-PermissionAbbreviation
{
    param(
        [parameter(Mandatory = $true)]
		[System.String]
        $PermissionFullName
    )
    switch ($PermissionFullName)
    {
        "Full Control"
        {
            Return "F"
        }

        "Modify"
        {
            Return "M"
        }

        "Read & Execute"
        {
            Return "RX"
        }


        "Read Only"
        {
            Return "R"
        }

        "Write Only"
        {
            Return "W"
        }
    }
}

Export-ModuleMember -Function *-TargetResource

