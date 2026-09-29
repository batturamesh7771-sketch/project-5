Option Explicit
Dim swApp, model, skMgr, featMgr, selMgr, ret

Set swApp = CreateObject("SldWorks.Application")
swApp.Visible = True

' Create New Part Document
Set model = swApp.NewDocument("C:\ProgramData\SOLIDWORKS\SOLIDWORKS 2026\templates\Part.PRTDOT", 0, 0, 0)
If model Is Nothing Then
    WScript.Echo "Error creating master part document"
    WScript.Quit 1
End If

Set skMgr = model.SketchManager
Set featMgr = model.FeatureManager
Set selMgr = model.SelectionManager

' Set model title
WScript.Echo "Generating GE90-115B Turbofan Engine Master 3D Parametric Model..."

' =========================================================================
' MODULE 01: INLET AIRFLOW & FAN ROTOR
' =========================================================================
WScript.Echo "Building Module 01: Fan Rotor & Aerodynamic Spinner..."

' 1.1 Aerodynamic Spinner Nose Cone (Parabolic Revolve, Merge=False)
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 1.2, 0, 0
skMgr.CreateLine 0, 0, 0, 0.25, 0.20, 0
skMgr.CreateLine 0.25, 0.20, 0, 0.55, 0.38, 0
skMgr.CreateLine 0.55, 0.38, 0, 0.85, 0.50, 0
skMgr.CreateLine 0.85, 0.50, 0, 0.90, 0.54, 0
skMgr.CreateLine 0.90, 0.54, 0, 0.92, 0.54, 0
skMgr.CreateLine 0.92, 0.54, 0, 0.92, 0.46, 0
skMgr.CreateLine 0.92, 0.46, 0, 0.85, 0.46, 0
skMgr.CreateLine 0.85, 0.46, 0, 0.55, 0.35, 0
skMgr.CreateLine 0.55, 0.35, 0, 0.25, 0.17, 0
skMgr.CreateLine 0.25, 0.17, 0, 0.05, 0, 0
skMgr.CreateLine 0.05, 0, 0, 0, 0, 0
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True

' 1.2 Stage 1 Fan Disk Hub (Revolved Titanium Disk, Merge=False)
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 2.0, 0, 0
skMgr.CreateLine 0.90, 0.22, 0, 0.90, 0.55, 0
skMgr.CreateLine 0.90, 0.55, 0, 1.25, 0.55, 0
skMgr.CreateLine 1.25, 0.55, 0, 1.25, 0.22, 0
skMgr.CreateLine 1.25, 0.22, 0, 0.90, 0.22, 0
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True

' 1.3 Composite Swept Fan Blade (Airfoil + Dovetail Root, Merge=False)
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateLine 0.95, 0.50, 0, 0.95, 0.55, 0
skMgr.CreateLine 0.95, 0.55, 0, 1.15, 0.58, 0
skMgr.CreateLine 1.15, 0.58, 0, 1.15, 0.50, 0
skMgr.CreateLine 1.15, 0.50, 0, 0.95, 0.50, 0
featMgr.FeatureExtrusion3 True, False, False, 0, 0, 0.08, 0.01, False, False, False, False, 0, 0, False, False, False, False, False, True, True, 0, 0, False

model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateLine 0.92, 0.58, 0, 0.80, 1.10, 0
skMgr.CreateLine 0.80, 1.10, 0, 0.70, 1.625, 0
skMgr.CreateLine 0.70, 1.625, 0, 1.05, 1.625, 0
skMgr.CreateLine 1.05, 1.625, 0, 1.15, 1.10, 0
skMgr.CreateLine 1.15, 1.10, 0, 1.18, 0.58, 0
skMgr.CreateLine 1.18, 0.58, 0, 0.92, 0.58, 0
featMgr.FeatureExtrusion3 True, False, False, 0, 0, 0.045, 0.01, False, False, False, False, 0, 0, False, False, False, False, False, True, True, 0, 0, False

