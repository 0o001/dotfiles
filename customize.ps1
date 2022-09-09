Function Set-WallPaper($Image) {  

Add-Type -TypeDefinition @" 
using System; 
using System.Runtime.InteropServices;
  
public class Params
{ 
    [DllImport("User32.dll",CharSet=CharSet.Unicode)] 
    public static extern int SystemParametersInfo (Int32 uAction, 
                                                   Int32 uParam, 
                                                   String lpvParam, 
                                                   Int32 fuWinIni);
}
"@ 
  
    $SPI_SETDESKWALLPAPER = 0x0014
    $UpdateIniFile = 0x01
    $SendChangeEvent = 0x02
  
    $fWinIni = $UpdateIniFile -bor $SendChangeEvent
  
    $ret = [Params]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $Image, $fWinIni)
 
}

Function Set-WindowsColor() {
    $RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent"

    #Accent Color Menu Key
    $AccentColorMenuKey = @{
        Key   = 'AccentColorMenu';
        Type  = "DWORD";
        Value = '0xff000000'
    }

    If ($Null -eq (Get-ItemProperty -Path $RegPath -Name $AccentColorMenuKey.Key -ErrorAction SilentlyContinue))
    {
        New-ItemProperty -Path $RegPath -Name $AccentColorMenuKey.Key -Value $AccentColorMenuKey.Value -PropertyType $AccentColorMenuKey.Type -Force
    }
    Else
    {
        Set-ItemProperty -Path $RegPath -Name $AccentColorMenuKey.Key -Value $AccentColorMenuKey.Value -Force
    }


    #Accent Palette Key
    $AccentPaletteKey = @{
        Key   = 'AccentPalette';
        Type  = "BINARY";
        Value = '6b,6b,6b,ff,59,59,59,ff,4c,4c,4c,ff,3f,3f,3f,ff,33,33,33,ff,26,26,26,ff,14,14,14,ff,88,17,98,00'
    }
    $hexified = $AccentPaletteKey.Value.Split(',') | ForEach-Object { "0x$_" }

    If ($Null -eq (Get-ItemProperty -Path $RegPath -Name $AccentPaletteKey.Key -ErrorAction SilentlyContinue))
    {
        New-ItemProperty -Path $RegPath -Name $AccentPaletteKey.Key -PropertyType Binary -Value ([byte[]]$hexified)
    }
    Else
    {
        Set-ItemProperty -Path $RegPath -Name $AccentPaletteKey.Key -Value ([byte[]]$hexified) -Force
    }


    #MotionAccentId_v1.00 Key
    $MotionAccentIdKey = @{
        Key   = 'MotionAccentId_v1.00';
        Type  = "DWORD";
        Value = '0x000000db'
    }

    If ($Null -eq (Get-ItemProperty -Path $RegPath -Name $MotionAccentIdKey.Key -ErrorAction SilentlyContinue))
    {
        New-ItemProperty -Path $RegPath -Name $MotionAccentIdKey.Key -Value $MotionAccentIdKey.Value -PropertyType $MotionAccentIdKey.Type -Force
    }
    Else
    {
        Set-ItemProperty -Path $RegPath -Name $MotionAccentIdKey.Key -Value $MotionAccentIdKey.Value -Force
    }



    #Start Color Menu Key
    $StartMenuKey = @{
        Key   = 'StartColorMenu';
        Type  = "DWORD";
        Value = '0xff000000'
    }

    If ($Null -eq (Get-ItemProperty -Path $RegPath -Name $StartMenuKey.Key -ErrorAction SilentlyContinue))
    {
        New-ItemProperty -Path $RegPath -Name $StartMenuKey.Key -Value $StartMenuKey.Value -PropertyType $StartMenuKey.Type -Force
    }
    Else
    {
        Set-ItemProperty -Path $RegPath -Name $StartMenuKey.Key -Value $StartMenuKey.Value -Force
    }


    Stop-Process -ProcessName explorer -Force -ErrorAction SilentlyContinue
}

$imageLocation = "$(Get-Location)\wallpaper.jpg"
Set-WallPaper -Image $imageLocation

Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{645FF040-5081-101B-9F08-00AA002F954E}" -Force -Verbose
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name AppsUseLightTheme -Value 0
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name 'ShowTaskViewButton' -Type 'DWord' -Value 0
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name 'SearchboxTaskbarMode' -Type 'DWord' -Value 1

Set-WindowsColor

pause
