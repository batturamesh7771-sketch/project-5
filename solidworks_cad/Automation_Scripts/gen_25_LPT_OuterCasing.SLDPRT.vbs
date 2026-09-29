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
skMgr.CreateCenterLine 0, 0, 0, 7.0, 0, 0

skMgr.CreateLine 4.78, 0.58, 0, 4.78, 0.64, 0
skMgr.CreateLine 4.78, 0.64, 0, 6.12, 0.74, 0
skMgr.CreateLine 6.12, 0.74, 0, 6.12, 0.67, 0
skMgr.CreateLine 6.12, 0.67, 0, 4.78, 0.58, 0

featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, True, True, True


ret = model.SaveAs3("C:\Users\user\.gemini\antigravity\scratch\GE90_115B_Turbofan_Engine\Parts\25_LPT_OuterCasing.SLDPRT", 0, 1)
swApp.CloseDoc model.GetTitle
WScript.Echo "SUCCESS: Generated 25_LPT_OuterCasing.SLDPRT"
