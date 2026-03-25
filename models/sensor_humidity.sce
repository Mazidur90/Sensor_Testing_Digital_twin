// ============================================================================
// SensorBench-Scilab — Humidity Sensor Model
// ============================================================================
// Models a capacitive humidity sensor with slow response dynamics.
// Humidity sensors typically have large time constants (1–10 s).
// ============================================================================

function output = sensor_humidity_model(t, stimulus, params)
    // Inputs:
    //   t        : 1xN time vector
    //   stimulus : 1xN normalized input stimulus (0..1)
    //   params   : sensor parameter struct (SENSOR_HUMID)
    // Output:
    //   output   : 1xN sensor response in %RH

    N = length(t);
    dt = t(2) - t(1);
    tau = params.time_const;

    // Scale to operating range
    range = params.range_high - params.range_low;
    input_scaled = params.range_low + stimulus * range;

    // First-order lag (slow response)
    alpha = dt / (tau + dt);
    output = zeros(1, N);
    output(1) = input_scaled(1);

    for i = 2:N
        output(i) = alpha * input_scaled(i) + (1 - alpha) * output(i-1);
    end

    // Clamp to physical range (humidity cannot be negative)
    output = max(params.range_low, min(params.range_high, output));

    // Add sensor noise
    output = output + params.noise_std * rand(1, N, "normal");

endfunction
