# Future Roadmap

## Near-Term Enhancements

### Scilab GUI Dashboard
Replace the CLI menu with a native Scilab GUI using `uicontrol` and `figure` widgets. Provide dropdown menus for sensor/profile/fault selection and real-time plot updates.

### Statistical Process Control (SPC)
Add control chart generation (X-bar, R, S charts) for batch analysis of sensor data over multiple test runs.

### Multi-Sensor Correlation
Analyze relationships between sensors (e.g., temperature vs. pressure coupling) using cross-correlation and coherence plots.

### Advanced Fault Models
- Intermittent connection faults (random dropouts)
- Sensor aging degradation (gradual parameter shift)
- Electromagnetic interference (EMI) patterns
- Quantization and ADC saturation effects

---

## Medium-Term Goals

### Real Hardware Connectivity
- **Serial / USB:** Read sensor data from Arduino, STM32, or industrial DAQ boards
- **NI-DAQmx Integration:** Interface with National Instruments data acquisition hardware
- **Modbus RTU/TCP:** Connect to PLC-based sensor systems

### Network Sensor Streaming
- **MQTT Client:** Subscribe to IoT sensor topics for live data ingestion
- **TCP Socket:** Direct socket connection for high-speed streaming
- **OPC-UA:** Industrial protocol support for SCADA integration

### External Data Import
- Import sensor data from CSV, Excel, or HDF5 files
- Replay recorded field data through the digital twin for post-analysis

---

## Long-Term Vision

### Xcos Integration
Create Xcos block diagram wrappers for all sensor models and fault injection blocks, enabling visual simulation in Scilab's block diagram editor.

### CI/CD Pipeline
- Automated regression testing via Scilab CLI mode
- Docker containerization for cloud execution
- GitHub Actions workflow for demo validation

### Machine Learning Extension
- Train anomaly detection models on synthetic fault data
- Integrate with Python (via Scilab-Python bridge) for ML inference
- Automate fault classification beyond threshold-based rules

### Multi-Bench Federation
- Run multiple virtual test benches in parallel
- Compare results across different sensor configurations
- Aggregate reports into a test campaign summary

---

## Contributing Ideas

If you have ideas for extensions, please open a GitHub Issue with the `enhancement` label. Areas of particular interest:
- Additional sensor physics models
- Industry-specific test protocols (automotive, aerospace, pharmaceutical)
- Integration with specific hardware platforms
