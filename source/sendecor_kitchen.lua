-- ============================================================
-- SENDECOR KITCHEN PLUGIN
-- Single-file bundle for PYTHA execution
-- Architecture: CFG > modules > runtime > placement > geometry > main
-- ============================================================

-- ============================================================
-- SECTION 1: CFG
-- ============================================================
local CFG = {
    base_depth      = 650,
    wall_depth      = 350,
    run_B_width     = 1950,
    total_h         = 2400,
    wall_h          = 860,
    toe_kick_h      = 80,
    base_body_h     = 720,

    panel_thickness = 18,
    back_thickness  = 9,
    door_thickness  = 18,
    side_width_tall = 50,
    side_width_wall = 18,
    side_width_base = 15,

    runA_origin_x   = 0,
    runA_origin_y   = 0,
    runA_origin_z   = 0,

    filler_w                = 50,
    show_corner_void_block  = true,
    show_runB_void_block    = true,
    void_debug_h            = 80,
}

-- ============================================================
-- SECTION 2: MODULES
-- ============================================================
local MODULES = {
    fridge = {
        id = "fridge", type = "tall", width = 820,
        depth_key = "base_depth", height_key = "total_h", builder = "tall",
    },
    sink = {
        id = "sink", type = "base", width = 485,
        depth_key = "base_depth", height_key = "base_body_h", builder = "base",
    },
    drawer = {
        id = "drawer", type = "base", width = 930,
        depth_key = "base_depth", height_key = "base_body_h", builder = "base",
    },
    corner = {
        id = "corner", type = "void", width = 680, builder = "void",
    },
    wall_2d = {
        id = "wall_2d", type = "wall", width = 605,
        depth_key = "wall_depth", height_key = "wall_h", builder = "wall",
    },
    tall_mw = {
        id = "tall_mw", type = "tall", width = 695,
        depth_key = "base_depth", height_key = "total_h", builder = "tall",
    },
}

-- ============================================================
-- SECTION 3: RUNTIME
-- ============================================================
local rt = {}

function rt.create_block(w, d, h, pos, name)
    if type(pytha) ~= "table" or type(pytha.create_block) ~= "function" then
        return nil, "pytha.create_block unavailable"
    end
    local ok, elem = pcall(pytha.create_block, w, d, h, pos, { name = name })
    if ok and elem then return elem, nil end
    ok, elem = pcall(pytha.create_block, w, d, h, pos, name)
    if ok and elem then return elem, nil end
    return nil, "create_block failed"
end

function rt.new_report(name)
    return { name = name, expected = 0, built = 0, failed = 0, errors = {} }
end

