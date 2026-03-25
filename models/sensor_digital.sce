// ============================================================================
// SensorBench-Scilab — Generic Digital Sensor Model
// ============================================================================
// Models a digital (on/off) sensor with threshold and hysteresis.
// Typical for limit switches, level sensors, photoelectric sensors.
// ============================================================================

function output = sensor_digital_model(t, stimulus, params)
    // Inputs:
    //   t        : 1xN time vector
    //   stimulus : 1xN normalized input stimulus (0..1)
    //   params   : sensor parameter struct (SENSOR_DIGITAL)
    // Output:
    //   output   : 1xN binary output (0 or 1)

    N = length(t);
    threshold = params.threshold;
    hyst = params.hysteresis;

    output = zeros(1, N);
    state = 0;  // initial state = OFF

    for i = 1:N
        if state == 0 then
            // Currently OFF — switch ON if stimulus exceeds upper threshold
            if stimulus(i) >= (threshold + hyst) then
                state = 1;
            end
        else
            // Currently ON — switch OFF if stimulus drops below lower threshold
            if stimulus(i) <= (threshold - hyst) then
                state = 0;
            end
        end
        output(i) = state;
    end

endfunction
