// ============================================================================
// SensorBench-Scilab — Report Generator Module
// ============================================================================
// Produces structured text reports summarizing test results.
// Reports include sensor info, test configuration, statistics, and verdict.
// ============================================================================

// -------------------------------------------------------------------------
// generate_report - Create a complete test report as a text file
// -------------------------------------------------------------------------
// Inputs:
//   test_result : struct with fields:
//     .sensor_name    : string
//     .sensor_unit    : string
//     .test_name      : string
//     .profile_type   : string
//     .fault_type     : string
//     .verdict        : "PASS" or "FAIL"
//     .reason         : string
//     .stats          : struct from compute_statistics()
//     .limit_result   : struct from check_limits()
//     .rate_result    : struct from check_rate_of_change()
//     .twin_status    : string (optional)
//     .duration       : test duration in seconds
//     .sample_rate    : samples per second
//   base_dir : output directory
// Output:
//   filepath : path to the generated report
// -------------------------------------------------------------------------
function filepath = generate_report(test_result, base_dir)
    if ~exists("base_dir", "local") then base_dir = SENSORBENCH_ROOT + CFG_REPORT_DIR; end
    if ~isdir(base_dir) then mkdir(base_dir); end

    // Generate filename
    timestamp_vec = clock();
    timestamp = msprintf("%04d%02d%02d_%02d%02d%02d", ..
        timestamp_vec(1), timestamp_vec(2), timestamp_vec(3), ..
        timestamp_vec(4), timestamp_vec(5), floor(timestamp_vec(6)));

    filename = "report_" + test_result.sensor_name + "_" + test_result.test_name + "_" + timestamp + ".txt";
    filepath = base_dir + filename;

    // Build report text
    fd = mopen(filepath, "w");

    mfprintf(fd, "================================================================\n");
    mfprintf(fd, "  SENSORBENCH-SCILAB — TEST REPORT\n");
    mfprintf(fd, "================================================================\n\n");

    mfprintf(fd, "  Generated    : %04d-%02d-%02d %02d:%02d:%02d\n", ..
        timestamp_vec(1), timestamp_vec(2), timestamp_vec(3), ..
        timestamp_vec(4), timestamp_vec(5), floor(timestamp_vec(6)));
    mfprintf(fd, "  Sensor       : %s\n", test_result.sensor_name);
    mfprintf(fd, "  Unit         : %s\n", test_result.sensor_unit);
    mfprintf(fd, "  Test Name    : %s\n", test_result.test_name);
    mfprintf(fd, "  Profile      : %s\n", test_result.profile_type);
    mfprintf(fd, "  Fault Inject : %s\n", test_result.fault_type);
    mfprintf(fd, "  Duration     : %.1f s\n", test_result.duration);
    mfprintf(fd, "  Sample Rate  : %d Hz\n", test_result.sample_rate);
    mfprintf(fd, "  Total Samples: %d\n\n", test_result.stats.samples);

    mfprintf(fd, "--- VERDICT ---\n");
    mfprintf(fd, "  Result       : *** %s ***\n", test_result.verdict);
    mfprintf(fd, "  Reason       : %s\n\n", test_result.reason);

    mfprintf(fd, "--- SIGNAL STATISTICS ---\n");
    mfprintf(fd, "  Mean         : %.4f %s\n", test_result.stats.mean_val, test_result.sensor_unit);
    mfprintf(fd, "  Std Dev      : %.4f %s\n", test_result.stats.std_val, test_result.sensor_unit);
    mfprintf(fd, "  Min          : %.4f %s\n", test_result.stats.min_val, test_result.sensor_unit);
    mfprintf(fd, "  Max          : %.4f %s\n", test_result.stats.max_val, test_result.sensor_unit);
    mfprintf(fd, "  Range        : %.4f %s\n\n", test_result.stats.range, test_result.sensor_unit);

    mfprintf(fd, "--- LIMIT CHECK ---\n");
    mfprintf(fd, "  Limits       : [%.2f, %.2f] %s\n", ..
        test_result.limit_result.limit_low, test_result.limit_result.limit_high, test_result.sensor_unit);
    mfprintf(fd, "  Within Limits: %.1f%%\n", test_result.limit_result.pct_ok);
    mfprintf(fd, "  Violations   : %d samples\n\n", length(test_result.limit_result.violations));

    mfprintf(fd, "--- RATE CHECK ---\n");
    mfprintf(fd, "  Max Rate     : %.4f /s\n", test_result.rate_result.max_rate);
    mfprintf(fd, "  Rate Limit   : %.4f /s\n", test_result.rate_result.rate_limit);
    mfprintf(fd, "  Within Limit : %s\n\n", string(test_result.rate_result.within));

    // Digital twin status (if available)
    if isfield(test_result, "twin_status") then
        mfprintf(fd, "--- DIGITAL TWIN ---\n");
        mfprintf(fd, "  Final State  : %s\n\n", test_result.twin_status);
    end

    mfprintf(fd, "================================================================\n");
    mfprintf(fd, "  End of Report\n");
    mfprintf(fd, "================================================================\n");

    mclose(fd);

    if CFG_VERBOSE then
        printf("  [REPORT] Saved to: %s\n", filepath);
    end
endfunction

// -------------------------------------------------------------------------
// print_summary - Display a compact summary to the console
// -------------------------------------------------------------------------
function print_summary(test_result)
    printf("\n╔══════════════════════════════════════════════════╗\n");
    printf("║  TEST RESULT: %-10s — %-20s  ║\n", test_result.sensor_name, test_result.test_name);
    printf("╠══════════════════════════════════════════════════╣\n");
    printf("║  Verdict : %-6s                                ║\n", test_result.verdict);
    printf("║  Profile : %-15s  Fault: %-12s  ║\n", test_result.profile_type, test_result.fault_type);
    printf("║  Mean    : %+10.4f  Std: %8.4f           ║\n", test_result.stats.mean_val, test_result.stats.std_val);
    printf("║  Range   : [%8.2f, %8.2f]                  ║\n", test_result.stats.min_val, test_result.stats.max_val);
    printf("║  In Spec : %5.1f%%                              ║\n", test_result.limit_result.pct_ok);
    if isfield(test_result, "twin_status") then
        printf("║  Twin    : %-10s                            ║\n", test_result.twin_status);
    end
    printf("╚══════════════════════════════════════════════════╝\n\n");
endfunction
