"""
Generates the 10 modular subassembly CAD models for GE90-115B in SolidWorks 2026.
Allows individual inspection and disassembly of each engine section.
"""

import os
import subprocess

PROJECT_DIR = r"C:\Users\user\.gemini\antigravity\scratch\GE90_115B_Turbofan_Engine"
SUB_DIR = os.path.join(PROJECT_DIR, "Subassemblies")
SCRIPTS_DIR = os.path.join(PROJECT_DIR, "Scripts")
TEMPLATE_PART = r"C:\ProgramData\SOLIDWORKS\SOLIDWORKS 2026\templates\Part.PRTDOT"

MODULES = [
    {
        "file": "ASM_01_Fan_Spinner.SLDPRT",
        "title": "Module 01: Fan Rotor & Aerodynamic Spinner",
        "code": '''
' Spinner Nose Cone
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

' Fan Disk Hub
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 2.0, 0, 0
skMgr.CreateLine 0.90, 0.22, 0, 0.90, 0.55, 0
skMgr.CreateLine 0.90, 0.55, 0, 1.25, 0.55, 0
skMgr.CreateLine 1.25, 0.55, 0, 1.25, 0.22, 0
skMgr.CreateLine 1.25, 0.22, 0, 0.90, 0.22, 0
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True

' Fan Blade with Dovetail Root
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
'''
    },
    {
        "file": "ASM_02_Fan_Case_Frame.SLDPRT",
        "title": "Module 02: Fan Containment Case & OGVs",
        "code": '''
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
'''
    },
    {
        "file": "ASM_03_LPC_Booster.SLDPRT",
        "title": "Module 03: 4-Stage LPC Booster",
        "code": '''
' Booster Drum
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

' Booster Blades
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateLine 1.30, 0.50, 0, 1.28, 0.68, 0
skMgr.CreateLine 1.28, 0.68, 0, 1.36, 0.68, 0
skMgr.CreateLine 1.36, 0.68, 0, 1.38, 0.50, 0
skMgr.CreateLine 1.38, 0.50, 0, 1.30, 0.50, 0
featMgr.FeatureExtrusion3 True, False, False, 0, 0, 0.018, 0.01, False, False, False, False, 0, 0, False, False, False, False, False, True, True, 0, 0, False

' Stator Vane Ring
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 3.0, 0, 0
skMgr.CreateLine 1.45, 0.50, 0, 1.45, 0.70, 0
skMgr.CreateLine 1.45, 0.70, 0, 1.50, 0.70, 0
skMgr.CreateLine 1.50, 0.70, 0, 1.50, 0.50, 0
skMgr.CreateLine 1.50, 0.50, 0, 1.45, 0.50, 0
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True
'''
    },
    {
        "file": "ASM_04_HPC_Core.SLDPRT",
        "title": "Module 04: 9-Stage HPC Core Drum & Split Casing",
        "code": '''
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
'''
    },
    {
        "file": "ASM_05_Combustion_System.SLDPRT",
        "title": "Module 05: Combustor Diffuser & Liners",
        "code": '''
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
'''
    },
    {
        "file": "ASM_06_High_Pressure_Turbine.SLDPRT",
        "title": "Module 06: 2-Stage High Pressure Turbine",
        "code": '''
' HPT NGV
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateLine 4.38, 0.44, 0, 4.38, 0.57, 0
skMgr.CreateLine 4.38, 0.57, 0, 4.46, 0.57, 0
skMgr.CreateLine 4.46, 0.57, 0, 4.46, 0.44, 0
skMgr.CreateLine 4.46, 0.44, 0, 4.38, 0.44, 0
featMgr.FeatureExtrusion3 True, False, False, 0, 0, 0.025, 0.01, False, False, False, False, 0, 0, False, False, False, False, False, True, True, 0, 0, False

' HPT Disk
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 5.5, 0, 0
skMgr.CreateLine 4.48, 0.25, 0, 4.48, 0.45, 0
skMgr.CreateLine 4.48, 0.45, 0, 4.75, 0.46, 0
skMgr.CreateLine 4.75, 0.46, 0, 4.75, 0.25, 0
skMgr.CreateLine 4.75, 0.25, 0, 4.48, 0.25, 0
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True

' HPT Blade
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateLine 4.50, 0.45, 0, 4.49, 0.58, 0
skMgr.CreateLine 4.49, 0.58, 0, 4.56, 0.58, 0
skMgr.CreateLine 4.56, 0.58, 0, 4.57, 0.45, 0
skMgr.CreateLine 4.57, 0.45, 0, 4.50, 0.45, 0
featMgr.FeatureExtrusion3 True, False, False, 0, 0, 0.02, 0.01, False, False, False, False, 0, 0, False, False, False, False, False, True, True, 0, 0, False
'''
    },
    {
        "file": "ASM_07_Low_Pressure_Turbine.SLDPRT",
        "title": "Module 07: 6-Stage LPT & Chevron Mixer",
        "code": '''
' LPT Drum
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 7.0, 0, 0
skMgr.CreateLine 4.80, 0.25, 0, 4.80, 0.46, 0
skMgr.CreateLine 4.80, 0.46, 0, 6.10, 0.55, 0
skMgr.CreateLine 6.10, 0.55, 0, 6.10, 0.25, 0
skMgr.CreateLine 6.10, 0.25, 0, 4.80, 0.25, 0
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True

' LPT Casing
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 7.0, 0, 0
skMgr.CreateLine 4.78, 0.58, 0, 4.78, 0.64, 0
skMgr.CreateLine 4.78, 0.64, 0, 6.12, 0.74, 0
skMgr.CreateLine 6.12, 0.74, 0, 6.12, 0.67, 0
skMgr.CreateLine 6.12, 0.67, 0, 4.78, 0.58, 0
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True

' Chevron Mixer Plug
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateCenterLine 0, 0, 0, 8.0, 0, 0
skMgr.CreateLine 6.30, 0.35, 0, 6.30, 0.65, 0
skMgr.CreateLine 6.30, 0.65, 0, 6.85, 0.40, 0
skMgr.CreateLine 6.85, 0.40, 0, 7.29, 0, 0
skMgr.CreateLine 7.29, 0, 0, 6.30, 0, 0
skMgr.CreateLine 6.30, 0, 0, 6.30, 0.35, 0
featMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, 6.2831853, 0, False, False, 0.01, 0.01, 0, 0, 0, False, True, True
'''
    },
    {
        "file": "ASM_08_Shafts_Bearings.SLDPRT",
        "title": "Module 08: Concentric N1 & N2 Drive Shafts",
        "code": '''
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
'''
    },
    {
        "file": "ASM_09_AGB_Driveshaft.SLDPRT",
        "title": "Module 09: Accessory Gearbox & Towershaft",
        "code": '''
' Towershaft
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateLine 1.78, -0.20, 0, 1.78, -1.45, 0
skMgr.CreateLine 1.78, -1.45, 0, 1.83, -1.45, 0
skMgr.CreateLine 1.83, -1.45, 0, 1.83, -0.20, 0
skMgr.CreateLine 1.83, -0.20, 0, 1.78, -0.20, 0
featMgr.FeatureExtrusion3 True, False, False, 0, 0, 0.04, 0.01, False, False, False, False, 0, 0, False, False, False, False, False, True, True, 0, 0, False

' Housing
model.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0
skMgr.InsertSketch True
skMgr.CreateLine 1.60, -1.45, 0, 1.60, -1.80, 0
skMgr.CreateLine 1.60, -1.80, 0, 2.30, -1.80, 0
skMgr.CreateLine 2.30, -1.80, 0, 2.30, -1.45, 0
skMgr.CreateLine 2.30, -1.45, 0, 1.60, -1.45, 0
featMgr.FeatureExtrusion3 True, False, False, 0, 0, 0.35, 0.01, False, False, False, False, 0, 0, False, False, False, False, False, True, True, 0, 0, False
'''
    },
    {
        "file": "ASM_10_Nacelle_Cowlings.SLDPRT",
        "title": "Module 10: Exterior Nacelle Cowlings",
        "code": '''
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
'''
    }
]

