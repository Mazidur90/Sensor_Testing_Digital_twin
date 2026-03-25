// ============================================================================
// Demo: Delayed Response
// ============================================================================
// Tests a proximity sensor with transport delay injected.
// Demonstrates how delay shifts the signal in time and affects validation.
// ============================================================================

if ~exists("SENSORBENCH_ROOT") then
    exec(get_absolute_file_path("demo_delayed_response.sce") + "../loader.sce", -1);
end

printf("\n=== DEMO: Delayed Response (Proximity) ===\n");

result = run_sensor_test( ..
    SENSOR_PROX, ..
    sensor_proximity_model, ..
    PROFILE_PULSE, ..              // pulse input
    "delay", ..                    // inject delay
    "delay_proximity", ..
    13 ..
);

printf("=== Demo complete. Observe time shift in signal. ===\n");
