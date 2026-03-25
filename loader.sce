// ============================================================================
// SensorBench-Scilab — Module Loader
// ============================================================================
// Loads all configuration, sensor models, and modules into the Scilab workspace.
// Run this script before using any SensorBench functions.
// ============================================================================

disp("=============================================================");
disp("  SensorBench-Scilab — Loading modules...");
disp("=============================================================");

// Determine project root (directory containing this loader)
SENSORBENCH_ROOT = get_absolute_file_path("loader.sce");

// Create output directories if they do not exist
function ensure_dir(dirpath)
    if ~isdir(dirpath) then
        mkdir(dirpath);
    end
endfunction

ensure_dir(SENSORBENCH_ROOT + "output");
ensure_dir(SENSORBENCH_ROOT + "output/logs");
ensure_dir(SENSORBENCH_ROOT + "output/plots");
ensure_dir(SENSORBENCH_ROOT + "output/reports");

// --- Load Configuration ---
disp("  [1/4] Loading configuration...");
exec(SENSORBENCH_ROOT + "config/default_config.sce",   -1);
exec(SENSORBENCH_ROOT + "config/sensor_params.sce",     -1);
exec(SENSORBENCH_ROOT + "config/test_profiles.sce",     -1);

// --- Load Sensor Models ---
disp("  [2/4] Loading sensor models...");
exec(SENSORBENCH_ROOT + "models/sensor_temperature.sce", -1);
exec(SENSORBENCH_ROOT + "models/sensor_pressure.sce",    -1);
exec(SENSORBENCH_ROOT + "models/sensor_humidity.sce",     -1);
exec(SENSORBENCH_ROOT + "models/sensor_proximity.sce",    -1);
exec(SENSORBENCH_ROOT + "models/sensor_vibration.sce",    -1);
exec(SENSORBENCH_ROOT + "models/sensor_analog.sce",       -1);
exec(SENSORBENCH_ROOT + "models/sensor_digital.sce",      -1);

// --- Load Core Modules ---
disp("  [3/4] Loading core modules...");
exec(SENSORBENCH_ROOT + "modules/fault_injection.sce",   -1);
exec(SENSORBENCH_ROOT + "modules/validation.sce",        -1);
exec(SENSORBENCH_ROOT + "modules/calibration.sce",       -1);
exec(SENSORBENCH_ROOT + "modules/data_logger.sce",       -1);
exec(SENSORBENCH_ROOT + "modules/visualization.sce",     -1);
exec(SENSORBENCH_ROOT + "modules/report_generator.sce",  -1);
exec(SENSORBENCH_ROOT + "modules/digital_twin.sce",      -1);
exec(SENSORBENCH_ROOT + "modules/test_controller.sce",   -1);

// --- Done ---
disp("  [4/4] All modules loaded successfully.");
disp("=============================================================");
disp("  SensorBench-Scilab is ready. Type ''sensorbench_menu()''");
disp("  or run main.sce to start the dashboard.");
disp("=============================================================");
