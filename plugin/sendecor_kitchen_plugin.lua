-- =============================================================================
-- SENDECOR KITCHEN PLUGIN — SINGLE FILE
-- RECOVERY STEP 1 — Minimal Foundation (corrected)
-- =============================================================================

-- =============================================================================
-- CFG
-- =============================================================================
local CFG = {
    base_depth        = 650,
    wall_depth        = 350,
    run_A_width       = 2915,
    run_B_width       = 1950,
    total_h           = 2400,
    wall_h            = 860,
    toe_kick_h        = 80,
    base_body_h       = 720,
    panel_thickness   = 18,
    back_thickness    = 9,
    door_thickness    = 18,
    debug_mode        = true,
    max_modules_total = 20,
    max_dimension_mm  = 5000,
    origin_x          = 0,
    origin_y          = 0,
    origin_z          = 0,
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
    return type(v) == "number" and v > 0 and v <= cfg.max_dimension_mm
end

function rt.validate_module(cfg, mod)
    if type(mod) ~= "table" then
        rt.debug_print(cfg, "SKIP: module is not a table")
        return false
    end
    if not mod.name or mod.name == "" then
        rt.debug_print(cfg, "SKIP: module missing name")
        return false
    end
    if not mod.kind or mod.kind == "" then
        rt.debug_print(cfg, "SKIP: module [" .. tostring(mod.name) .. "] missing kind")
        return false
    end
    if not (mod.width and mod.width > 0) then
        rt.debug_print(cfg, "SKIP: module [" .. tostring(mod.name) .. "] invalid width")
        return false
    end
    if not (mod.depth and mod.depth > 0) then
        rt.debug_print(cfg, "SKIP: module [" .. tostring(mod.name) .. "] invalid depth")
        return false
    end
    if not (mod.height and mod.height > 0) then
        rt.debug_print(cfg, "SKIP: module [" .. tostring(mod.name) .. "] invalid height")
        return false
    end
    return true
end

function rt.create_block(w, d, h, pos, name)
    if not rt.is_valid_dimension(CFG, w) or
       not rt.is_valid_dimension(CFG, d) or
       not rt.is_valid_dimension(CFG, h) then
        print("INVALID DIMENSION: " .. tostring(name))
        return nil
    end
    if pytha and pytha.create_block then
        return pytha.create_block(w, d, h, pos, name)
    end
end

-- =============================================================================
-- MODULE DEFINITIONS
-- =============================================================================
-- Each module is a plain table.
-- Fields: name, kind, width, depth, height, run
-- kind: "base" | "wall" | "tall" | "void"
-- run:  "A" | "B"

local MODULES = {
    { name="fridge", kind="tall", width=820, depth=650, height=2400, run="A" },
    { name="drawer", kind="base", width=600, depth=650, height=720,  run="A" },
    { name="sink",   kind="base", width=485, depth=650, height=720,  run="A" },
    { name="corner", kind="void", width=680, depth=650, height=720,  run="A" },
}

-- =============================================================================
-- PLACEMENT ENGINE — RUN A ONLY (Step 1 scope)
-- =============================================================================
-- Returns a placement record table.
-- Each record: { name, kind, run, x, y, z, width, depth, height }
-- Accumulates left to right using current_x.
-- Invalid modules are skipped safely.

local function build_placement_runA(cfg, modules)
    local placed    = {}
    local current_x = cfg.origin_x
    local y0        = cfg.origin_y
    local z0        = cfg.origin_z

    for _, mod in ipairs(modules) do
        if mod.run == "A" then
            if rt.validate_module(cfg, mod) then
                placed[#placed + 1] = {
                    name   = mod.name,
                    kind   = mod.kind,
                    run    = mod.run,
                    x      = current_x,
                    y      = y0,
                    z      = z0,
                    width  = mod.width,
                    depth  = mod.depth,
                    height = mod.height,
                }
                current_x = current_x + mod.width
            end
        end
    end

    return placed
end

-- =============================================================================
-- PLACEMENT REPORT
-- =============================================================================
local function report_placement(cfg, placed)
    rt.debug_print(cfg, "--- PLACEMENT REPORT ---")
    for _, p in ipairs(placed) do
        rt.debug_print(cfg,
            string.format("  [%s] kind=%s run=%s x=%d y=%d z=%d w=%d d=%d h=%d",
                p.name, p.kind, p.run, p.x, p.y, p.z, p.width, p.depth, p.height)
        )
    end
    rt.debug_print(cfg, string.format("  MODULES PLACED: %d", #placed))
end

-- =============================================================================
-- MAIN
-- =============================================================================
function main()
    rt.debug_print(CFG, "=== SENDECOR KITCHEN — RECOVERY STEP 1 ===")

    -- Safety guard
    if #MODULES > CFG.max_modules_total then
        print("ABORT: module count exceeds max_modules_total")
        return
    end

    -- Build Run A placement
    local placed = build_placement_runA(CFG, MODULES)

    -- Report placement
    report_placement(CFG, placed)

    -- Geometry stub: one test block per non-void placed module
    -- Real geometry builders come in a future recovery step
    local built_block_count = 0

    for _, p in ipairs(placed) do
        if p.kind ~= "void" then
            rt.create_block(
                p.width,
                p.depth,
                p.height,
                { p.x, p.y, p.z },
                "STUB_" .. p.name
            )
            built_block_count = built_block_count + 1
        end
    end

    rt.debug_print(CFG, string.format("MODULES PLACED : %d", #placed))
    rt.debug_print(CFG, string.format("BLOCKS BUILT   : %d", built_block_count))
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
