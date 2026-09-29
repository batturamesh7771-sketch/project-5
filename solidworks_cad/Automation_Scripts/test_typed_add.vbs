Option Explicit
Dim swApp, asmDoc, comp
Dim compName, cfgOpt, cfgName, regId, faceNm, posX, posY, posZ

Set swApp = CreateObject("SldWorks.Application")
Set asmDoc = swApp.NewDocument("C:\ProgramData\SOLIDWORKS\SOLIDWORKS 2026\templates\Assembly.ASMDOT", 0, 0, 0)

compName = "C:\Users\user\.gemini\antigravity\scratch\GE90_115B_Turbofan_Engine\Parts\01_SpinnerCone.SLDPRT"
cfgOpt = CLng(0)
cfgName = ""
regId = CBool(False)
faceNm = ""
posX = CDbl(0)
posY = CDbl(0)
posZ = CDbl(0)

Set comp = asmDoc.AddComponent5(compName, cfgOpt, cfgName, regId, faceNm, posX, posY, posZ)
WScript.Echo "AddComponent5 result: " & (Not comp Is Nothing)
If Not comp Is Nothing Then
    WScript.Echo "Component Name: " & comp.Name2
End If
swApp.CloseDoc asmDoc.GetTitle
