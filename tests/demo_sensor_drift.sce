// ============================================================================
// Demo: Sensor Drift
// ============================================================================
// Tests a humidity sensor with linear drift injected over time.
// Demonstrates how drift causes gradual deviation from the expected value.
// ============================================================================

if ~exists("SENSORBENCH_ROOT") then
    exec(get_absolute_file_path("demo_sensor_drift.sce") + "../loader.sce", -1);
end

printf("\n=== DEMO: Sensor Drift (Humidity) ===\n");

result = run_sensor_test( ..
    SENSOR_HUMID, ..
    sensor_humidity_model, ..
    PROFILE_RAMP, ..               // ramp humidity profile
    "drift", ..                    // inject drift
    "drift_humidity", ..
    12 ..
);

printf("=== Demo complete. Observe drift in the residual plot. ===\n");
