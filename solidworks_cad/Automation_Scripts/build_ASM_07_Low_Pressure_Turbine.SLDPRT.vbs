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


' LPT Drum
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 7.0, 0, 0
skMgr.CreateLine 4.80, 0.25, 0, 4.80, 0.46, 0
skMgr.CreateLine 4.80, 0.46, 0, 6.10, 0.55, 0
skMgr.CreateLine 6.10, 0.55, 0, 6.10, 0.25, 0
skMgr.CreateLine 6.10, 0.25, 0, 4.80, 0.25, 0
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True

' LPT Casing
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 7.0, 0, 0
skMgr.CreateLine 4.78, 0.58, 0, 4.78, 0.64, 0
skMgr.CreateLine 4.78, 0.64, 0, 6.12, 0.74, 0
skMgr.CreateLine 6.12, 0.74, 0, 6.12, 0.67, 0
skMgr.CreateLine 6.12, 0.67, 0, 4.78, 0.58, 0
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True

' Chevron Mixer Plug
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 8.0, 0, 0
skMgr.CreateLine 6.30, 0.35, 0, 6.30, 0.65, 0
skMgr.CreateLine 6.30, 0.65, 0, 6.85, 0.40, 0
skMgr.CreateLine 6.85, 0.40, 0, 7.29, 0, 0
skMgr.CreateLine 7.29, 0, 0, 6.30, 0, 0
skMgr.CreateLine 6.30, 0, 0, 6.30, 0.35, 0
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True


model.ShowNamedView2 "*Isometric", 7
model.ViewZoomtofit2
ret = model.SaveAs3("C:\Users\user\.gemini\antigravity\scratch\GE90_115B_Turbofan_Engine\Subassemblies\ASM_07_Low_Pressure_Turbine.SLDPRT", 0, 1)
swApp.CloseDoc model.GetTitle
WScript.Echo "SUCCESS: ASM_07_Low_Pressure_Turbine.SLDPRT"
