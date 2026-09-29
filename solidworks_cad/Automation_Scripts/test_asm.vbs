Option Explicit
Dim swApp, asmDoc, comp, partPath, asmPath, ret

Set swApp = CreateObject("SldWorks.Application")
swApp.Visible = True

Set asmDoc = swApp.NewDocument("C:\ProgramData\SOLIDWORKS\SOLIDWORKS 2026\templates\Assembly.ASMDOT", 0, 0, 0)
If asmDoc Is Nothing Then
    WScript.Echo "Error creating assembly"
    WScript.Quit 1
End If

partPath = "C:\Users\user\.gemini\antigravity\scratch\GE90_115B_Turbofan_Engine\Parts\01_SpinnerCone.SLDPRT"
Set comp = asmDoc.AddComponent5(partPath, 0, "", False, "", 0, 0, 0)
WScript.Echo "Component added: " & (Not comp Is Nothing)

asmPath = "C:\Users\user\.gemini\antigravity\scratch\GE90_115B_Turbofan_Engine\Subassemblies\test_asm.SLDASM"
ret = asmDoc.SaveAs3(asmPath, 0, 1)
WScript.Echo "Assembly saved, ret = " & ret
swApp.CloseDoc asmDoc.GetTitle
WScript.Echo "Assembly test completed successfully!"
