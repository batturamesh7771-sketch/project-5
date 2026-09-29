Option Explicit
Dim swApp, asmDoc, comp

Set swApp = CreateObject("SldWorks.Application")
Set asmDoc = swApp.NewDocument("C:\ProgramData\SOLIDWORKS\SOLIDWORKS 2026\templates\Assembly.ASMDOT", 0, 0, 0)

On Error Resume Next
Set comp = asmDoc.AddComponent5("C:\Users\user\.gemini\antigravity\scratch\GE90_115B_Turbofan_Engine\Parts\01_SpinnerCone.SLDPRT", 0, "", False, "", 0, 0, 0)
WScript.Echo "Err: " & Err.Description
WScript.Echo "TypeName: " & TypeName(comp)

' Count components in assembly
Dim comps
comps = asmDoc.GetComponents(False)
WScript.Echo "Components count: " & UBound(comps) + 1

swApp.CloseDoc asmDoc.GetTitle