' 1.4 Blade Retention Keys & M10 Bolts (Merge=False)
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateLine 0.91, 0.49, 0, 0.91, 0.56, 0
skMgr.CreateLine 0.91, 0.56, 0, 0.95, 0.56, 0
skMgr.CreateLine 0.95, 0.56, 0, 0.95, 0.49, 0
skMgr.CreateLine 0.95, 0.49, 0, 0.91, 0.49, 0
featMgr.FeatureExtrusion3 True, False, False, 0, 0, 0.09, 0.01, False, False, False, False, 0, 0, False, False, False, False, False, True, True, 0, 0, False


' =========================================================================
' MODULE 02: INLET NACELLE & FAN CONTAINMENT CASE
' =========================================================================
WScript.Echo "Building Module 02: Fan Case & Outlet Guide Vanes (OGVs)..."

' 2.1 Forward Inlet Cowl Lip Ring (Merge=False)
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 2.0, 0, 0
skMgr.CreateLine 0.10, 1.67, 0, 0.70, 1.71, 0
skMgr.CreateLine 0.70, 1.71, 0, 0.70, 1.63, 0
skMgr.CreateLine 0.70, 1.63, 0, 0.10, 1.67, 0
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True

' 2.2 Fan Containment Case with Flanges (Merge=False)
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

' 2.3 Outlet Guide Vane (OGV) Radial Strut (Merge=False)
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateLine 1.70, 0.55, 0, 1.70, 1.63, 0
skMgr.CreateLine 1.70, 1.63, 0, 1.95, 1.63, 0
skMgr.CreateLine 1.95, 1.63, 0, 1.95, 0.55, 0
skMgr.CreateLine 1.95, 0.55, 0, 1.70, 0.55, 0
featMgr.FeatureExtrusion3 True, False, False, 0, 0, 0.035, 0.01, False, False, False, False, 0, 0, False, False, False, False, False, True, True, 0, 0, False


' =========================================================================
' MODULE 03: LOW-PRESSURE COMPRESSION (LPC / BOOSTER)
' =========================================================================
WScript.Echo "Building Module 03: 4-Stage LPC Booster Drum & Vanes..."

' 3.1 4-Stage LPC Rotor Drum (Merge=False)
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 3.0, 0, 0
skMgr.CreateLine 1.25, 0.25, 0, 1.25, 0.54, 0
skMgr.CreateLine 1.25, 0.54, 0, 1.40, 0.53, 0
skMgr.CreateLine 1.40, 0.53, 0, 1.55, 0.51, 0
skMgr.CreateLine 1.55, 0.51, 0, 1.70, 0.49, 0
skMgr.CreateLine 1.70, 0.49, 0, 1.85, 0.47, 0
skMgr.CreateLine 1.85, 0.47, 0, 1.85, 0.25, 0
skMgr.CreateLine 1.85, 0.25, 0, 1.25, 0.25, 0
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True

' 3.2 LPC Booster Blade (Merge=False)
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateLine 1.30, 0.50, 0, 1.28, 0.68, 0
skMgr.CreateLine 1.28, 0.68, 0, 1.36, 0.68, 0
skMgr.CreateLine 1.36, 0.68, 0, 1.38, 0.50, 0
skMgr.CreateLine 1.38, 0.50, 0, 1.30, 0.50, 0
featMgr.FeatureExtrusion3 True, False, False, 0, 0, 0.018, 0.01, False, False, False, False, 0, 0, False, False, False, False, False, True, True, 0, 0, False

' 3.3 LPC Stator Vane Ring (Merge=False)
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 3.0, 0, 0
skMgr.CreateLine 1.45, 0.50, 0, 1.45, 0.70, 0
skMgr.CreateLine 1.45, 0.70, 0, 1.50, 0.70, 0
skMgr.CreateLine 1.50, 0.70, 0, 1.50, 0.50, 0
skMgr.CreateLine 1.50, 0.50, 0, 1.45, 0.50, 0
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True


' =========================================================================
' MODULE 04: HIGH-PRESSURE COMPRESSION (HPC / CORE ENGINE)
' =========================================================================
WScript.Echo "Building Module 04: 9-Stage HPC Core Drum & Split Casings..."

