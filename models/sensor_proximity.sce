// ============================================================================
// SensorBench-Scilab — Proximity Sensor Model
// ============================================================================
// Models an inductive/capacitive proximity sensor.
// Very fast response with near-instantaneous output and low noise.
// ============================================================================

function output = sensor_proximity_model(t, stimulus, params)
    // Inputs:
    //   t        : 1xN time vector
    //   stimulus : 1xN normalized input stimulus (0..1)
    //   params   : sensor parameter struct (SENSOR_PROX)
    // Output:
    //   output   : 1xN sensor response in mm

    N = length(t);
    dt = t(2) - t(1);
    tau = params.time_const;

    // Scale to operating range
    range = params.range_high - params.range_low;
    input_scaled = params.range_low + stimulus * range;

    // First-order response (very fast)
    alpha = dt / (tau + dt);
    output = zeros(1, N);
    output(1) = input_scaled(1);

    for i = 2:N
        output(i) = alpha * input_scaled(i) + (1 - alpha) * output(i-1);
    end

    // Clamp to non-negative range
    output = max(0, output);

    // Add sensor noise
    output = output + params.noise_std * rand(1, N, "normal");

endfunction
