Option Explicit
Dim swApp, model, skMgr, featMgr, ret

Set swApp = CreateObject("SldWorks.Application")
swApp.Visible = True

Set model = swApp.NewDocument("C:\ProgramData\SOLIDWORKS\SOLIDWORKS 2026\templates\Part.PRTDOT", 0, 0, 0)
If model Is Nothing Then
    WScript.Echo "Error: Could not create part document"
    WScript.Quit 1
End If

Set skMgr = model.SketchManager
Set featMgr = model.FeatureManager


model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 0.10, 0, 0

' Revolved bolt: head R=0.008m, shank R=0.005m, length=0.045m
skMgr.CreateLine 0, 0, 0, 0, 0.008, 0
skMgr.CreateLine 0, 0.008, 0, 0.010, 0.008, 0
skMgr.CreateLine 0.010, 0.008, 0, 0.010, 0.005, 0
skMgr.CreateLine 0.010, 0.005, 0, 0.045, 0.005, 0
skMgr.CreateLine 0.045, 0.005, 0, 0.045, 0, 0
skMgr.CreateLine 0.045, 0, 0, 0, 0, 0

featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, True, True, True


ret = model.SaveAs3("C:\Users\user\.gemini\antigravity\scratch\GE90_115B_Turbofan_Engine\Parts\39_Fastener_M10_SocketHeadCapScrew.SLDPRT", 0, 1)
swApp.CloseDoc model.GetTitle
WScript.Echo "SUCCESS: Generated 39_Fastener_M10_SocketHeadCapScrew.SLDPRT"
