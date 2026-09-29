# AERO-X1 / GE90-115B TURBOFAN ENGINE: SYSTEM PROMPT & SPECIFICATIONS

## 1. PROJECT OBJECTIVES
The objective of **Project 5** is to create a complete, end-to-end digital twin of a commercial high-bypass turbofan powerplant (Boeing 777 / GE90-115B class) incorporating:
1. **Interactive 3D WebGL / Three.js Simulator**:
   - Real-time thermodynamic telemetry (N1, N2, EGT, Thrust, Fuel Flow, EPR).
   - Dual-spool rotational inertia and spool-up lag physics.
   - Dynamic Variable Stator Vanes (VSV) actuation linked to N2 speed.
   - Volumetric Supersonic Shock Diamonds rendered via custom GLSL shaders at PLA > 88%.
   - Thermal Heat-Mapping GLSL shader in X-Ray inspection mode scaled to live EGT.
   - Aerodynamic Compressor Stall / Surge fault injection with reversed flame puffs and cockpit vibration.
   - Real-time Brayton Cycle P-V thermodynamic diagram with dynamic work area and thermal efficiency calculation.
   - Pneumatic Bleed Air ECS off-take particle streams.
   - Fullscreen canvas with collapsible & draggable cybernetic HUD panels.

2. **Full 3D Parametric CAD SolidWorks Assembly Suite (50+ Files)**:
   - 44 individual parametric solid parts modeled to GE90-115B real-world dimensions (128" / 3,250 mm fan diameter).
   - 10 modular subassemblies covering all engine modules from fan spinner to exhaust mixer.
   - Master Engine Model linking all subassemblies with interlocking concentric and planar mates.
   - Automation scripts in Python and VBScript for programmatic generation, component patterning (22 fan blades, 38 compressor blades), and exploded view disassembly sequences.

---

## 2. ORIGINAL PROMPT INSTRUCTIONS

### Section A: SolidWorks Parametric Engine Assembly
```
OBJECT: BOEING 777 POWERPLANT — GE90-115B HIGH-BYPASS TURBOFAN ENGINE
ASSEMBLY STRUCTURE: MODULAR, DISASSEMBLE-READY, INTERLOCKING HARDWARE ASSEMBLY

--- SECTION 1: CORE CAD METHODOLOGY & SKETCHING CONSTRAINTS ---
1. GEOMETRY ORIGIN & SKETCHING FRAMEWORK:
   - Begin all sub-components as 2D fully-constrained parametric sketches on designated planes (Front, Top, Right) or offsets relative to the main Shaft Centerline Axis (X-Axis).
   - Enforce parametric sketch relations (Coincident, Concentric, Equal, Tangent, Symmetric, Horizontal/Vertical) prior to 3D feature creation (Revolve, Extrude, Sweep, Loft).
   - Use precise real-world dimensional scaling relative to the GE90-115B dimensions:
     * Fan Diameter: 128 inches (3,250 mm)
     * Engine Overall Length: 287 inches (7,290 mm)
     * Core Cowl Diameter: 62 inches (1,575 mm)
     * High-Pressure Compressor Stage 1 Tip Radius: 27 inches (685 mm)

--- SECTION 2: STEP-BY-STEP CAD RECONSTRUCTION SEQUENCE (PART-BY-PART) ---
1. MODULE 1: LOW-PRESSURE SPOOL (LPS) — FAN ROTOR & SPINNER
   - Part 1.1: Fan Spinner Cone (Parabolic Revolve with Spiral De-Icing Trajectory)
   - Part 1.2: Wide-Chord Composite Fan Blade (3D Airfoil Loft with Dovetail Root)
   - Part 1.3: Fan Hub Rotor Disk (Forged Titanium with 22 Broached Dovetail Slots)
   - Part 1.4: Fan Blade Retaining Front & Rear Spacer Rings
2. MODULE 2: FAN CASING & STRUCTURAL BYPASS DUCT
   - Part 2.1: Forward Inlet Lip Cowl (Aerodynamic Acoustic Ring)
   - Part 2.2: Fan Containment Case (Kevlar Armored Titanium Outer Shroud)
   - Part 2.3: Outlet Guide Vanes (OGVs) Structural Stator Array
3. MODULE 3: LOW-PRESSURE COMPRESSOR (LPC) / BOOSTER MODULE
   - Part 3.1: LPC 4-Stage Rotor Drum
   - Part 3.2: LPC Compressor Blades & Stator Ring Vanes
4. MODULE 4: HIGH-PRESSURE COMPRESSOR (HPC) CORE
   - Part 4.1: 9-Stage HPC Welded Rotor Drum with Dovetail Circumferential Slots
   - Part 4.2: HPC Rotor Blades (Stages 1-9)
   - Part 4.3: Split HPC Casing Top & Bottom Halves with Bolted Flanges
5. MODULE 5: COMBUSTION SYSTEM
   - Part 5.1: Annular Combustor Diffuser Outer Case
   - Part 5.2: Combustor Double-Walled Liner with Cooling Holes
   - Part 5.3: 30x Dual-Circuit Fuel Injectors & Spark Igniters
6. MODULE 6: HIGH-PRESSURE TURBINE (HPT)
   - Part 6.1: Stage 1 Nozzle Guide Vane (NGV) Ring
   - Part 6.2: 2-Stage HPT Rotor Disks with Fir-Tree Blade Attachment Slots
   - Part 6.3: Single-Crystal Superalloy Turbine Blades
7. MODULE 7: LOW-PRESSURE TURBINE (LPT)
   - Part 7.1: 6-Stage LPT Rotor Assembly
   - Part 7.2: LPT Outer Casing with Integrated Stator Rings
8. MODULE 8: EXHAUST SYSTEM & CENTERBODY
   - Part 8.1: Turbine Exhaust Case (TEC) with Internal Deswirl Struts
   - Part 8.2: Conical Exhaust Centerbody Plug & Chevron Mixer Nozzle
9. MODULE 9: SHAFTS, BEARINGS & TRANSMISSION
   - Part 9.1: N1 Low-Pressure Inner Shaft & N2 High-Pressure Outer Hollow Shaft
   - Part 9.2: Bearing Assemblies #1 through #5 (Inner/Outer Races, Rollers, Balls)
   - Part 9.3: Accessory Gearbox (AGB) & Radial Towershaft with Bevel Gears
10. MODULE 10: NACELLE & FASTENER HARDWARE
   - Split Fan Cowl Doors, Thrust Reverser Translating Sleeves, M8/M10 Aircraft Bolts and Alignment Pins.
```

### Section B: Web Simulator UI & Physics Architecture
```
TARGET APPLICATION: AERO-X1 TURBOFAN SIMULATOR (THREE.JS / WEBGL)
1. MAXIMIZE 3D CANVAS VIEWPORT (100vw x 100vh) behind UI elements.
2. COLLAPSIBLE & DRAGGABLE PANELS with grip handles, edge clamping, and dock tabs.
3. SEMI-TRANSPARENT HUD OVERLAY CARD with hotkey 'I' toggle and drag handle.
4. KINEMATICS & SPOOL-UP INERTIA:
   - N2 accelerates faster than N1 (dual-spool rotational inertia).
   - PLA Detents: Cutoff (0%), Idle (25%), Cruise (75%), Afterburner (100%).
5. ADVANCED GLSL SHADERS:
   - Volumetric Supersonic Shock Diamonds at PLA > 88%.
   - Thermal Heat-Mapping in X-Ray mode dynamically scaled to live EGT.
6. AERODYNAMIC COMPRESSOR STALL / SURGE:
   - Fault injection button: thrust collapse, EGT redline, reversed intake blast, airframe vibration.
7. REAL-TIME BRAYTON CYCLE:
   - SVG P-V loop polygon with live thermal efficiency eta_th and net power W_net.
8. BLEED AIR ECS OFF-TAKES:
   - Pneumatic air streams from 4th and 9th stage ports.
```
