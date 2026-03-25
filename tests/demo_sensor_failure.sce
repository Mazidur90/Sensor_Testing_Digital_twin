// ============================================================================
// Demo: Sensor Failure / Out-of-Range Condition
// ============================================================================
// Tests an analog sensor with an out-of-range fault injected.
// Simulates a catastrophic sensor failure where readings leave valid bounds.
// ============================================================================

if ~exists("SENSORBENCH_ROOT") then
    exec(get_absolute_file_path("demo_sensor_failure.sce") + "../loader.sce", -1);
end

printf("\n=== DEMO: Sensor Failure — Out of Range (Analog) ===\n");

result = run_sensor_test( ..
    SENSOR_ANALOG, ..
    sensor_analog_model, ..
    PROFILE_SINE, ..
    "outofrange", ..               // inject out-of-range fault
    "failure_analog", ..
    14 ..
);

printf("=== Demo complete. Expect FAIL verdict due to range violation. ===\n");
