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


' N1 Shaft
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 8.0, 0, 0
skMgr.CreateLine 0.90, 0.08, 0, 0.90, 0.12, 0
skMgr.CreateLine 0.90, 0.12, 0, 6.20, 0.12, 0
skMgr.CreateLine 6.20, 0.12, 0, 6.20, 0.08, 0
skMgr.CreateLine 6.20, 0.08, 0, 0.90, 0.08, 0
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True

' N2 Shaft
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 6.0, 0, 0
skMgr.CreateLine 1.90, 0.14, 0, 1.90, 0.18, 0
skMgr.CreateLine 1.90, 0.18, 0, 4.70, 0.18, 0
skMgr.CreateLine 4.70, 0.18, 0, 4.70, 0.14, 0
skMgr.CreateLine 4.70, 0.14, 0, 1.90, 0.14, 0
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True


model.ShowNamedView2 "*Isometric", 7
model.ViewZoomtofit2
ret = model.SaveAs3("C:\Users\user\.gemini\antigravity\scratch\GE90_115B_Turbofan_Engine\Subassemblies\ASM_08_Shafts_Bearings.SLDPRT", 0, 1)
swApp.CloseDoc model.GetTitle
WScript.Echo "SUCCESS: ASM_08_Shafts_Bearings.SLDPRT"
