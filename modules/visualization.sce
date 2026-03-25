// ============================================================================
// SensorBench-Scilab — Visualization Module
// ============================================================================
// Generates professional-quality plots for sensor test results.
// Supports ideal-vs-measured overlays, error plots, and pass/fail bands.
// ============================================================================

// -------------------------------------------------------------------------
// plot_sensor_test - Main plot: ideal vs measured with limit bands
// -------------------------------------------------------------------------
function plot_sensor_test(t, ideal, measured, sensor_name, unit, limits, test_name, fig_id)
    if ~exists("unit", "local")        then unit = "";           end
    if ~exists("limits", "local")      then limits = [];         end
    if ~exists("test_name", "local")   then test_name = "Test";  end
    if ~exists("fig_id", "local")      then fig_id = 1;          end

    scf(fig_id); clf();

    // --- Subplot 1: Signal comparison ---
    subplot(2, 1, 1);
    plot(t, ideal, "b-", "LineWidth", 2);
    plot(t, measured, "r-", "LineWidth", 1);

    // Draw limit bands if provided
    if ~isempty(limits) then
        limit_low  = limits(1);
        limit_high = limits(2);
        plot(t, limit_low * ones(1, length(t)), "k--", "LineWidth", 1);
        plot(t, limit_high * ones(1, length(t)), "k--", "LineWidth", 1);
    end

    xlabel("Time (s)");
    if unit <> "" then
        ylabel(sensor_name + " (" + unit + ")");
    else
        ylabel(sensor_name);
    end
    title(sensor_name + " — " + test_name);
    legend(["Ideal (Expected)"; "Measured"; "Lower Limit"; "Upper Limit"], "in_upper_left");
    xgrid();

    // --- Subplot 2: Error (residual) ---
    subplot(2, 1, 2);
    error_signal = measured - ideal;
    plot(t, error_signal, "m-", "LineWidth", 1);
    plot(t, zeros(1, length(t)), "k-", "LineWidth", 0.5);
    xlabel("Time (s)");
    ylabel("Error (" + unit + ")");
    title("Residual Error (Measured - Ideal)");
    xgrid();

endfunction

// -------------------------------------------------------------------------
// plot_digital_twin - Plot digital twin comparison with state colors
// -------------------------------------------------------------------------
function plot_digital_twin(t, expected, measured, residual, twin_state, sensor_name, fig_id)
    if ~exists("fig_id", "local") then fig_id = 2; end

    scf(fig_id); clf();

    // --- Subplot 1: Twin comparison ---
    subplot(3, 1, 1);
    plot(t, expected, "b-", "LineWidth", 2);
    plot(t, measured, "r-", "LineWidth", 1);
    xlabel("Time (s)");
    ylabel("Signal");
    title(sensor_name + " — Digital Twin Comparison");
    legend(["Twin Expected"; "Measured"], "in_upper_left");
    xgrid();

    // --- Subplot 2: Residual ---
    subplot(3, 1, 2);
    plot(t, residual, "m-", "LineWidth", 1);
    plot(t, CFG_TWIN_RESIDUAL_WARN * ones(1, length(t)),  "y--", "LineWidth", 1);
    plot(t, -CFG_TWIN_RESIDUAL_WARN * ones(1, length(t)), "y--", "LineWidth", 1);
    plot(t, CFG_TWIN_RESIDUAL_FAULT * ones(1, length(t)), "r--", "LineWidth", 1);
    plot(t, -CFG_TWIN_RESIDUAL_FAULT * ones(1, length(t)), "r--", "LineWidth", 1);
    xlabel("Time (s)");
    ylabel("Residual");
    title("Twin Residual with Thresholds");
    legend(["Residual"; "Warning"; ""; "Fault"; ""], "in_upper_left");
    xgrid();

    // --- Subplot 3: State ---
    subplot(3, 1, 3);
    // Encode state as numeric: NOMINAL=0, WARNING=1, FAULT=2
    state_num = zeros(1, length(twin_state));
    for i = 1:length(twin_state)
        select twin_state(i)
        case "NOMINAL" then state_num(i) = 0;
        case "WARNING" then state_num(i) = 1;
        case "FAULT"   then state_num(i) = 2;
        end
    end
    plot(t, state_num, "k-", "LineWidth", 2);
    xlabel("Time (s)");
    ylabel("State");
    title("Digital Twin State (0=Nominal, 1=Warning, 2=Fault)");
    xgrid();

endfunction

// -------------------------------------------------------------------------
// plot_calibration - Before/after calibration comparison
// -------------------------------------------------------------------------
function plot_calibration(t, raw, corrected, reference, sensor_name, fig_id)
    if ~exists("fig_id", "local") then fig_id = 3; end

    scf(fig_id); clf();

    subplot(2, 1, 1);
    plot(t, reference, "g-", "LineWidth", 2);
    plot(t, raw, "r-", "LineWidth", 1);
    plot(t, corrected, "b-", "LineWidth", 1);
    xlabel("Time (s)");
    ylabel("Signal");
    title(sensor_name + " — Calibration Before/After");
    legend(["Reference"; "Raw (uncalibrated)"; "Corrected"], "in_upper_left");
    xgrid();

    subplot(2, 1, 2);
    error_before = raw - reference;
    error_after  = corrected - reference;
    plot(t, error_before, "r-", "LineWidth", 1);
    plot(t, error_after,  "b-", "LineWidth", 1);
    plot(t, zeros(1, length(t)), "k-", "LineWidth", 0.5);
    xlabel("Time (s)");
    ylabel("Error");
    title("Calibration Error Reduction");
    legend(["Before cal."; "After cal."; "Zero line"], "in_upper_left");
    xgrid();

endfunction

// -------------------------------------------------------------------------
// export_plot - Save current figure to PNG
// -------------------------------------------------------------------------
function export_plot(fig_id, filename, base_dir)
    if ~exists("base_dir", "local") then base_dir = SENSORBENCH_ROOT + CFG_PLOT_DIR; end
    if ~isdir(base_dir) then mkdir(base_dir); end

    filepath = base_dir + filename + ".png";
    xs2png(fig_id, filepath);

    if CFG_VERBOSE then
        printf("  [PLOT] Exported to: %s\n", filepath);
    end
endfunction
