// ============================================================================
// Demo: Full Bench Test — All Sensors
// ============================================================================
// Runs all demo scenarios in sequence and then performs a full bench test
// with all analog sensors using a step profile.
// ============================================================================

if ~exists("SENSORBENCH_ROOT") then
    exec(get_absolute_file_path("demo_full_bench.sce") + "../loader.sce", -1);
end

printf("\n");
printf("###########################################################\n");
printf("###                                                     ###\n");
printf("###   SENSORBENCH — COMPREHENSIVE DEMO SUITE            ###\n");
printf("###                                                     ###\n");
printf("###########################################################\n\n");

// --- Individual demos ---
printf("=== [1/7] Normal Temperature Response ===\n");
exec(SENSORBENCH_ROOT + "tests/demo_normal_temperature.sce", -1);

printf("=== [2/7] Noisy Sensor Signal ===\n");
exec(SENSORBENCH_ROOT + "tests/demo_noisy_signal.sce", -1);

printf("=== [3/7] Sensor Drift ===\n");
exec(SENSORBENCH_ROOT + "tests/demo_sensor_drift.sce", -1);

printf("=== [4/7] Delayed Response ===\n");
exec(SENSORBENCH_ROOT + "tests/demo_delayed_response.sce", -1);

printf("=== [5/7] Sensor Failure ===\n");
exec(SENSORBENCH_ROOT + "tests/demo_sensor_failure.sce", -1);

printf("=== [6/7] Calibration ===\n");
exec(SENSORBENCH_ROOT + "tests/demo_calibration.sce", -1);

printf("=== [7/7] Full Bench — Step Profile ===\n");
run_full_bench(PROFILE_STEP, "none");

printf("\n");
printf("###########################################################\n");
printf("###   ALL DEMOS COMPLETE                                ###\n");
printf("###   Check output/ directory for logs, plots, reports  ###\n");
printf("###########################################################\n\n");
