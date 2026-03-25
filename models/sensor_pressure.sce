// ============================================================================
// SensorBench-Scilab — Pressure Sensor Model
// ============================================================================
// Models a pressure transducer (piezoelectric / strain gauge).
// First-order response with slight damping and fast dynamics.
// ============================================================================

function output = sensor_pressure_model(t, stimulus, params)
    // Inputs:
    //   t        : 1xN time vector
    //   stimulus : 1xN normalized input stimulus (0..1)
    //   params   : sensor parameter struct (SENSOR_PRESS)
    // Output:
    //   output   : 1xN sensor response in engineering units

    N = length(t);
    dt = t(2) - t(1);
    tau = params.time_const;

    // Scale stimulus to sensor range
    range = params.range_high - params.range_low;
    input_scaled = params.range_low + stimulus * range;

    // First-order low-pass (fast pressure response)
    alpha = dt / (tau + dt);
    output = zeros(1, N);
    output(1) = input_scaled(1);

    for i = 2:N
        output(i) = alpha * input_scaled(i) + (1 - alpha) * output(i-1);
    end

    // Add sensor noise
    output = output + params.noise_std * rand(1, N, "normal");

endfunction
