-- =============================================================================
-- SENDECOR KITCHEN PLUGIN — SINGLE FILE (no require)
-- Architecture: CFG > modules > runtime > placement > geometry > main
-- =============================================================================

-- =============================================================================
-- 1. CFG
-- =============================================================================
local CFG = {
    -- Core dimensions
    base_depth      = 650,
    wall_depth      = 350,
    run_A_width     = 2915,
    run_B_width     = 1950,
    total_h         = 2400,
    wall_h          = 860,
    toe_kick_h      = 80,
    base_body_h     = 720,

    -- Panel thickness
    panel_thickness = 18,
    back_thickness  = 9,
    door_thickness  = 18,
    side_width_tall = 50,
    side_width_wall = 18,
    side_width_base = 15,

    -- Origin (Run A)
    runA_origin_x   = 0,
    runA_origin_y   = 0,
    runA_origin_z   = 0,

    -- Wall mount height (bottom of wall cabinet above floor)
    wall_mount_z    = 1380,

    -- Shared front face Y reference
    front_y         = 0,

    -- Invariants / debug
    filler_w               = 50,
    show_corner_void_block = true,
    show_runB_void_block   = true,
    void_debug_h           = 80,
    enable_highlight       = false,
}

-- =============================================================================
-- 2. MODULE DEFINITIONS
-- =============================================================================
local MODULES = {
    fridge = {
        id         = "fridge",
        type       = "tall",
        width      = 820,
        depth_key  = "base_depth",
        height_key = "total_h",
        builder    = "tall",
    },
    sink = {
        id         = "sink",
        type       = "base",
        width      = 485,
        depth_key  = "base_depth",
        height_key = "base_body_h",
        builder    = "base",
    },
    drawer = {
        id         = "drawer",
        type       = "base",
        width      = 930,
        depth_key  = "base_depth",
        height_key = "base_body_h",
        builder    = "base",
    },
    corner = {
        id      = "corner",
        type    = "void",
        width   = 680,
        builder = "void",
    },
    wall_2d = {
        id         = "wall_2d",
        type       = "wall",
        width      = 605,
        depth_key  = "wall_depth",
        height_key = "wall_h",
        builder    = "wall",
    },
    tall_mw = {
        id         = "tall_mw",
        type       = "tall",
        width      = 695,
        depth_key  = "base_depth",
        height_key = "total_h",
        builder    = "tall",
    },
}

-- =============================================================================
-- 3. RUNTIME HELPERS
-- =============================================================================
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
        rt.add_error(rep, name .. " invalid size: " .. w .. "x" .. d .. "x" .. h)
        return nil
    end
    local elem, err = rt.create_block(w, d, h, { x, y, z }, name)
    if elem then
        rep.built = rep.built + 1
        return elem
    end
    rt.add_error(rep, name .. " failed: " .. tostring(err))
    return nil
end

function rt.print_report(rep)
    print("[" .. rep.name .. "] built=" .. rep.built .. "/" .. rep.expected
          .. " failed=" .. rep.failed)
    for _, e in ipairs(rep.errors) do
        print("  ERROR: " .. e)
    end
end

-- =============================================================================
-- 4. PLACEMENT ENGINE
-- =============================================================================
local placement = {}

