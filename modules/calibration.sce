// ============================================================================
// SensorBench-Scilab — Calibration Module
// ============================================================================
// Linear calibration (offset + gain correction) for sensor signals.
// Supports computing calibration coefficients from known reference points
// and applying corrections to raw signals.
// ============================================================================

// -------------------------------------------------------------------------
// apply_calibration - Apply offset and gain correction to a signal
// -------------------------------------------------------------------------
// Corrected = (Raw - offset) / gain
// This reverses the sensor's systematic error.
// -------------------------------------------------------------------------
function corrected = apply_calibration(raw_signal, cal_offset, cal_gain)
    if ~exists("cal_offset", "local") then cal_offset = CFG_CAL_OFFSET; end
    if ~exists("cal_gain", "local")   then cal_gain = CFG_CAL_GAIN; end

    if cal_gain == 0 then
        disp("ERROR: Calibration gain cannot be zero.");
        corrected = raw_signal;
        return;
    end

    corrected = (raw_signal - cal_offset) / cal_gain;
endfunction

// -------------------------------------------------------------------------
// compute_calibration - Determine calibration coefficients from reference
// -------------------------------------------------------------------------
// Uses two known reference points (low and high) to compute offset and gain.
// Inputs:
//   ref_low, ref_high   : known true values
//   meas_low, meas_high : measured sensor values at those references
// Outputs:
//   cal_offset : computed offset
//   cal_gain   : computed gain
// -------------------------------------------------------------------------
function [cal_offset, cal_gain] = compute_calibration(ref_low, ref_high, meas_low, meas_high)
    if ref_high == ref_low then
        disp("ERROR: Reference points must be different.");
        cal_offset = 0;
        cal_gain   = 1;
        return;
    end

    // Linear fit: measured = gain * reference + offset
    cal_gain   = (meas_high - meas_low) / (ref_high - ref_low);
    cal_offset = meas_low - cal_gain * ref_low;
endfunction

// -------------------------------------------------------------------------
// calibration_report - Print calibration summary
// -------------------------------------------------------------------------
function calibration_report(raw_signal, corrected_signal, cal_offset, cal_gain, sensor_name)
    if ~exists("sensor_name", "local") then sensor_name = "Sensor"; end

    raw_stats = compute_statistics(raw_signal);
    cor_stats = compute_statistics(corrected_signal);
    error_before = raw_stats.std_val;
    error_after  = cor_stats.std_val;

    printf("\n--- Calibration Report: %s ---\n", sensor_name);
    printf("  Offset applied : %+.4f\n", cal_offset);
    printf("  Gain applied   : %.4f\n", cal_gain);
    printf("  Before: mean=%.3f, std=%.3f, range=[%.3f, %.3f]\n", ..
           raw_stats.mean_val, raw_stats.std_val, raw_stats.min_val, raw_stats.max_val);
    printf("  After : mean=%.3f, std=%.3f, range=[%.3f, %.3f]\n", ..
           cor_stats.mean_val, cor_stats.std_val, cor_stats.min_val, cor_stats.max_val);
    printf("-----------------------------------\n\n");
endfunction
