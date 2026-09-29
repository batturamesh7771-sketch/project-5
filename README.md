# Project 5: AeroX-1 / GE90-115B Turbofan Engine Digital Twin

[![Three.js](https://img.shields.io/badge/WebGL-Three.js_r128-blue.svg)](https://threejs.org/)
[![SolidWorks](https://img.shields.io/badge/CAD-SolidWorks_2026-red.svg)](https://www.solidworks.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

A complete aerospace engineering digital twin of the **Boeing 777 powerplant (General Electric GE90-115B class high-bypass turbofan)**. This repository integrates an interactive WebGL simulation environment with a full 50+ component parametric 3D CAD model suite designed for modular assembly and disassembly.

---

## 📑 Repository Structure

```
project-5/
├── README.md                              # Master Project Documentation
├── LICENSE                                # MIT Open Source License
├── docs/                                  # Engineering & Architectural Specifications
│   ├── PROMPT_SPECIFICATIONS.md           # Original Engineering Prompts & Directives
│   ├── SOLIDWORKS_CAD_MODULES.md          # 50+ Component CAD Hierarchy & Mate Map
│   └── SIMULATOR_GUIDE.md                 # WebGL Simulator User Guide & GLSL Shaders
├── web_simulator/                         # 3D Interactive WebGL Aerospace Laboratory
│   ├── index.html                         # Fullscreen Simulation Dashboard
│   ├── style.css                          # Cybernetic HUD, Draggable Panels & Animations
│   ├── app.js                             # Three.js Kinematics, GLSL Shaders & Physics
│   ├── jet_engine.glb                     # 3D PBR Model Asset
│   ├── jet_plane.mp3                      # Dual-Spool Acoustic Audio Stream
│   ├── js/                                # Three.js Libraries (r128, OrbitControls, GLTFLoader)
│   └── textures/                          # Metallic PBR Textures
└── solidworks_cad/                        # 50+ Native SolidWorks CAD Models & Assemblies
    ├── Master/                            # Full Master Engine Models (SLDPRT / SLDASM)
    │   └── GE90_115B_Master_Engine.SLDPRT
    ├── Subassemblies/                     # 10 Functional Engine Modules (ASM_01 to ASM_10)
    │   ├── ASM_01_Fan_Spinner.SLDASM
    │   ├── ASM_01_Fan_Spinner.SLDPRT
    │   ├── ASM_02_Fan_Case_Frame.SLDPRT
    │   ├── ASM_03_LPC_Booster.SLDPRT
    │   ├── ASM_04_HPC_Core.SLDPRT
    │   ├── ASM_05_Combustion_System.SLDPRT
    │   ├── ASM_06_High_Pressure_Turbine.SLDPRT
    │   ├── ASM_07_Low_Pressure_Turbine.SLDPRT
    │   ├── ASM_08_Shafts_Bearings.SLDPRT
    │   ├── ASM_09_AGB_Driveshaft.SLDPRT
    │   └── ASM_10_Nacelle_Cowlings.SLDPRT
    ├── Parts/                             # 44 Individual Solid Components (SLDPRT)
    │   ├── 01_SpinnerCone.SLDPRT
    │   ├── 02_FanBlade_Composite.SLDPRT
    │   ├── 03_FanDiskHub_Stg1.SLDPRT
    │   ├── ... (44 detailed aircraft parts)
    │   └── 44_Blade_LockingKey_Pin.SLDPRT
    └── Automation_Scripts/                # Python COM & VBScript CAD Generators
        ├── generate_all_parts.py
        ├── generate_all_subassemblies.py
        └── generate_master_model.py
```

---

## ⚡ 1. Interactive Web Simulator Features

* **True 100vw × 100vh Viewport**: The 3D turbine model occupies the complete screen with unobstructed OrbitControls (orbit, pan, zoom) enabled across the entire viewport.
* **Movable & Collapsible Side Panels**: Both the **Telemetry & FADEC** and **Structure & AR Inspection** panels feature custom drag handles with boundary clamping, and can be collapsed into sleek side dock tabs (`▶` / `◀`).
* **Calibrated PLA Power Lever**:
  * **PLA 0% (Cutoff)**: $\text{N1} = 0\%$, $\text{N2} = 0\%$, $\text{EGT} = 20^\circ\text{C}$, $\text{Fuel} = 0\text{ kg/h}$.
  * **PLA 25% (Idle)**: $\text{N1} = 22\%$, $\text{N2} = 55\%$, $\text{EGT} = 350^\circ\text{C}$, $\text{Fuel} = 380\text{ kg/h}$.
  * **PLA 75% (Cruise)**: $\text{N1} = 78\%$, $\text{N2} = 80.8\%$, $\text{EGT} = 691^\circ\text{C}$, $\text{Fuel} = 1,450\text{ kg/h}$.
  * **PLA 100% (Afterburner/Max)**: $\text{N1} = 100\%$, $\text{N2} = 100\%$, $\text{EGT} = 920^\circ\text{C}$, $\text{Fuel} = 2,200\text{ kg/h}$ + supersonic shock diamonds!
* **Dual-Spool Angular Momentum & Inertia**: Realistic spool-up lag physics where the lightweight high-pressure core ($\text{N2}$) accelerates rapidly, followed by rotational inertia lag on the wide-chord fan ($\text{N1}$).
* **Variable Stator Vanes (VSV) Kinematics**: HPC stator vanes rotate dynamically on local Y-axes from $+30.0^\circ$ (idle) to $-5.0^\circ$ (max thrust).
* **Volumetric GLSL Exhaust Shock Diamonds**: Custom vertex and fragment shaders render animated Mach diamond nodes at $\text{PLA} > 88\%$.
* **Thermal Heat-Mapping GLSL Shader**: In **X-Ray Ghost** mode, engine components display a real-time thermal gradient (Blue $\rightarrow$ Cyan $\rightarrow$ Amber $\rightarrow$ White-Hot) scaled to live EGT.
* **Aerodynamic Compressor Stall & Surge**: Interactive fault injection triggers thrust collapse, EGT redline ($> 1050^\circ\text{C}$), reversed intake flame puffs, and airframe vibration.
* **Real-Time Brayton Cycle (P-V Diagram)**: Dynamic SVG polygon showing real-time thermodynamic cycle work expansion and efficiency calculation $\eta_{th}$.
* **Pneumatic Bleed Air ECS**: Visualizes 4th and 9th stage bleed air streams tapping pressurized air for cabin climate control.
* **Procedural 3D Fallback Engine**: If an external `.glb` file is missing, the simulator automatically constructs an intricate multi-stage procedural turbine from Three.js primitives without interrupting the session.

---

## 🛠️ 2. SolidWorks CAD Architecture (50+ Files)

* **Real-World Dimensional Scaling**:
  * Fan Tip Diameter: 128 inches (3,250 mm)
  * Overall Powerplant Length: 287 inches (7,290 mm)
  * Core Cowl Diameter: 62 inches (1,575 mm)
* **Modular Assembly Sequence**:
  * **LPS Fan Rotor**: 22 scimitar wide-chord composite blades locked via broached dovetail slots and retention plates.
  * **LPC Booster**: 4-stage axial compressor drum.
  * **HPC Core**: 9-stage welded titanium drum housed inside split top and bottom casings with VSV actuator mounts.
  * **Combustion System**: Double-walled effusion-cooled liner with 30 dual-circuit fuel injectors.
  * **HPT Module**: 2-stage turbine disks with fir-tree rim slots and single-crystal superalloy blades.
  * **LPT Module**: 6-stage shrouded turbine assembly.
  * **Dual Coaxial Shafts**: Concentric LP and HP shafts with bearing races, ball, and roller elements.
  * **Aerodynamic Nacelle**: Hinged fan cowl doors, translating reverse-thrust sleeves, and chevron mixer nozzle.

---

## 🚀 3. Quick Start & Execution

### Running the Web Simulator Locally:
```bash
# Navigate to web simulator directory
cd web_simulator

# Start local HTTP server
python -m http.server 8088

# Open in your browser:
# http://127.0.0.1:8088/
```

### Hotkeys in Simulator:
| Key | Action |
| :--- | :--- |
| `Space` | Toggle Engine Master Run / Spool-Down |
| `H` | Cycle Casing Visibility (Solid / X-Ray / Exposed) |
| `X` | Quick Toggle Thermal X-Ray Ghost Mode |
| `A` | Toggle Engine Audio Synthesis |
| `R` | Reset Camera to Isometric Viewpoint |
| `I` | Toggle Detail HUD Telemetry Card |
| `S` | Induce / Clear Compressor Stall |
| `1` - `4` | Throttle Detents (Cutoff, Idle, Cruise, Max) |

---

## 📜 4. License
This project is released under the **MIT License**.
