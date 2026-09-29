/**
 * AeroX-1 Jet Engine Simulation Laboratory (Digital Twin Edition)
 * High-Bypass Commercial Turbofan (Boeing 777 / GE90 Class)
 * Features: Dual-Spool Inertia, VSV Kinematics, Volumetric Shock Diamonds,
 * Thermal Heat-Mapping GLSL, Compressor Stall Injection, Real-Time Brayton Cycle.
 */

// ==========================================
// 1. GLOBAL STATE & AEROSPACE SPECIFICATIONS
// ==========================================
const state = {
  isRunning: true,
  isStalled: false,
  pla: 75.0,              // Current Power Lever Angle (0 - 100%)
  targetPLA: 75.0,        // Target PLA from slider / detents
  
  // Dual-Spool Inertial Dynamics
  n1Pct: 78.0,            // Low-Pressure Spool (Fan & LPC) %
  n2Pct: 80.8,            // High-Pressure Spool (HPC & HPT) %
  rpmN1: 7800,
  rpmN2: 12120,
  
  // Aerothermal Telemetry
  egt: 691.0,             // Exhaust Gas Temp (°C)
  thrustKn: 98.4,         // Net Thrust (kN)
  thrustLbf: 22120,       // Net Thrust (lbf)
  fuelFlow: 1450.0,       // Fuel Flow (kg/h)
  epr: 1.62,              // Engine Pressure Ratio
  
  // Subsystems & Actuation
  vsvAngle: -2.8,         // Variable Stator Vanes angle (+30° to -5°)
  bleedActive: true,      // 4th/9th stage pneumatic bleed
  bleedPressure: 24.2,    // PSI
  surgeMargin: 28.0,      // %
  shakeIntensity: 0.0,    // Airframe vibration amplitude
  
  // Visual & Rendering Modes
  hullMode: 'solid',      // 'solid', 'xray', 'hidden'
  explodeRatio: 0.0,
  targetExplodeRatio: 0.0,
  audioEnabled: false,
  particlesEnabled: true,
  selectedComponent: null,
  activeCameraPreset: 'iso',
  
  // Shaders & Materials
  shockDiamondMat: null,
  thermalShaderMat: null,
  xrayGhostMat: null,
  isProcedural: false
};

// Component metadata & focus coordinates
const COMPONENT_DETAILS = {
  fan: {
    name: 'Titanium Fan & Intake Spinner',
    tag: 'LOW-PRESSURE SPOOL (N1)',
    desc: 'High-bypass wide-chord fan blades forged from titanium alloy with composite damping. Generates ~80% of total subsonic thrust.',
    rpm: '7,800 RPM',
    mat: 'Ti-6Al-4V Alloy PBR',
    camPos: [0, 0.4, 4.2],
    camTarget: [0, 0, 1.8]
  },
  hull: {
    name: 'Titanium Nacelle & Middle Shroud',
    tag: 'STRUCTURAL AIRFRAME & CASING',
    desc: 'Outer aerodynamic nacelle and acoustic attenuation liner. Protects inner core and guides bypass air stream.',
    rpm: 'STATIC ENCLOSURE',
    mat: 'Hull-3 Metallic Casing',
    camPos: [3.8, 1.2, 0.2],
    camTarget: [0, 0, 0]
  },
  grid: {
    name: 'Intake Protection Grid & Inlet Stators',
    tag: 'FOD INTAKE PROTECTION',
    desc: 'Structural stainless steel grid and pre-swirl vanes to prevent foreign object debris from entering core stages.',
    rpm: 'STATIC GUIDE',
    mat: 'Grid-0 Hardened Steel',
    camPos: [0, 1.5, 3.8],
    camTarget: [0, 0, 2.6]
  },
  nozzle: {
    name: 'Variable Exhaust Flaps & Stabilisers',
    tag: 'THRUST VECTOR & PROPULSION',
    desc: 'Multi-petal convergent-divergent nozzle flaps actuated by hydraulic rams for supersonic expansion and Mach diamond containment.',
    rpm: 'ACTUATED 15° - 42°',
    mat: 'Inconel Superalloy',
    camPos: [0, -0.6, -4.8],
    camTarget: [0, 0, -2.5]
  },
  fuel: {
    name: 'High-Pressure Fuel Manifolds & Hydraulics',
    tag: 'FADEC DISTRIBUTION SYSTEM',
    desc: 'Dual-circuit fuel injector rails and titanium hydraulic actuator lines routed to variable stator vanes.',
    rpm: 'PRESSURIZED (180 BAR)',
    mat: 'Stainless / Chrome Rails',
    camPos: [1.8, 1.4, -0.5],
    camTarget: [0, 0.2, -0.2]
  },
  fadec: {
    name: 'Full Authority Digital Engine Control (FADEC)',
    tag: 'AVIONICS & CORE COMPUTER',
    desc: 'Dual-redundant digital engine control computer managing ignition, fuel metering, surge protection, and telemetry.',
    rpm: 'BUS CLOCK 400 MHz',
    mat: 'Composite Avionics Enclosure',
    camPos: [-1.8, 1.2, 0.5],
    camTarget: [-0.3, 0.6, 0.2]
  }
};

// ==========================================
// 2. THREE.JS SCENE INSTANCES & REFERENCES
// ==========================================
let scene, camera, renderer, controls;
let engineGroup, rotorGroup, hullGroup, coreGroup;
let shockDiamondMesh;
let vsvStatorMeshes = [];
let partMeshes = [];
let audioContext, audioBuffer, audioSource, audioGain;
let intakeParticles, exhaustParticles, bleedParticles, stallParticles;
let raycaster, mouse;
let clock;

// DOM References
const canvas = document.getElementById('webgl-canvas');
const loadingOverlay = document.getElementById('loading-overlay');
const loadingFill = document.getElementById('loading-bar-fill');
const loadingStatus = document.getElementById('loading-status-text');

// Telemetry Elements
const n1Val = document.getElementById('n1-val');
const n1Rpm = document.getElementById('n1-rpm');
const n1Bar = document.getElementById('n1-bar');
const n2Val = document.getElementById('n2-val');
const n2Rpm = document.getElementById('n2-rpm');
const n2Bar = document.getElementById('n2-bar');
const egtVal = document.getElementById('egt-val');
const egtBar = document.getElementById('egt-bar');
const thrustVal = document.getElementById('thrust-val');
const thrustLbf = document.getElementById('thrust-lbf');
const thrustBar = document.getElementById('thrust-bar');
const fuelVal = document.getElementById('fuel-val');
const fuelBar = document.getElementById('fuel-bar');
const eprVal = document.getElementById('epr-val');
const eprBar = document.getElementById('epr-bar');
const throttleSlider = document.getElementById('throttle-slider');
const throttlePctDisplay = document.getElementById('throttle-pct-display');
const btnEngineToggle = document.getElementById('btn-engine-toggle');
const engineBtnText = document.getElementById('engine-btn-text');
const masterStatus = document.getElementById('master-status');

// Subsystems & Fault Injection
const vsvAngleVal = document.getElementById('vsv-angle-val');
const vsvStatus = document.getElementById('vsv-status');
const bleedStatusVal = document.getElementById('bleed-status-val');
const bleedPressVal = document.getElementById('bleed-press-val');
const btnStallToggle = document.getElementById('btn-stall-toggle');
const stallBtnText = document.getElementById('stall-btn-text');
const stallIndicator = document.getElementById('stall-indicator');

// Brayton SVG
const braytonEff = document.getElementById('brayton-eff');
const braytonWnet = document.getElementById('brayton-wnet');
const pvPolygon = document.getElementById('pv-polygon');
const pvPt1 = document.getElementById('pv-pt1');
const pvPt2 = document.getElementById('pv-pt2');
const pvPt3 = document.getElementById('pv-pt3');
const pvPt4 = document.getElementById('pv-pt4');

// Casing & Explode Controls
const btnHullSolid = document.getElementById('btn-hull-solid');
const btnHullXray = document.getElementById('btn-hull-xray');
const btnHullHide = document.getElementById('btn-hull-hide');
const explodeSlider = document.getElementById('explode-slider');
const explodePct = document.getElementById('explode-pct');

// Header & Audio
const btnSound = document.getElementById('btn-sound-toggle');
const soundBtnLabel = document.getElementById('sound-btn-label');
const btnToggleHud = document.getElementById('btn-toggle-hud');
const btnCloseTooltip = document.getElementById('btn-close-tooltip');
const tooltip = document.getElementById('part-tooltip');
const tooltipTitle = document.getElementById('tooltip-name');
const tooltipTag = document.getElementById('tooltip-tag');
const tooltipDesc = document.getElementById('tooltip-desc');
const tooltipRpm = document.getElementById('tooltip-rpm');
const tooltipMat = document.getElementById('tooltip-mat');
const deltaDisplay = document.getElementById('delta-display');

