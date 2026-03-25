# SensorBench-Scilab

**Sensor Testing Bench Automation System with Digital Twin Functionality**

A modular, professional-grade Scilab platform for simulating, testing, validating, and monitoring sensor behavior on a virtual test bench. Includes automated test execution, fault injection, calibration, digital twin comparison, and comprehensive reporting.

> Built for mechatronics engineers, automation engineers, and control systems students who need a structured, extensible sensor validation framework.

---

## Features

| Category | Capabilities |
|----------|-------------|
| **Sensor Models** | Temperature, Pressure, Humidity, Proximity, Vibration, Generic Analog, Generic Digital (7 models) |
| **Test Profiles** | Step, Ramp, Sinusoidal, Pulse Train, Random, Frequency Sweep |
| **Fault Injection** | Noise, Drift, Spikes, Transport Delay, Stuck-at, Out-of-Range |
| **Validation** | Limit checking, rate-of-change monitoring, pass/fail evaluation |
| **Calibration** | Two-point linear calibration with before/after comparison |
| **Digital Twin** | Parallel expected-model execution, residual computation, NOMINAL/WARNING/FAULT state classification |
| **Data Logging** | Timestamped CSV files with ideal, measured, and error columns |
| **Visualization** | Signal comparison plots, residual error plots, calibration plots, twin state plots |
| **Reporting** | Structured text reports with statistics, verdicts, and twin status |
| **Dashboard** | Menu-driven CLI for interactive or automated test execution |

---

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    main.sce (Dashboard)                  │
│              Menu-driven CLI entry point                 │
├────────┬──────────┬──────────┬──────────┬───────────────┤
│ Sensor │  Test    │ Digital  │ Visual-  │    Report     │
│ Models │ Engine   │ Twin     │ ization  │   Generator   │
├────────┼──────────┼──────────┼──────────┼───────────────┤
│ Config │Validation│Calibra-  │  Data    │    Fault      │
│ System │ Module   │tion      │  Logger  │  Injection    │
└────────┴──────────┴──────────┴──────────┴───────────────┘
```

**Data Flow:**
1. User selects a test scenario or defines one via config files
2. Sensor model generates simulated response to a stimulus profile
3. Fault injection module optionally corrupts the signal
4. Test controller orchestrates the complete pipeline
5. Validation module checks thresholds and rate limits
6. Digital twin compares expected vs. measured signals
7. Data logger writes CSV; visualization generates plots
8. Report generator produces a structured summary

---

## Repository Structure

```
SensorBench-Scilab/
├── main.sce                    # Entry point / dashboard
├── loader.sce                  # Loads all modules
├── README.md
├── ARCHITECTURE.md
├── LICENSE
├── .gitignore
│
├── config/
│   ├── default_config.sce      # System parameters (sample rate, thresholds, paths)
│   ├── sensor_params.sce       # Per-sensor calibration & physics data
│   └── test_profiles.sce       # Stimulus profile generator & presets
│
├── models/
│   ├── sensor_temperature.sce  # Thermocouple/RTD with thermal lag
│   ├── sensor_pressure.sce     # Piezoelectric transducer
│   ├── sensor_humidity.sce     # Capacitive humidity sensor
│   ├── sensor_proximity.sce    # Inductive/capacitive proximity
│   ├── sensor_vibration.sce    # Accelerometer (2nd-order dynamics)
│   ├── sensor_analog.sce       # Generic 0-5V / 4-20mA sensor
│   └── sensor_digital.sce      # Digital on/off with hysteresis
│
├── modules/
│   ├── fault_injection.sce     # 6 fault types
│   ├── test_controller.sce     # Test sequence orchestrator
│   ├── validation.sce          # Limit & rate checking, pass/fail
│   ├── calibration.sce         # Offset + gain correction
│   ├── data_logger.sce         # CSV logging
│   ├── visualization.sce       # Plot generation & export
│   ├── report_generator.sce    # Text report creation
│   └── digital_twin.sce        # Expected-vs-actual comparison
│
├── tests/
│   ├── demo_normal_temperature.sce
│   ├── demo_noisy_signal.sce
│   ├── demo_sensor_drift.sce
│   ├── demo_delayed_response.sce
│   ├── demo_sensor_failure.sce
│   ├── demo_calibration.sce
│   └── demo_full_bench.sce
│
├── output/                     # Auto-generated at runtime
│   ├── logs/                   # CSV data logs
│   ├── plots/                  # Exported PNG plots
│   └── reports/                # Text summary reports
│
└── docs/
    ├── digital_twin_concept.md
    ├── sensor_models.md
    └── future_roadmap.md
