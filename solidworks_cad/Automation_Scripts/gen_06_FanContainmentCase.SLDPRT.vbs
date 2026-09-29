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


' Revolved Kevlar containment cylinder with mounting flanges (X=0.70m to 2.20m, R=1.63m to 1.70m)
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 3.0, 0, 0

' Main barrel and forward/aft flanges
skMgr.CreateLine 0.70, 1.63, 0, 0.70, 1.75, 0
skMgr.CreateLine 0.70, 1.75, 0, 0.75, 1.75, 0
skMgr.CreateLine 0.75, 1.75, 0, 0.75, 1.68, 0
skMgr.CreateLine 0.75, 1.68, 0, 2.15, 1.68, 0
skMgr.CreateLine 2.15, 1.68, 0, 2.15, 1.75, 0
skMgr.CreateLine 2.15, 1.75, 0, 2.20, 1.75, 0
skMgr.CreateLine 2.20, 1.75, 0, 2.20, 1.63, 0
skMgr.CreateLine 2.20, 1.63, 0, 0.70, 1.63, 0

featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, True, True, True


ret = model.SaveAs3("C:\Users\user\.gemini\antigravity\scratch\GE90_115B_Turbofan_Engine\Parts\06_FanContainmentCase.SLDPRT", 0, 1)
swApp.CloseDoc model.GetTitle
WScript.Echo "SUCCESS: Generated 06_FanContainmentCase.SLDPRT"