function rt.add_error(rep, msg)
    rep.failed = rep.failed + 1
    rep.errors[#rep.errors + 1] = msg
end

function rt.add_panel(rep, x, y, z, w, d, h, name)
    rep.expected = rep.expected + 1
    if w <= 0 or d <= 0 or h <= 0 then
        rt.add_error(rep, name .. " invalid size")
        return nil
    end
    local elem, err = rt.create_block(w, d, h, {x, y, z}, name)
    if elem then
        rep.built = rep.built + 1
        return elem
    end
    rt.add_error(rep, name .. " create failed: " .. tostring(err))
    return nil
end

function rt.print_report(rep)
    print("[" .. rep.name .. "] expected=" .. rep.expected
        .. " built=" .. rep.built .. " failed=" .. rep.failed)
    for _, e in ipairs(rep.errors) do
        print("  ERR: " .. e)
    end
end

-- ============================================================
-- SECTION 4: PLACEMENT
-- ============================================================
local function build_layout(cfg)
    local placed = { runA = {}, runB = {} }

    local current_x = cfg.runA_origin_x
    local y0 = cfg.runA_origin_y
    local z0 = cfg.runA_origin_z

    local runA_sequence = {
        MODULES.fridge,
        MODULES.sink,
        MODULES.drawer,
        MODULES.corner,
    }

    for _, mod in ipairs(runA_sequence) do
        placed.runA[mod.id] = {
            x = current_x,
            y = y0,
            z = z0,
            width = mod.width,
        }
        current_x = current_x + mod.width
    end

    -- Run B: anchored from corner, placeholder
    -- TODO: implement Run B accumulation along -Y

    return placed
end

-- ============================================================
-- SECTION 5: GEOMETRY — BASE
-- ============================================================
local function build_base(cfg, pl, opts)
    local rep = rt.new_report("BASE_" .. tostring(opts and opts.id or "?"))
    local x   = pl.x
    local y   = pl.y
    local z   = pl.z
    local w   = pl.width
    local d   = cfg.base_depth
    local h   = cfg.base_body_h
    local pt  = cfg.panel_thickness
    local bt  = cfg.back_thickness
    local tk  = cfg.toe_kick_h

    -- Toe kick front rail
    rt.add_panel(rep, x, y - d, z, w, pt, tk, "tk_front")
    -- Toe kick back rail
    rt.add_panel(rep, x, y - pt, z, w, pt, tk, "tk_back")
    -- Left side
    rt.add_panel(rep, x, y - d, z + tk, pt, d, h - tk, "side_L")
    -- Right side
    rt.add_panel(rep, x + w - pt, y - d, z + tk, pt, d, h - tk, "side_R")
    -- Bottom panel (full depth)
    rt.add_panel(rep, x + pt, y - d, z + tk, w - 2*pt, d, pt, "bottom")
    -- Back panel
    rt.add_panel(rep, x + pt, y - bt, z + tk, w - 2*pt, bt, h - tk - pt, "back")
    -- Top rail
    rt.add_panel(rep, x + pt, y - d, z + h - pt, w - 2*pt, d, pt, "top_rail")

    rt.print_report(rep)
    return rep
end

-- ============================================================
-- SECTION 6: GEOMETRY — TALL
-- ============================================================
local function build_tall(cfg, pl, opts)
    local rep = rt.new_report("TALL_" .. tostring(opts and opts.id or "?"))
    local x   = pl.x
    local y   = pl.y
    local z   = pl.z
    local w   = pl.width
    local d   = cfg.base_depth
    local h   = cfg.total_h
    local pt  = cfg.panel_thickness
    local bt  = cfg.back_thickness
    local sw  = cfg.side_width_tall
    local tk  = cfg.toe_kick_h

    -- Left side channel
    rt.add_panel(rep, x, y - d, z, sw, d, h, "side_L")
    -- Right side channel
    rt.add_panel(rep, x + w - sw, y - d, z, sw, d, h, "side_R")
    -- Bottom panel
    rt.add_panel(rep, x + sw, y - d, z + tk, w - 2*sw, d, pt, "bottom")
    -- Back panel
    rt.add_panel(rep, x + sw, y - bt, z, w - 2*sw, bt, h, "back")
    -- Upper divider shelf
    local shelf_z = h - 600
    rt.add_panel(rep, x + sw, y - d, z + shelf_z, w - 2*sw, d, pt, "upper_shelf")
    -- Toe kick face
    rt.add_panel(rep, x + sw, y - d, z, w - 2*sw, pt, tk, "toe_kick")

    rt.print_report(rep)
    return rep
end

-- ============================================================
-- SECTION 7: GEOMETRY — WALL
-- ============================================================
local function build_wall(cfg, pl, opts)
    local rep = rt.new_report("WALL_" .. tostring(opts and opts.id or "?"))
    local x   = pl.x
    local y   = pl.y
    local z   = pl.z
    local w   = pl.width
    local d   = cfg.wall_depth
    local h   = cfg.wall_h
    local pt  = cfg.panel_thickness
    local bt  = cfg.back_thickness

    -- Left side
    rt.add_panel(rep, x, y - d, z, pt, d, h, "side_L")
    -- Right side
    rt.add_panel(rep, x + w - pt, y - d, z, pt, d, h, "side_R")
    -- Top panel
    rt.add_panel(rep, x + pt, y - d, z + h - pt, w - 2*pt, d, pt, "top")
    -- Bottom panel
    rt.add_panel(rep, x + pt, y - d, z, w - 2*pt, d, pt, "bottom")
    -- Back panel
    rt.add_panel(rep, x + pt, y - bt, z + pt, w - 2*pt, bt, h - 2*pt, "back")
    -- Internal shelf (mid)
    local shelf_z = z + math.floor(h / 2)
    rt.add_panel(rep, x + pt, y - d, shelf_z, w - 2*pt, d, pt, "shelf")
    -- Proud flap door
    rt.add_panel(rep, x + pt, y - d - cfg.door_thickness, z + pt,
        w - 2*pt, cfg.door_thickness, h - 2*pt, "flap_door")

    rt.print_report(rep)
    return rep
end

-- ============================================================
-- SECTION 8: GROUPING (stub)
-- ============================================================
local function group_module(name, elements)
    return elements
end

-- ============================================================
-- SECTION 9: MAIN DISPATCH
-- ============================================================
local BUILDERS = {
    base = build_base,
    tall = build_tall,
    wall = build_wall,
}

function main()
    print("SENDECOR KITCHEN — INIT")

    local placed = build_layout(CFG)

    -- Run A dispatch
    local runA_sequence = {
        MODULES.fridge,
        MODULES.sink,
        MODULES.drawer,
    }

    for _, mod in ipairs(runA_sequence) do
        local pl  = placed.runA[mod.id]
        local fn  = BUILDERS[mod.builder]
        if pl and fn then
            fn(CFG, pl, mod)
        else
            print("SKIP: " .. mod.id .. " (type=" .. mod.type .. ")")
        end
    end

    print("SENDECOR KITCHEN — DONE")
end
