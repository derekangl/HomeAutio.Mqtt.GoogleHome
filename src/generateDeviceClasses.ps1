﻿$traitUrl = "https://developers.google.com/assistant/smarthome/guides"
$content = Invoke-WebRequest -Uri $traitUrl

$table = $content.ParsedHtml.getElementsByTagName("table")[0]

$devices = @()
$totalRows=@($table.rows).count
$textInfo = (Get-Culture).TextInfo
for ($idx = 1; $idx -lt $totalRows; $idx++) {
    $row = $table.rows[$idx]
    $cells = @($row.cells)        

    $deviceName = $row.cells[0].innerText
    $deviceId = $row.id
    $deviceDescription = $row.cells[2].innerText
    $deviceSupportedTraits = $row.cells[3].innerText.Split([Environment]::NewLine)

    $device = @{
        name = $textInfo.ToTitleCase($deviceName) -replace "[^a-zA-Z0-9]", ""
        id = $deviceId
        description = $deviceDescription
        supportedTraits = $deviceSupportedTraits
    }

    $devices += $device
}

# Generate DeviceTypes
$deviceTypeFilePath = ".\HomeAutio.Mqtt.GoogleHome\Models\DeviceType.cs"

$deviceTypesHeader = @"
using System.Runtime.Serialization;

namespace HomeAutio.Mqtt.GoogleHome.Models
{
    /// <summary>
    /// Device type enumeration.
    /// </summary>
    public enum DeviceType
    {
"@

$deviceTypesFooter = @"
        /// <summary>
        /// Unknown device type.
        /// </summary>
        Unknown
    }
}
"@

$sb = [System.Text.StringBuilder]::new()
$sb.AppendLine($deviceTypesHeader)

foreach ($device in $devices) {
    $deviceTypeString = @"
        /// <summary>
        /// $($device.id).
        /// </summary>
        [EnumMember(Value = "$($device.id)")]
        $($device.name),

"@

    $sb.AppendLine($deviceTypeString)
}

$sb.AppendLine($deviceTypesFooter)

Set-Content -Path $deviceTypeFilePath -Value $sb.ToString()