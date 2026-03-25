// ============================================================================
// SensorBench-Scilab — Fault Injection Module
// ============================================================================
// Provides functions to inject realistic sensor faults into clean signals.
// Used for testing sensor robustness and validating anomaly detection.
// ============================================================================

// -------------------------------------------------------------------------
// inject_noise - Add Gaussian white noise to a signal
// -------------------------------------------------------------------------
function corrupted = inject_noise(signal, amplitude)
    if ~exists("amplitude", "local") then amplitude = CFG_NOISE_AMPLITUDE; end
    N = length(signal);
    corrupted = signal + amplitude * rand(1, N, "normal");
endfunction

// -------------------------------------------------------------------------
// inject_drift - Add linear drift over time
// -------------------------------------------------------------------------
function corrupted = inject_drift(signal, drift_rate)
    if ~exists("drift_rate", "local") then drift_rate = CFG_DRIFT_RATE; end
    N = length(signal);
    drift = drift_rate * linspace(0, 1, N);
    corrupted = signal + drift;
endfunction

// -------------------------------------------------------------------------
// inject_spike - Insert random spikes into the signal
// -------------------------------------------------------------------------
function corrupted = inject_spike(signal, magnitude, probability)
    if ~exists("magnitude", "local")   then magnitude = CFG_SPIKE_MAGNITUDE; end
    if ~exists("probability", "local") then probability = CFG_SPIKE_PROBABILITY; end
    N = length(signal);
    corrupted = signal;
    spike_mask = rand(1, N) < probability;
    spike_sign = 2 * (rand(1, N) > 0.5) - 1;  // random +1 or -1
    corrupted = corrupted + spike_mask .* spike_sign * magnitude;
endfunction

// -------------------------------------------------------------------------
// inject_delay - Shift signal in time (introduce transport delay)
// -------------------------------------------------------------------------
function corrupted = inject_delay(signal, delay_samples)
    if ~exists("delay_samples", "local") then delay_samples = CFG_DELAY_SAMPLES; end
    N = length(signal);
    delay_samples = min(delay_samples, N - 1);
    corrupted = [signal(1) * ones(1, delay_samples), signal(1:N - delay_samples)];
endfunction

// -------------------------------------------------------------------------
// inject_stuckat - Freeze signal at a fixed value for a portion of time
// -------------------------------------------------------------------------
function corrupted = inject_stuckat(signal, stuck_value, start_frac, end_frac)
    if ~exists("stuck_value", "local") then stuck_value = CFG_STUCKAT_VALUE; end
    if ~exists("start_frac", "local")  then start_frac = CFG_STUCKAT_START;  end
    if ~exists("end_frac", "local")    then end_frac = CFG_STUCKAT_END;      end
    N = length(signal);
    corrupted = signal;
    i_start = max(1, round(start_frac * N));
    i_end   = min(N, round(end_frac * N));
    corrupted(i_start:i_end) = stuck_value;
endfunction

// -------------------------------------------------------------------------
// inject_outofrange - Force signal beyond valid sensor limits
// -------------------------------------------------------------------------
function corrupted = inject_outofrange(signal, range_low, range_high, start_frac, end_frac)
    if ~exists("range_low", "local")   then range_low = CFG_DEFAULT_LIMIT_LOW; end
    if ~exists("range_high", "local")  then range_high = CFG_DEFAULT_LIMIT_HIGH; end
    if ~exists("start_frac", "local")  then start_frac = 0.3; end
    if ~exists("end_frac", "local")    then end_frac = 0.5;   end
    N = length(signal);
    corrupted = signal;
    overshoot = (range_high - range_low) * 0.3;
    i_start = max(1, round(start_frac * N));
    i_end   = min(N, round(end_frac * N));
    // Push above upper limit
    corrupted(i_start:i_end) = range_high + overshoot;
endfunction

// -------------------------------------------------------------------------
// apply_fault - Convenience wrapper to apply a named fault
// -------------------------------------------------------------------------
function corrupted = apply_fault(signal, fault_type, params)
    // fault_type: "none", "noise", "drift", "spike", "delay", "stuckat", "outofrange"
    // params: sensor parameter struct (for range info)
    select fault_type
    case "none" then
        corrupted = signal;
    case "noise" then
        corrupted = inject_noise(signal);
    case "drift" then
        corrupted = inject_drift(signal);
    case "spike" then
        corrupted = inject_spike(signal);
    case "delay" then
        corrupted = inject_delay(signal);
    case "stuckat" then
        corrupted = inject_stuckat(signal);
    case "outofrange" then
        if exists("params", "local") then
            corrupted = inject_outofrange(signal, params.range_low, params.range_high);
        else
            corrupted = inject_outofrange(signal);
        end
    else
        corrupted = signal;
        disp("WARNING: Unknown fault type: " + fault_type);
    end
endfunction