function placement.build_layout(cfg)
    local placed = { runA = {}, runB = {}, wall = {} }

    local front_y   = cfg.front_y
    local x0        = cfg.runA_origin_x
    local z0        = cfg.runA_origin_z
    local current_x = x0

    local runA_sequence = {
        MODULES.fridge,
        MODULES.sink,
        MODULES.drawer,
        MODULES.corner,
    }

    for _, mod in ipairs(runA_sequence) do
        local depth   = (mod.depth_key and cfg[mod.depth_key]) or 0
        local place_y = front_y + depth
        placed.runA[mod.id] = {
            x       = current_x,
            y       = place_y,
            z       = z0,
            width   = mod.width,
            depth   = depth,
            front_y = front_y,
            type    = mod.type,
        }
        current_x = current_x + mod.width
    end

    local corner_rec    = placed.runA["corner"]
    local corner_x      = corner_rec and corner_rec.x or current_x
    local runB_origin_z = z0

    local runB_sequence = {
        MODULES.tall_mw,
    }

    local current_y_b = corner_rec and corner_rec.y or (front_y + cfg.base_depth)

    for _, mod in ipairs(runB_sequence) do
        if mod.type ~= "wall" then
            local depth   = (mod.depth_key and cfg[mod.depth_key]) or 0
            local place_y = current_y_b
            placed.runB[mod.id] = {
                x       = corner_x,
                y       = place_y,
                z       = runB_origin_z,
                width   = mod.width,
                depth   = depth,
                front_y = cfg.front_y,
                type    = mod.type,
            }
            current_y_b = current_y_b + mod.width
        end
    end

    local wall_sequence = {
        { mod = MODULES.wall_2d, ref_id = "sink" },
    }

    local wall_z = cfg.wall_mount_z

    for _, entry in ipairs(wall_sequence) do
        local mod     = entry.mod
        local ref_id  = entry.ref_id
        local ref     = placed.runA[ref_id]
        local wx      = ref and ref.x or 0
        local depth   = (mod.depth_key and cfg[mod.depth_key]) or 0
        local place_y = front_y + depth
        placed.wall[mod.id] = {
            x       = wx,
            y       = place_y,
            z       = wall_z,
            width   = mod.width,
            depth   = depth,
            front_y = front_y,
            type    = mod.type,
        }
    end

    return placed
end

-- =============================================================================
-- 5. GEOMETRY — BASE CABINET (sink-unit pattern, new source)
-- =============================================================================
local base_geom = {}

