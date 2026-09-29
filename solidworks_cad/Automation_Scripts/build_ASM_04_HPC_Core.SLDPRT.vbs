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


' HPC Drum
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 4.0, 0, 0
skMgr.CreateLine 1.90, 0.28, 0, 1.90, 0.46, 0
skMgr.CreateLine 1.90, 0.46, 0, 3.40, 0.42, 0
skMgr.CreateLine 3.40, 0.42, 0, 3.40, 0.28, 0
skMgr.CreateLine 3.40, 0.28, 0, 1.90, 0.28, 0
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True

' Split Top Half
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 4.0, 0, 0
skMgr.CreateLine 1.88, 0.58, 0, 1.88, 0.65, 0
skMgr.CreateLine 1.88, 0.65, 0, 3.42, 0.60, 0
skMgr.CreateLine 3.42, 0.60, 0, 3.42, 0.54, 0
skMgr.CreateLine 3.42, 0.54, 0, 1.88, 0.58, 0
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 3.1415926, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True

' Split Bottom Half
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 4.0, 0, 0
skMgr.CreateLine 1.88, -0.58, 0, 1.88, -0.65, 0
skMgr.CreateLine 1.88, -0.65, 0, 3.42, -0.60, 0
skMgr.CreateLine 3.42, -0.60, 0, 3.42, -0.54, 0
skMgr.CreateLine 3.42, -0.54, 0, 1.88, -0.58, 0
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 3.1415926, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True


model.ShowNamedView2 "*Isometric", 7
model.ViewZoomtofit2
ret = model.SaveAs3("C:\Users\user\.gemini\antigravity\scratch\GE90_115B_Turbofan_Engine\Subassemblies\ASM_04_HPC_Core.SLDPRT", 0, 1)
swApp.CloseDoc model.GetTitle
WScript.Echo "SUCCESS: ASM_04_HPC_Core.SLDPRT"
