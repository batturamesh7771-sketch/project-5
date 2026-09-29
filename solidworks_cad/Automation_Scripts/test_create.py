import os
import win32com.client

project_dir = r"C:\Users\user\.gemini\antigravity\scratch\GE90_115B_Turbofan_Engine"
part_template = r"C:\ProgramData\SOLIDWORKS\SOLIDWORKS 2026\templates\Part.PRTDOT"

sw = win32com.client.Dispatch("SldWorks.Application")
sw.Visible = True

# Create new part
model = sw.NewDocument(part_template, 0, 0, 0)
if model is None:
    print("Failed to create document")
    exit(1)

test_part_path = os.path.join(project_dir, "Parts", "test_part.sldprt")

# Save document (swSaveAsOptions_Silent = 1)
errors = win32com.client.VARIANT(win32com.client.pythoncom.VT_BYREF | win32com.client.pythoncom.VT_I4, 0)
warnings = win32com.client.VARIANT(win32com.client.pythoncom.VT_BYREF | win32com.client.pythoncom.VT_I4, 0)

save_success = model.SaveAs4(test_part_path, 0, 1, errors, warnings)
print(f"Save success: {save_success}, Errors: {errors.value}, Warnings: {warnings.value}")

sw.CloseDoc(test_part_path)
print("Part closed successfully.")
