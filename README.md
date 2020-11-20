# azureWVD

Run begin.ps1 in the Scripts folder
    This will connect to Azure
    Create admin accounts and groups and add admins
    Register the provider
    Create Resource Groups needed

Run AADDS_KeyVault_Automation.ps1
    This will use ARM templates to deploy
        AADDS
        KeyVault
        Automation

Run uploadNodeConfiguration.ps1
    This will upload the provisionVM DSC config to the Automation account

Run deployAADDSmanagement.ps1
    This will deploy the AADDS management VM

Run RegisterAADDS_MGMT.ps1
    This will add the DSC node configuration to the VM and install AD Tools and Group Policy Management

Run UpdateDNSforAADDS.ps1
    This will update the DNS on the vnet to point to the AADDS installation

    