// ==========================================
// 3. GLSL SHADERS (CFD & THERMODYNAMICS)
// ==========================================
const SHADER_SHOCK_DIAMOND = {
  vertexShader: `
    varying vec2 vUv;
    varying vec3 vPosition;
    void main() {
      vUv = uv;
      vPosition = position;
      gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
    }
  `,
  fragmentShader: `
    uniform float uTime;
    uniform float uIntensity;
    uniform vec3 uColorCore;
    uniform vec3 uColorGlow;
    varying vec2 vUv;
    varying vec3 vPosition;

    void main() {
      if (uIntensity <= 0.01) {
        discard;
      }
      // Axial progression along exhaust stream (Z from 0 to 1)
      float z = vUv.y * 14.0;
      // Periodic Mach diamond compression nodes
      float diamond = abs(sin(z * 3.14159));
      diamond = pow(diamond, 3.2);

      // Radial decay away from core centerline
      float radial = 1.0 - abs(vUv.x - 0.5) * 2.0;
      radial = pow(max(0.0, radial), 2.2);

      // High frequency supersonic expansion waves
      float ripple = sin(z * 8.0 - uTime * 24.0) * 0.15;
      float shockCore = smoothstep(0.25, 0.95, diamond + ripple) * radial;

      // Outer plasma shear boundary
      float shear = sin(vUv.y * 16.0 - uTime * 30.0 + vUv.x * 10.0) * 0.1;
      float plasma = smoothstep(0.1, 0.7, radial + shear) * (1.0 - vUv.y * 0.5);

      vec3 col = mix(uColorGlow, uColorCore, shockCore);
      float alpha = (shockCore * 0.95 + plasma * 0.3) * uIntensity;

      gl_FragColor = vec4(col, alpha);
    }
  `
};

const SHADER_THERMAL_XRAY = {
  vertexShader: `
    varying vec3 vWorldPosition;
    varying vec3 vNormal;
    void main() {
      vNormal = normalize(normalMatrix * normal);
      vec4 worldPos = modelMatrix * vec4(position, 1.0);
      vWorldPosition = worldPos.xyz;
      gl_Position = projectionMatrix * viewMatrix * worldPos;
    }
  `,
  fragmentShader: `
    uniform float uEgtNorm; // 0.0 to 1.0 based on EGT (20 to 1100 °C)
    uniform float uOpacity;
    varying vec3 vWorldPosition;
    varying vec3 vNormal;

    void main() {
      float z = vWorldPosition.z;

      // Fresnel edge halo
      float fresnel = 1.0 - abs(dot(vNormal, vec3(0.0, 0.0, 1.0)));
      fresnel = pow(fresnel, 1.6);

      // Thermodynamic thermal color map along engine axis (Z):
      // z > 1.2 : Intake Fan & LPC (Cold Air: Deep Blue -> Cyan ~ 20 - 150 °C)
      // 0.2 < z <= 1.2 : HPC Drum (Compressed Air: Yellow/Amber ~ 250 - 550 °C)
      // -1.5 < z <= 0.2 : Combustor & HPT (Intense Combustion: Fiery Orange -> White Hot ~ 900 - 1300 °C)
      // z <= -1.5 : LPT & Exhaust (Radiant Amber -> Cherry Red ~ 600 - 800 °C)
      vec3 col;
      if (z > 1.2) {
        col = mix(vec3(0.0, 0.25, 0.95), vec3(0.0, 0.85, 1.0), (3.0 - z) / 1.8);
      } else if (z > 0.2) {
        col = mix(vec3(0.0, 0.9, 0.75), vec3(1.0, 0.85, 0.1), (1.2 - z) / 1.0);
      } else if (z > -1.5) {
        float t = (0.2 - z) / 1.7;
        col = mix(vec3(1.0, 0.45, 0.0), vec3(1.0, 0.98, 0.9), t * uEgtNorm);
      } else {
        col = mix(vec3(1.0, 0.35, 0.0), vec3(0.85, 0.12, 0.05), (-1.5 - z) / 2.0);
      }

      float thermalGlow = (0.4 + uEgtNorm * 0.7) * (0.55 + fresnel * 0.8);
      gl_FragColor = vec4(col * thermalGlow, uOpacity);
    }
  `
};

// ==========================================
// 4. INITIALIZATION & THREE.JS SETUP
// ==========================================
window.addEventListener('DOMContentLoaded', () => {
  initThree();
  initAudio();
  initUIListeners();
  loadEngineModel();
});

function initThree() {
  clock = new THREE.Clock();
  raycaster = new THREE.Raycaster();
  mouse = new THREE.Vector2(-1000, -1000);

  // Scene
  scene = new THREE.Scene();
  scene.fog = new THREE.FogExp2(0x07090e, 0.042);

  // Camera with true 100vw/100vh aspect
  const aspect = window.innerWidth / window.innerHeight;
  camera = new THREE.PerspectiveCamera(45, aspect, 0.1, 100);
  camera.position.set(4.2, 1.8, 4.8);

  // Renderer
  renderer = new THREE.WebGLRenderer({
    canvas: canvas,
    antialias: true,
    alpha: true,
    powerPreference: 'high-performance'
  });
  renderer.setSize(window.innerWidth, window.innerHeight);
  renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
  renderer.toneMapping = THREE.ACESFilmicToneMapping;
  renderer.toneMappingExposure = 1.35;
  renderer.shadowMap.enabled = true;
  renderer.shadowMap.type = THREE.PCFSoftShadowMap;

  // OrbitControls
  controls = new THREE.OrbitControls(camera, canvas);
  controls.enableDamping = true;
  controls.dampingFactor = 0.05;
  controls.minDistance = 1.0;
  controls.maxDistance = 25.0;
  controls.target.set(0, 0, 0);

  // Lighting & Environment
  setupLighting();
  setupEnvironment();

  // Particle Systems
  setupParticles();

  // Window Resize & Interactivity
  window.addEventListener('resize', onWindowResize);
  canvas.addEventListener('mousemove', onCanvasMouseMove);
  canvas.addEventListener('click', onCanvasClick);

  // Start Animation Loop
  requestAnimationFrame(animate);
}

function setupLighting() {
  const ambient = new THREE.AmbientLight(0xd5e3ff, 0.7);
  scene.add(ambient);

  const keyLight = new THREE.DirectionalLight(0xffffff, 2.2);
  keyLight.position.set(6, 10, 8);
  keyLight.castShadow = true;
  keyLight.shadow.mapSize.width = 2048;
  keyLight.shadow.mapSize.height = 2048;
  keyLight.shadow.camera.near = 0.5;
  keyLight.shadow.camera.far = 30;
  keyLight.shadow.bias = -0.0005;
  scene.add(keyLight);

  const rimLight = new THREE.DirectionalLight(0x00f0ff, 2.0);
  rimLight.position.set(-8, 3, -6);
  scene.add(rimLight);

  const bounceLight = new THREE.DirectionalLight(0xff7700, 0.6);
  bounceLight.position.set(0, -5, 0);
  scene.add(bounceLight);

  const afterburnerLight = new THREE.PointLight(0xff5500, 0, 12);
  afterburnerLight.position.set(0, 0, -3.8);
  scene.add(afterburnerLight);
  state.afterburnerLight = afterburnerLight;
}

function setupEnvironment() {
  const gridHelper = new THREE.GridHelper(24, 48, 0x00f0ff, 0x1a2638);
  gridHelper.position.y = -2.2;
  scene.add(gridHelper);

  const ringGeo = new THREE.RingGeometry(2.1, 2.2, 64);
  const ringMat = new THREE.MeshBasicMaterial({ color: 0x00f0ff, side: THREE.DoubleSide, transparent: true, opacity: 0.25 });
  const ring = new THREE.Mesh(ringGeo, ringMat);
  ring.rotation.x = Math.PI / 2;
  ring.position.y = -2.19;
  scene.add(ring);
}

