# SOLIDWORKS CAD MASTER INVENTORY & MODULE HIERARCHY

This directory houses the complete parametric CAD definition of the **GE90-115B High-Bypass Turbofan Engine** created in SolidWorks.

## Directory Structure
* `Master/`: Full engine assemblies and unified master part models with all 10 stages integrated.
* `Subassemblies/`: 10 independent functional modules configured with concentric, planar, and dovetail mates.
* `Parts/`: 44 distinct detailed `.SLDPRT` components with exact geometric dimensions, draft angles, and PBR aerospace materials.
* `Automation_Scripts/`: Automation scripts (Python COM & VBScript) used to build, mate, pattern, and verify the engine models.

---

## 1. Subassembly Breakdown (`Subassemblies/`)

| Assembly ID | Subassembly Name | Primary Components | Key Assembly Mates |
| :--- | :--- | :--- | :--- |
| **ASM_01** | `ASM_01_Fan_Spinner` | 01_SpinnerCone, 02_FanBlade_Composite (22x), 03_FanDiskHub, 04_RetainingPlate | Concentric to Centerline, Dovetail Tangent, Circular Pattern (22x) |
| **ASM_02** | `ASM_02_Fan_Case_Frame` | 05_ForwardInletLipCowl, 06_FanContainmentCase, 07_OutletGuideVane (48x) | Cylindrical Flange Mates, Bolted Fastener Pattern |
| **ASM_03** | `ASM_03_LPC_Booster` | 08_LPC_RotorDrum, 09_LPC_CompressorBlade (4 stages), 10_LPC_StatorRing | Axis Align, Shaft Keyway Coincident |
| **ASM_04** | `ASM_04_HPC_Core` | 11_HPC_9Stage_RotorDrum, 12_HPC_Blade, 13_SplitCasing_Top, 14_SplitCasing_Bottom | Split Line Planar Mates, VSV Pivot Mates |
| **ASM_05** | `ASM_05_Combustion_System` | 15_DiffuserCase, 16_OuterLiner, 17_InnerLiner, 18_FuelInjector (30x), 19_SparkIgniter (2x) | Radial Swirler Mates, Annular Bolting |
| **ASM_06** | `ASM_06_High_Pressure_Turbine`| 20_HPT_NGV_Ring, 21_HPT_2Stage_Disk, 22_HPT_TurbineBlade (Fir-tree) | Fir-tree Root Mates, Thermal Expansion Clearances |
| **ASM_07** | `ASM_07_Low_Pressure_Turbine` | 23_LPT_6Stage_RotorDrum, 24_LPT_Blade, 25_LPT_OuterCasing | Drum Stacking Mates, Tie-bolt Clamp |
| **ASM_08** | `ASM_08_Shafts_Bearings` | 28_Shaft_N1_LP, 29_Shaft_N2_HP, 30_Bearing_InnerRace, 31_OuterRace, 32_Rollers, 33_Balls | Concentric Coaxial Mates, Counter-Rotation Freedom |
| **ASM_09** | `ASM_09_AGB_Driveshaft` | 34_Towershaft_BevelGear, 35_AGB_MainHousing | 90° Bevel Gear Mesh Mates, Radial Strut Passage |
| **ASM_10** | `ASM_10_Nacelle_Cowlings` | 36_FanCowl_Left, 37_FanCowl_Right, 38_AftThrustReverserCowl | Hinge Pin Cylindrical Mates, Latch Interfaces |

---

## 2. Complete Parts Inventory (`Parts/`)

