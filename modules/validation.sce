// ============================================================================
// SensorBench-Scilab — Validation Module
// ============================================================================
// Limit checking, rate-of-change monitoring, and pass/fail evaluation.
// ============================================================================

// -------------------------------------------------------------------------
// check_limits - Check if signal stays within min/max bounds
// -------------------------------------------------------------------------
// Returns:
//   result.within    : boolean — %T if ALL samples within limits
//   result.violations: indices of samples that exceeded limits
//   result.pct_ok    : percentage of samples within limits
// -------------------------------------------------------------------------
function result = check_limits(signal, limit_low, limit_high)
    N = length(signal);
    violations = find(signal < limit_low | signal > limit_high);
    result        = struct();
    result.within     = isempty(violations);
    result.violations = violations;
    result.pct_ok     = (N - length(violations)) / N * 100;
    result.limit_low  = limit_low;
    result.limit_high = limit_high;
endfunction

// -------------------------------------------------------------------------
// check_rate_of_change - Verify signal does not change too fast
// -------------------------------------------------------------------------
// Returns:
//   result.within    : boolean
//   result.violations: indices where rate exceeded limit
//   result.max_rate  : maximum rate observed
// -------------------------------------------------------------------------
function result = check_rate_of_change(signal, dt, rate_limit)
    if ~exists("rate_limit", "local") then rate_limit = CFG_RATE_LIMIT; end
    rate = abs(diff(signal)) / dt;
    violations = find(rate > rate_limit);
    result            = struct();
    result.within     = isempty(violations);
    result.violations = violations;
    result.max_rate   = max(rate);
    result.rate_limit = rate_limit;
endfunction

// -------------------------------------------------------------------------
// compute_statistics - Calculate descriptive statistics of a signal
// -------------------------------------------------------------------------
function stats = compute_statistics(signal)
    stats          = struct();
    stats.mean_val = mean(signal);
    stats.max_val  = max(signal);
    stats.min_val  = min(signal);
    stats.std_val  = stdev(signal);
    stats.range    = max(signal) - min(signal);
    stats.samples  = length(signal);
endfunction

// -------------------------------------------------------------------------
// evaluate_pass_fail - Overall test verdict
// -------------------------------------------------------------------------
// Inputs:
//   limit_result : output of check_limits()
//   rate_result  : output of check_rate_of_change()
//   min_pct_ok   : minimum acceptable % of samples within limits (default 95)
// Returns:
//   verdict : "PASS" or "FAIL"
//   reason  : explanation string
// -------------------------------------------------------------------------
function [verdict, reason] = evaluate_pass_fail(limit_result, rate_result, min_pct_ok)
    if ~exists("min_pct_ok", "local") then min_pct_ok = 95; end

    reasons = [];

    if limit_result.pct_ok < min_pct_ok then
        reasons = [reasons; "Limit violations: " + string(100 - limit_result.pct_ok) + "% of samples out of range"];
    end

    if ~rate_result.within then
        reasons = [reasons; "Rate-of-change exceeded: max=" + string(rate_result.max_rate) + " (limit=" + string(rate_result.rate_limit) + ")"];
    end

    if isempty(reasons) then
        verdict = "PASS";
        reason  = "All checks passed. " + string(limit_result.pct_ok) + "% within limits.";
    else
        verdict = "FAIL";
        reason  = "";
        for i = 1:size(reasons, 1)
            reason = reason + reasons(i);
            if i < size(reasons, 1) then
                reason = reason + " | ";
            end
        end
    end
endfunction
