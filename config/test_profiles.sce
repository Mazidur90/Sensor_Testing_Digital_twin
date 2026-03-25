// ============================================================================
// SensorBench-Scilab — Test Profiles
// ============================================================================
// Pre-defined stimulus profiles for sensor testing.
// Each profile defines a function that generates an input signal.
// ============================================================================

// -------------------------------------------------------------------------
// generate_profile - Create a stimulus signal based on profile type
// -------------------------------------------------------------------------
// Inputs:
//   t          : time vector (1xN)
//   profile    : string — "step", "ramp", "sine", "pulse", "random", "sweep"
//   amplitude  : signal amplitude (peak value)
//   offset     : signal DC offset
//   frequency  : frequency for periodic signals (Hz)
//   duty       : duty cycle for pulse (0 to 1)
// Output:
//   signal     : 1xN stimulus signal
// -------------------------------------------------------------------------
function signal = generate_profile(t, profile, amplitude, offset, frequency, duty)

    // Default arguments
    if ~exists("amplitude", "local") then amplitude = 1; end
    if ~exists("offset", "local")    then offset = 0;    end
    if ~exists("frequency", "local") then frequency = 1;  end
    if ~exists("duty", "local")      then duty = 0.5;     end

    N = length(t);
    T_total = t($) - t(1);

    select profile

    case "step" then
        // Step from 0 to amplitude at t = T/3
        signal = offset * ones(1, N);
        step_idx = find(t >= t(1) + T_total / 3);
        if ~isempty(step_idx) then
            signal(step_idx) = offset + amplitude;
        end

    case "ramp" then
        // Linear ramp from 0 to amplitude over full duration
        signal = offset + amplitude * (t - t(1)) / T_total;

    case "sine" then
        // Sinusoidal signal
        signal = offset + amplitude * sin(2 * %pi * frequency * t);

    case "pulse" then
        // Periodic rectangular pulse with specified duty cycle
        period = 1 / frequency;
        phase = modulo(t - t(1), period);
        signal = offset + amplitude * double(phase < duty * period);

    case "random" then
        // Band-limited random signal (uniform distribution)
        signal = offset + amplitude * (rand(1, N) - 0.5) * 2;

    case "sweep" then
        // Linear frequency sweep from 0.1 Hz to frequency
        f0 = 0.1;
        f1 = frequency;
        phase_inst = 2 * %pi * (f0 * t + (f1 - f0) / (2 * T_total) * t.^2);
        signal = offset + amplitude * sin(phase_inst);

    else
        // Constant signal (flat)
        signal = offset * ones(1, N);
        disp("WARNING: Unknown profile '" + profile + "'. Using constant signal.");
    end

endfunction

// -------------------------------------------------------------------------
// Pre-defined test profile configurations (as structs)
// -------------------------------------------------------------------------

PROFILE_STEP         = struct();
PROFILE_STEP.name    = "Step Response";
PROFILE_STEP.type    = "step";
PROFILE_STEP.amp     = 1;
PROFILE_STEP.offset  = 0;
PROFILE_STEP.freq    = 1;
PROFILE_STEP.duty    = 0.5;

PROFILE_RAMP         = struct();
PROFILE_RAMP.name    = "Ramp";
PROFILE_RAMP.type    = "ramp";
PROFILE_RAMP.amp     = 1;
PROFILE_RAMP.offset  = 0;
PROFILE_RAMP.freq    = 1;
PROFILE_RAMP.duty    = 0.5;

PROFILE_SINE         = struct();
PROFILE_SINE.name    = "Sinusoidal";
PROFILE_SINE.type    = "sine";
PROFILE_SINE.amp     = 1;
PROFILE_SINE.offset  = 0;
PROFILE_SINE.freq    = 1;
PROFILE_SINE.duty    = 0.5;

PROFILE_PULSE        = struct();
PROFILE_PULSE.name   = "Pulse Train";
PROFILE_PULSE.type   = "pulse";
PROFILE_PULSE.amp    = 1;
PROFILE_PULSE.offset = 0;
PROFILE_PULSE.freq   = 2;
PROFILE_PULSE.duty   = 0.3;

PROFILE_RANDOM       = struct();
PROFILE_RANDOM.name  = "Random";
PROFILE_RANDOM.type  = "random";
PROFILE_RANDOM.amp   = 1;
PROFILE_RANDOM.offset= 0;
PROFILE_RANDOM.freq  = 1;
PROFILE_RANDOM.duty  = 0.5;

PROFILE_SWEEP        = struct();
PROFILE_SWEEP.name   = "Frequency Sweep";
PROFILE_SWEEP.type   = "sweep";
PROFILE_SWEEP.amp    = 1;
PROFILE_SWEEP.offset = 0;
PROFILE_SWEEP.freq   = 10;
PROFILE_SWEEP.duty   = 0.5;
