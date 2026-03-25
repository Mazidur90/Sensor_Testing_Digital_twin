// ============================================================================
// SensorBench-Scilab — Sensor Parameters
// ============================================================================
// Per-sensor calibration data, operating ranges, and physical properties.
// Each sensor is defined as a Scilab struct for clean parameter passing.
// ============================================================================

// --- Temperature Sensor (Thermocouple / RTD) ---
SENSOR_TEMP            = struct();
SENSOR_TEMP.name       = "Temperature";
SENSOR_TEMP.unit       = "°C";
SENSOR_TEMP.range_low  = -40;
SENSOR_TEMP.range_high = 200;
SENSOR_TEMP.nominal    = 25;       // nominal operating value
SENSOR_TEMP.time_const = 0.5;      // thermal time constant (s)
SENSOR_TEMP.cal_offset = 0.3;      // factory calibration offset
SENSOR_TEMP.cal_gain   = 1.02;     // factory calibration gain
SENSOR_TEMP.noise_std  = 0.5;      // intrinsic sensor noise (std dev)

// --- Pressure Sensor (Piezoelectric / Strain Gauge) ---
SENSOR_PRESS            = struct();
SENSOR_PRESS.name       = "Pressure";
SENSOR_PRESS.unit       = "bar";
SENSOR_PRESS.range_low  = 0;
SENSOR_PRESS.range_high = 10;
SENSOR_PRESS.nominal    = 5;
SENSOR_PRESS.time_const = 0.1;
SENSOR_PRESS.cal_offset = 0.05;
SENSOR_PRESS.cal_gain   = 0.98;
SENSOR_PRESS.noise_std  = 0.1;

// --- Humidity Sensor (Capacitive) ---
SENSOR_HUMID            = struct();
SENSOR_HUMID.name       = "Humidity";
SENSOR_HUMID.unit       = "%RH";
SENSOR_HUMID.range_low  = 0;
SENSOR_HUMID.range_high = 100;
SENSOR_HUMID.nominal    = 50;
SENSOR_HUMID.time_const = 2.0;     // humidity sensors are slow
SENSOR_HUMID.cal_offset = 1.0;
SENSOR_HUMID.cal_gain   = 0.97;
SENSOR_HUMID.noise_std  = 1.0;

// --- Proximity Sensor (Inductive / Capacitive) ---
SENSOR_PROX            = struct();
SENSOR_PROX.name       = "Proximity";
SENSOR_PROX.unit       = "mm";
SENSOR_PROX.range_low  = 0;
SENSOR_PROX.range_high = 50;
SENSOR_PROX.nominal    = 10;
SENSOR_PROX.time_const = 0.05;     // very fast response
SENSOR_PROX.cal_offset = 0.1;
SENSOR_PROX.cal_gain   = 1.01;
SENSOR_PROX.noise_std  = 0.2;

// --- Vibration Sensor (Accelerometer) ---
SENSOR_VIB            = struct();
SENSOR_VIB.name       = "Vibration";
SENSOR_VIB.unit       = "g";
SENSOR_VIB.range_low  = -5;
SENSOR_VIB.range_high = 5;
SENSOR_VIB.nominal    = 0;
SENSOR_VIB.time_const = 0.01;      // very fast
SENSOR_VIB.cal_offset = 0.02;
SENSOR_VIB.cal_gain   = 1.005;
SENSOR_VIB.noise_std  = 0.05;
SENSOR_VIB.frequency  = 10;        // dominant vibration frequency (Hz)
SENSOR_VIB.damping    = 0.05;      // damping ratio

// --- Generic Analog Sensor ---
SENSOR_ANALOG            = struct();
SENSOR_ANALOG.name       = "Analog";
SENSOR_ANALOG.unit       = "V";
SENSOR_ANALOG.range_low  = 0;
SENSOR_ANALOG.range_high = 5;
SENSOR_ANALOG.nominal    = 2.5;
SENSOR_ANALOG.time_const = 0.2;
SENSOR_ANALOG.cal_offset = 0.01;
SENSOR_ANALOG.cal_gain   = 1.0;
SENSOR_ANALOG.noise_std  = 0.02;

// --- Generic Digital Sensor (On/Off with threshold) ---
SENSOR_DIGITAL            = struct();
SENSOR_DIGITAL.name       = "Digital";
SENSOR_DIGITAL.unit       = "state";
SENSOR_DIGITAL.range_low  = 0;
SENSOR_DIGITAL.range_high = 1;
SENSOR_DIGITAL.nominal    = 0;
SENSOR_DIGITAL.threshold  = 0.5;   // switching threshold
SENSOR_DIGITAL.hysteresis = 0.05;  // hysteresis band
SENSOR_DIGITAL.cal_offset = 0;
SENSOR_DIGITAL.cal_gain   = 1;
SENSOR_DIGITAL.noise_std  = 0;
