# AERO-X1 TURBOFAN WEB SIMULATOR GUIDE

## Architecture Overview
The **AeroX-1 Simulator** runs inside standard modern web browsers on top of **Three.js (r128)**, utilizing standard WebGL 2.0 with custom GLSL shaders and physical equations of motion.

---

## 1. Thermodynamic Telemetry Equations
The simulator calculates continuous thermodynamic state variables as a function of the Power Lever Angle (PLA) and rotational speeds:

1. **Dual-Spool Rotor Angular Velocity**:
   $$\omega_{N1} = 2\pi \times \frac{\text{RPM}_{N1}}{60}, \quad \omega_{N2} = 2\pi \times \frac{\text{RPM}_{N2}}{60}$$
   Rotations are synchronized to time delta ($\Delta t$) so frame-rate drops do not cause visual desync.

2. **Rotor Inertial Lag**:
   $$\frac{d(\text{N2})}{dt} = 4.2 \times (\text{N2}_{\text{target}} - \text{N2}), \quad \frac{d(\text{N1})}{dt} = 1.6 \times (\text{N1}_{\text{target}} - \text{N1})$$
   Because the high-pressure spool has significantly lower rotational inertia than the 128-inch titanium fan, N2 responds rapidly to throttle transients while N1 displays characteristic high-bypass spool-up delay.

3. **Engine Pressure Ratio (EPR) & Overall Pressure Ratio (OPR)**:
   $$\text{OPR} = 1.0 + 37.5 \times (\text{N2}_{\text{norm}})^{1.85}$$
   $$\text{EPR} = 1.0 + 0.85 \times (\text{N2}_{\text{norm}})^{1.8}$$

4. **Brayton Cycle Thermal Efficiency**:
   $$\eta_{th} = 1 - \frac{1}{\text{OPR}^{(\gamma - 1)/\gamma}} \quad (\text{with } \gamma = 1.4 \implies \frac{\gamma-1}{\gamma} \approx 0.286)$$

5. **Variable Stator Vane (VSV) Kinematic Law**:
   $$\theta_{VSV} = +30.0^\circ - 35.0^\circ \times \left(\frac{\text{N2}\%}{100}\right)$$
   At idle ($22\% \text{ N2}$), the vanes close to $+30^\circ$ to prevent boundary layer separation and aerodynamic stall. At full cruise/max thrust ($100\% \text{ N2}$), the vanes rotate to $-5^\circ$ for maximum mass airflow throughput.

---

## 2. GLSL Shaders

### A. Volumetric Supersonic Shock Diamonds (`SHADER_SHOCK_DIAMOND`)
Applied to a conical mesh aligned along the nozzle longitudinal axis ($Z$).
* Evaluates periodic axial compression waves:
  $$\text{node} = \left|\sin(z \cdot \pi)\right|^{3.2}$$
* Radial attenuation decays towards the nozzle boundary:
  $$\text{radial} = \left(1 - 2\left|u - 0.5\right|\right)^{2.2}$$
* Superimposes high-frequency expansion wave perturbations:
  $$\text{wave} = \sin(8z - 24t) \times 0.15$$
* The shader automatically engages when $\text{PLA} > 88\%$, achieving peak luminous intensity at $100\%$ PLA.

### B. Thermal Heat-Mapping Shader (`SHADER_THERMAL_XRAY`)
Used when the user switches to **X-RAY GHOST** mode.
* Measures vertex world position $z$ along the engine longitudinal axis:
  * $z > 1.2\text{ m}$: Intake & Fan (Cryogenic Blue: $0^\circ\text{C} - 50^\circ\text{C}$)
  * $0.2 < z \le 1.2\text{ m}$: High-Pressure Compressor (Warm Amber: $250^\circ\text{C} - 550^\circ\text{C}$)
  * $-1.5 < z \le 0.2\text{ m}$: Combustor & HPT (Intense Orange to White: $900^\circ\text{C} - 1300^\circ\text{C}$)
  * $z \le -1.5\text{ m}$: Low-Pressure Turbine & Exhaust (Radiant Cherry Red: $600^\circ\text{C} - 800^\circ\text{C}$)
* Dynamically scales emission intensity with the live Exhaust Gas Temperature ($\text{EGT}$) variable.

---

## 3. Fault Injection System: Compressor Stall & Surge
Clicking **"INDUCE COMPRESSOR STALL"** executes an aerodynamic surge transient:
1. **Thrust Collapse**: Net thrust drops to $< 3\text{ kN}$ while EPR falls to $1.02$.
2. **Thermal Spike**: EGT spikes past redline ($> 1050^\circ\text{C}$) simulating combustor backpressure stagnation.
3. **Reversed Intake Plume**: The stall particle emitter triggers forward-traveling ($+Z$) flame/smoke bursts ejecting from the inlet.
4. **Airframe Vibration**: Perturbs camera coordinates with high-frequency noise simulating severe cockpit buffeting.
5. **Recovery**: Clicking the button again clears the stall and returns the surge margin to nominal ($28\%$).
