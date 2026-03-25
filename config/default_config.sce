// ============================================================================
// SensorBench-Scilab — Default Configuration
// ============================================================================
// Global system parameters for the sensor testing bench.
// Modify these values to change the default behavior of all tests.
// ============================================================================

// --- Sampling and Timing ---
CFG_SAMPLE_RATE    = 100;      // Hz — samples per second
CFG_TEST_DURATION  = 10;       // seconds — default test length
CFG_DT             = 1 / CFG_SAMPLE_RATE;  // time step (s)

// --- Default Thresholds ---
CFG_DEFAULT_LIMIT_LOW   = 0;      // default lower threshold (unit-dependent)
CFG_DEFAULT_LIMIT_HIGH  = 100;    // default upper threshold (unit-dependent)
CFG_RATE_LIMIT          = 50;     // max allowed rate of change per second

// --- Digital Twin ---
CFG_TWIN_RESIDUAL_WARN  = 5;      // residual > this → WARNING state
CFG_TWIN_RESIDUAL_FAULT = 15;     // residual > this → FAULT state

// --- Fault Injection Defaults ---
CFG_NOISE_AMPLITUDE     = 2.0;    // default noise amplitude
CFG_DRIFT_RATE          = 0.5;    // default drift rate per second
CFG_SPIKE_MAGNITUDE     = 50;     // default spike magnitude
CFG_SPIKE_PROBABILITY   = 0.02;   // probability of spike per sample
CFG_DELAY_SAMPLES       = 10;     // default delay in samples
CFG_STUCKAT_VALUE       = 25;     // default stuck-at value
CFG_STUCKAT_START       = 0.4;    // fraction of signal where stuck starts
CFG_STUCKAT_END         = 0.6;    // fraction of signal where stuck ends

// --- Output Paths (relative to project root) ---
CFG_LOG_DIR    = "output/logs/";
CFG_PLOT_DIR   = "output/plots/";
CFG_REPORT_DIR = "output/reports/";

// --- Calibration Defaults ---
CFG_CAL_OFFSET  = 0;    // default calibration offset
CFG_CAL_GAIN    = 1;    // default calibration gain

// --- Display ---
CFG_SHOW_PLOTS   = %T;   // display plots interactively
CFG_EXPORT_PLOTS = %T;   // export plots to PNG files
CFG_VERBOSE      = %T;   // print status messages to console