```

---

## Installation & Prerequisites

### Requirements
- **Scilab 6.x** (tested on Scilab 6.1+)
- No additional toolboxes required

### Setup
1. Clone this repository:
   ```bash
   git clone https://github.com/YOUR_USERNAME/SensorBench-Scilab.git
   cd SensorBench-Scilab
   ```
2. Open **Scilab**
3. Navigate to the project directory in Scilab's file browser

---

## How to Run

### Interactive Dashboard
```scilab
exec("main.sce");
```
This launches a menu-driven interface where you can:
- Run individual sensor tests with selectable profiles and faults
- Run the full bench test across all sensors
- Execute any of the 7 pre-built demo scenarios

### Run a Specific Demo
```scilab
exec("tests/demo_normal_temperature.sce");
exec("tests/demo_noisy_signal.sce");
exec("tests/demo_calibration.sce");
```

### Run All Demos
```scilab
exec("tests/demo_full_bench.sce");
```

### Load Modules Only (for scripting)
```scilab
exec("loader.sce");
// Now all functions are available
result = run_sensor_test(SENSOR_TEMP, sensor_temperature_model, PROFILE_STEP, "noise", "my_test");
```

---

## Demo Scenarios

| Demo | Sensor | Profile | Fault | Expected Verdict |
|------|--------|---------|-------|-----------------|
| Normal Temperature | Temperature | Step | None | PASS |
| Noisy Signal | Pressure | Sine | Noise | PASS (marginal) |
| Sensor Drift | Humidity | Ramp | Drift | FAIL |
| Delayed Response | Proximity | Pulse | Delay | PASS |
| Sensor Failure | Analog | Sine | Out-of-Range | FAIL |
| Calibration | Temperature | Ramp | None | N/A (calibration demo) |
| Full Bench | All Sensors | Step | None | Mixed |

---

## Supported Sensor Models

| Sensor | Physics Model | Time Constant | Range |
|--------|--------------|---------------|-------|
| Temperature | 1st-order thermal lag (RC equivalent) | 0.5 s | -40 to 200 °C |
| Pressure | 1st-order damped transducer | 0.1 s | 0 to 10 bar |
| Humidity | 1st-order slow capacitive response | 2.0 s | 0 to 100 %RH |
| Proximity | 1st-order fast inductive response | 0.05 s | 0 to 50 mm |
| Vibration | 2nd-order mass-spring-damper | 0.01 s | -5 to 5 g |
| Analog | 1st-order generic (4-20mA / 0-5V) | 0.2 s | 0 to 5 V |
| Digital | Schmitt-trigger with hysteresis | instantaneous | 0 or 1 |

---

## Digital Twin Concept

The **Digital Twin** in SensorBench runs the ideal sensor model in parallel with the measured (possibly faulty) signal. It continuously computes the **residual** (difference between expected and actual) and classifies the sensor into one of three states:

| State | Condition | Meaning |
|-------|-----------|---------|
| **NOMINAL** | residual < warning threshold | Sensor operating normally |
| **WARNING** | warning ≤ residual < fault threshold | Deviation detected, investigation needed |
| **FAULT** | residual ≥ fault threshold | Significant anomaly, sensor may have failed |

This mirrors how industrial digital twins monitor real equipment — providing predictive maintenance insights and early fault detection.

> **Design Assumption:** The digital twin here is a *behavioral twin* (model-based comparison), not a full physics or 3D simulation. This is the most practical approach for sensor validation and is directly applicable to real DAQ systems.

---

## Example Output

### Console Summary
```
╔══════════════════════════════════════════════════╗
║  TEST RESULT: Temperature — normal_temp          ║
╠══════════════════════════════════════════════════╣
║  Verdict : PASS                                  ║
║  Profile : Step Response   Fault: none           ║
║  Mean    :   +53.2841  Std:  56.4823             ║
║  Range   : [  -39.87,  199.42]                   ║
║  In Spec :  100.0%                               ║
║  Twin    : NOMINAL                               ║
╚══════════════════════════════════════════════════╝
```

### Generated Files
- `output/logs/Temperature_normal_temp_20260325_104200.csv`
- `output/plots/Temperature_normal_temp.png`
- `output/reports/report_Temperature_normal_temp_20260325_104200.txt`

---

## Screenshots

> After running the demos, check `output/plots/` for generated PNG files:
> - `Temperature_normal_temp.png` — Clean step response with thermal lag
> - `Pressure_noisy_pressure.png` — Noise-corrupted sinusoidal signal
> - `Humidity_drift_humidity.png` — Gradual drift deviation
> - `calibration_temperature.png` — Before/after calibration correction

---

## Future Roadmap

- [ ] Real hardware DAQ connectivity (serial, USB, NI-DAQmx)
- [ ] PLC integration via Modbus/TCP
- [ ] MQTT data streaming for IoT sensor networks
- [ ] External CSV sensor data import
- [ ] Scilab GUI dashboard (using `uicontrol`)
- [ ] Statistical process control (SPC) charts
- [ ] Multi-sensor correlation analysis
- [ ] Automated regression test suite
- [ ] Docker container for CI/CD pipelines
- [ ] Export to Xcos block diagrams

---

## GitHub Publishing

### Repository Description
> Scilab-based sensor testing bench automation system with digital twin — simulates, tests, validates, and visualizes sensor behavior for mechatronics engineering.

### Suggested Topics
`scilab`, `sensor-testing`, `digital-twin`, `automation`, `mechatronics`, `test-bench`, `signal-processing`, `fault-injection`, `calibration`, `control-systems`

### First Commit
```bash
cd SensorBench-Scilab
git init
git add .
git commit -m "feat: initial release — sensor bench automation with digital twin

- 7 sensor models (temperature, pressure, humidity, proximity, vibration, analog, digital)
- 6 fault injection types (noise, drift, spike, delay, stuck-at, out-of-range)
- Automated test controller with validation and pass/fail evaluation
- Digital twin with residual analysis and state classification
- CSV data logging, plot export, and text report generation
- Menu-driven CLI dashboard
- 7 demo scenarios with example outputs"

git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/SensorBench-Scilab.git
git push -u origin main
```

---

## License

This project is licensed under the MIT License — see [LICENSE](LICENSE) for details.

---

## Contributing

Contributions, issues, and feature requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

---

*Built with Scilab — for engineers, by engineers.*
