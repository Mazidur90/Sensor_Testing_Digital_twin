// ============================================================================
// SensorBench-Scilab — Vibration Sensor Model (Accelerometer)
// ============================================================================
// Models an accelerometer with second-order dynamics (mass-spring-damper).
// Adds resonance behavior at the natural frequency.
// ============================================================================

function output = sensor_vibration_model(t, stimulus, params)
    // Inputs:
    //   t        : 1xN time vector
    //   stimulus : 1xN normalized input stimulus (0..1)
    //   params   : sensor parameter struct (SENSOR_VIB)
    // Output:
    //   output   : 1xN sensor response in g

    N = length(t);
    dt = t(2) - t(1);

    // Scale to operating range
    range = params.range_high - params.range_low;
    input_scaled = params.range_low + stimulus * range;

    // Second-order system parameters
    wn = 2 * %pi * params.frequency;   // natural frequency (rad/s)
    zeta = params.damping;              // damping ratio

    // State-space discretization (x = [position; velocity])
    // x_dot = A*x + B*u;  y = C*x
    A = [0, 1; -wn^2, -2*zeta*wn];
    B = [0; wn^2];
    C = [1, 0];

    // Euler integration
    x = [input_scaled(1); 0];
    output = zeros(1, N);
    output(1) = C * x;

    for i = 2:N
        x_dot = A * x + B * input_scaled(i);
        x = x + dt * x_dot;
        output(i) = C * x;
    end

    // Add sensor noise
    output = output + params.noise_std * rand(1, N, "normal");

endfunction
