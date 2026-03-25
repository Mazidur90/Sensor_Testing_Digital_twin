// ============================================================================
// Demo: Normal Temperature Sensor Response
// ============================================================================
// Tests a temperature sensor under nominal conditions (step profile, no faults).
// Expected result: PASS with clean step response showing thermal lag.
// ============================================================================

// Ensure modules are loaded
if ~exists("SENSORBENCH_ROOT") then
    exec(get_absolute_file_path("demo_normal_temperature.sce") + "../loader.sce", -1);
end

printf("\n=== DEMO: Normal Temperature Sensor Response ===\n");

result = run_sensor_test( ..
    SENSOR_TEMP, ..                // sensor parameters
    sensor_temperature_model, ..   // sensor model function
    PROFILE_STEP, ..               // step input profile
    "none", ..                     // no fault injection
    "normal_temp", ..              // test identifier
    10 ..                          // figure number
);

printf("=== Demo complete. Check output/ for logs, plots, and reports. ===\n");
