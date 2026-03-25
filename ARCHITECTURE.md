# Architecture — SensorBench-Scilab

## System Overview

SensorBench-Scilab follows a **layered, modular architecture** where each concern is isolated into a separate Scilab script file. All modules communicate through well-defined function interfaces and Scilab structs.

## Layer Diagram

```
┌───────────────────────────────────────────────────────────┐
│  PRESENTATION LAYER                                       │
│  main.sce → sensorbench_menu() — CLI dashboard            │
├───────────────────────────────────────────────────────────┤
│  ORCHESTRATION LAYER                                      │
│  test_controller.sce → run_sensor_test(), run_full_bench()│
├────────┬──────────┬──────────┬──────────┬────────────────┤
│ INPUT  │ PROCESS  │ COMPARE  │ OUTPUT   │ OUTPUT         │
│        │          │          │          │                │
│Sensor  │Validation│Digital   │Data      │Visualization   │
│Models  │Module    │Twin      │Logger    │Module          │
│        │          │          │          │                │
│Fault   │Calibra-  │          │Report    │                │
│Inject  │tion      │          │Generator │                │
├────────┴──────────┴──────────┴──────────┴────────────────┤
│  CONFIGURATION LAYER                                      │
│  default_config.sce | sensor_params.sce | test_profiles   │
└───────────────────────────────────────────────────────────┘
```

## Module Responsibilities

### Configuration Layer (`config/`)
| File | Purpose |
|------|---------|
| `default_config.sce` | System-wide constants: sample rate, thresholds, paths, display flags |
| `sensor_params.sce` | Per-sensor structs with calibration data, ranges, physics constants |
| `test_profiles.sce` | `generate_profile()` function and preset profile structs |

### Sensor Models (`models/`)
All sensor models follow the **same function signature**:
```scilab
function output = sensor_XXX_model(t, stimulus, params)
```
This uniformity allows the test controller to work with any sensor model interchangeably.

| Model | Physics |
|-------|---------|
| Temperature | First-order thermal lag (τ = 0.5s) |
| Pressure | First-order damped (τ = 0.1s) |
| Humidity | First-order slow (τ = 2.0s) |
| Proximity | First-order fast (τ = 0.05s) |
| Vibration | Second-order mass-spring-damper |
| Analog | First-order generic |
| Digital | Schmitt-trigger threshold with hysteresis |

### Core Modules (`modules/`)

**`fault_injection.sce`** — Signal corruption for testing robustness. Applies faults *after* the ideal model generates the signal, preserving the clean baseline for digital twin comparison.

**`validation.sce`** — Signal quality assessment. Checks absolute limits and rate-of-change, then combines results into a pass/fail verdict.

**`calibration.sce`** — Two-point linear correction. Computes gain and offset from known reference points, then applies the inverse correction to raw sensor data.

**`data_logger.sce`** — File I/O. Writes CSV with time, ideal, measured, and error columns. Also maintains a session event log.

**`visualization.sce`** — Plot generation. Creates multi-subplot figures for signal comparison, error analysis, calibration assessment, and digital twin state. Exports to PNG.

**`report_generator.sce`** — Structured text output. Produces summary reports with sensor info, statistics, validation results, and digital twin status.

**`digital_twin.sce`** — Behavioral twin that runs the ideal model in parallel and classifies the system state based on residual magnitude.

**`test_controller.sce`** — Central orchestrator. Coordinates the 7-step pipeline: time vector → stimulus → model → fault → validation → twin → output.

## Data Flow Detail

```
[User Input]
     │
     ▼
[generate_profile()] ──→ stimulus (1×N vector)
     │
     ▼
[sensor_XXX_model()] ──→ ideal_signal (1×N)
     │
     ├──→ [Digital Twin: run_twin()] ──→ expected (1×N, no noise)
     │
     ▼
[apply_fault()] ──→ measured_signal (1×N, corrupted)
     │
     ├──→ [Digital Twin: evaluate_twin()] ──→ residual, state
     │
     ├──→ [check_limits(), check_rate_of_change()]
     │         │
     │         ▼
     │    [evaluate_pass_fail()] ──→ verdict, reason
     │
     ├──→ [log_data_csv()] ──→ output/logs/*.csv
     ├──→ [plot_sensor_test()] ──→ output/plots/*.png
     └──→ [generate_report()] ──→ output/reports/*.txt
```

## Design Principles

1. **Separation of Concerns** — Each `.sce` file handles exactly one responsibility
2. **Uniform Interfaces** — All sensor models share the same `(t, stimulus, params)` signature
3. **Structs as Data Containers** — Sensor parameters, test results, and twin state travel as Scilab structs
4. **Fail-Safe Defaults** — All optional parameters have sensible defaults in `default_config.sce`
5. **Extensibility** — Adding a new sensor requires only a new model file and a parameter struct