// ==========================================
// 5. ADVANCED PARTICLE SYSTEMS
// ==========================================
function setupParticles() {
  // 1. Continuous Airflow Velocity Stream
  const intakeCount = 700;
  const intakeGeo = new THREE.BufferGeometry();
  const intakePositions = new Float32Array(intakeCount * 3);
  const intakeVelocities = new Float32Array(intakeCount * 3);
  const intakeColors = new Float32Array(intakeCount * 3);

  for (let i = 0; i < intakeCount; i++) {
    const angle = Math.random() * Math.PI * 2;
    const rad = 0.2 + Math.random() * 1.5;
    const z = 4.5 - Math.random() * 8.5; // along full engine path

    intakePositions[i * 3] = Math.cos(angle) * rad;
    intakePositions[i * 3 + 1] = Math.sin(angle) * rad;
    intakePositions[i * 3 + 2] = z;

    intakeVelocities[i * 3] = (Math.random() - 0.5) * 0.01;
    intakeVelocities[i * 3 + 1] = (Math.random() - 0.5) * 0.01;
    intakeVelocities[i * 3 + 2] = -0.08 - Math.random() * 0.12;

    // Gradient based on Z
    updateParticleColor(intakeColors, i, z);
  }
  intakeGeo.setAttribute('position', new THREE.BufferAttribute(intakePositions, 3));
  intakeGeo.setAttribute('color', new THREE.BufferAttribute(intakeColors, 3));

  const intakeMat = new THREE.PointsMaterial({
    size: 0.055,
    vertexColors: true,
    transparent: true,
    opacity: 0.8,
    blending: THREE.AdditiveBlending
  });
  intakeParticles = new THREE.Points(intakeGeo, intakeMat);
  intakeParticles.userData = { velocities: intakeVelocities, initialCount: intakeCount };
  scene.add(intakeParticles);

  // 2. High-Temperature Exhaust & Shock Plume
  const exhaustCount = 450;
  const exhaustGeo = new THREE.BufferGeometry();
  const exhaustPositions = new Float32Array(exhaustCount * 3);
  const exhaustVelocities = new Float32Array(exhaustCount * 3);

  for (let i = 0; i < exhaustCount; i++) {
    const angle = Math.random() * Math.PI * 2;
    const rad = Math.random() * 0.45;
    exhaustPositions[i * 3] = Math.cos(angle) * rad;
    exhaustPositions[i * 3 + 1] = Math.sin(angle) * rad;
    exhaustPositions[i * 3 + 2] = -3.2 - Math.random() * 3.5;

    exhaustVelocities[i * 3] = (Math.random() - 0.5) * 0.02;
    exhaustVelocities[i * 3 + 1] = (Math.random() - 0.5) * 0.02;
    exhaustVelocities[i * 3 + 2] = -0.15 - Math.random() * 0.22;
  }
  exhaustGeo.setAttribute('position', new THREE.BufferAttribute(exhaustPositions, 3));

  const exhaustMat = new THREE.PointsMaterial({
    color: 0xff6600,
    size: 0.08,
    transparent: true,
    opacity: 0.75,
    blending: THREE.AdditiveBlending
  });
  exhaustParticles = new THREE.Points(exhaustGeo, exhaustMat);
  exhaustParticles.userData = { velocities: exhaustVelocities, initialCount: exhaustCount };
  scene.add(exhaustParticles);

  // 3. Bleed Air ECS Off-Take Particle Streams
  const bleedCount = 180;
  const bleedGeo = new THREE.BufferGeometry();
  const bleedPositions = new Float32Array(bleedCount * 3);
  const bleedVelocities = new Float32Array(bleedCount * 3);

  for (let i = 0; i < bleedCount; i++) {
    resetBleedParticle(bleedPositions, bleedVelocities, i);
  }
  bleedGeo.setAttribute('position', new THREE.BufferAttribute(bleedPositions, 3));

  const bleedMat = new THREE.PointsMaterial({
    color: 0x60d5ff,
    size: 0.045,
    transparent: true,
    opacity: 0.85,
    blending: THREE.AdditiveBlending
  });
  bleedParticles = new THREE.Points(bleedGeo, bleedMat);
  bleedParticles.userData = { velocities: bleedVelocities, count: bleedCount };
  scene.add(bleedParticles);

  // 4. Compressor Stall / Surge Reversed Flame & Smoke Blast
  const stallCount = 250;
  const stallGeo = new THREE.BufferGeometry();
  const stallPositions = new Float32Array(stallCount * 3);
  const stallVelocities = new Float32Array(stallCount * 3);

  for (let i = 0; i < stallCount; i++) {
    resetStallParticle(stallPositions, stallVelocities, i);
  }
  stallGeo.setAttribute('position', new THREE.BufferAttribute(stallPositions, 3));

  const stallMat = new THREE.PointsMaterial({
    color: 0xff2200,
    size: 0.12,
    transparent: true,
    opacity: 0.0,
    blending: THREE.AdditiveBlending
  });
  stallParticles = new THREE.Points(stallGeo, stallMat);
  stallParticles.userData = { velocities: stallVelocities, count: stallCount };
  scene.add(stallParticles);
}

function updateParticleColor(colors, index, z) {
  let r = 0, g = 0.5, b = 1.0;
  if (z > 1.2) {
    // Intake
    r = 0.0; g = 0.5; b = 1.0;
  } else if (z > 0.0) {
    // Compressor
    r = 0.0; g = 0.95; b = 0.9;
  } else if (z > -1.8) {
    // Combustor & Turbine
    r = 1.0; g = 0.45; b = 0.05;
  } else {
    // Exhaust
    r = 1.0; g = 0.85; b = 0.7;
  }
  colors[index * 3] = r;
  colors[index * 3 + 1] = g;
  colors[index * 3 + 2] = b;
}

function resetBleedParticle(positions, velocities, i) {
  // Emit from 4th and 9th stage ports
  const stageZ = i % 2 === 0 ? 0.75 : 0.25;
  const angle = (Math.PI * 0.25) + (Math.random() - 0.5) * 0.6;
  const rad = 0.62;

  positions[i * 3] = Math.cos(angle) * rad;
  positions[i * 3 + 1] = Math.sin(angle) * rad;
  positions[i * 3 + 2] = stageZ;

  // Velocity outward into pylon interface (+X, +Y)
  velocities[i * 3] = Math.cos(angle) * (0.02 + Math.random() * 0.03);
  velocities[i * 3 + 1] = Math.sin(angle) * (0.02 + Math.random() * 0.03);
  velocities[i * 3 + 2] = (Math.random() - 0.5) * 0.01;
}

function resetStallParticle(positions, velocities, i) {
  // Emits from compressor core forward out through intake
  const angle = Math.random() * Math.PI * 2;
  const rad = Math.random() * 0.8;

  positions[i * 3] = Math.cos(angle) * rad;
  positions[i * 3 + 1] = Math.sin(angle) * rad;
  positions[i * 3 + 2] = 1.0 + Math.random() * 0.5;

  // Violent forward velocity (+Z)
  velocities[i * 3] = (Math.random() - 0.5) * 0.06;
  velocities[i * 3 + 1] = (Math.random() - 0.5) * 0.06;
  velocities[i * 3 + 2] = 0.18 + Math.random() * 0.25;
}

// ==========================================
// 6. VOLUMETRIC SHOCK DIAMONDS & GLSL SHADERS
// ==========================================
function setupVolumetricShockDiamonds() {
  const coneGeo = new THREE.CylinderGeometry(0.08, 0.42, 3.2, 32, 32, true);
  coneGeo.rotateX(Math.PI / 2);

  state.shockDiamondMat = new THREE.ShaderMaterial({
    vertexShader: SHADER_SHOCK_DIAMOND.vertexShader,
    fragmentShader: SHADER_SHOCK_DIAMOND.fragmentShader,
    uniforms: {
      uTime: { value: 0.0 },
      uIntensity: { value: 0.0 },
      uColorCore: { value: new THREE.Color(0xffffff) },
      uColorGlow: { value: new THREE.Color(0x00f0ff) }
    },
    transparent: true,
    depthWrite: false,
    blending: THREE.AdditiveBlending,
    side: THREE.DoubleSide
  });

  shockDiamondMesh = new THREE.Mesh(coneGeo, state.shockDiamondMat);
  shockDiamondMesh.position.set(0, 0, -4.5);
  scene.add(shockDiamondMesh);

  // Initialize Thermal Shader Material for X-Ray
  state.thermalShaderMat = new THREE.ShaderMaterial({
    vertexShader: SHADER_THERMAL_XRAY.vertexShader,
    fragmentShader: SHADER_THERMAL_XRAY.fragmentShader,
    uniforms: {
      uEgtNorm: { value: 0.7 },
      uOpacity: { value: 0.45 }
    },
    transparent: true,
    depthWrite: false,
    side: THREE.DoubleSide
  });
}

