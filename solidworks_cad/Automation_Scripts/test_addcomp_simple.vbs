Option Explicit
Dim swApp, asmDoc, res, partPath

Set swApp = CreateObject("SldWorks.Application")
Set asmDoc = swApp.NewDocument("C:\ProgramData\SOLIDWORKS\SOLIDWORKS 2026\templates\Assembly.ASMDOT", 0, 0, 0)

partPath = "C:\Users\user\.gemini\antigravity\scratch\GE90_115B_Turbofan_Engine\Parts\01_SpinnerCone.SLDPRT"
res = asmDoc.AddComponent(partPath, 0.0, 0.0, 0.0)
WScript.Echo "AddComponent result: " & res

Dim asmPath, ret
asmPath = "C:\Users\user\.gemini\antigravity\scratch\GE90_115B_Turbofan_Engine\Subassemblies\ASM_01_Fan_Spinner.SLDASM"
ret = asmDoc.SaveAs3(asmPath, 0, 1)
WScript.Echo "Saved: " & ret

swApp.CloseDoc asmDoc.GetTitle
