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


' Inlet Lip
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 2.0, 0, 0
skMgr.CreateLine 0.10, 1.67, 0, 0.70, 1.71, 0
skMgr.CreateLine 0.70, 1.71, 0, 0.70, 1.63, 0
skMgr.CreateLine 0.70, 1.63, 0, 0.10, 1.67, 0
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True

' Containment Case
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 3.0, 0, 0
skMgr.CreateLine 0.70, 1.63, 0, 0.70, 1.75, 0
skMgr.CreateLine 0.70, 1.75, 0, 0.75, 1.75, 0
skMgr.CreateLine 0.75, 1.75, 0, 0.75, 1.68, 0
skMgr.CreateLine 0.75, 1.68, 0, 2.15, 1.68, 0
skMgr.CreateLine 2.15, 1.68, 0, 2.15, 1.75, 0
skMgr.CreateLine 2.15, 1.75, 0, 2.20, 1.75, 0
skMgr.CreateLine 2.20, 1.75, 0, 2.20, 1.63, 0
skMgr.CreateLine 2.20, 1.63, 0, 0.70, 1.63, 0
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True

' OGV Struts
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateLine 1.70, 0.55, 0, 1.70, 1.63, 0
skMgr.CreateLine 1.70, 1.63, 0, 1.95, 1.63, 0
skMgr.CreateLine 1.95, 1.63, 0, 1.95, 0.55, 0
skMgr.CreateLine 1.95, 0.55, 0, 1.70, 0.55, 0
featMgr.FeatureExtrusion3 True, False, False, 0, 0, 0.035, 0.01, False, False, False, False, 0, 0, False, False, False, False, False, True, True, 0, 0, False


model.ShowNamedView2 "*Isometric", 7
model.ViewZoomtofit2
ret = model.SaveAs3("C:\Users\user\.gemini\antigravity\scratch\GE90_115B_Turbofan_Engine\Subassemblies\ASM_02_Fan_Case_Frame.SLDPRT", 0, 1)
swApp.CloseDoc model.GetTitle
WScript.Echo "SUCCESS: ASM_02_Fan_Case_Frame.SLDPRT"