// ==========================================
// 7. 3D MODEL LOADER & PROCEDURAL FALLBACK
// ==========================================
function loadEngineModel() {
  loadingStatus.innerText = 'Streaming jet_engine.glb binary buffer...';
  loadingFill.style.width = '35%';

  setupVolumetricShockDiamonds();

  const loader = new THREE.GLTFLoader();
  loader.load(
    'jet_engine.glb',
    (gltf) => {
      loadingFill.style.width = '85%';
      loadingStatus.innerText = 'Binding PBR shaders & hierarchy nodes...';

      engineGroup = gltf.scene;
      finalizeEngineModel();
    },
    (xhr) => {
      if (xhr.lengthComputable) {
        const pct = Math.round((xhr.loaded / xhr.total) * 70);
        loadingFill.style.width = `${pct}%`;
      }
    },
    (err) => {
      console.warn('External GLB load failed or missing. Generating procedural GE90 Engine...', err);
      loadingStatus.innerText = 'Generating Procedural High-Bypass GE90 Turbofan...';
      buildProceduralEngine();
    }
  );
}

function finalizeEngineModel() {
  scene.add(engineGroup);

  // Auto-center and normalize bounding box into camera frustum
  const bbox = new THREE.Box3().setFromObject(engineGroup);
  const size = bbox.getSize(new THREE.Vector3());
  const center = bbox.getCenter(new THREE.Vector3());

  engineGroup.position.sub(center);
  // Scale to standard view length (~4.5 units)
  const maxDim = Math.max(size.x, size.y, size.z);
  if (maxDim > 0.001) {
    const scaleFactor = 4.2 / maxDim;
    engineGroup.scale.setScalar(scaleFactor);
  }
  engineGroup.position.y += 0.2;

  // Retrieve hierarchy groups
  rotorGroup = engineGroup.getObjectByName('TurbineRotor');
  hullGroup = engineGroup.getObjectByName('EngineHull');
  coreGroup = engineGroup.getObjectByName('EngineCore');

  // Traverse submeshes and configure exploded view offsets & materials
  partMeshes = [];
  engineGroup.traverse((child) => {
    if (child.isMesh) {
      partMeshes.push(child);
      child.castShadow = true;
      child.receiveShadow = true;

      child.userData.origPosition = child.position.clone();
      child.userData.origMaterial = child.material;

      const childBox = new THREE.Box3().setFromObject(child);
      const childCenter = childBox.getCenter(new THREE.Vector3());
      child.userData.zOffset = childCenter.z;

      // Classify for custom exploded view scaling
      const lowerName = child.name.toLowerCase();
      if (lowerName.includes('lip') || lowerName.includes('inlet')) child.userData.explodeScale = 3.0;
      else if (lowerName.includes('hull') || lowerName.includes('case')) child.userData.explodeScale = 2.0;
      else if (lowerName.includes('fan') || lowerName.includes('lpc')) child.userData.explodeScale = 1.0;
      else if (lowerName.includes('core') || lowerName.includes('tube')) child.userData.explodeScale = -0.5;
      else if (lowerName.includes('hpt')) child.userData.explodeScale = -1.5;
      else if (lowerName.includes('lpt')) child.userData.explodeScale = -2.5;
      else if (lowerName.includes('nozzle') || lowerName.includes('flap')) child.userData.explodeScale = -3.5;
      else child.userData.explodeScale = (childCenter.z > 0 ? 1.0 : -1.0);
    }
  });

  // Attach VSV Stator rings if present or procedural
  setupVSVMeshes();

  console.log(`Turbofan Loaded: ${partMeshes.length} meshes.`);
  loadingFill.style.width = '100%';
  loadingStatus.innerText = 'Assembly Complete. Starting Engine...';

  setTimeout(() => {
    loadingOverlay.classList.add('fade-out');
  }, 400);
}

// Procedural 3D Turbofan Generator (Three.js Primitives)
function buildProceduralEngine() {
  state.isProcedural = true;
  engineGroup = new THREE.Group();
  rotorGroup = new THREE.Group();
  hullGroup = new THREE.Group();
  coreGroup = new THREE.Group();

  rotorGroup.name = 'TurbineRotor';
  hullGroup.name = 'EngineHull';
  coreGroup.name = 'EngineCore';

  engineGroup.add(rotorGroup);
  engineGroup.add(hullGroup);
  engineGroup.add(coreGroup);

  // PBR Materials
  const matTitanium = new THREE.MeshStandardMaterial({ color: 0xc8d2dc, metalness: 0.85, roughness: 0.25 });
  const matCarbon = new THREE.MeshStandardMaterial({ color: 0x1f242c, metalness: 0.4, roughness: 0.6 });
  const matInconel = new THREE.MeshStandardMaterial({ color: 0x7a838f, metalness: 0.7, roughness: 0.35 });
  const matGoldFoil = new THREE.MeshStandardMaterial({ color: 0xd4af37, metalness: 0.9, roughness: 0.2 });
  const matChrome = new THREE.MeshStandardMaterial({ color: 0xffffff, metalness: 0.95, roughness: 0.1 });

  // 1. Nose Spinner Cone
  const spinnerGeo = new THREE.ConeGeometry(0.42, 1.1, 32);
  spinnerGeo.rotateX(Math.PI / 2);
  const spinnerMesh = new THREE.Mesh(spinnerGeo, matTitanium);
  spinnerMesh.position.set(0, 0, 1.85);
  spinnerMesh.name = 'SpinnerCone';
  rotorGroup.add(spinnerMesh);

  // 2. 22 Wide-Chord Scimitar Fan Blades
  const fanHubGeo = new THREE.CylinderGeometry(0.55, 0.55, 0.45, 32);
  fanHubGeo.rotateX(Math.PI / 2);
  const fanHub = new THREE.Mesh(fanHubGeo, matTitanium);
  fanHub.position.set(0, 0, 1.3);
  rotorGroup.add(fanHub);

  for (let i = 0; i < 22; i++) {
    const angle = (i / 22) * Math.PI * 2;
    const bladeGeo = new THREE.BoxGeometry(0.12, 1.25, 0.04);
    bladeGeo.translate(0, 0.65, 0);
    const blade = new THREE.Mesh(bladeGeo, matCarbon);
    blade.position.set(0, 0, 1.3);
    blade.rotation.z = angle;
    blade.rotation.y = 0.45; // blade twist
    blade.name = `FanBlade_${i + 1}`;
    rotorGroup.add(blade);
  }

  // 3. LPC Booster & HPC Drums
  const hpcGeo = new THREE.CylinderGeometry(0.48, 0.42, 1.8, 32);
  hpcGeo.rotateX(Math.PI / 2);
  const hpcDrum = new THREE.Mesh(hpcGeo, matTitanium);
  hpcDrum.position.set(0, 0, 0.2);
  hpcDrum.name = 'HPC_Drum';
  rotorGroup.add(hpcDrum);

  // 4. Combustion Chamber & Fuel Injectors
  const combustorGeo = new THREE.CylinderGeometry(0.52, 0.54, 0.9, 32, 1, true);
  combustorGeo.rotateX(Math.PI / 2);
  const combustor = new THREE.Mesh(combustorGeo, matInconel);
  combustor.position.set(0, 0, -1.05);
  combustor.name = 'Combustor';
  coreGroup.add(combustor);

  // Fuel Manifold Ring
  const fuelRingGeo = new THREE.TorusGeometry(0.58, 0.025, 16, 48);
  const fuelRing = new THREE.Mesh(fuelRingGeo, matChrome);
  fuelRing.position.set(0, 0, -0.65);
  fuelRing.name = 'FuelManifold';
  coreGroup.add(fuelRing);

  // 5. High-Pressure & Low-Pressure Turbines
  const turbineGeo = new THREE.CylinderGeometry(0.46, 0.44, 0.8, 32);
  turbineGeo.rotateX(Math.PI / 2);
  const turbineRotor = new THREE.Mesh(turbineGeo, matInconel);
  turbineRotor.position.set(0, 0, -1.8);
  turbineRotor.name = 'TurbineDisks';
  rotorGroup.add(turbineRotor);

  // 6. Exhaust Center Cone Plug
  const plugGeo = new THREE.ConeGeometry(0.35, 1.5, 32);
  plugGeo.rotateX(-Math.PI / 2);
  const plug = new THREE.Mesh(plugGeo, matInconel);
  plug.position.set(0, 0, -2.8);
  plug.name = 'ExhaustPlug';
  coreGroup.add(plug);

  // 7. Outer Nacelle Casing & Acoustic Cowl
  const nacelleGeo = new THREE.CylinderGeometry(1.68, 1.62, 3.2, 48, 1, true);
  nacelleGeo.rotateX(Math.PI / 2);
  const nacelle = new THREE.Mesh(nacelleGeo, matTitanium);
  nacelle.position.set(0, 0, 0.4);
  nacelle.name = 'NacelleCasing';
  hullGroup.add(nacelle);

  // 8. Variable Exhaust Nozzle Ring
  const nozzleGeo = new THREE.CylinderGeometry(1.45, 1.25, 1.2, 48, 1, true);
  nozzleGeo.rotateX(Math.PI / 2);
  const nozzle = new THREE.Mesh(nozzleGeo, matInconel);
  nozzle.position.set(0, 0, -2.1);
  nozzle.name = 'NozzleFlaps';
  hullGroup.add(nozzle);

  finalizeEngineModel();
}

