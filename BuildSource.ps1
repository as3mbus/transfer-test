param(
    [bool]$save=1,
    [bool]$reset=0
) 

$ConfigPath = "./EngineDirectory.txt"

# Load file in Config Path if exist
$engineDirectory = Get-Content -Path $ConfigPath

Function Get-Folder($initialDirectory="")
{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")|Out-Null

    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
    $foldername.Description = "Select Unreal Engine Directory (e.g. C:/EpicGames/UE_5.2)"
    $foldername.rootfolder = "MyComputer"
    $foldername.SelectedPath = $initialDirectory

    if($foldername.ShowDialog() -eq "OK")
    {
        $folder += $foldername.SelectedPath
    }

    return $folder
}

if($null -eq $engineDirectory -or $engineDirectory -eq "" -or $reset)
{
    $engineDirectory = Get-Folder
}

$projectDirectory = $PSScriptRoot
$uprojectFile = Get-ChildItem -Path $projectDirectory -Filter "*.uproject" -File
$uprojectContent = Get-Content $uprojectFile -Raw | ConvertFrom-Json 

$executedScript = "`"$($engineDirectory)\Engine\Build\BatchFiles\Build.bat`" $($uprojectContent.Modules[0].Name)Editor Win64 Development -Project=`"$($uprojectFile.FullName)`" -WaitMutex -FromMsBuild"

Write-Host "Engine Directory : $engineDirectory" 
Write-Host $uprojectFile.BaseName
Write-Host $executedScript

cmd.exe /c $executedScript

if($save)
{
    $engineDirectory | Out-File -FilePath $ConfigPath
}

Read-Host -Prompt "Press Enter to exit"