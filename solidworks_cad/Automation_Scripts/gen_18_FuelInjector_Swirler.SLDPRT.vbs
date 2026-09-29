Option Explicit
Dim swApp, model, skMgr, featMgr, ret

Set swApp = CreateObject("SldWorks.Application")
swApp.Visible = True

Set model = swApp.NewDocument("C:\ProgramData\SOLIDWORKS\SOLIDWORKS 2026\templates\Part.PRTDOT", 0, 0, 0)
If model Is Nothing Then
    WScript.Echo "Error: Could not create part document"
    WScript.Quit 1
End If

Set skMgr = model.SketchManager
Set featMgr = model.FeatureManager


model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateLine 3.65, 0.50, 0, 3.65, 0.68, 0
skMgr.CreateLine 3.65, 0.68, 0, 3.72, 0.68, 0
skMgr.CreateLine 3.72, 0.68, 0, 3.72, 0.50, 0
skMgr.CreateLine 3.72, 0.50, 0, 3.65, 0.50, 0

featMgr.FeatureExtrusion3 True, False, False, 0, 0, 0.025, 0.01, False, False, False, False, 0, 0, False, False, False, False, True, True, True, 0, 0, False


ret = model.SaveAs3("C:\Users\user\.gemini\antigravity\scratch\GE90_115B_Turbofan_Engine\Parts\18_FuelInjector_Swirler.SLDPRT", 0, 1)
swApp.CloseDoc model.GetTitle
WScript.Echo "SUCCESS: Generated 18_FuelInjector_Swirler.SLDPRT"