function setupVSVMeshes() {
  vsvStatorMeshes = [];
  // Build kinematic VSV stator rings around HPC core
  const vsvHolder = new THREE.Group();
  vsvHolder.name = 'VSV_Assembly';
  
  const vaneGeo = new THREE.BoxGeometry(0.04, 0.18, 0.08);
  vaneGeo.translate(0, 0.09, 0);
  const matVsv = new THREE.MeshStandardMaterial({ color: 0x48cae4, metalness: 0.8, roughness: 0.25 });

  for (let ring = 0; ring < 3; ring++) {
    const ringZ = 0.8 - ring * 0.45;
    for (let i = 0; i < 18; i++) {
      const angle = (i / 18) * Math.PI * 2;
      const vane = new THREE.Mesh(vaneGeo, matVsv);
      vane.position.set(Math.cos(angle) * 0.52, Math.sin(angle) * 0.52, ringZ);
      vane.rotation.z = angle + Math.PI / 2;
      vsvStatorMeshes.push(vane);
      vsvHolder.add(vane);
    }
  }

  engineGroup.add(vsvHolder);
}

// ==========================================
// 8. AUDIO SYNTHESIS & WEBAUDIO
// ==========================================
function initAudio() {
  try {
    const AudioCtx = window.AudioContext || window.webkitAudioContext;
    audioContext = new AudioCtx();

    // Create synthetic engine sound generator using lowpass noise + dual-spool harmonic oscillators
    fetch('jet_plane.mp3')
      .then(res => res.arrayBuffer())
      .then(buf => audioContext.decodeAudioData(buf))
      .then(decoded => {
        audioBuffer = decoded;
      })
      .catch(() => {
        console.log('Using WebAudio procedural oscillator synth for jet turbine audio.');
      });
  } catch (e) {
    console.warn('Web Audio API not supported:', e);
  }
}

function startAudioLoop() {
  if (!audioContext) return;
  if (audioContext.state === 'suspended') audioContext.resume();

  if (audioBuffer) {
    audioSource = audioContext.createBufferSource();
    audioSource.buffer = audioBuffer;
    audioSource.loop = true;
    audioGain = audioContext.createGain();
    audioGain.gain.value = 0.35;
    audioSource.connect(audioGain);
    audioGain.connect(audioContext.destination);
    audioSource.start(0);
  }
}

function stopAudioLoop() {
  if (audioSource) {
    try { audioSource.stop(); } catch (_) {}
    audioSource = null;
  }
}

function updateAudioParameters() {
  if (!audioSource || !audioGain) return;
  const thrNorm = (state.isRunning && !state.isStalled) ? state.pla / 100 : 0.05;
  const targetRate = 0.65 + thrNorm * 0.85;
  const targetGain = state.isRunning ? 0.15 + thrNorm * 0.55 : 0.05;

  audioSource.playbackRate.setTargetAtTime(targetRate, audioContext.currentTime, 0.1);
  audioGain.gain.setTargetAtTime(targetGain, audioContext.currentTime, 0.1);
}

// ==========================================
// 9. UI EVENT LISTENERS & INTERACTION
// ==========================================
function initUIListeners() {
  setupDraggablePanels();

  // PLA / Throttle Slider
  throttleSlider.addEventListener('input', (e) => {
    setThrottle(parseFloat(e.target.value));
  });

  // Quick Throttle Buttons (Detents)
  document.querySelectorAll('.t-btn').forEach(btn => {
    btn.addEventListener('click', () => {
      document.querySelectorAll('.t-btn').forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      const val = parseFloat(btn.getAttribute('data-val'));
      setThrottle(val);
      throttleSlider.value = val;
    });
  });

  // Master Engine Toggle
  btnEngineToggle.addEventListener('click', toggleEngineMaster);

  // Compressor Stall / Surge Toggle Button
  if (btnStallToggle) {
    btnStallToggle.addEventListener('click', toggleCompressorStall);
  }

  // Audio Toggle
  btnSound.addEventListener('click', toggleAudio);

  // HUD & Tooltip Controls
  if (btnToggleHud) btnToggleHud.addEventListener('click', toggleInfoHud);
  if (btnCloseTooltip) btnCloseTooltip.addEventListener('click', () => tooltip.classList.add('hidden'));

  // Reset Camera View
  document.getElementById('btn-reset-view').addEventListener('click', resetCamera);

  // Fullscreen
  document.getElementById('btn-fullscreen').addEventListener('click', () => {
    if (!document.fullscreenElement) {
      document.documentElement.requestFullscreen();
    } else {
      document.exitFullscreen();
    }
  });

  // Hull Visibility (MeshToggler)
  btnHullSolid.addEventListener('click', () => setHullMode('solid'));
  btnHullXray.addEventListener('click', () => setHullMode('xray'));
  btnHullHide.addEventListener('click', () => setHullMode('hidden'));

  // Explode View Slider
  explodeSlider.addEventListener('input', (e) => {
    state.targetExplodeRatio = parseFloat(e.target.value) / 100;
    explodePct.innerText = `${e.target.value}%`;
  });

  document.getElementById('btn-explode-0').addEventListener('click', () => setExplode(0));
  document.getElementById('btn-explode-50').addEventListener('click', () => setExplode(50));
  document.getElementById('btn-explode-100').addEventListener('click', () => setExplode(100));

  // Camera Presets
  document.querySelectorAll('.cam-btn').forEach(btn => {
    btn.addEventListener('click', () => {
      document.querySelectorAll('.cam-btn').forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      applyCameraPreset(btn.getAttribute('data-cam'));
    });
  });

  // Component Breakdown Explorer
  document.querySelectorAll('.comp-item').forEach(item => {
    item.addEventListener('click', () => {
      document.querySelectorAll('.comp-item').forEach(i => i.classList.remove('active'));
      item.classList.add('active');
      selectComponent(item.getAttribute('data-part'));
    });
  });

  // Visual Env Toggles
  const btnHangar = document.getElementById('btn-env-hangar');
  const btnDark = document.getElementById('btn-env-dark');
  const btnParticles = document.getElementById('btn-particles');

  btnHangar.addEventListener('click', () => {
    btnHangar.classList.add('active');
    btnDark.classList.remove('active');
    renderer.toneMappingExposure = 1.35;
  });

  btnDark.addEventListener('click', () => {
    btnDark.classList.add('active');
    btnHangar.classList.remove('active');
    renderer.toneMappingExposure = 0.95;
  });

  btnParticles.addEventListener('click', () => {
    state.particlesEnabled = !state.particlesEnabled;
    btnParticles.classList.toggle('active', state.particlesEnabled);
    if (intakeParticles) intakeParticles.visible = state.particlesEnabled;
    if (exhaustParticles) exhaustParticles.visible = state.particlesEnabled;
    if (bleedParticles) bleedParticles.visible = state.particlesEnabled;
  });

  // Keyboard Shortcuts
  window.addEventListener('keydown', (e) => {
    if (e.code === 'Space') {
      e.preventDefault();
      toggleEngineMaster();
    } else if (e.code === 'KeyH') {
      cycleHullMode();
    } else if (e.code === 'KeyX') {
      setHullMode(state.hullMode === 'xray' ? 'solid' : 'xray');
    } else if (e.code === 'KeyA') {
      toggleAudio();
    } else if (e.code === 'KeyR') {
      resetCamera();
    } else if (e.code === 'KeyI') {
      toggleInfoHud();
    } else if (e.code === 'KeyS') {
      toggleCompressorStall();
    } else if (e.key === '1') setThrottle(0);
    else if (e.key === '2') setThrottle(25);
    else if (e.key === '3') setThrottle(75);
    else if (e.key === '4') setThrottle(100);
  });
}

function setThrottle(val) {
  state.targetPLA = Math.max(0, Math.min(100, val));
  throttlePctDisplay.innerText = `${Math.round(state.targetPLA)}%`;
  updateAudioParameters();
}

