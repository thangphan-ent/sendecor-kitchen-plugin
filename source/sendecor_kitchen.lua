-- =============================================================================
-- SENDECOR KITCHEN PLUGIN — SINGLE FILE
-- =============================================================================

-- =============================================================================
-- CFG (Security Layer V1 included)
-- =============================================================================
local CFG = {
    base_depth = 650,
    wall_depth = 350,
    run_A_width = 2915,
    run_B_width = 1950,
    total_h = 2400,
    wall_h = 860,
    toe_kick_h = 80,
    base_body_h = 720,

    panel_thickness = 18,
    back_thickness = 9,
    door_thickness = 18,

    debug_mode = true,
    max_modules_total = 20,
    max_dimension_mm = 5000
}

-- =============================================================================
-- RUNTIME HELPERS
-- =============================================================================
local rt = {}

function rt.debug_print(cfg, msg)
    if cfg and cfg.debug_mode then
        print(msg)
    end
end

function rt.is_valid_dimension(cfg, v)
    return v > 0 and v <= cfg.max_dimension_mm
end

function rt.create_block(w, d, h, pos, name)
    if not rt.is_valid_dimension(CFG, w)
    or not rt.is_valid_dimension(CFG, d)
    or not rt.is_valid_dimension(CFG, h) then
        print("INVALID DIMENSION: "..name)
        return nil
    end

    if pytha and pytha.create_block then
        return pytha.create_block(w, d, h, pos, name)
    end
end

-- =============================================================================
-- SIMPLE TEST BUILD
-- =============================================================================
function main()

    local modules_count = 1
    if modules_count > CFG.max_modules_total then
        print("ABORT: too many modules")
        return
    end

    rt.debug_print(CFG, "RUN MAIN")

    -- simple test geometry
    rt.create_block(600, 600, 720, {0,0,0}, "BASE_TEST")

    print("PLUGIN RUN OK")
end

-- =============================================================================
-- ENTRY POINTS (MATCH config.xml)
-- =============================================================================
function main_run()
    return main()
end

function edit_cabinet(...)
    print("edit_cabinet called")
end
