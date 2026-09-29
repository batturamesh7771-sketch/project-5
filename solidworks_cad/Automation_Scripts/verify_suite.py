import os

PROJECT_DIR = r"C:\Users\user\.gemini\antigravity\scratch\GE90_115B_Turbofan_Engine"
PARTS_DIR = os.path.join(PROJECT_DIR, "Parts")
SUB_DIR = os.path.join(PROJECT_DIR, "Subassemblies")
MASTER_DIR = os.path.join(PROJECT_DIR, "Master")

parts = sorted([f for f in os.listdir(PARTS_DIR) if f.upper().endswith(".SLDPRT") and not f.startswith("~$") and f != "test_part.SLDPRT"])
subs = sorted([f for f in os.listdir(SUB_DIR) if (f.upper().endswith(".SLDPRT") or f.upper().endswith(".SLDASM")) and not f.startswith("~$") and not f.startswith("test_")])
masters = sorted([f for f in os.listdir(MASTER_DIR) if not f.startswith("~$")])

print(f"=== GE90-115B SOLIDWORKS CAD SUITE VERIFICATION ===")
print(f"Total Unique Part Files in Parts/: {len(parts)}")
for p in parts:
    size = os.path.getsize(os.path.join(PARTS_DIR, p))
    print(f"  - {p} ({size:,} bytes)")

print(f"\nTotal Modular Subassemblies in Subassemblies/: {len(subs)}")
for s in subs:
    size = os.path.getsize(os.path.join(SUB_DIR, s))
    print(f"  - {s} ({size:,} bytes)")

print(f"\nTotal Master Models in Master/: {len(masters)}")
for m in masters:
    size = os.path.getsize(os.path.join(MASTER_DIR, m))
    print(f"  - {m} ({size:,} bytes)")
