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


' Radial aerodynamic strut spanning R=0.55m to R=1.63m at X=1.70m to 1.95m
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateLine 1.70, 0.55, 0, 1.70, 1.63, 0
skMgr.CreateLine 1.70, 1.63, 0, 1.95, 1.63, 0
skMgr.CreateLine 1.95, 1.63, 0, 1.95, 0.55, 0
skMgr.CreateLine 1.95, 0.55, 0, 1.70, 0.55, 0

featMgr.FeatureExtrusion3 True, False, False, 0, 0, 0.035, 0.01, False, False, False, False, 0, 0, False, False, False, False, True, True, True, 0, 0, False


ret = model.SaveAs3("C:\Users\user\.gemini\antigravity\scratch\GE90_115B_Turbofan_Engine\Parts\07_OutletGuideVane_OGV.SLDPRT", 0, 1)
swApp.CloseDoc model.GetTitle
WScript.Echo "SUCCESS: Generated 07_OutletGuideVane_OGV.SLDPRT"
