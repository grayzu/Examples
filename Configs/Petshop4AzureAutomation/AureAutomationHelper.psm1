﻿Function Select-AzureResourceGroup
{
    param(
        [parameter(Mandatory)]
        [String]
        $AutomatinonAccountName,

        [parameter(Mandatory)]
        [String]
        $ResourceGroupName
    )

    $PSDefaultParameterValues = @{
        "Get-AzureAutomationDscCompilationJob:ResourceGroupName"="$ResourceGroupName";
        "Get-AzureAutomationDscCompilationJob:AutomationAccountName"="$AutomatinonAccountName";
        "Get-AzureAutomationDscCompilationJobOutput:ResourceGroupName"="$ResourceGroupName";
        "Get-AzureAutomationDscCompilationJobOutput:AutomationAccountName"="$AutomatinonAccountName";
        "Get-AzureAutomationDscConfiguration:ResourceGroupName"="$ResourceGroupName";
        "Get-AzureAutomationDscConfiguration:AutomationAccountName"="$AutomatinonAccountName";
        "Get-AzureAutomationDscNode:ResourceGroupName"="$ResourceGroupName";
        "Get-AzureAutomationDscNode:AutomationAccountName"="$AutomatinonAccountName";
        "Get-AzureAutomationDscNodeConfiguration:ResourceGroupName"="$ResourceGroupName";
        "Get-AzureAutomationDscNodeConfiguration:AutomationAccountName"="$AutomatinonAccountName";
        "Get-AzureAutomationDscOnboardingMetaconfig:ResourceGroupName"="$ResourceGroupName";
        "Get-AzureAutomationDscOnboardingMetaconfig:AutomationAccountName"="$AutomatinonAccountName";
        "Get-AzureAutomationModule:ResourceGroupName"="$ResourceGroupName";
        "Get-AzureAutomationModule:AutomationAccountName"="$AutomatinonAccountName";
        "Get-AzureAutomationRegistrationInfo:ResourceGroupName"="$ResourceGroupName";
        "Get-AzureAutomationRegistrationInfo:AutomationAccountName"="$AutomatinonAccountName";
        "Import-AzureAutomationDscConfiguration:ResourceGroupName"="$ResourceGroupName";
        "Import-AzureAutomationDscConfiguration:AutomationAccountName"="$AutomatinonAccountName";
        "New-AzureAutomationKey:ResourceGroupName"="$ResourceGroupName";
        "New-AzureAutomationKey:AutomationAccountName"="$AutomatinonAccountName";
        "New-AzureAutomationModule:ResourceGroupName"="$ResourceGroupName";
        "New-AzureAutomationModule:AutomationAccountName"="$AutomatinonAccountName";
        "Register-AzureAutomationDscNode:ResourceGroupName"="$ResourceGroupName";
        "Register-AzureAutomationDscNode:AutomationAccountName"="$AutomatinonAccountName";
        "Remove-AzureAutomationAccount:ResourceGroupName"="$ResourceGroupName";
        "Remove-AzureAutomationAccount:AutomationAccountName"="$AutomatinonAccountName";
        "Remove-AzureAutomationModule:ResourceGroupName"="$ResourceGroupName";
        "Remove-AzureAutomationModule:AutomationAccountName"="$AutomatinonAccountName";
        "Set-AzureAutomationDscNode:ResourceGroupName"="$ResourceGroupName";
        "Set-AzureAutomationDscNode:AutomationAccountName"="$AutomatinonAccountName";
        "Set-AzureAutomationModule:ResourceGroupName"="$ResourceGroupName";
        "Set-AzureAutomationModule:AutomationAccountName"="$AutomatinonAccountName";
        "Start-AzureAutomationDscCompilationJob:ResourceGroupName"="$ResourceGroupName";
        "Start-AzureAutomationDscCompilationJob:AutomationAccountName"="$AutomatinonAccountName";
        "Unregister-AzureAutomationDscNode:ResourceGroupName"="$ResourceGroupName";
        "Unregister-AzureAutomationDscNode:AutomationAccountName"="$AutomatinonAccountName"
    }
}