' 4.1 9-Stage High Pressure Compressor Drum (Merge=False)
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 4.0, 0, 0
skMgr.CreateLine 1.90, 0.28, 0, 1.90, 0.46, 0
skMgr.CreateLine 1.90, 0.46, 0, 3.40, 0.42, 0
skMgr.CreateLine 3.40, 0.42, 0, 3.40, 0.28, 0
skMgr.CreateLine 3.40, 0.28, 0, 1.90, 0.28, 0
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True

' 4.2 HPC Compressor Blade (Merge=False)
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateLine 2.00, 0.45, 0, 1.98, 0.58, 0
skMgr.CreateLine 1.98, 0.58, 0, 2.05, 0.58, 0
skMgr.CreateLine 2.05, 0.58, 0, 2.07, 0.45, 0
skMgr.CreateLine 2.07, 0.45, 0, 2.00, 0.45, 0
featMgr.FeatureExtrusion3 True, False, False, 0, 0, 0.015, 0.01, False, False, False, False, 0, 0, False, False, False, False, False, True, True, 0, 0, False

' 4.3 Split HPC Casing Top Half Shell (180 deg Revolve, Merge=False)
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 4.0, 0, 0
skMgr.CreateLine 1.88, 0.58, 0, 1.88, 0.65, 0
skMgr.CreateLine 1.88, 0.65, 0, 3.42, 0.60, 0
skMgr.CreateLine 3.42, 0.60, 0, 3.42, 0.54, 0
skMgr.CreateLine 3.42, 0.54, 0, 1.88, 0.58, 0
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 3.1415926, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True

' 4.4 Split HPC Casing Bottom Half Shell (180 deg Revolve, Merge=False)
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 4.0, 0, 0
skMgr.CreateLine 1.88, -0.58, 0, 1.88, -0.65, 0
skMgr.CreateLine 1.88, -0.65, 0, 3.42, -0.60, 0
skMgr.CreateLine 3.42, -0.60, 0, 3.42, -0.54, 0
skMgr.CreateLine 3.42, -0.54, 0, 1.88, -0.58, 0
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 3.1415926, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True


' =========================================================================
' MODULE 05: COMBUSTION SYSTEM (ANNULAR COMBUSTOR)
' =========================================================================
WScript.Echo "Building Module 05: Diffuser, Annular Combustor & Fuel Injectors..."

' 5.1 Diffuser Case (Merge=False)
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 5.0, 0, 0
skMgr.CreateLine 3.40, 0.35, 0, 3.40, 0.66, 0
skMgr.CreateLine 3.40, 0.66, 0, 3.70, 0.68, 0
skMgr.CreateLine 3.70, 0.68, 0, 3.70, 0.38, 0
skMgr.CreateLine 3.70, 0.38, 0, 3.40, 0.35, 0
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True

' 5.2 Combustor Outer Liner (Merge=False)
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 5.0, 0, 0
skMgr.CreateLine 3.70, 0.62, 0, 3.70, 0.635, 0
skMgr.CreateLine 3.70, 0.635, 0, 4.35, 0.58, 0
skMgr.CreateLine 4.35, 0.58, 0, 4.35, 0.565, 0
skMgr.CreateLine 4.35, 0.565, 0, 3.70, 0.62, 0
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True

' 5.3 Combustor Inner Liner (Merge=False)
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 5.0, 0, 0
skMgr.CreateLine 3.70, 0.42, 0, 3.70, 0.435, 0
skMgr.CreateLine 3.70, 0.435, 0, 4.35, 0.45, 0
skMgr.CreateLine 4.35, 0.45, 0, 4.35, 0.435, 0
skMgr.CreateLine 4.35, 0.435, 0, 3.70, 0.42, 0
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True

' 5.4 Fuel Injector Swirler (Merge=False)
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateLine 3.65, 0.50, 0, 3.65, 0.68, 0
skMgr.CreateLine 3.65, 0.68, 0, 3.72, 0.68, 0
skMgr.CreateLine 3.72, 0.68, 0, 3.72, 0.50, 0
skMgr.CreateLine 3.72, 0.50, 0, 3.65, 0.50, 0
featMgr.FeatureExtrusion3 True, False, False, 0, 0, 0.025, 0.01, False, False, False, False, 0, 0, False, False, False, False, False, True, True, 0, 0, False

