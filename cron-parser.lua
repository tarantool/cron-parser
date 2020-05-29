local ffi = require('ffi')

ffi.cdef[[
typedef long     time_t;
typedef struct {
    uint8_t seconds[8];
    uint8_t minutes[8];
    uint8_t hours[3];
    uint8_t days_of_week[1];
    uint8_t days_of_month[4];
    uint8_t months[2];
} cron_expr;
void cron_parse_expr(const char* expression, cron_expr* target, const char** error);
time_t cron_next(cron_expr* expr, time_t date);
]]

--local ccronexpr = package.search('cron.ccronexpr')
local ccronexpr = package.searchpath('cron.ccronexpr',package.cpath)
local cron = ffi.load(ccronexpr)

local function parse(raw_expr)
    local parsed_expr = ffi.new("cron_expr[1]")

    local err = ffi.new("const char*[1]")
    cron.cron_parse_expr(raw_expr, parsed_expr, err)

    if err[0] ~= ffi.NULL then
        return nil, ffi.string(err[0])
    end

    local lua_parsed_expr = {
        seconds = {},
        minutes = {},
        hours = {},
        days_of_week = nil,
        days_of_month = {},
        months = {}
    }

    for i = 0,7 do
        lua_parsed_expr.seconds[i + 1] = parsed_expr[0].seconds[i]
        lua_parsed_expr.minutes[i + 1] = parsed_expr[0].minutes[i]
    end

    for i = 0,2 do
        lua_parsed_expr.hours[i + 1] = parsed_expr[0].hours[i]
    end

    lua_parsed_expr.days_of_week = parsed_expr[0].days_of_week[0]

    for i = 0,3 do
        lua_parsed_expr.days_of_month[i + 1] = parsed_expr[0].days_of_month[i]
    end

    for i = 0,1 do
        lua_parsed_expr.months[i + 1] = parsed_expr[0].months[i]
    end

    return lua_parsed_expr
end

local function next(lua_parsed_expr, base_time)
    local parsed_expr = ffi.new('cron_expr[1]')

    for i = 0,7 do
        parsed_expr[0].seconds[i] = lua_parsed_expr.seconds[i + 1]
        parsed_expr[0].minutes[i] = lua_parsed_expr.minutes[i + 1]
    end

    for i = 0,2 do
        parsed_expr[0].hours[i] = lua_parsed_expr.hours[i + 1]
    end

    parsed_expr[0].days_of_week[0] = lua_parsed_expr.days_of_week

    for i = 0,3 do
        parsed_expr[0].days_of_month[i] = lua_parsed_expr.days_of_month[i + 1]
    end

    for i = 0,1 do
        parsed_expr[0].months[i] = lua_parsed_expr.months[i + 1]
    end

    local v_time = base_time or os.time()

    local ts = cron.cron_next(parsed_expr, v_time)
    return tonumber(ts)
end

return {
    parse = parse,
    next = next
}
