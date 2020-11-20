Configuration AADDSmgmt {

    Import-DscResource -ModuleName PsDesiredStateConfiguration  

    Node "localhost" {

        WindowsFeature ActiveDirectoryTools  {
            Name = 'RSAT-AD-Tools'
            Ensure = 'Present'
        }

        WindowsFeature ActiveDirectoryAdminCenter {
            Name = 'RSAT-AD-AdminCenter'
            Ensure = 'Present'
            DependsOn = "[WindowsFeature]ActiveDirectoryTools" 
        }
        
        WindowsFeature ActiveDirectoryPowershell {  
            Ensure = "Present"  
            Name  = "RSAT-AD-PowerShell"  
            DependsOn = "[WindowsFeature]ActiveDirectoryAdminCenter"  
        }

        WindowsFeature GPMC {
            Name = 'GPMC'
            Ensure = 'Present'
            DependsOn = "[WindowsFeature]ActiveDirectoryPowershell" 
        }
    }
}