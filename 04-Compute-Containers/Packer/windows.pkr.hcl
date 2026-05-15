packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = ">= 2.1.6"
    }
  }
}

source "azure-arm" "AVD" {
  azure_tags = {
    createdBy = "Brian Veldman"
    website = "CloudTips.nl"
    environment = "prod"
  }
  build_resource_group_name           = "rg-packer-dev"
  client_id                           = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
  client_secret                       = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
  communicator                        = "winrm"
  image_offer                         = "office-365"
  image_publisher                     = "MicrosoftWindowsDesktop"
  image_sku                           = "win11-23h2-avd-m365"
  managed_image_name                  = "packerImage-prod"
  managed_image_resource_group_name   = "rg-images-prod"
  managed_image_storage_account_type  = "Premium_LRS"
  os_type                             = "Windows"
  subscription_id                     = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
  tenant_id                           = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
  vm_size                             = "Standard_D4ds_v5"
  winrm_insecure                      = true
  winrm_timeout                       = "5m"
  winrm_use_ssl                       = true
  winrm_username                      = "packer"
  public_ip_sku                       = "Standard"
}

build {
  sources = ["source.azure-arm.AVD"]

  #Chocolatey Installation + Some Apps
  provisioner "powershell" {
    inline = ["Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))",
              "choco install adobereader -y",
              "choco install googlechrome -y"
    ]
  }

  #Sysprep
  provisioner "powershell" {
    inline = [
      "& $env:SystemRoot\\System32\\Sysprep\\Sysprep.exe /oobe /generalize /quiet /quit",
      "while($true) { $imageState = Get-ItemProperty HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Setup\\State | Select ImageState; if($imageState.ImageState -ne 'IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE') { Write-Output $imageState.ImageState; Start-Sleep -s 10  } else { break } }"
    ]
  }
}