function toggleEngineMaster() {
  state.isRunning = !state.isRunning;
  if (state.isRunning) {
    btnEngineToggle.classList.remove('stopped');
    btnEngineToggle.classList.add('running');
    engineBtnText.innerText = 'STOP';
    masterStatus.innerText = 'RUNNING • ROTATION SYNC ON';
    masterStatus.style.color = '#00ff88';
  } else {
    btnEngineToggle.classList.remove('running');
    btnEngineToggle.classList.add('stopped');
    engineBtnText.innerText = 'START';
    masterStatus.innerText = 'SPOOLING DOWN • IDLE';
    masterStatus.style.color = '#ff3b5c';
  }
  updateAudioParameters();
}

function toggleCompressorStall() {
  state.isStalled = !state.isStalled;
  if (state.isStalled) {
    if (btnStallToggle) btnStallToggle.classList.add('active');
    if (stallBtnText) stallBtnText.innerText = 'RECOVER COMPRESSOR STALL';
    if (stallIndicator) {
      stallIndicator.classList.remove('normal');
      stallIndicator.classList.add('active');
      stallIndicator.innerText = 'SURGE MARGIN: 0% [STALL]';
    }
  } else {
    if (btnStallToggle) btnStallToggle.classList.remove('active');
    if (stallBtnText) stallBtnText.innerText = 'INDUCE COMPRESSOR STALL';
    if (stallIndicator) {
      stallIndicator.classList.remove('active');
      stallIndicator.classList.add('normal');
      stallIndicator.innerText = 'SURGE MARGIN: 28% [NOMINAL]';
    }
  }
}

function toggleInfoHud() {
  if (tooltip.classList.contains('hidden')) {
    if (!state.selectedComponent) selectComponent('fan');
    else tooltip.classList.remove('hidden');
  } else {
    tooltip.classList.add('hidden');
  }
}

function toggleAudio() {
  state.audioEnabled = !state.audioEnabled;
  btnSound.classList.toggle('active', state.audioEnabled);
  soundBtnLabel.innerText = state.audioEnabled ? 'AUDIO: ON' : 'AUDIO: OFF';

  if (state.audioEnabled) startAudioLoop();
  else stopAudioLoop();
}

function setHullMode(mode) {
  state.hullMode = mode;
  btnHullSolid.classList.toggle('active', mode === 'solid');
  btnHullXray.classList.toggle('active', mode === 'xray');
  btnHullHide.classList.toggle('active', mode === 'hidden');

  if (!hullGroup) return;

  if (mode === 'hidden') {
    hullGroup.visible = false;
  } else if (mode === 'solid') {
    hullGroup.visible = true;
    hullGroup.traverse(child => {
      if (child.isMesh) {
        child.material = child.userData.origMaterial;
        child.material.transparent = false;
        child.material.opacity = 1.0;
        child.material.wireframe = false;
      }
    });
  } else if (mode === 'xray') {
    hullGroup.visible = true;
    hullGroup.traverse(child => {
      if (child.isMesh) {
        child.material = state.thermalShaderMat || child.userData.origMaterial;
      }
    });
  }
}

function cycleHullMode() {
  if (state.hullMode === 'solid') setHullMode('xray');
  else if (state.hullMode === 'xray') setHullMode('hidden');
  else setHullMode('solid');
}

function setExplode(val) {
  state.targetExplodeRatio = val / 100;
  explodeSlider.value = val;
  explodePct.innerText = `${val}%`;

  document.querySelectorAll('.sub-btn').forEach(b => b.classList.remove('active'));
  if (val === 0) document.getElementById('btn-explode-0').classList.add('active');
  else if (val === 50) document.getElementById('btn-explode-50').classList.add('active');
  else if (val === 100) document.getElementById('btn-explode-100').classList.add('active');
}

// ==========================================
// 10. DRAGGABLE & COLLAPSIBLE PANELS
// ==========================================
function setupDraggablePanels() {
  const leftPanel = document.getElementById('left-panel');
  const rightPanel = document.getElementById('right-panel');
  const leftHandle = document.getElementById('left-panel-handle');
  const rightHandle = document.getElementById('right-panel-handle');
  const tooltipHandle = document.getElementById('tooltip-drag-handle');

  const btnCollapseLeft = document.getElementById('btn-collapse-left');
  const btnCollapseRight = document.getElementById('btn-collapse-right');
  const dockTabLeft = document.getElementById('dock-tab-left');
  const dockTabRight = document.getElementById('dock-tab-right');

  if (leftPanel && leftHandle) makeDraggable(leftPanel, leftHandle);
  if (rightPanel && rightHandle) makeDraggable(rightPanel, rightHandle);
  if (tooltip && tooltipHandle) makeDraggable(tooltip, tooltipHandle);

  if (btnCollapseLeft && dockTabLeft && leftPanel) {
    btnCollapseLeft.addEventListener('click', () => {
      leftPanel.classList.add('collapsed');
      dockTabLeft.classList.remove('hidden');
    });

    dockTabLeft.addEventListener('click', () => {
      leftPanel.classList.remove('collapsed');
      dockTabLeft.classList.add('hidden');
    });
  }

  if (btnCollapseRight && dockTabRight && rightPanel) {
    btnCollapseRight.addEventListener('click', () => {
      rightPanel.classList.add('collapsed');
      dockTabRight.classList.remove('hidden');
    });

    dockTabRight.addEventListener('click', () => {
      rightPanel.classList.remove('collapsed');
      dockTabRight.classList.add('hidden');
    });
  }
}

function makeDraggable(element, handle) {
  let isDragging = false;
  let startX = 0, startY = 0;
  let origLeft = 0, origTop = 0;

  handle.addEventListener('pointerdown', (e) => {
    if (e.target.closest('button')) return;
    isDragging = true;
    handle.setPointerCapture(e.pointerId);

    const rect = element.getBoundingClientRect();
    startX = e.clientX;
    startY = e.clientY;
    origLeft = rect.left;
    origTop = rect.top;

    element.style.bottom = 'auto';
    element.style.right = 'auto';
    element.style.transform = 'none';
    element.style.left = `${origLeft}px`;
    element.style.top = `${origTop}px`;

    element.classList.add('is-dragging');
    e.preventDefault();
  });

  handle.addEventListener('pointermove', (e) => {
    if (!isDragging) return;
    const dx = e.clientX - startX;
    const dy = e.clientY - startY;

    let newLeft = origLeft + dx;
    let newTop = origTop + dy;

    const maxLeft = Math.max(10, window.innerWidth - element.offsetWidth - 10);
    const maxTop = Math.max(10, window.innerHeight - element.offsetHeight - 10);

    newLeft = Math.max(10, Math.min(newLeft, maxLeft));
    newTop = Math.max(10, Math.min(newTop, maxTop));

    element.style.left = `${newLeft}px`;
    element.style.top = `${newTop}px`;
  });

  const stopDrag = (e) => {
    if (isDragging) {
      isDragging = false;
      try { handle.releasePointerCapture(e.pointerId); } catch (_) {}
      element.classList.remove('is-dragging');
    }
  };

  handle.addEventListener('pointerup', stopDrag);
  handle.addEventListener('pointercancel', stopDrag);
}

// ==========================================
// 11. CAMERA TWEENING & COMPONENT FOCUS
// ==========================================
function applyCameraPreset(preset) {
  state.activeCameraPreset = preset;
  let targetPos, targetLook;

  switch (preset) {
    case 'front':
      targetPos = new THREE.Vector3(0, 0, 5.2);
      targetLook = new THREE.Vector3(0, 0, 1.0);
      break;
    case 'side':
      targetPos = new THREE.Vector3(5.5, 0.2, 0);
      targetLook = new THREE.Vector3(0, 0, 0);
      break;
    case 'exhaust':
      targetPos = new THREE.Vector3(0, 0, -5.5);
      targetLook = new THREE.Vector3(0, 0, -1.5);
      break;
    case 'top':
      targetPos = new THREE.Vector3(0, 6.0, 0.1);
      targetLook = new THREE.Vector3(0, 0, 0);
      break;
    case 'rotor':
      targetPos = new THREE.Vector3(1.2, 0.6, 2.5);
      targetLook = new THREE.Vector3(0, 0, 1.8);
      break;
    case 'iso':
    default:
      targetPos = new THREE.Vector3(4.2, 1.8, 4.8);
      targetLook = new THREE.Vector3(0, 0, 0);
      break;
  }

  tweenCamera(targetPos, targetLook, 1.2);
}

