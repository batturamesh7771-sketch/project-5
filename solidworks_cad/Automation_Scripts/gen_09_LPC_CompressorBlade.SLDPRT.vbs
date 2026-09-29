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
skMgr.CreateLine 1.30, 0.50, 0, 1.28, 0.68, 0
skMgr.CreateLine 1.28, 0.68, 0, 1.36, 0.68, 0
skMgr.CreateLine 1.36, 0.68, 0, 1.38, 0.50, 0
skMgr.CreateLine 1.38, 0.50, 0, 1.30, 0.50, 0

featMgr.FeatureExtrusion3 True, False, False, 0, 0, 0.018, 0.01, False, False, False, False, 0, 0, False, False, False, False, True, True, True, 0, 0, False


ret = model.SaveAs3("C:\Users\user\.gemini\antigravity\scratch\GE90_115B_Turbofan_Engine\Parts\09_LPC_CompressorBlade.SLDPRT", 0, 1)
swApp.CloseDoc model.GetTitle
WScript.Echo "SUCCESS: Generated 09_LPC_CompressorBlade.SLDPRT"
