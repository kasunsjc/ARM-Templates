Configuration InstallIIS
{
Import-DscResource -ModuleName PSDesiredStateConfiguration
Node localhost
  {
    WindowsFeatureSet WebCommonHttp
    {
      Name = @("Web-Default-Doc", "Web-Dir-Browsing", "Web-Http-Errors", "Web-Static-Content", "Web-Http-Redirect")
      Ensure = "Present"
    }
    WindowsFeature WebHealth
    {
      Name = "Web-Health"
      IncludeAllSubFeature = $true
      Ensure = "Present"
    }
    WindowsFeature WebPerformance
    {
      Name = "Web-Performance"
      IncludeAllSubFeature = $true
      Ensure = "Present"
    }
    WindowsFeatureSet WebSecurity
    {
      Name = @("Web-Filtering", "Web-Basic-Auth", "Web-Digest-Auth", "Web-IP-Security", "Web-Windows-Auth")
      Ensure = "Present"
    }

    WindowsFeatureSet WebAppDev
    {
      Name = @("Web-Net-Ext", "Web-Net-Ext45", "Web-Asp-Net", "Web-Asp-Net45", "Web-ISAPI-Ext", "Web-ISAPI-Filter")
      Ensure = "Present"
    }
    WindowsFeature WebFtpServer
    {
      Name = "Web-Ftp-Service"
      Ensure = "Present"
    }
    WindowsFeatureSet WebMgmtTools
    {
      Name = @("Web-Mgmt-Console", "Web-Scripting-Tools")
      Ensure = "Present"
    }
    WindowsFeature WebMgmtCompat
    {
        Name = "Web-Mgmt-Compat"
        IncludeAllSubFeature = $true
        Ensure = "Present"
    }
    WindowsFeatureSet NETFramework
    {
        Name = @("NET-Framework-Core", "NET-Framework-45-ASPNET", "NET-WCF-Services45", "NET-WCF-HTTP-Activation45")
        Ensure = "Present"
    }
    WindowsFeatureSet RSAT
    {
        Name = @("RSAT-SMTP", "RSAT-SNMP")
        Ensure = "Present"
    }
    WindowsFeature SMTPServer
    {
        Name = "SMTP-Server"
        Ensure = "Present"
    }
    WindowsFeature SNMPService
    {
        Name = "SNMP-Service"
        IncludeAllSubFeature = $true
        Ensure = "Present"
    }
    WindowsFeature TelnetClient
    {
        Name = "Telnet-Client"
        Ensure = "Present"
    }
    WindowsFeature PowerShellRoot
    {
        Name = "PowerShellRoot"
        IncludeAllSubFeature = $true
        Ensure = "Present"
    }
    WindowsFeatureSet WAS
    {
        Name = @("WAS-Process-Model", "WAS-Config-APIs")
        Ensure = "Present"
    }
    WindowsFeature WindowsServerBackup
    {
        Name = "Windows-Server-Backup"
        Ensure = "Present"
    }
  }
}
