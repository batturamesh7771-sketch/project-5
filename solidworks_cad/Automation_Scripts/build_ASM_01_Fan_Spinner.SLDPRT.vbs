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


' Spinner Nose Cone
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 1.2, 0, 0
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
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True

' Fan Disk Hub
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 2.0, 0, 0
skMgr.CreateLine 0.90, 0.22, 0, 0.90, 0.55, 0
skMgr.CreateLine 0.90, 0.55, 0, 1.25, 0.55, 0
skMgr.CreateLine 1.25, 0.55, 0, 1.25, 0.22, 0
skMgr.CreateLine 1.25, 0.22, 0, 0.90, 0.22, 0
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True

' Fan Blade with Dovetail Root
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateLine 0.95, 0.50, 0, 0.95, 0.55, 0
skMgr.CreateLine 0.95, 0.55, 0, 1.15, 0.58, 0
skMgr.CreateLine 1.15, 0.58, 0, 1.15, 0.50, 0
skMgr.CreateLine 1.15, 0.50, 0, 0.95, 0.50, 0
featMgr.FeatureExtrusion3 True, False, False, 0, 0, 0.08, 0.01, False, False, False, False, 0, 0, False, False, False, False, False, True, True, 0, 0, False

model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateLine 0.92, 0.58, 0, 0.80, 1.10, 0
skMgr.CreateLine 0.80, 1.10, 0, 0.70, 1.625, 0
skMgr.CreateLine 0.70, 1.625, 0, 1.05, 1.625, 0
skMgr.CreateLine 1.05, 1.625, 0, 1.15, 1.10, 0
skMgr.CreateLine 1.15, 1.10, 0, 1.18, 0.58, 0
skMgr.CreateLine 1.18, 0.58, 0, 0.92, 0.58, 0
featMgr.FeatureExtrusion3 True, False, False, 0, 0, 0.045, 0.01, False, False, False, False, 0, 0, False, False, False, False, False, True, True, 0, 0, False


model.ShowNamedView2 "*Isometric", 7
model.ViewZoomtofit2
ret = model.SaveAs3("C:\Users\user\.gemini\antigravity\scratch\GE90_115B_Turbofan_Engine\Subassemblies\ASM_01_Fan_Spinner.SLDPRT", 0, 1)
swApp.CloseDoc model.GetTitle
WScript.Echo "SUCCESS: ASM_01_Fan_Spinner.SLDPRT"
