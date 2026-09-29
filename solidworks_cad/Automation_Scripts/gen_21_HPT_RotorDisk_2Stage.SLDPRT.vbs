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


' 2-stage HPT disk: X=4.48m to 4.75m, R=0.25m to 0.45m
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 5.5, 0, 0

skMgr.CreateLine 4.48, 0.25, 0, 4.48, 0.45, 0
skMgr.CreateLine 4.48, 0.45, 0, 4.75, 0.46, 0
skMgr.CreateLine 4.75, 0.46, 0, 4.75, 0.25, 0
skMgr.CreateLine 4.75, 0.25, 0, 4.48, 0.25, 0

featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, True, True, True


ret = model.SaveAs3("C:\Users\user\.gemini\antigravity\scratch\GE90_115B_Turbofan_Engine\Parts\21_HPT_RotorDisk_2Stage.SLDPRT", 0, 1)
swApp.CloseDoc model.GetTitle
WScript.Echo "SUCCESS: Generated 21_HPT_RotorDisk_2Stage.SLDPRT"
