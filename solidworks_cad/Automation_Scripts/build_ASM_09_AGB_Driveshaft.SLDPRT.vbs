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


' Towershaft
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateLine 1.78, -0.20, 0, 1.78, -1.45, 0
skMgr.CreateLine 1.78, -1.45, 0, 1.83, -1.45, 0
skMgr.CreateLine 1.83, -1.45, 0, 1.83, -0.20, 0
skMgr.CreateLine 1.83, -0.20, 0, 1.78, -0.20, 0
featMgr.FeatureExtrusion3 True, False, False, 0, 0, 0.04, 0.01, False, False, False, False, 0, 0, False, False, False, False, False, True, True, 0, 0, False

' Housing
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateLine 1.60, -1.45, 0, 1.60, -1.80, 0
skMgr.CreateLine 1.60, -1.80, 0, 2.30, -1.80, 0
skMgr.CreateLine 2.30, -1.80, 0, 2.30, -1.45, 0
skMgr.CreateLine 2.30, -1.45, 0, 1.60, -1.45, 0
featMgr.FeatureExtrusion3 True, False, False, 0, 0, 0.35, 0.01, False, False, False, False, 0, 0, False, False, False, False, False, True, True, 0, 0, False


model.ShowNamedView2 "*Isometric", 7
model.ViewZoomtofit2
ret = model.SaveAs3("C:\Users\user\.gemini\antigravity\scratch\GE90_115B_Turbofan_Engine\Subassemblies\ASM_09_AGB_Driveshaft.SLDPRT", 0, 1)
swApp.CloseDoc model.GetTitle
WScript.Echo "SUCCESS: ASM_09_AGB_Driveshaft.SLDPRT"
