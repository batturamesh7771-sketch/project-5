import os
import math
import win32com.client

project_dir = r"C:\Users\user\.gemini\antigravity\scratch\GE90_115B_Turbofan_Engine"
part_template = r"C:\ProgramData\SOLIDWORKS\SOLIDWORKS 2026\templates\Part.PRTDOT"

sw = win32com.client.Dispatch("SldWorks.Application")
model = sw.NewDocument(part_template, 0, 0, 0)

# Select Front Plane
# In SW API: SelectByID2(Name, Type, X, Y, Z, Append, Mark, Callout, SelectOption)
sel = model.Extension.SelectByID2("Front Plane", "PLANE", 0, 0, 0, False, 0, None, 0)
print("Front Plane selected:", sel)

model.SketchManager.InsertSketch(True)

# Draw centerline on axis of revolution (X axis: y=0)
cl = model.SketchManager.CreateCenterLine(0, 0, 0, 0.5, 0, 0)

# Draw a closed profile for revolve:
# Point 1: (0, 0, 0) -> Point 2: (0, 0.1, 0) -> Point 3: (0.3, 0.05, 0) -> Point 4: (0.3, 0, 0) -> Point 1
l1 = model.SketchManager.CreateLine(0, 0, 0, 0, 0.1, 0)
l2 = model.SketchManager.CreateLine(0, 0.1, 0, 0.3, 0.05, 0)
l3 = model.SketchManager.CreateLine(0.3, 0.05, 0, 0.3, 0, 0)
l4 = model.SketchManager.CreateLine(0.3, 0, 0, 0, 0, 0)

# Select centerline for revolution
model.ClearSelection2(True)
model.Extension.SelectByID2("Line1", "SKETCHPRIMITIVE", 0.25, 0, 0, True, 16, None, 0) # Mark 16 for axis

# Revolve 360 deg (2*pi radians)
# FeatureRevolve2(SingleDir, IsSolid, IsThin, ReverseDir, OverRideDir, ReverseThinDir,
# Type1, Type2, Angle1, Angle2, OffsetReverse1, OffsetReverse2, OffsetDist1, OffsetDist2,
# ThinType, ThinThickness1, ThinThickness2, Merge, UseFeatScope, UseAutoSelect)
feat = model.FeatureManager.FeatureRevolve2(True, True, False, False, False, False, 0, 0, 2*math.pi, 0, False, False, 0.01, 0.01, 0, 0, 0, True, True, True)
print("Revolve feature created:", feat is not None)

test_part_path = os.path.join(project_dir, "Parts", "test_revolve.sldprt")
errors = win32com.client.VARIANT(win32com.client.pythoncom.VT_BYREF | win32com.client.pythoncom.VT_I4, 0)
warnings = win32com.client.VARIANT(win32com.client.pythoncom.VT_BYREF | win32com.client.pythoncom.VT_I4, 0)
model.SaveAs4(test_part_path, 0, 1, errors, warnings)
sw.CloseDoc(test_part_path)
print("Saved and closed test_revolve.sldprt")
