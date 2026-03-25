// ============================================================================
// SensorBench-Scilab — Generic Analog Sensor Model
// ============================================================================
// A general-purpose analog sensor with configurable first-order response.
// Useful for 4-20 mA / 0-5V / 0-10V type industrial sensors.
// ============================================================================

function output = sensor_analog_model(t, stimulus, params)
    // Inputs:
    //   t        : 1xN time vector
    //   stimulus : 1xN normalized input stimulus (0..1)
    //   params   : sensor parameter struct (SENSOR_ANALOG)
    // Output:
    //   output   : 1xN sensor response in engineering units (V, mA, etc.)

    N = length(t);
    dt = t(2) - t(1);
    tau = params.time_const;

    // Scale to sensor output range
    range = params.range_high - params.range_low;
    input_scaled = params.range_low + stimulus * range;

    // First-order lag filter
    alpha = dt / (tau + dt);
    output = zeros(1, N);
    output(1) = input_scaled(1);

    for i = 2:N
        output(i) = alpha * input_scaled(i) + (1 - alpha) * output(i-1);
    end

    // Add sensor noise
    output = output + params.noise_std * rand(1, N, "normal");

endfunction
