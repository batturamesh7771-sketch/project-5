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


' Revolved 180 degrees (bottom half)
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 4.0, 0, 0

skMgr.CreateLine 1.88, -0.58, 0, 1.88, -0.65, 0
skMgr.CreateLine 1.88, -0.65, 0, 3.42, -0.60, 0
skMgr.CreateLine 3.42, -0.60, 0, 3.42, -0.54, 0
skMgr.CreateLine 3.42, -0.54, 0, 1.88, -0.58, 0

featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 3.1415926, 0, False, False, 0.01, 0.01, 0, 0, 0, True, True, True


ret = model.SaveAs3("C:\Users\user\.gemini\antigravity\scratch\GE90_115B_Turbofan_Engine\Parts\14_HPC_SplitCasing_BottomHalf.SLDPRT", 0, 1)
swApp.CloseDoc model.GetTitle
WScript.Echo "SUCCESS: Generated 14_HPC_SplitCasing_BottomHalf.SLDPRT"
