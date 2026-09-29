Option Explicit
Dim swApp, model, skMgr, featMgr, partPath, ret

Set swApp = CreateObject("SldWorks.Application")
swApp.Visible = True

' Create new part
Set model = swApp.NewDocument("C:\ProgramData\SOLIDWORKS\SOLIDWORKS 2026\templates\Part.PRTDOT", 0, 0, 0)
Set skMgr = model.SketchManager
Set featMgr = model.FeatureManager

' Select Front Plane
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True

' Centerline along X-axis
skMgr.CreateCenterLine 0, 0, 0, 1.2, 0, 0

' Outer contour
skMgr.CreateLine 0, 0, 0, 0.25, 0.20, 0
skMgr.CreateLine 0.25, 0.20, 0, 0.55, 0.38, 0
skMgr.CreateLine 0.55, 0.38, 0, 0.85, 0.50, 0
skMgr.CreateLine 0.85, 0.50, 0, 0.90, 0.54, 0
skMgr.CreateLine 0.90, 0.54, 0, 0.92, 0.54, 0
skMgr.CreateLine 0.92, 0.54, 0, 0.92, 0.46, 0
skMgr.CreateLine 0.92, 0.46, 0, 0.85, 0.46, 0
skMgr.CreateLine 0.85, 0.46, 0, 0.55, 0.35, 0
skMgr.CreateLine 0.55, 0.35, 0, 0.25, 0.17, 0
skMgr.CreateLine 0.25, 0.17, 0, 0.05, 0, 0
skMgr.CreateLine 0.05, 0, 0, 0, 0, 0

' Revolve 360 deg
Dim revFeat
Set revFeat = featMgr.FeatureRevolve2(True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, True, True, True)

partPath = "C:\Users\user\.gemini\antigravity\scratch\GE90_115B_Turbofan_Engine\Parts\01_SpinnerCone.SLDPRT"
ret = model.SaveAs3(partPath, 0, 1)
WScript.Echo "SaveAs3 returned: " & ret
swApp.CloseDoc model.GetTitle
WScript.Echo "Part generated and closed successfully!"