function base_geom.build(cfg, rec, opts)
    local id       = opts and opts.id or "BASE"
    local rep      = rt.new_report("BASE_" .. id)
    local elements = {}

    local pt = cfg.panel_thickness
    local bt = cfg.back_thickness
    local tk = cfg.toe_kick_h
    local dt = cfg.door_thickness

    local W = rec.width
    local D = rec.depth
    local H = cfg.base_body_h

    local ox, oy, oz = rec.x, rec.y, rec.z

    local side_h  = H - tk
    local inner_w = W - 2 * pt

    local function p(x, y, z, w, d, h, name)
        local e = rt.add_panel(rep, x, y, z, w, d, h, name)
        if e then elements[#elements + 1] = e end
    end

    p(ox,          oy - D,  oz + tk,      pt,      D,  side_h,      id .. "_side_L")
    p(ox + W - pt, oy - D,  oz + tk,      pt,      D,  side_h,      id .. "_side_R")
    p(ox + pt,     oy - D,  oz + tk,      inner_w, D,  pt,          id .. "_bottom")
    p(ox + pt,     oy - bt, oz + tk + pt, inner_w, bt, H - tk - pt, id .. "_back")
    p(ox + pt,     oy - D,  oz,           inner_w, pt, tk,          id .. "_tk_front")
    p(ox + pt,     oy - pt, oz,           inner_w, pt, tk,          id .. "_tk_back")
    p(ox + pt,     oy - D,  oz + H - pt,  inner_w, D,  pt,          id .. "_top_rail")

    local door_y = rec.front_y - dt
    p(ox, door_y, oz + tk, W, dt, H - tk, id .. "_door")

    return rep, elements
end

-- =============================================================================
-- 6. GEOMETRY — TALL CABINET (fridge-unit pattern, new source)
-- =============================================================================
local tall_geom = {}

function tall_geom.build(cfg, rec, opts)
    local id       = opts and opts.id or "TALL"
    local rep      = rt.new_report("TALL_" .. id)
    local elements = {}

    local pt = cfg.panel_thickness
    local bt = cfg.back_thickness
    local sw = cfg.side_width_tall
    local tk = cfg.toe_kick_h
    local dt = cfg.door_thickness

    local W = rec.width
    local D = rec.depth
    local H = cfg.total_h

    local ox, oy, oz = rec.x, rec.y, rec.z

    local inner_w = W - 2 * sw
    local side_h  = H - tk

    local function p(x, y, z, w, d, h, name)
        local e = rt.add_panel(rep, x, y, z, w, d, h, name)
        if e then elements[#elements + 1] = e end
    end

    p(ox,          oy - D,  oz + tk,          sw,      D,  side_h,      id .. "_side_L")
    p(ox + W - sw, oy - D,  oz + tk,          sw,      D,  side_h,      id .. "_side_R")
    p(ox + sw,     oy - D,  oz + tk,          inner_w, D,  pt,          id .. "_bottom")
    p(ox + sw,     oy - bt, oz + tk + pt,     inner_w, bt, H - tk - pt, id .. "_back")
    p(ox + sw,     oy - D,  oz + cfg.wall_h,  inner_w, D,  pt,          id .. "_divider")
    p(ox + sw,     oy - D,  oz,               inner_w, D,  tk,          id .. "_toe_kick")

    local door_y  = rec.front_y - dt
    local lower_h = cfg.wall_h - tk
    local upper_h = H - cfg.wall_h - pt
    p(ox, door_y, oz + tk,              W, dt, lower_h, id .. "_door_lower")
    p(ox, door_y, oz + cfg.wall_h + pt, W, dt, upper_h, id .. "_door_upper")

    return rep, elements
end

-- =============================================================================
-- 7. GEOMETRY — WALL CABINET (flap-overhead pattern, new source)
-- =============================================================================
local wall_geom = {}

function wall_geom.build(cfg, rec, opts)
    local id       = opts and opts.id or "WALL"
    local rep      = rt.new_report("WALL_" .. id)
    local elements = {}

    local pt = cfg.side_width_wall
    local bt = cfg.back_thickness
    local dt = cfg.door_thickness

    local W = rec.width
    local D = rec.depth
    local H = cfg.wall_h

    local ox, oy, oz = rec.x, rec.y, rec.z

    local inner_w = W - 2 * pt
    local back_h  = H - 2 * pt
    local shelf_z = oz + math.floor(H / 2)

    local function p(x, y, z, w, d, h, name)
        local e = rt.add_panel(rep, x, y, z, w, d, h, name)
        if e then elements[#elements + 1] = e end
    end

    p(ox,          oy - D,  oz,          pt,      D,      H,      id .. "_side_L")
    p(ox + W - pt, oy - D,  oz,          pt,      D,      H,      id .. "_side_R")
    p(ox + pt,     oy - D,  oz + H - pt, inner_w, D,      pt,     id .. "_top")
    p(ox + pt,     oy - D,  oz,          inner_w, D,      pt,     id .. "_bottom")
    p(ox + pt,     oy - bt, oz + pt,     inner_w, bt,     back_h, id .. "_back")
    p(ox + pt,     oy - D,  shelf_z,     inner_w, D - bt, pt,     id .. "_shelf")

    local door_y = rec.front_y - dt
    p(ox, door_y, oz, W, dt, H, id .. "_flap_door")

    return rep, elements
end

-- =============================================================================
-- 8. GROUPING
-- =============================================================================
local grouping = {}

function grouping.group_module(name, elements)
    if #elements == 0 then return elements end

    if type(pytha) == "table" and type(pytha.create_group) == "function" then
        local ok, grp = pcall(pytha.create_group, elements, { name = name })
        if ok and grp then
            return { grp }
        end
    end

    return elements
end

-- =============================================================================
-- 9. HIGHLIGHT HELPER (debug mode)
-- =============================================================================
local function highlight_module(cfg, id, rec)
    if not cfg.enable_highlight then return end

    print("[HIGHLIGHT] " .. id
          .. " x=" .. rec.x
          .. " y=" .. rec.y
          .. " z=" .. rec.z
          .. " w=" .. rec.width
          .. " d=" .. rec.depth)

    if type(pytha) == "table" and type(pytha.create_block) == "function" then
        local thin = 5
        pcall(pytha.create_block,
            rec.width, thin, thin,
            { rec.x, rec.front_y - thin, rec.z },
            { name = id .. "_highlight" }
        )
    end
end

-- =============================================================================
-- 10. GLOBAL STATE
-- =============================================================================
GLOBAL_GROUPS    = nil
GLOBAL_PLACEMENT = nil
GLOBAL_HIGHLIGHT = nil

-- =============================================================================
-- 11. GLOBAL SELECTION HELPER
-- =============================================================================
function select_module(id)
    if GLOBAL_GROUPS == nil then
        print("NO GROUPS AVAILABLE")
        return
    end

    local elems = GLOBAL_GROUPS[id]
    if elems == nil then
        print("MODULE NOT FOUND: " .. tostring(id))
        return
    end

    print("SELECTED: " .. id)
    print("  elements: " .. #elems)

    -- Delete previous highlight if API available
    if GLOBAL_HIGHLIGHT ~= nil then
        if type(pytha) == "table" and type(pytha.delete_element) == "function" then
            pcall(pytha.delete_element, GLOBAL_HIGHLIGHT)
        end
        GLOBAL_HIGHLIGHT = nil
    end

    -- Re-highlight: look up placement record across all runs
    local rec = nil
    if GLOBAL_PLACEMENT then
        rec = GLOBAL_PLACEMENT.runA[id]
              or GLOBAL_PLACEMENT.runB[id]
              or GLOBAL_PLACEMENT.wall[id]
    end

    if rec then
        print("[HIGHLIGHT] " .. id
              .. " x=" .. rec.x
              .. " y=" .. rec.y
              .. " z=" .. rec.z
              .. " w=" .. rec.width
              .. " d=" .. rec.depth)

        if type(pytha) == "table" and type(pytha.create_block) == "function" then
            local thin = 5
            local ok, elem = pcall(pytha.create_block,
                rec.width, thin, thin,
                { rec.x, rec.front_y - thin, rec.z },
                { name = id .. "_select_highlight" }
            )
            -- Store new highlight element for future cleanup
            if ok and elem then
                GLOBAL_HIGHLIGHT = elem
            end
        end
    else
        print("  [HIGHLIGHT] no placement record found for: " .. id)
    end
end

-- =============================================================================
-- 12. MAIN
-- =============================================================================
function main()
    -- Step 1: placement
    local placed = placement.build_layout(CFG)

    -- Expose placement globally for select_module reuse
    GLOBAL_PLACEMENT = placed

    local reports = {}
    local grouped = {}

    -- Step 2 & 3: geometry dispatch + collect + group — Run A
    for id, rec in pairs(placed.runA) do
        local mod = MODULES[id]
        if mod then
            local t = mod.type
            if t == "base" then
                local rep, elems = base_geom.build(CFG, rec, { id = id })
                reports[#reports + 1] = rep
                grouped[id] = grouping.group_module(id, elems)
                highlight_module(CFG, id, rec)

            elseif t == "tall" then
                local rep, elems = tall_geom.build(CFG, rec, { id = id })
                reports[#reports + 1] = rep
                grouped[id] = grouping.group_module(id, elems)
                highlight_module(CFG, id, rec)

            elseif t == "void" and CFG.show_corner_void_block then
                local e = rt.create_block(
                    rec.width, CFG.void_debug_h, CFG.void_debug_h,
                    { rec.x, rec.y, rec.z },
                    id .. "_void"
                )
                grouped[id] = e and { e } or {}
            end
        end
    end

    -- Run B
    for id, rec in pairs(placed.runB) do
        local mod = MODULES[id]
        if mod then
            local t = mod.type
            if t == "tall" then
                local rep, elems = tall_geom.build(CFG, rec, { id = id })
                reports[#reports + 1] = rep
                grouped[id] = grouping.group_module(id, elems)
                highlight_module(CFG, id, rec)

            elseif t == "base" then
                local rep, elems = base_geom.build(CFG, rec, { id = id })
                reports[#reports + 1] = rep
                grouped[id] = grouping.group_module(id, elems)
                highlight_module(CFG, id, rec)
            end
        end
    end

    -- Wall modules
    for id, rec in pairs(placed.wall) do
        local mod = MODULES[id]
        if mod then
            local rep, elems = wall_geom.build(CFG, rec, { id = id })
            reports[#reports + 1] = rep
            grouped[id] = grouping.group_module(id, elems)
            highlight_module(CFG, id, rec)
        end
    end

    -- Expose grouped table globally
    GLOBAL_GROUPS = grouped

    -- Summary
    local total_exp, total_blt, total_fail = 0, 0, 0
    for _, rep in ipairs(reports) do
        rt.print_report(rep)
        total_exp  = total_exp  + rep.expected
        total_blt  = total_blt  + rep.built
        total_fail = total_fail + rep.failed
    end
    print("=== TOTAL: built=" .. total_blt .. "/" .. total_exp
          .. " failed=" .. total_fail .. " ===")

    print("🚀🚀🚀 TASK COMPLETED 🚀🚀🚀")
    print("READY FOR GPT REVIEW")
end
