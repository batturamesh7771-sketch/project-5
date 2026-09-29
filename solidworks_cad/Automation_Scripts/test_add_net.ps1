$dllPath = (Get-ChildItem -Path "C:\Program Files\SOLIDWORKS Corp" -Recurse -Filter "SolidWorks.Interop.sldworks.dll" | Select-Object -First 1).FullName
[System.Reflection.Assembly]::LoadFrom($dllPath) | Out-Null

$sw = New-Object -ComObject SldWorks.Application
$sw.Visible = $true
$asmTemplate = "C:\ProgramData\SOLIDWORKS\SOLIDWORKS 2026\templates\Assembly.ASMDOT"
$asm = $sw.NewDocument($asmTemplate, 0, 0, 0)
$partPath = "C:\Users\user\.gemini\antigravity\scratch\GE90_115B_Turbofan_Engine\Parts\01_SpinnerCone.SLDPRT"

try {
    # Open the part document first into SolidWorks
    $partDoc = $sw.OpenDoc6($partPath, 1, 1, "", [ref]0, [ref]0)
    Write-Host "Part opened: $($partDoc -ne $null)"
    
    # Activate the assembly window
    $sw.ActivateDoc3($asm.GetTitle(), $true, 0, [ref]0) | Out-Null
    
    # Insert component
    $comp = $asm.AddComponent4($partPath, "", 0.0, 0.0, 0.0)
    Write-Host "AddComponent4 returned: $($comp -ne $null)"
    if ($comp -ne $null) {
        Write-Host "Component Name: $($comp.Name2)"
    }
} catch {
    Write-Host "Exception: $_"
}

$asm.SaveAs3("C:\Users\user\.gemini\antigravity\scratch\GE90_115B_Turbofan_Engine\Subassemblies\test_asm_powershell.SLDASM", 0, 1) | Out-Null
$sw.CloseDoc($asm.GetTitle())
if ($partDoc -ne $null) {
    $sw.CloseDoc($partDoc.GetTitle())
}
Write-Host "Done!"
