// ============================================================================
// SensorBench-Scilab — Data Logger Module
// ============================================================================
// Writes test data to CSV files with timestamped filenames.
// Also provides functions to log events and messages.
// ============================================================================

// -------------------------------------------------------------------------
// log_data_csv - Write time-series data to a CSV file
// -------------------------------------------------------------------------
// Inputs:
//   t             : 1xN time vector
//   ideal_signal  : 1xN ideal (expected) signal
//   measured_signal: 1xN measured (possibly corrupted) signal
//   sensor_name   : string identifier
//   test_name     : string identifier for the test
//   base_dir      : output directory (default: CFG_LOG_DIR)
// Output:
//   filepath      : full path to the written file
// -------------------------------------------------------------------------
function filepath = log_data_csv(t, ideal_signal, measured_signal, sensor_name, test_name, base_dir)
    if ~exists("base_dir", "local") then base_dir = SENSORBENCH_ROOT + CFG_LOG_DIR; end

    // Ensure directory exists
    if ~isdir(base_dir) then mkdir(base_dir); end

    // Generate filename with timestamp
    timestamp = msprintf("%04d%02d%02d_%02d%02d%02d", ..
        datevec(now()));
    filename = sensor_name + "_" + test_name + "_" + timestamp + ".csv";
    filepath = base_dir + filename;

    // Write CSV
    N = length(t);
    fd = mopen(filepath, "w");
    mfprintf(fd, "Time_s,Ideal,Measured,Error\n");
    for i = 1:N
        err = measured_signal(i) - ideal_signal(i);
        mfprintf(fd, "%.4f,%.6f,%.6f,%.6f\n", t(i), ideal_signal(i), measured_signal(i), err);
    end
    mclose(fd);

    if CFG_VERBOSE then
        printf("  [LOG] Data saved to: %s\n", filepath);
    end
endfunction

// -------------------------------------------------------------------------
// log_event - Append an event line to a session log file
// -------------------------------------------------------------------------
function log_event(message, logfile)
    if ~exists("logfile", "local") then
        logfile = SENSORBENCH_ROOT + CFG_LOG_DIR + "session_log.txt";
    end

    timestamp = msprintf("%04d-%02d-%02d %02d:%02d:%02d", ..
        datevec(now()));

    fd = mopen(logfile, "a");
    mfprintf(fd, "[%s] %s\n", timestamp, message);
    mclose(fd);
endfunction

// -------------------------------------------------------------------------
// datevec - Returns [Y M D h m s] from datenum value
// -------------------------------------------------------------------------
// Scilab helper to get date components
// -------------------------------------------------------------------------
function dv = datevec(dn)
    // Use Scilab's clock() function for current date/time
    dv = clock();
    // clock returns [year month day hour minute seconds]
    // Round seconds to integer
    dv(6) = floor(dv(6));
endfunction

// -------------------------------------------------------------------------
// now - Returns current datenum (placeholder for timestamp use)
// -------------------------------------------------------------------------
function dn = now()
    dn = datenum();
endfunction