function selectComponent(partKey) {
  const info = COMPONENT_DETAILS[partKey];
  if (!info) return;

  state.selectedComponent = partKey;

  tooltipTitle.innerText = info.name;
  tooltipTag.innerText = info.tag;
  tooltipDesc.innerText = info.desc;
  tooltipRpm.innerText = info.rpm;
  tooltipMat.innerText = info.mat;
  tooltip.classList.remove('hidden');

  if (info.camPos && info.camTarget) {
    tweenCamera(
      new THREE.Vector3(...info.camPos),
      new THREE.Vector3(...info.camTarget),
      1.2
    );
  }
}

function resetCamera() {
  document.querySelectorAll('.cam-btn').forEach(b => b.classList.remove('active'));
  const isoBtn = document.querySelector('.cam-btn[data-cam="iso"]');
  if (isoBtn) isoBtn.classList.add('active');
  tweenCamera(new THREE.Vector3(4.2, 1.8, 4.8), new THREE.Vector3(0, 0, 0), 1.2);
  tooltip.classList.add('hidden');
}

function tweenCamera(pos, target, durationSec = 1.2) {
  const startPos = camera.position.clone();
  const startTarget = controls.target.clone();
  let startTime = null;

  function step(time) {
    if (!startTime) startTime = time;
    const elapsed = (time - startTime) / 1000;
    const progress = Math.min(1.0, elapsed / durationSec);
    const ease = easeOutCubic(progress);

    camera.position.lerpVectors(startPos, pos, ease);
    controls.target.lerpVectors(startTarget, target, ease);

    if (progress < 1.0) {
      requestAnimationFrame(step);
    }
  }
  requestAnimationFrame(step);
}

function easeOutCubic(x) {
  return 1 - Math.pow(1 - x, 3);
}

function onWindowResize() {
  const width = window.innerWidth;
  const height = window.innerHeight;
  camera.aspect = width / height;
  camera.updateProjectionMatrix();
  renderer.setSize(width, height);
}

function onCanvasMouseMove(e) {
  const rect = canvas.getBoundingClientRect();
  mouse.x = ((e.clientX - rect.left) / canvas.clientWidth) * 2 - 1;
  mouse.y = -((e.clientY - rect.top) / canvas.clientHeight) * 2 + 1;
}

function onCanvasClick() {
  raycaster.setFromCamera(mouse, camera);
  const intersects = raycaster.intersectObjects(partMeshes, true);

  if (intersects.length > 0) {
    const hit = intersects[0].object;
    const hitName = hit.name.toLowerCase();

    let matchedPart = 'fan';
    if (hitName.includes('hull') || hitName.includes('casing') || hitName.includes('nacelle')) matchedPart = 'hull';
    else if (hitName.includes('grid')) matchedPart = 'grid';
    else if (hitName.includes('flap') || hitName.includes('nozzle') || hitName.includes('plug')) matchedPart = 'nozzle';
    else if (hitName.includes('tube') || hitName.includes('pipe') || hitName.includes('fuel')) matchedPart = 'fuel';
    else if (hitName.includes('electron') || hitName.includes('fadec')) matchedPart = 'fadec';

    document.querySelectorAll('.comp-item').forEach(item => {
      if (item.getAttribute('data-part') === matchedPart) {
        item.classList.add('active');
        item.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
      } else {
        item.classList.remove('active');
      }
    });

    selectComponent(matchedPart);
  }
}

// ==========================================
// 12. BRAYTON CYCLE PV DIAGRAM CALCULATION
// ==========================================
function updateBraytonCycle(n2Norm, egtVal, plaNorm) {
  // Pressure ratio scales with N2
  const opr = 1.0 + Math.pow(n2Norm, 1.85) * 37.5;
  // Thermal efficiency eta_th = 1 - (1 / OPR^0.286)
  const etaTh = (1.0 - (1.0 / Math.pow(Math.max(1.05, opr), 0.286))) * 100;
  const wNet = (plaNorm * 58.2).toFixed(1);

  if (braytonEff) braytonEff.innerText = `${Math.min(52.5, Math.max(0, etaTh)).toFixed(1)}%`;
  if (braytonWnet) braytonWnet.innerText = `${wNet} MW`;

  // Dynamic PV loop points:
  // Point 1: Ambient Intake (High V, Low P)
  const x1 = 250, y1 = 92;
  // Point 2: Compressor Discharge (Low V, High P)
  const p2Height = 92 - (opr / 42.0) * 65;
  const x2 = 75, y2 = Math.max(22, p2Height);
  // Point 3: Combustor Outlet (Expanded V from Heat Addition, Constant P)
  const x3 = x2 + (egtVal / 1000.0) * 55;
  const y3 = y2 - 4;
  // Point 4: Turbine Expansion (High V, Low P)
  const x4 = 255;
  const y4 = Math.min(88, y3 + (1.0 - n2Norm * 0.4) * 45);

  if (pvPolygon) {
    pvPolygon.setAttribute('points', `${x1},${y1} ${x2},${y2} ${x3},${y3} ${x4},${y4}`);
  }
  if (pvPt1) { pvPt1.setAttribute('cx', x1); pvPt1.setAttribute('cy', y1); }
  if (pvPt2) { pvPt2.setAttribute('cx', x2); pvPt2.setAttribute('cy', y2); }
  if (pvPt3) { pvPt3.setAttribute('cx', x3); pvPt3.setAttribute('cy', y3); }
  if (pvPt4) { pvPt4.setAttribute('cx', x4); pvPt4.setAttribute('cy', y4); }
}

