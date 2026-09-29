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


' HPT NGV
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateLine 4.38, 0.44, 0, 4.38, 0.57, 0
skMgr.CreateLine 4.38, 0.57, 0, 4.46, 0.57, 0
skMgr.CreateLine 4.46, 0.57, 0, 4.46, 0.44, 0
skMgr.CreateLine 4.46, 0.44, 0, 4.38, 0.44, 0
featMgr.FeatureExtrusion3 True, False, False, 0, 0, 0.025, 0.01, False, False, False, False, 0, 0, False, False, False, False, False, True, True, 0, 0, False

' HPT Disk
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 5.5, 0, 0
skMgr.CreateLine 4.48, 0.25, 0, 4.48, 0.45, 0
skMgr.CreateLine 4.48, 0.45, 0, 4.75, 0.46, 0
skMgr.CreateLine 4.75, 0.46, 0, 4.75, 0.25, 0
skMgr.CreateLine 4.75, 0.25, 0, 4.48, 0.25, 0
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True

' HPT Blade
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateLine 4.50, 0.45, 0, 4.49, 0.58, 0
skMgr.CreateLine 4.49, 0.58, 0, 4.56, 0.58, 0
skMgr.CreateLine 4.56, 0.58, 0, 4.57, 0.45, 0
skMgr.CreateLine 4.57, 0.45, 0, 4.50, 0.45, 0
featMgr.FeatureExtrusion3 True, False, False, 0, 0, 0.02, 0.01, False, False, False, False, 0, 0, False, False, False, False, False, True, True, 0, 0, False


model.ShowNamedView2 "*Isometric", 7
model.ViewZoomtofit2
ret = model.SaveAs3("C:\Users\user\.gemini\antigravity\scratch\GE90_115B_Turbofan_Engine\Subassemblies\ASM_06_High_Pressure_Turbine.SLDPRT", 0, 1)
swApp.CloseDoc model.GetTitle
WScript.Echo "SUCCESS: ASM_06_High_Pressure_Turbine.SLDPRT"
