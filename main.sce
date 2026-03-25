// ============================================================================
// SensorBench-Scilab — Main Dashboard
// ============================================================================
// Entry point for the sensor testing bench automation system.
// Provides a menu-driven interface for running tests and demos.
// ============================================================================

// Load all modules
exec(get_absolute_file_path("main.sce") + "loader.sce", -1);

// =========================================================================
// sensorbench_menu - Interactive menu loop
// =========================================================================
function sensorbench_menu()

    running = %T;

    while running
        printf("\n");
        printf("╔══════════════════════════════════════════════════════════╗\n");
        printf("║         SENSORBENCH-SCILAB — DASHBOARD                  ║\n");
        printf("║   Sensor Testing Bench Automation + Digital Twin        ║\n");
        printf("╠══════════════════════════════════════════════════════════╣\n");
        printf("║                                                         ║\n");
        printf("║   1. Run Single Sensor Test                             ║\n");
        printf("║   2. Run Full Bench Test (All Sensors)                  ║\n");
        printf("║   3. Run Demo: Normal Temperature Response              ║\n");
        printf("║   4. Run Demo: Noisy Sensor Signal                      ║\n");
        printf("║   5. Run Demo: Sensor Drift                             ║\n");
        printf("║   6. Run Demo: Delayed Response                         ║\n");
        printf("║   7. Run Demo: Sensor Failure (Out of Range)            ║\n");
        printf("║   8. Run Demo: Calibration Before/After                 ║\n");
        printf("║   9. Run All Demos                                      ║\n");
        printf("║   0. Exit                                               ║\n");
        printf("║                                                         ║\n");
        printf("╚══════════════════════════════════════════════════════════╝\n");
        printf("\n");

        choice = input("  Select option [0-9]: ");

        select choice

        case 1 then
            // --- Single Sensor Test ---
            printf("\n  Available sensors:\n");
            printf("    1. Temperature\n");
            printf("    2. Pressure\n");
            printf("    3. Humidity\n");
            printf("    4. Proximity\n");
            printf("    5. Vibration\n");
            printf("    6. Analog (Generic)\n");
            printf("    7. Digital (On/Off)\n");
            s_choice = input("  Select sensor [1-7]: ");

            sensor_list  = list(SENSOR_TEMP, SENSOR_PRESS, SENSOR_HUMID, SENSOR_PROX, SENSOR_VIB, SENSOR_ANALOG, SENSOR_DIGITAL);
            model_list   = list(sensor_temperature_model, sensor_pressure_model, sensor_humidity_model, ..
                               sensor_proximity_model, sensor_vibration_model, sensor_analog_model, sensor_digital_model);

            if s_choice >= 1 & s_choice <= 7 then
                printf("\n  Available profiles:\n");
                printf("    1. Step Response\n");
                printf("    2. Ramp\n");
                printf("    3. Sinusoidal\n");
                printf("    4. Pulse Train\n");
                printf("    5. Random\n");
                printf("    6. Frequency Sweep\n");
                p_choice = input("  Select profile [1-6]: ");

                profile_list = list(PROFILE_STEP, PROFILE_RAMP, PROFILE_SINE, PROFILE_PULSE, PROFILE_RANDOM, PROFILE_SWEEP);
                if p_choice < 1 | p_choice > 6 then p_choice = 1; end
                profile = profile_list(p_choice);

                printf("\n  Available faults:\n");
                printf("    0. None\n");
                printf("    1. Noise\n");
                printf("    2. Drift\n");
                printf("    3. Spike\n");
                printf("    4. Delay\n");
                printf("    5. Stuck-at\n");
                printf("    6. Out of Range\n");
                f_choice = input("  Select fault [0-6]: ");

                fault_names = ["none", "noise", "drift", "spike", "delay", "stuckat", "outofrange"];
                if f_choice < 0 | f_choice > 6 then f_choice = 0; end
                fault = fault_names(f_choice + 1);

                run_sensor_test(sensor_list(s_choice), model_list(s_choice), profile, fault, "manual_test");
            else
                printf("  Invalid sensor selection.\n");
            end

        case 2 then
            // --- Full Bench ---
            run_full_bench(PROFILE_STEP, "none");

        case 3 then
            exec(SENSORBENCH_ROOT + "tests/demo_normal_temperature.sce", -1);

        case 4 then
            exec(SENSORBENCH_ROOT + "tests/demo_noisy_signal.sce", -1);

        case 5 then
            exec(SENSORBENCH_ROOT + "tests/demo_sensor_drift.sce", -1);

        case 6 then
            exec(SENSORBENCH_ROOT + "tests/demo_delayed_response.sce", -1);

        case 7 then
            exec(SENSORBENCH_ROOT + "tests/demo_sensor_failure.sce", -1);

        case 8 then
            exec(SENSORBENCH_ROOT + "tests/demo_calibration.sce", -1);

        case 9 then
            // --- Run all demos ---
            printf("\n  Running all demo scenarios...\n\n");
            exec(SENSORBENCH_ROOT + "tests/demo_full_bench.sce", -1);

        case 0 then
            printf("\n  Exiting SensorBench. Goodbye.\n\n");
            running = %F;

        else
            printf("\n  Invalid option. Please select 0-9.\n");
        end

    end

endfunction

// Launch the menu
sensorbench_menu();
