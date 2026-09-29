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


' Diffuser
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 5.0, 0, 0
skMgr.CreateLine 3.40, 0.35, 0, 3.40, 0.66, 0
skMgr.CreateLine 3.40, 0.66, 0, 3.70, 0.68, 0
skMgr.CreateLine 3.70, 0.68, 0, 3.70, 0.38, 0
skMgr.CreateLine 3.70, 0.38, 0, 3.40, 0.35, 0
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True

' Outer Liner
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 5.0, 0, 0
skMgr.CreateLine 3.70, 0.62, 0, 3.70, 0.635, 0
skMgr.CreateLine 3.70, 0.635, 0, 4.35, 0.58, 0
skMgr.CreateLine 4.35, 0.58, 0, 4.35, 0.565, 0
skMgr.CreateLine 4.35, 0.565, 0, 3.70, 0.62, 0
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True

' Inner Liner
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 5.0, 0, 0
skMgr.CreateLine 3.70, 0.42, 0, 3.70, 0.435, 0
skMgr.CreateLine 3.70, 0.435, 0, 4.35, 0.45, 0
skMgr.CreateLine 4.35, 0.45, 0, 4.35, 0.435, 0
skMgr.CreateLine 4.35, 0.435, 0, 3.70, 0.42, 0
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True


model.ShowNamedView2 "*Isometric", 7
model.ViewZoomtofit2
ret = model.SaveAs3("C:\Users\user\.gemini\antigravity\scratch\GE90_115B_Turbofan_Engine\Subassemblies\ASM_05_Combustion_System.SLDPRT", 0, 1)
swApp.CloseDoc model.GetTitle
WScript.Echo "SUCCESS: ASM_05_Combustion_System.SLDPRT"