1. `01_SpinnerCone.SLDPRT` - Parabolic nose cone with aerodynamic spiral line (Aluminum/Composite).
2. `02_FanBlade_Composite.SLDPRT` - 3D twisted wide-chord scimitar fan blade with titanium leading-edge sheath and dovetail root.
3. `03_FanDiskHub_Stg1.SLDPRT` - Forged titanium disk with 22 broached circumferential dovetail slots.
4. `04_FanBlade_RetainingPlate.SLDPRT` - Annular locking plate securing blade roots against axial travel.
5. `05_ForwardInletLipCowl.SLDPRT` - Aerodynamic intake cowl with acoustic honeycomb insulation.
6. `06_FanContainmentCase.SLDPRT` - Armored containment ring engineered for blade-out containment.
7. `07_OutletGuideVane_OGV.SLDPRT` - Aerodynamic stator vane removing swirl from fan bypass stream.
8. `08_LPC_RotorDrum_4Stage.SLDPRT` - 4-stage booster spool welded drum.
9. `09_LPC_CompressorBlade.SLDPRT` - Low-aspect ratio compressor blade with curved root.
10. `10_LPC_StatorVaneRing.SLDPRT` - Stationary stator segment for booster stages.
11. `11_HPC_9Stage_RotorDrum.SLDPRT` - 9-stage inertia-welded high-pressure compressor rotor drum.
12. `12_HPC_CompressorBlade_Stg1.SLDPRT` - High-pressure compressor airfoil blade.
13. `13_HPC_SplitCasing_TopHalf.SLDPRT` - Upper half of axially split compressor casing with VSV boreholes.
14. `14_HPC_SplitCasing_BottomHalf.SLDPRT` - Lower half of axially split compressor casing with mating flange.
15. `15_Combustor_DiffuserCase.SLDPRT` - Pressure vessel directing compressor discharge air into burner.
16. `16_Combustor_OuterLiner.SLDPRT` - Double-wall effusion-cooled outer combustion liner.
17. `17_Combustor_InnerLiner.SLDPRT` - High-temperature ceramic-matrix composite inner burner liner.
18. `18_FuelInjector_Swirler.SLDPRT` - Dual-orifice fuel injection nozzle with swirl cup.
19. `19_SparkIgniter_Plug.SLDPRT` - High-energy electrical ignition plug.
20. `20_HPT_NozzleGuideVane_Stg1.SLDPRT` - Film-cooled high-pressure nozzle guide vane ring.
21. `21_HPT_RotorDisk_2Stage.SLDPRT` - 2-stage turbine rotor disk with fir-tree rim slots.
22. `22_HPT_TurbineBlade.SLDPRT` - Single-crystal nickel superalloy blade with internal serpentine cooling channels.
23. `23_LPT_6Stage_RotorDrum.SLDPRT` - 6-stage low-pressure turbine disk stack.
24. `24_LPT_TurbineBlade.SLDPRT` - Shrouded tip low-pressure turbine blade.
25. `25_LPT_OuterCasing.SLDPRT` - Structural turbine case with interstage seal lands.
26. `26_TurbineExhaustCase_TEC.SLDPRT` - Aft structural frame with aerodynamically faired radial struts.
27. `27_ExhaustMixer_ChevronPlug.SLDPRT` - Serrated chevron mixer nozzle and central exhaust bullet plug.
28. `28_Shaft_N1_LowPressure.SLDPRT` - Long central drive shaft coupling fan and LPT.
29. `29_Shaft_N2_HighPressure.SLDPRT` - Coaxial outer hollow shaft coupling HPC and HPT.
30. `30_Bearing_InnerRace.SLDPRT` - Precision ground inner race for #1/#2 main bearings.
31. `31_Bearing_OuterRace.SLDPRT` - Outer race with oil damper squeeze film lands.
32. `32_Bearing_RollerElement.SLDPRT` - Cylindrical roller element for radial load bearing.
33. `33_Bearing_BallElement.SLDPRT` - Angular contact ball element for axial thrust bearing.
34. `34_Towershaft_BevelGear.SLDPRT` - Spiral bevel gear transmitting power to accessory drive.
35. `35_AGB_MainHousing.SLDPRT` - Cast aluminum gearbox housing mounting fuel pumps and generators.
36. `36_Nacelle_FanCowlDoor_Left.SLDPRT` - Hinged access cowl door (port side).
37. `37_Nacelle_FanCowlDoor_Right.SLDPRT` - Hinged access cowl door (starboard side).
38. `38_Nacelle_AftThrustReverserCowl.SLDPRT` - Translating sleeve cowl for reverse thrust deceleration.
39. `39_Fastener_M10_SocketHeadCapScrew.SLDPRT` - High-strength aerospace alloy cap screw.
40. `40_Fastener_M8_HexFlangeBolt.SLDPRT` - Casing flange bolt with integrated washer head.
41. `41_Fastener_M8_LockNut.SLDPRT` - Self-locking deformed thread aerospace nut.
42. `42_Fastener_M8_HardenedWasher.SLDPRT` - Precision hardened load distribution washer.
43. `43_Fastener_AlignmentDowelPin.SLDPRT` - Ground shear alignment pin for split casing halves.
44. `44_Blade_LockingKey_Pin.SLDPRT` - Retention key for securing fan and turbine blades into rotor slots.
