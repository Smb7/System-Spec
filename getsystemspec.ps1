# Step 1: Create Temporary Folder and File
$tempFolder = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "SystemSpecs")
if (-not (Test-Path -Path $tempFolder)) {
    New-Item -ItemType Directory -Path $tempFolder -Force
}

$tempFile = [System.IO.Path]::Combine($tempFolder, "system_specs.txt")
if (Test-Path -Path $tempFile) {
    Remove-Item -Path $tempFile -Force
}

# Step 2: Gather System Specifications
$systemSpecs = @()

# Example: Get OS information
$os = Get-CimInstance -ClassName Win32_OperatingSystem
$systemSpecs += "OS Name: $($os.Caption)"
$systemSpecs += "OS Version: $($os.Version)"
$systemSpecs += "OS Architecture: $($os.OSArchitecture)"

# Example: Get CPU information
$cpu = Get-CimInstance -ClassName Win32_Processor
$systemSpecs += "CPU: $($cpu.Name)"
$systemSpecs += "CPU Cores: $($cpu.NumberOfCores)"
$systemSpecs += "CPU Logical Processors: $($cpu.NumberOfLogicalProcessors)"

# Example: Get RAM information
$ram = Get-CimInstance -ClassName Win32_PhysicalMemory
$totalRAM = ($ram.Capacity | Measure-Object -Sum).Sum
$totalRAMGB = [math]::Round($totalRAM / 1GB, 2)
$systemSpecs += "Total RAM: $totalRAMGB GB"

# Example: Get Disk information
$disk = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3"
foreach ($d in $disk) {
    $systemSpecs += "Drive $($d.DeviceID): $([math]::Round($d.Size / 1GB, 2)) GB, Free Space: $([math]::Round($d.FreeSpace / 1GB, 2)) GB"
}

# Step 3: Write Specifications to the File
$systemSpecs | Out-File -FilePath $tempFile

# Output the location of the temporary file
Write-Host "System specifications have been written to $tempFile"
