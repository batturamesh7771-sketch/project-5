Option Explicit
Dim swApp, asmDoc, comp, partPath

Set swApp = CreateObject("SldWorks.Application")
Set asmDoc = swApp.NewDocument("C:\ProgramData\SOLIDWORKS\SOLIDWORKS 2026\templates\Assembly.ASMDOT", 0, 0, 0)

partPath = "C:\Users\user\.gemini\antigravity\scratch\GE90_115B_Turbofan_Engine\Parts\01_SpinnerCone.SLDPRT"
Set comp = asmDoc.AddComponent4(partPath, "", 0, 0, 0)
WScript.Echo "AddComponent4 result: " & (Not comp Is Nothing)
swApp.CloseDoc asmDoc.GetTitle
