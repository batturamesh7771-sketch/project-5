Option Explicit
Dim swApp, model, skMgr, featMgr, ret

Set swApp = CreateObject("SldWorks.Application")
swApp.Visible = True

Set model = swApp.NewDocument("C:\ProgramData\SOLIDWORKS\SOLIDWORKS 2026\templates\Part.PRTDOT", 0, 0, 0)
If model Is Nothing Then
    WScript.Echo "Error: Could not create document"
    WScript.Quit 1
End If

Set skMgr = model.SketchManager
Set featMgr = model.FeatureManager


' Booster Drum
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
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True

' Booster Blades
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateLine 1.30, 0.50, 0, 1.28, 0.68, 0
skMgr.CreateLine 1.28, 0.68, 0, 1.36, 0.68, 0
skMgr.CreateLine 1.36, 0.68, 0, 1.38, 0.50, 0
skMgr.CreateLine 1.38, 0.50, 0, 1.30, 0.50, 0
featMgr.FeatureExtrusion3 True, False, False, 0, 0, 0.018, 0.01, False, False, False, False, 0, 0, False, False, False, False, False, True, True, 0, 0, False

' Stator Vane Ring
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 3.0, 0, 0
skMgr.CreateLine 1.45, 0.50, 0, 1.45, 0.70, 0
skMgr.CreateLine 1.45, 0.70, 0, 1.50, 0.70, 0
skMgr.CreateLine 1.50, 0.70, 0, 1.50, 0.50, 0
skMgr.CreateLine 1.50, 0.50, 0, 1.45, 0.50, 0
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True


model.ShowNamedView2 "*Isometric", 7
model.ViewZoomtofit2
ret = model.SaveAs3("C:\Users\user\.gemini\antigravity\scratch\GE90_115B_Turbofan_Engine\Subassemblies\ASM_03_LPC_Booster.SLDPRT", 0, 1)
swApp.CloseDoc model.GetTitle
WScript.Echo "SUCCESS: ASM_03_LPC_Booster.SLDPRT"
