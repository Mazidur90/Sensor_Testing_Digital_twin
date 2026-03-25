// ============================================================================
// Demo: Noisy Sensor Signal
// ============================================================================
// Tests a pressure sensor with Gaussian noise injected.
// Demonstrates noise's effect on signal quality and validation.
// ============================================================================

if ~exists("SENSORBENCH_ROOT") then
    exec(get_absolute_file_path("demo_noisy_signal.sce") + "../loader.sce", -1);
end

printf("\n=== DEMO: Noisy Sensor Signal (Pressure) ===\n");

result = run_sensor_test( ..
    SENSOR_PRESS, ..
    sensor_pressure_model, ..
    PROFILE_SINE, ..               // sinusoidal pressure input
    "noise", ..                    // inject noise
    "noisy_pressure", ..
    11 ..
);

printf("=== Demo complete. Observe noise corruption in plots. ===\n");