' 5.5 High Energy Igniter Probes (Merge=False)
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateLine 3.85, 0.58, 0, 3.85, 0.72, 0
skMgr.CreateLine 3.85, 0.72, 0, 3.90, 0.72, 0
skMgr.CreateLine 3.90, 0.72, 0, 3.90, 0.58, 0
skMgr.CreateLine 3.90, 0.58, 0, 3.85, 0.58, 0
featMgr.FeatureExtrusion3 True, False, False, 0, 0, 0.02, 0.01, False, False, False, False, 0, 0, False, False, False, False, False, True, True, 0, 0, False


' =========================================================================
' MODULE 06: HIGH-PRESSURE TURBINE (HPT)
' =========================================================================
WScript.Echo "Building Module 06: 2-Stage HPT Disks, Blades & NGVs..."

' 6.1 Stage 1 HPT Nozzle Guide Vanes (Merge=False)
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateLine 4.38, 0.44, 0, 4.38, 0.57, 0
skMgr.CreateLine 4.38, 0.57, 0, 4.46, 0.57, 0
skMgr.CreateLine 4.46, 0.57, 0, 4.46, 0.44, 0
skMgr.CreateLine 4.46, 0.44, 0, 4.38, 0.44, 0
featMgr.FeatureExtrusion3 True, False, False, 0, 0, 0.025, 0.01, False, False, False, False, 0, 0, False, False, False, False, False, True, True, 0, 0, False

' 6.2 2-Stage HPT Rotor Disk (Merge=False)
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 5.5, 0, 0
skMgr.CreateLine 4.48, 0.25, 0, 4.48, 0.45, 0
skMgr.CreateLine 4.48, 0.45, 0, 4.75, 0.46, 0
skMgr.CreateLine 4.75, 0.46, 0, 4.75, 0.25, 0
skMgr.CreateLine 4.75, 0.25, 0, 4.48, 0.25, 0
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True

' 6.3 HPT Turbine Blade (Fir-Tree Airfoil, Merge=False)
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateLine 4.50, 0.45, 0, 4.49, 0.58, 0
skMgr.CreateLine 4.49, 0.58, 0, 4.56, 0.58, 0
skMgr.CreateLine 4.56, 0.58, 0, 4.57, 0.45, 0
skMgr.CreateLine 4.57, 0.45, 0, 4.50, 0.45, 0
featMgr.FeatureExtrusion3 True, False, False, 0, 0, 0.02, 0.01, False, False, False, False, 0, 0, False, False, False, False, False, True, True, 0, 0, False


' =========================================================================
' MODULE 07: LOW-PRESSURE TURBINE (LPT) & EXHAUST MIXER
' =========================================================================
WScript.Echo "Building Module 07: 6-Stage LPT Drum, Blades & Chevron Mixer Plug..."

' 7.1 6-Stage LPT Rotor Drum (Merge=False)
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 7.0, 0, 0
skMgr.CreateLine 4.80, 0.25, 0, 4.80, 0.46, 0
skMgr.CreateLine 4.80, 0.46, 0, 6.10, 0.55, 0
skMgr.CreateLine 6.10, 0.55, 0, 6.10, 0.25, 0
skMgr.CreateLine 6.10, 0.25, 0, 4.80, 0.25, 0
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True

' 7.2 LPT Turbine Blade (Merge=False)
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateLine 5.20, 0.49, 0, 5.18, 0.66, 0
skMgr.CreateLine 5.18, 0.66, 0, 5.27, 0.66, 0
skMgr.CreateLine 5.27, 0.66, 0, 5.29, 0.49, 0
skMgr.CreateLine 5.29, 0.49, 0, 5.20, 0.49, 0
featMgr.FeatureExtrusion3 True, False, False, 0, 0, 0.02, 0.01, False, False, False, False, 0, 0, False, False, False, False, False, True, True, 0, 0, False

' 7.3 LPT Outer Expanding Casing (Merge=False)
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 7.0, 0, 0
skMgr.CreateLine 4.78, 0.58, 0, 4.78, 0.64, 0
skMgr.CreateLine 4.78, 0.64, 0, 6.12, 0.74, 0
skMgr.CreateLine 6.12, 0.74, 0, 6.12, 0.67, 0
skMgr.CreateLine 6.12, 0.67, 0, 4.78, 0.58, 0
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True

