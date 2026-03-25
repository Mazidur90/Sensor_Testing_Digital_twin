// ============================================================================
// SensorBench-Scilab — Temperature Sensor Model
// ============================================================================
// Models a thermocouple / RTD with first-order thermal lag.
// Transfer function: G(s) = 1 / (tau*s + 1)
// ============================================================================

function output = sensor_temperature_model(t, stimulus, params)
    // Inputs:
    //   t        : 1xN time vector
    //   stimulus : 1xN input stimulus (desired temperature)
    //   params   : sensor parameter struct (SENSOR_TEMP)
    // Output:
    //   output   : 1xN sensor response with thermal lag

    N = length(t);
    dt = t(2) - t(1);
    tau = params.time_const;

    // Scale stimulus to sensor operating range
    range = params.range_high - params.range_low;
    input_scaled = params.range_low + stimulus * range;

    // First-order lag filter (discrete approximation)
    alpha = dt / (tau + dt);
    output = zeros(1, N);
    output(1) = input_scaled(1);

    for i = 2:N
        output(i) = alpha * input_scaled(i) + (1 - alpha) * output(i-1);
    end

    // Add intrinsic sensor noise
    output = output + params.noise_std * rand(1, N, "normal");

endfunction
