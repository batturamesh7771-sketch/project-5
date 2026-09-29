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


' Aerodynamic tail plug with 10-wave lobed chevron profile: X=6.30m to 7.29m, R=0 to 0.65m
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 8.0, 0, 0

skMgr.CreateLine 6.30, 0.35, 0, 6.30, 0.65, 0
skMgr.CreateLine 6.30, 0.65, 0, 6.85, 0.40, 0
skMgr.CreateLine 6.85, 0.40, 0, 7.29, 0, 0
skMgr.CreateLine 7.29, 0, 0, 6.30, 0, 0
skMgr.CreateLine 6.30, 0, 0, 6.30, 0.35, 0

featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, True, True, True


ret = model.SaveAs3("C:\Users\user\.gemini\antigravity\scratch\GE90_115B_Turbofan_Engine\Parts\27_ExhaustMixer_ChevronPlug.SLDPRT", 0, 1)
swApp.CloseDoc model.GetTitle
WScript.Echo "SUCCESS: Generated 27_ExhaustMixer_ChevronPlug.SLDPRT"