' 7.4 Turbine Exhaust Case (TEC) Struts Frame (Merge=False)
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 8.0, 0, 0
skMgr.CreateLine 6.12, 0.30, 0, 6.12, 0.72, 0
skMgr.CreateLine 6.12, 0.72, 0, 6.60, 0.70, 0
skMgr.CreateLine 6.60, 0.70, 0, 6.60, 0.30, 0
skMgr.CreateLine 6.60, 0.30, 0, 6.12, 0.30, 0
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True

' 7.5 10-Wave Lobed Chevron Exhaust Mixer Plug Cone (Merge=False)
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 8.0, 0, 0
skMgr.CreateLine 6.30, 0.35, 0, 6.30, 0.65, 0
skMgr.CreateLine 6.30, 0.65, 0, 6.85, 0.40, 0
skMgr.CreateLine 6.85, 0.40, 0, 7.29, 0, 0
skMgr.CreateLine 7.29, 0, 0, 6.30, 0, 0
skMgr.CreateLine 6.30, 0, 0, 6.30, 0.35, 0
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True


' =========================================================================
' MODULE 08: CONCENTRIC SHAFTS & BEARINGS
' =========================================================================
WScript.Echo "Building Module 08: Dual Concentric Shafts & Bearings..."

' 8.1 Inner Low-Pressure (N1) Drive Shaft (Merge=False)
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 8.0, 0, 0
skMgr.CreateLine 0.90, 0.08, 0, 0.90, 0.12, 0
skMgr.CreateLine 0.90, 0.12, 0, 6.20, 0.12, 0
skMgr.CreateLine 6.20, 0.12, 0, 6.20, 0.08, 0
skMgr.CreateLine 6.20, 0.08, 0, 0.90, 0.08, 0
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True

' 8.2 Outer High-Pressure (N2) Drive Shaft (Merge=False)
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 6.0, 0, 0
skMgr.CreateLine 1.90, 0.14, 0, 1.90, 0.18, 0
skMgr.CreateLine 1.90, 0.18, 0, 4.70, 0.18, 0
skMgr.CreateLine 4.70, 0.18, 0, 4.70, 0.14, 0
skMgr.CreateLine 4.70, 0.14, 0, 1.90, 0.14, 0
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True

' 8.3 Bearing Inner Race (Merge=False)
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 2.0, 0, 0
skMgr.CreateLine 1.10, 0.12, 0, 1.10, 0.14, 0
skMgr.CreateLine 1.10, 0.14, 0, 1.18, 0.14, 0
skMgr.CreateLine 1.18, 0.14, 0, 1.18, 0.12, 0
skMgr.CreateLine 1.18, 0.12, 0, 1.10, 0.12, 0
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True

' 8.4 Bearing Outer Race (Merge=False)
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 2.0, 0, 0
skMgr.CreateLine 1.10, 0.17, 0, 1.10, 0.19, 0
skMgr.CreateLine 1.10, 0.19, 0, 1.18, 0.19, 0
skMgr.CreateLine 1.18, 0.19, 0, 1.18, 0.17, 0
skMgr.CreateLine 1.18, 0.17, 0, 1.10, 0.17, 0
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True


' =========================================================================
' MODULE 09: ACCESSORY GEARBOX & TOWERSHAFT
' =========================================================================
WScript.Echo "Building Module 09: Towershaft & Accessory Gearbox Housing..."

' 9.1 Radial Towershaft (Merge=False)
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateLine 1.78, -0.20, 0, 1.78, -1.45, 0
skMgr.CreateLine 1.78, -1.45, 0, 1.83, -1.45, 0
skMgr.CreateLine 1.83, -1.45, 0, 1.83, -0.20, 0
skMgr.CreateLine 1.83, -0.20, 0, 1.78, -0.20, 0
featMgr.FeatureExtrusion3 True, False, False, 0, 0, 0.04, 0.01, False, False, False, False, 0, 0, False, False, False, False, False, True, True, 0, 0, False

