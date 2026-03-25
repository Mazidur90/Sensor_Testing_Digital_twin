// ============================================================================
// Demo: Calibration Before and After Correction
// ============================================================================
// Demonstrates the calibration workflow:
//   1. Generate a reference signal (known true value)
//   2. Simulate a raw sensor reading with systematic error
//   3. Compute calibration coefficients from reference points
//   4. Apply calibration correction
//   5. Compare before/after error
// ============================================================================

if ~exists("SENSORBENCH_ROOT") then
    exec(get_absolute_file_path("demo_calibration.sce") + "../loader.sce", -1);
end

printf("\n=== DEMO: Calibration Before/After (Temperature) ===\n");

// --- Setup ---
t = 0:CFG_DT:(CFG_TEST_DURATION - CFG_DT);
N = length(t);

// Generate reference signal (known true temperature)
reference = generate_profile(t, "ramp", 1, 0, 1, 0.5);
range = SENSOR_TEMP.range_high - SENSOR_TEMP.range_low;
reference = SENSOR_TEMP.range_low + reference * range;

// Simulate raw sensor reading with systematic error (offset + gain error)
raw_signal = SENSOR_TEMP.cal_gain * reference + SENSOR_TEMP.cal_offset;
raw_signal = raw_signal + SENSOR_TEMP.noise_std * rand(1, N, "normal");

// Compute calibration from two reference points
ref_low  = SENSOR_TEMP.range_low + 0.1 * range;
ref_high = SENSOR_TEMP.range_low + 0.9 * range;
meas_low  = SENSOR_TEMP.cal_gain * ref_low + SENSOR_TEMP.cal_offset;
meas_high = SENSOR_TEMP.cal_gain * ref_high + SENSOR_TEMP.cal_offset;

[cal_offset, cal_gain] = compute_calibration(ref_low, ref_high, meas_low, meas_high);

// Apply calibration
corrected_signal = apply_calibration(raw_signal, cal_offset, cal_gain);

// Report
calibration_report(raw_signal, corrected_signal, cal_offset, cal_gain, "Temperature");

// Visualize
plot_calibration(t, raw_signal, corrected_signal, reference, "Temperature", 15);

if CFG_EXPORT_PLOTS then
    export_plot(15, "calibration_temperature");
end

// Log
log_data_csv(t, reference, corrected_signal, "Temperature", "calibration");

printf("=== Demo complete. Observe error reduction in the plot. ===\n");
