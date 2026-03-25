# Digital Twin Concept

## What is a Digital Twin?

A **digital twin** is a virtual replica of a physical system that runs in parallel with the real (or simulated) system. It uses the same inputs and a known-good model to predict what the system *should* be doing. By comparing the twin's prediction against actual measurements, we can detect anomalies, predict failures, and validate sensor health.

## Implementation in SensorBench

### Architecture

```
Environment Input (stimulus)
         │
         ├──→ [Ideal Sensor Model] ──→ Expected Output (no noise, no faults)
         │                                    │
         │                                    ├── Residual = |Expected - Measured|
         │                                    │
         └──→ [Real/Simulated Sensor] ──→ Measured Output (with noise, faults)
                                              │
                                         [State Classifier]
                                              │
                                    ┌─────────┼─────────┐
                                    │         │         │
                                 NOMINAL   WARNING    FAULT
```

### State Classification

| State | Condition | Action |
|-------|-----------|--------|
| **NOMINAL** | `|residual| < 5.0` | Normal operation, no action needed |
| **WARNING** | `5.0 ≤ |residual| < 15.0` | Alert operator, schedule inspection |
| **FAULT** | `|residual| ≥ 15.0` | Stop test, investigate sensor failure |

Thresholds are configurable in `config/default_config.sce`:
- `CFG_TWIN_RESIDUAL_WARN = 5`
- `CFG_TWIN_RESIDUAL_FAULT = 15`

### Key Design Decision

The twin runs with `noise_std = 0` — an idealized version of the same sensor model. This isolates the comparison to systematic faults (drift, spikes, stuck-at) rather than random sensor noise, which would always produce a small residual.

## Industrial Relevance

This approach mirrors real-world implementations:
- **Predictive maintenance** in manufacturing plants
- **Condition monitoring** for rotating machinery
- **Process validation** in pharmaceutical and automotive testing
- **Anomaly detection** in IoT sensor networks

## Limitations & Future Work

- Current implementation is a *behavioral twin* (model-based), not a *physics twin* (FEA/CFD)
- No real-time streaming — operates on batch data
- Future: connect to live DAQ or MQTT streams for real-time twin comparison
