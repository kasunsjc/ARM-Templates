#Create Resource Group
$ResourceGroup = (New-AzResourceGroup -Name VM-UpdateMgt -Location "Southeast Asia").ResourceGroupName

#Create ARM Deployment
New-AzResourceGroupDeployment -Name VM-UpdateMgt -ResourceGroupName $ResourceGroup -Mode Incremental -TemplateFile ./201-EnableUpdateManagement/azuredeploy.json -TemplateParameterFile ./201-EnableUpdateManagement/azuredeploy-parm.json -Verbose

#Configure Update Management

$duration = New-TimeSpan -Hours 2
$StartTime = (Get-Date "02:00:00").AddDays(5)
$ImediateUpdateStartTime = (Get-Date).AddHours(1)
[System.DayOfWeek[]]$WeekendDay = [System.DayOfWeek]::Sunday
$AutomationAccountName = (Get-AzAutomationAccount -ResourceGroupName $ResourceGroup).AutomationAccountName 
$LogAnalyticsWorkspaceName = (Get-AzOperationalInsightsWorkspace -ResourceGroupName $ResourceGroup).Name


#Create a Weekly Scedule 
$Schedule = New-AzAutomationSchedule -AutomationAccountName $AutomationAccountName -Name "WeeklyCriticalSecurity" -StartTime $StartTime -WeekInterval 1 -DaysOfWeek $WeekendDay -ResourceGroupName $ResourceGroup -Verbose
#Imediate Update Scedule
$ImediateUpdateSchedule = New-AzAutomationSchedule -AutomationAccountName $AutomationAccountName -Name "FullUpdate" -StartTime $ImediateUpdateStartTime -OneTime -ResourceGroupName $ResourceGroup -Verbose

#Get VM IDs
$VMIDs = (Get-AzVM -ResourceGroupName $ResourceGroup).Id 

#Software Update Weekly configuration
New-AzAutomationSoftwareUpdateConfiguration -ResourceGroupName $ResourceGroup -Schedule $Schedule -Windows -AzureVMResourceId $VMIDs -Duration $duration -IncludedUpdateClassification Critical,Security,Definition -AutomationAccountName $AutomationAccountName -Verbose

#Software Update Onetime configuration
New-AzAutomationSoftwareUpdateConfiguration -ResourceGroupName $ResourceGroup -Schedule $ImediateUpdateSchedule -Windows -AzureVMResourceId $VMIDs -Duration $duration -IncludedUpdateClassification Critical,Security,ServicePack,FeaturePack,UpdateRollup,Updates,Definition -AutomationAccountName $AutomationAccountName -Verbose