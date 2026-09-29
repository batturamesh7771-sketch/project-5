$dllPath = (Get-ChildItem -Path "C:\Program Files\SOLIDWORKS Corp" -Recurse -Filter "SolidWorks.Interop.sldworks.dll" | Select-Object -First 1).FullName
Write-Host "DLL: $dllPath"
$asm = [System.Reflection.Assembly]::LoadFrom($dllPath)
$type = $asm.GetType("SolidWorks.Interop.sldworks.IAssemblyDoc")
$type.GetMethods() | Where-Object { $_.Name -like "AddComponent*" -or $_.Name -like "*InsertComponent*" } | ForEach-Object {
    $params = ($_.GetParameters() | ForEach-Object { "$($_.ParameterType.Name) $($_.Name)" }) -join ", "
    Write-Host "$($_.ReturnType.Name) $($_.Name)($params)"
}
