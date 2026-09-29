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
skMgr.CreateCenterLine 0, 0, 0, 0.08, 0, 0

' Head R=0.007m, shank R=0.004m, length=0.035m
skMgr.CreateLine 0, 0, 0, 0, 0.007, 0
skMgr.CreateLine 0, 0.007, 0, 0.008, 0.007, 0
skMgr.CreateLine 0.008, 0.007, 0, 0.008, 0.004, 0
skMgr.CreateLine 0.008, 0.004, 0, 0.035, 0.004, 0
skMgr.CreateLine 0.035, 0.004, 0, 0.035, 0, 0
skMgr.CreateLine 0.035, 0, 0, 0, 0, 0

featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, True, True, True


ret = model.SaveAs3("C:\Users\user\.gemini\antigravity\scratch\GE90_115B_Turbofan_Engine\Parts\40_Fastener_M8_HexFlangeBolt.SLDPRT", 0, 1)
swApp.CloseDoc model.GetTitle
WScript.Echo "SUCCESS: Generated 40_Fastener_M8_HexFlangeBolt.SLDPRT"