// ==========================================
// 13. MASTER ANIMATION & SIMULATION LOOP
// ==========================================
function animate() {
  requestAnimationFrame(animate);

  const delta = clock.getDelta();
  const time = clock.getElapsedTime();
  if (deltaDisplay) deltaDisplay.innerText = `${(delta * 1000).toFixed(1)}ms`;

  controls.update();

  // 1. PLA & Dual-Spool Inertial Dynamics
  state.pla += (state.targetPLA - state.pla) * (delta * 3.5);
  const plaNorm = state.isRunning ? state.pla / 100 : 0.0;

  // Target spools based on PLA specification:
  // PLA 0%   => N1 = 0%,   N2 = 0%
  // PLA 25%  => N1 = 22%,  N2 = 55%
  // PLA 75%  => N1 = 78%,  N2 = 80.8%
  // PLA 100% => N1 = 100%, N2 = 100%
  let targetN1 = 0;
  let targetN2 = 0;
  if (plaNorm <= 0.25) {
    const t = plaNorm / 0.25;
    targetN1 = t * 22.0;
    targetN2 = t * 55.0;
  } else if (plaNorm <= 0.75) {
    const t = (plaNorm - 0.25) / 0.5;
    targetN1 = 22.0 + t * (78.0 - 22.0);
    targetN2 = 55.0 + t * (80.8 - 55.0);
  } else {
    const t = (plaNorm - 0.75) / 0.25;
    targetN1 = 78.0 + t * (100.0 - 78.0);
    targetN2 = 80.8 + t * (100.0 - 80.8);
  }

  // Spool-up lag (Rotor Inertia): N2 has lower mass, spools up faster than N1
  state.n2Pct += (targetN2 - state.n2Pct) * (delta * 4.2);
  state.n1Pct += (targetN1 - state.n1Pct) * (delta * 1.6);

  const n1Norm = state.n1Pct / 100;
  const n2Norm = state.n2Pct / 100;

  state.rpmN1 = Math.round(state.n1Pct * 100);     // 10,000 max
  state.rpmN2 = Math.round(state.n2Pct * 150);     // 15,000 max

  // Thermodynamic variables
  let calculatedEgt = Math.round(20 + Math.pow(n2Norm, 1.25) * 900);
  let calculatedThrust = (Math.pow(n1Norm, 2.1) * 124.5).toFixed(1);
  let calculatedFuel = Math.round(Math.pow(n2Norm, 1.65) * 2200);
  let calculatedEpr = (1.0 + Math.pow(n2Norm, 1.8) * 0.85).toFixed(2);

  // Fault Injection: Compressor Stall / Surge Logic
  if (state.isStalled) {
    calculatedThrust = (2.5 + Math.random() * 2.0).toFixed(1);
    calculatedEpr = '1.02';
    calculatedEgt = Math.min(1150, calculatedEgt + 380 + Math.round(Math.random() * 60));
    // Airframe vibration noise
    const shake = 0.05 * (0.6 + Math.random() * 0.4);
    camera.position.x += (Math.random() - 0.5) * shake;
    camera.position.y += (Math.random() - 0.5) * shake;
  }

  state.egt = calculatedEgt;
  state.thrustKn = calculatedThrust;
  state.thrustLbf = Math.round(calculatedThrust * 224.8);
  state.fuelFlow = calculatedFuel;
  state.epr = calculatedEpr;

  // 2. VSV Kinematics (Variable Stator Vanes)
  // Rotates on local Y from +30° (idle) to -5° (max thrust)
  state.vsvAngle = (30.0 - n2Norm * 35.0).toFixed(1);
  const vsvRad = (state.vsvAngle * Math.PI) / 180;
  vsvStatorMeshes.forEach(vane => {
    vane.rotation.y = vsvRad;
  });

  // 3. Bleed Air ECS Logic
  state.bleedActive = state.pla >= 50.0 && state.isRunning;
  state.bleedPressure = state.bleedActive ? (18.0 + n2Norm * 12.0).toFixed(1) : '0.0';

  // Update UI Elements
  if (n1Val) n1Val.innerText = state.n1Pct.toFixed(1);
  if (n1Rpm) n1Rpm.innerText = state.rpmN1.toLocaleString();
  if (n1Bar) n1Bar.style.width = `${Math.min(100, state.n1Pct)}%`;

  if (n2Val) n2Val.innerText = state.n2Pct.toFixed(1);
  if (n2Rpm) n2Rpm.innerText = state.rpmN2.toLocaleString();
  if (n2Bar) n2Bar.style.width = `${Math.min(100, state.n2Pct)}%`;

  if (egtVal) {
    egtVal.innerText = state.egt;
    if (state.egt > 920 || state.isStalled) egtVal.style.color = '#ff3b5c';
    else if (state.egt > 650) egtVal.style.color = '#ffaa00';
    else egtVal.style.color = '#00f0ff';
  }
  if (egtBar) egtBar.style.width = `${Math.min(100, (state.egt / 1100) * 100)}%`;

  if (thrustVal) thrustVal.innerText = state.thrustKn;
  if (thrustLbf) thrustLbf.innerText = state.thrustLbf.toLocaleString();
  if (thrustBar) thrustBar.style.width = `${Math.min(100, (state.thrustKn / 125) * 100)}%`;

  if (fuelVal) fuelVal.innerText = state.fuelFlow.toLocaleString();
  if (fuelBar) fuelBar.style.width = `${Math.min(100, (state.fuelFlow / 2200) * 100)}%`;

  if (eprVal) eprVal.innerText = state.epr;
  if (eprBar) eprBar.style.width = `${Math.min(100, ((parseFloat(state.epr) - 1.0) / 0.85) * 100)}%`;

  if (vsvAngleVal) vsvAngleVal.innerText = `${state.vsvAngle}°`;
  if (bleedStatusVal) bleedStatusVal.innerText = state.bleedActive ? 'ACTIVE' : 'ISOLATED';
  if (bleedPressVal) bleedPressVal.innerText = `${state.bleedPressure} PSI TAPPED`;

  // Update Brayton Cycle Chart
  updateBraytonCycle(n2Norm, state.egt, plaNorm);

  // 4. Turbine Rotor Rotation
  if (rotorGroup) {
    const rotSpeed = 16.0 * (n1Norm > 0.02 ? n1Norm : 0);
    rotorGroup.rotation.z -= rotSpeed * delta;
  }

  // 5. Exploded Assembly View
  state.explodeRatio += (state.targetExplodeRatio - state.explodeRatio) * (delta * 6.0);
  if (Math.abs(state.targetExplodeRatio - state.explodeRatio) > 0.001 || state.explodeRatio > 0.001) {
    partMeshes.forEach(mesh => {
      if (mesh.userData.origPosition) {
        const mult = mesh.userData.explodeScale || (mesh.userData.zOffset > 0 ? 1.0 : -1.0);
        const offsetZ = mult * state.explodeRatio * 1.5;
        mesh.position.z = mesh.userData.origPosition.z + offsetZ;
      }
    });
  }

  // 6. Volumetric Exhaust Shock Diamonds Shader Update
  if (state.shockDiamondMat) {
    state.shockDiamondMat.uniforms.uTime.value = time;
    // Activate above 88% PLA
    const shockIntensity = (!state.isStalled && plaNorm > 0.88) ? (plaNorm - 0.88) / 0.12 : 0.0;
    state.shockDiamondMat.uniforms.uIntensity.value = shockIntensity;
  }

  // 7. Thermal Shader Uniforms (X-Ray Mode)
  if (state.thermalShaderMat) {
    state.thermalShaderMat.uniforms.uEgtNorm.value = THREE.MathUtils.clamp((state.egt - 20) / 1000, 0.0, 1.0);
  }

  // 8. Afterburner Dynamic Light
  if (state.afterburnerLight) {
    if (plaNorm > 0.85 && state.isRunning && !state.isStalled) {
      state.afterburnerLight.intensity = (plaNorm - 0.85) * 55 + Math.random() * 8;
    } else {
      state.afterburnerLight.intensity = 0;
    }
  }

  // 9. Particles Update
  if (state.particlesEnabled) {
    // Airflow stream
    if (intakeParticles) {
      const posAttr = intakeParticles.geometry.attributes.position;
      const vels = intakeParticles.userData.velocities;
      const speedMult = 0.5 + n1Norm * 4.0;

      for (let i = 0; i < posAttr.count; i++) {
        let z = posAttr.getZ(i);
        z += vels[i * 3 + 2] * speedMult * delta * 60;
        if (z < -4.5) {
          z = 4.5 + Math.random() * 0.5;
        }
        posAttr.setZ(i, z);
      }
      posAttr.needsUpdate = true;
    }

    // Exhaust particles
    if (exhaustParticles) {
      const posAttr = exhaustParticles.geometry.attributes.position;
      const vels = exhaustParticles.userData.velocities;
      const flameSpeed = 0.6 + n2Norm * 5.5;

      for (let i = 0; i < posAttr.count; i++) {
        let z = posAttr.getZ(i);
        z += vels[i * 3 + 2] * flameSpeed * delta * 60;
        if (z < -7.0) {
          z = -3.2 - Math.random() * 0.4;
          const angle = Math.random() * Math.PI * 2;
          const rad = Math.random() * 0.45;
          posAttr.setX(i, Math.cos(angle) * rad);
          posAttr.setY(i, Math.sin(angle) * rad);
        }
        posAttr.setZ(i, z);
      }
      posAttr.needsUpdate = true;
      exhaustParticles.material.opacity = (state.isRunning && !state.isStalled) ? (0.2 + n2Norm * 0.8) : 0.05;
    }

    // Bleed air ECS particles
    if (bleedParticles) {
      if (state.bleedActive) {
        bleedParticles.material.opacity = 0.8;
        const posAttr = bleedParticles.geometry.attributes.position;
        const vels = bleedParticles.userData.velocities;

        for (let i = 0; i < posAttr.count; i++) {
          let x = posAttr.getX(i) + vels[i * 3] * delta * 60;
          let y = posAttr.getY(i) + vels[i * 3 + 1] * delta * 60;
          let z = posAttr.getZ(i) + vels[i * 3 + 2] * delta * 60;

          if (Math.sqrt(x * x + y * y) > 1.6) {
            resetBleedParticle(posAttr.array, vels, i);
            x = posAttr.getX(i);
            y = posAttr.getY(i);
            z = posAttr.getZ(i);
          }
          posAttr.setXYZ(i, x, y, z);
        }
        posAttr.needsUpdate = true;
      } else {
        bleedParticles.material.opacity = 0.0;
      }
    }

    // Compressor Stall reversed intake flame & smoke particles
    if (stallParticles) {
      if (state.isStalled) {
        stallParticles.material.opacity = 0.85;
        const posAttr = stallParticles.geometry.attributes.position;
        const vels = stallParticles.userData.velocities;

        for (let i = 0; i < posAttr.count; i++) {
          let x = posAttr.getX(i) + vels[i * 3] * delta * 60;
          let y = posAttr.getY(i) + vels[i * 3 + 1] * delta * 60;
          let z = posAttr.getZ(i) + vels[i * 3 + 2] * delta * 60;

          if (z > 4.8) {
            resetStallParticle(posAttr.array, vels, i);
            x = posAttr.getX(i);
            y = posAttr.getY(i);
            z = posAttr.getZ(i);
          }
          posAttr.setXYZ(i, x, y, z);
        }
        posAttr.needsUpdate = true;
      } else {
        stallParticles.material.opacity = 0.0;
      }
    }
  }

  renderer.render(scene, camera);
}
