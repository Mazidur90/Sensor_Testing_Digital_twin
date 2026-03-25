# Sensor Models Reference

## Overview

All sensor models in SensorBench follow the same interface:

```scilab
function output = sensor_XXX_model(t, stimulus, params)
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `t` | 1×N vector | Time vector in seconds |
| `stimulus` | 1×N vector | Normalized input stimulus (0 to 1) |
| `params` | struct | Sensor-specific parameters from `sensor_params.sce` |
| **Returns** `output` | 1×N vector | Sensor response in engineering units |

---

## Temperature Sensor

**Type:** Thermocouple / RTD  
**Physics:** First-order thermal lag — models the thermal mass of the sensing element  
**Transfer Function:** G(s) = 1 / (τs + 1), τ = 0.5 s  
**Range:** -40 to 200 °C  
**Noise:** σ = 0.5 °C

The sensor cannot respond instantly to temperature changes due to thermal inertia. This creates a visible lag in step response tests.

---

## Pressure Sensor

**Type:** Piezoelectric / Strain gauge transducer  
**Physics:** First-order damped response — fast dynamics  
**Time Constant:** 0.1 s  
**Range:** 0 to 10 bar  
**Noise:** σ = 0.1 bar

Responds quickly to pressure changes. Suitable for hydraulic and pneumatic systems.

---

## Humidity Sensor

**Type:** Capacitive humidity sensor  
**Physics:** First-order response with large time constant  
**Time Constant:** 2.0 s (slow)  
**Range:** 0 to 100 %RH  
**Noise:** σ = 1.0 %RH

Humidity sensors are inherently slow due to moisture absorption/desorption in the sensing element. Output is clamped to physical range.

---

## Proximity Sensor

**Type:** Inductive / Capacitive proximity  
**Physics:** First-order, very fast  
**Time Constant:** 0.05 s  
**Range:** 0 to 50 mm  
**Noise:** σ = 0.2 mm

Detects the presence and distance of metallic or non-metallic objects. Output is clamped to non-negative values.

---

## Vibration Sensor (Accelerometer)

**Type:** MEMS or piezoelectric accelerometer  
**Physics:** Second-order mass-spring-damper  
**Natural Frequency:** 10 Hz  
**Damping Ratio:** 0.05 (lightly damped)  
**Range:** -5 to 5 g  
**Noise:** σ = 0.05 g

The only second-order model in the suite. Exhibits resonance behavior near the natural frequency, making it useful for demonstrating frequency-domain effects.

---

## Generic Analog Sensor

**Type:** General-purpose industrial sensor (4-20 mA / 0-5V / 0-10V)  
**Physics:** First-order  
**Time Constant:** 0.2 s  
**Range:** 0 to 5 V  
**Noise:** σ = 0.02 V

Placeholder model for any analog sensor not covered by specific types. Parameters can be overridden.

---

## Generic Digital Sensor

**Type:** Limit switch / level sensor / photoelectric sensor  
**Physics:** Schmitt-trigger with hysteresis  
**Threshold:** 0.5 (normalized)  
**Hysteresis:** ±0.05  
**Range:** 0 or 1 (binary)  
**Noise:** None

Binary output with hysteresis to prevent chattering at the switching threshold. No time constant — purely combinational logic.

---

## Adding a New Sensor

1. Create `models/sensor_newtype.sce`
2. Implement `sensor_newtype_model(t, stimulus, params)` following the same interface
3. Add a `SENSOR_NEWTYPE` struct in `config/sensor_params.sce`
4. Add the sensor to `loader.sce` and `test_controller.sce` lists
5. Create a demo in `tests/`
