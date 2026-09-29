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


' Left Cowl Door
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 4.0, 0, 0
skMgr.CreateLine 0.70, 1.72, 0, 0.70, 1.76, 0
skMgr.CreateLine 0.70, 1.76, 0, 3.20, 1.65, 0
skMgr.CreateLine 3.20, 1.65, 0, 3.20, 1.61, 0
skMgr.CreateLine 3.20, 1.61, 0, 0.70, 1.72, 0
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 3.1415926, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True

' Right Cowl Door
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 4.0, 0, 0
skMgr.CreateLine 0.70, -1.72, 0, 0.70, -1.76, 0
skMgr.CreateLine 0.70, -1.76, 0, 3.20, -1.65, 0
skMgr.CreateLine 3.20, -1.65, 0, 3.20, -1.61, 0
skMgr.CreateLine 3.20, -1.61, 0, 0.70, -1.72, 0
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 3.1415926, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True

' Translating Sleeve
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 6.0, 0, 0
skMgr.CreateLine 3.20, 1.55, 0, 3.20, 1.65, 0
skMgr.CreateLine 3.20, 1.65, 0, 5.50, 1.30, 0
skMgr.CreateLine 5.50, 1.30, 0, 5.50, 1.25, 0
skMgr.CreateLine 5.50, 1.25, 0, 3.20, 1.55, 0
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True


model.ShowNamedView2 "*Isometric", 7
model.ViewZoomtofit2
ret = model.SaveAs3("C:\Users\user\.gemini\antigravity\scratch\GE90_115B_Turbofan_Engine\Subassemblies\ASM_10_Nacelle_Cowlings.SLDPRT", 0, 1)
swApp.CloseDoc model.GetTitle
WScript.Echo "SUCCESS: ASM_10_Nacelle_Cowlings.SLDPRT"
