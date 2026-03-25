// ============================================================================
// SensorBench-Scilab — Test Controller Module
// ============================================================================
// Central orchestrator that coordinates the entire test pipeline:
//   stimulus → sensor model → fault injection → validation →
//   digital twin → logging → visualization → report
// ============================================================================

// -------------------------------------------------------------------------
// run_sensor_test - Execute a complete sensor test sequence
// -------------------------------------------------------------------------
// Inputs:
//   sensor_params  : sensor parameter struct (e.g., SENSOR_TEMP)
//   sensor_model   : function handle for the sensor model
//   profile        : profile struct (e.g., PROFILE_STEP)
//   fault_type     : string — "none","noise","drift","spike","delay","stuckat","outofrange"
//   test_name      : string identifier
//   fig_id         : figure number for plots (default: 1)
// Output:
//   result         : struct containing all test data and verdict
// -------------------------------------------------------------------------
function result = run_sensor_test(sensor_params, sensor_model, profile, fault_type, test_name, fig_id)
    if ~exists("fault_type", "local") then fault_type = "none"; end
    if ~exists("test_name", "local")  then test_name = "default"; end
    if ~exists("fig_id", "local")     then fig_id = 1; end

    printf("\n===========================================================\n");
    printf("  RUNNING TEST: %s — %s\n", sensor_params.name, test_name);
    printf("  Profile: %s | Fault: %s\n", profile.name, fault_type);
    printf("===========================================================\n");

    // --- Step 1: Generate time vector ---
    t = 0:CFG_DT:(CFG_TEST_DURATION - CFG_DT);
    N = length(t);
    printf("  [1/7] Time vector: %d samples, %.1f s duration\n", N, CFG_TEST_DURATION);

    // --- Step 2: Generate stimulus ---
    stim_range = sensor_params.range_high - sensor_params.range_low;
    stimulus = generate_profile(t, profile.type, profile.amp, profile.offset, profile.freq, profile.duty);
    printf("  [2/7] Stimulus generated: %s\n", profile.name);

    // --- Step 3: Run sensor model (ideal response) ---
    ideal_signal = sensor_model(t, stimulus, sensor_params);
    printf("  [3/7] Sensor model executed: %s\n", sensor_params.name);

    // --- Step 4: Apply fault injection ---
    measured_signal = apply_fault(ideal_signal, fault_type, sensor_params);
    printf("  [4/7] Fault injected: %s\n", fault_type);

    // --- Step 5: Validate signal ---
    limit_result = check_limits(measured_signal, sensor_params.range_low, sensor_params.range_high);
    rate_result  = check_rate_of_change(measured_signal, CFG_DT);
    [verdict, reason] = evaluate_pass_fail(limit_result, rate_result);
    printf("  [5/7] Validation complete: %s\n", verdict);

    // --- Step 6: Digital Twin Evaluation ---
    twin = create_twin(sensor_params, stimulus, t);
    twin = run_twin(twin, sensor_model, sensor_params);
    twin.measured = measured_signal;
    twin = evaluate_twin(twin);
    printf("  [6/7] Digital twin state: %s\n", twin.final_state);

    // --- Step 7: Compute statistics ---
    stats = compute_statistics(measured_signal);
    printf("  [7/7] Statistics computed\n");

    // --- Build result struct ---
    result = struct();
    result.sensor_name   = sensor_params.name;
    result.sensor_unit   = sensor_params.unit;
    result.test_name     = test_name;
    result.profile_type  = profile.name;
    result.fault_type    = fault_type;
    result.verdict       = verdict;
    result.reason        = reason;
    result.stats         = stats;
    result.limit_result  = limit_result;
    result.rate_result   = rate_result;
    result.twin_status   = twin.final_state;
    result.duration      = CFG_TEST_DURATION;
    result.sample_rate   = CFG_SAMPLE_RATE;
    result.t             = t;
    result.ideal         = ideal_signal;
    result.measured      = measured_signal;
    result.twin          = twin;

    // --- Log data ---
    log_data_csv(t, ideal_signal, measured_signal, sensor_params.name, test_name);
    log_event(sensor_params.name + " | " + test_name + " | " + verdict);

    // --- Generate plot ---
    if CFG_SHOW_PLOTS then
        plot_sensor_test(t, ideal_signal, measured_signal, ..
            sensor_params.name, sensor_params.unit, ..
            [sensor_params.range_low, sensor_params.range_high], ..
            test_name, fig_id);
    end

    if CFG_EXPORT_PLOTS then
        export_plot(fig_id, sensor_params.name + "_" + test_name);
    end

    // --- Generate report ---
    generate_report(result);

    // --- Print summary ---
    print_summary(result);

    // --- Digital twin summary ---
    twin_summary(twin);

    printf("  TEST COMPLETE: %s — %s\n\n", sensor_params.name, test_name);

endfunction

// -------------------------------------------------------------------------
// run_full_bench - Run all sensors with a given profile and fault
// -------------------------------------------------------------------------
function results = run_full_bench(profile, fault_type)
    if ~exists("fault_type", "local") then fault_type = "none"; end

    printf("\n");
    printf("###########################################################\n");
    printf("###   SENSORBENCH — FULL BENCH TEST                     ###\n");
    printf("###   Profile: %-15s Fault: %-15s ###\n", profile.name, fault_type);
    printf("###########################################################\n\n");

    // Define all sensors and their models
    sensor_list   = list(SENSOR_TEMP, SENSOR_PRESS, SENSOR_HUMID, SENSOR_PROX, SENSOR_VIB, SENSOR_ANALOG);
    model_list    = list(sensor_temperature_model, sensor_pressure_model, sensor_humidity_model, ..
                         sensor_proximity_model, sensor_vibration_model, sensor_analog_model);
    n_sensors     = length(sensor_list);

    results = list();
    for i = 1:n_sensors
        test_name = "bench_" + profile.type;
        r = run_sensor_test(sensor_list(i), model_list(i), profile, fault_type, test_name, i);
        results(i) = r;
    end

    // --- Bench summary ---
    printf("\n###########################################################\n");
    printf("###   BENCH SUMMARY                                     ###\n");
    printf("###########################################################\n");
    n_pass = 0;
    n_fail = 0;
    for i = 1:n_sensors
        r = results(i);
        if r.verdict == "PASS" then
            n_pass = n_pass + 1;
            marker = "✓";
        else
            n_fail = n_fail + 1;
            marker = "✗";
        end
        printf("  %s  %-15s : %s  (Twin: %s)\n", marker, r.sensor_name, r.verdict, r.twin_status);
    end
    printf("-----------------------------------------------------------\n");
    printf("  Total: %d passed, %d failed out of %d sensors\n", n_pass, n_fail, n_sensors);
    printf("###########################################################\n\n");

endfunction
