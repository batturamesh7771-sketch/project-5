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


' 4-stage booster drum: X=1.25m to 1.85m, R=0.25m to 0.54m
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 3.0, 0, 0

skMgr.CreateLine 1.25, 0.25, 0, 1.25, 0.54, 0
skMgr.CreateLine 1.25, 0.54, 0, 1.40, 0.53, 0
skMgr.CreateLine 1.40, 0.53, 0, 1.55, 0.51, 0
skMgr.CreateLine 1.55, 0.51, 0, 1.70, 0.49, 0
skMgr.CreateLine 1.70, 0.49, 0, 1.85, 0.47, 0
skMgr.CreateLine 1.85, 0.47, 0, 1.85, 0.25, 0
skMgr.CreateLine 1.85, 0.25, 0, 1.25, 0.25, 0

featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, True, True, True


ret = model.SaveAs3("C:\Users\user\.gemini\antigravity\scratch\GE90_115B_Turbofan_Engine\Parts\08_LPC_RotorDrum_4Stage.SLDPRT", 0, 1)
swApp.CloseDoc model.GetTitle
WScript.Echo "SUCCESS: Generated 08_LPC_RotorDrum_4Stage.SLDPRT"
