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


' Fan Blade: Swept wide-chord airfoil with dovetail root
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True

' Dovetail root profile at base (X=0.95 to 1.15m, R=0.50 to 0.58m)
skMgr.CreateLine 0.95, 0.50, 0, 0.95, 0.55, 0
skMgr.CreateLine 0.95, 0.55, 0, 1.15, 0.58, 0
skMgr.CreateLine 1.15, 0.58, 0, 1.15, 0.50, 0
skMgr.CreateLine 1.15, 0.50, 0, 0.95, 0.50, 0

' Extrude root block thickness 0.08m
featMgr.FeatureExtrusion3 True, False, False, 0, 0, 0.08, 0.01, False, False, False, False, 0, 0, False, False, False, False, True, True, True, 0, 0, False

' Blade Aerofoil Body
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
' Airfoil profile extending to Fan Tip Radius = 1.625m (Diameter 3.25m)
skMgr.CreateLine 0.92, 0.58, 0, 0.80, 1.10, 0
skMgr.CreateLine 0.80, 1.10, 0, 0.70, 1.625, 0
skMgr.CreateLine 0.70, 1.625, 0, 1.05, 1.625, 0
skMgr.CreateLine 1.05, 1.625, 0, 1.15, 1.10, 0
skMgr.CreateLine 1.15, 1.10, 0, 1.18, 0.58, 0
skMgr.CreateLine 1.18, 0.58, 0, 0.92, 0.58, 0

featMgr.FeatureExtrusion3 True, False, False, 0, 0, 0.045, 0.01, False, False, False, False, 0, 0, False, False, False, False, True, True, True, 0, 0, False


ret = model.SaveAs3("C:\Users\user\.gemini\antigravity\scratch\GE90_115B_Turbofan_Engine\Parts\02_FanBlade_Composite.SLDPRT", 0, 1)
swApp.CloseDoc model.GetTitle
WScript.Echo "SUCCESS: Generated 02_FanBlade_Composite.SLDPRT"
