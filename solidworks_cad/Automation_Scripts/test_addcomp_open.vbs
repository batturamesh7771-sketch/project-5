Option Explicit
Dim swApp, asmDoc, partDoc, comp, partPath, nErrors, nWarnings

Set swApp = CreateObject("SldWorks.Application")

partPath = "C:\Users\user\.gemini\antigravity\scratch\GE90_115B_Turbofan_Engine\Parts\01_SpinnerCone.SLDPRT"
' Open part first
Set partDoc = swApp.OpenDoc6(partPath, 1, 1, "", nErrors, nWarnings)
WScript.Echo "Part open: " & (Not partDoc Is Nothing)

' Create assembly
Set asmDoc = swApp.NewDocument("C:\ProgramData\SOLIDWORKS\SOLIDWORKS 2026\templates\Assembly.ASMDOT", 0, 0, 0)
Set comp = asmDoc.AddComponent4(partPath, "", 0, 0, 0)
WScript.Echo "AddComponent4 after open: " & (Not comp Is Nothing)

swApp.CloseDoc asmDoc.GetTitle
swApp.CloseDoc partDoc.GetTitle