def generate_subassembly(mod):
    file_name = mod["file"]
    target_path = os.path.join(SUB_DIR, file_name)
    vbs_path = os.path.join(SCRIPTS_DIR, f"build_{file_name}.vbs")

    vbs_script = f'''Option Explicit
Dim swApp, model, skMgr, featMgr, ret

Set swApp = CreateObject("SldWorks.Application")
swApp.Visible = True

Set model = swApp.NewDocument("{TEMPLATE_PART}", 0, 0, 0)
If model Is Nothing Then
    WScript.Echo "Error: Could not create document"
    WScript.Quit 1
End If

Set skMgr = model.SketchManager
Set featMgr = model.FeatureManager

{mod["code"]}

model.ShowNamedView2 "*Isometric", 7
model.ViewZoomtofit2
ret = model.SaveAs3("{target_path}", 0, 1)
swApp.CloseDoc model.GetTitle
WScript.Echo "SUCCESS: {file_name}"
'''

    with open(vbs_path, "w", encoding="utf-8") as f:
        f.write(vbs_script)

    res = subprocess.run(["cscript", "//nologo", vbs_path], capture_output=True, text=True)
    if "SUCCESS" in res.stdout:
        print(f"[DONE] {file_name} generated.")
        return True
    else:
        print(f"[ERROR] {file_name}: {res.stdout} {res.stderr}")
        return False

def main():
    print("Generating 10 Modular Subassemblies...")
    count = 0
    for m in MODULES:
        if generate_subassembly(m):
            count += 1
    print(f"\nAll {count}/10 subassemblies generated in {SUB_DIR}!")

if __name__ == "__main__":
    main()