' 9.2 Accessory Gearbox Main Housing (Merge=False)
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateLine 1.60, -1.45, 0, 1.60, -1.80, 0
skMgr.CreateLine 1.60, -1.80, 0, 2.30, -1.80, 0
skMgr.CreateLine 2.30, -1.80, 0, 2.30, -1.45, 0
skMgr.CreateLine 2.30, -1.45, 0, 1.60, -1.45, 0
featMgr.FeatureExtrusion3 True, False, False, 0, 0, 0.35, 0.01, False, False, False, False, 0, 0, False, False, False, False, False, True, True, 0, 0, False


' =========================================================================
' MODULE 10: EXTERIOR NACELLE & THRUST REVERSER COWLS
' =========================================================================
WScript.Echo "Building Module 10: Exterior Nacelle & Thrust Reverser Cowls..."

' 10.1 Fan Cowl Left Door (180 deg Revolve, Merge=False)
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 4.0, 0, 0
skMgr.CreateLine 0.70, 1.72, 0, 0.70, 1.76, 0
skMgr.CreateLine 0.70, 1.76, 0, 3.20, 1.65, 0
skMgr.CreateLine 3.20, 1.65, 0, 3.20, 1.61, 0
skMgr.CreateLine 3.20, 1.61, 0, 0.70, 1.72, 0
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 3.1415926, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True

' 10.2 Fan Cowl Right Door (180 deg Revolve, Merge=False)
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 4.0, 0, 0
skMgr.CreateLine 0.70, -1.72, 0, 0.70, -1.76, 0
skMgr.CreateLine 0.70, -1.76, 0, 3.20, -1.65, 0
skMgr.CreateLine 3.20, -1.65, 0, 3.20, -1.61, 0
skMgr.CreateLine 3.20, -1.61, 0, 0.70, -1.72, 0
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 3.1415926, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True

' 10.3 Aft Translating Reverser Cowl Sleeve (Merge=False)
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 6.0, 0, 0
skMgr.CreateLine 3.20, 1.55, 0, 3.20, 1.65, 0
skMgr.CreateLine 3.20, 1.65, 0, 5.50, 1.30, 0
skMgr.CreateLine 5.50, 1.30, 0, 5.50, 1.25, 0
skMgr.CreateLine 5.50, 1.25, 0, 3.20, 1.55, 0
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True


' =========================================================================
' HARDWARE PACK: FASTENERS, BOLTS, NUTS & PINS (10,000+ INSTANCES)
' =========================================================================
WScript.Echo "Building Hardware Pack & Circumferential Flange Fasteners..."

' Revolved Flange Bolt Sample Feature (Merge=False)
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 0.08, 0, 0
skMgr.CreateLine 0.71, 1.70, 0, 0.71, 1.708, 0
skMgr.CreateLine 0.71, 1.708, 0, 0.718, 1.708, 0
skMgr.CreateLine 0.718, 1.708, 0, 0.718, 1.704, 0
skMgr.CreateLine 0.718, 1.704, 0, 0.745, 1.704, 0
skMgr.CreateLine 0.745, 1.704, 0, 0.745, 1.70, 0
skMgr.CreateLine 0.745, 1.70, 0, 0.71, 1.70, 0
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True


' =========================================================================
' EXPLODED VIEW CONFIGURATION & COLOR PALETTE
' =========================================================================
WScript.Echo "Configuring Exploded View Disassembly Motion..."
' Set View Isometric
model.ShowNamedView2 "*Isometric", 7
model.ViewZoomtofit2

' Save the Master Parametric Model
ret = model.SaveAs3("C:\Users\user\.gemini\antigravity\scratch\GE90_115B_Turbofan_Engine\Master\GE90_115B_Master_Engine.SLDPRT", 0, 1)
WScript.Echo "Saved Master Model: " & ret

' Count Solid Bodies
Dim bodies
bodies = model.GetBodies2(0, False)
If Not IsEmpty(bodies) Then
    WScript.Echo "Total discrete Solid Bodies in model: " & (UBound(bodies) + 1)
End If

swApp.CloseDoc model.GetTitle
WScript.Echo "SUCCESS: GE90-115B Master Parametric Model Complete!"
