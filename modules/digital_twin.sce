// ============================================================================
// SensorBench-Scilab — Digital Twin Module
// ============================================================================
// Implements a virtual representation of the sensor under test.
// The digital twin runs the ideal sensor model in parallel and compares
// the expected output against the measured (possibly faulty) signal.
// ============================================================================

// -------------------------------------------------------------------------
// create_twin - Initialize a digital twin for a sensor
// -------------------------------------------------------------------------
// Inputs:
//   sensor_params : sensor parameter struct
//   env_input     : 1xN environment stimulus
//   t             : 1xN time vector
// Output:
//   twin : struct containing twin state and data
// -------------------------------------------------------------------------
function twin = create_twin(sensor_params, env_input, t)
    twin = struct();
    twin.sensor_name = sensor_params.name;
    twin.t           = t;
    twin.env_input   = env_input;
    twin.expected    = [];    // will be filled by run_twin
    twin.measured    = [];    // will be set externally
    twin.residual    = [];
    twin.state       = [];    // per-sample state: "NOMINAL", "WARNING", "FAULT"
    twin.final_state = "NOMINAL";
    twin.warn_thresh = CFG_TWIN_RESIDUAL_WARN;
    twin.fault_thresh= CFG_TWIN_RESIDUAL_FAULT;
endfunction

// -------------------------------------------------------------------------
// run_twin - Execute the digital twin and compute expected output
// -------------------------------------------------------------------------
// Inputs:
//   twin          : twin struct from create_twin
//   sensor_model  : function handle for the sensor model
//   sensor_params : sensor parameter struct
// Output:
//   twin          : updated with .expected field
// -------------------------------------------------------------------------
function twin = run_twin(twin, sensor_model, sensor_params)
    // Generate the ideal expected output (no faults, no noise)
    // Temporarily suppress noise for the expected model
    params_clean = sensor_params;
    params_clean.noise_std = 0;

    twin.expected = sensor_model(twin.t, twin.env_input, params_clean);
endfunction

// -------------------------------------------------------------------------
// evaluate_twin - Compare measured vs expected and determine state
// -------------------------------------------------------------------------
// Inputs:
//   twin     : twin struct with .expected and .measured filled
// Output:
//   twin     : updated with .residual, .state, .final_state
// -------------------------------------------------------------------------
function twin = evaluate_twin(twin)
    N = length(twin.expected);

    // Compute residual (absolute difference)
    twin.residual = abs(twin.measured - twin.expected);

    // Classify each sample
    twin.state = emptystr(1, N);
    for i = 1:N
        if twin.residual(i) >= twin.fault_thresh then
            twin.state(i) = "FAULT";
        elseif twin.residual(i) >= twin.warn_thresh then
            twin.state(i) = "WARNING";
        else
            twin.state(i) = "NOMINAL";
        end
    end

    // Determine final (overall) twin state
    if or(twin.state == "FAULT") then
        twin.final_state = "FAULT";
    elseif or(twin.state == "WARNING") then
        twin.final_state = "WARNING";
    else
        twin.final_state = "NOMINAL";
    end
endfunction

// -------------------------------------------------------------------------
// twin_summary - Print digital twin analysis to console
// -------------------------------------------------------------------------
function twin_summary(twin)
    N = length(twin.state);
    n_nominal = length(find(twin.state == "NOMINAL"));
    n_warning = length(find(twin.state == "WARNING"));
    n_fault   = length(find(twin.state == "FAULT"));

    printf("\n--- Digital Twin Report: %s ---\n", twin.sensor_name);
    printf("  Final State    : %s\n", twin.final_state);
    printf("  Samples        : %d\n", N);
    printf("  NOMINAL        : %d (%.1f%%)\n", n_nominal, n_nominal/N*100);
    printf("  WARNING        : %d (%.1f%%)\n", n_warning, n_warning/N*100);
    printf("  FAULT          : %d (%.1f%%)\n", n_fault, n_fault/N*100);
    printf("  Max Residual   : %.4f\n", max(twin.residual));
    printf("  Mean Residual  : %.4f\n", mean(twin.residual));
    printf("  Warn Threshold : %.2f\n", twin.warn_thresh);
    printf("  Fault Threshold: %.2f\n", twin.fault_thresh);
    printf("-----------------------------------\n\n");
endfunction
