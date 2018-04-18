local ffi = require('ffi')
ffi.cdef[[
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

local cron = ffi.load("ccronexpr.so")

local parse = function(raw_expr)
    local parsed_expr = ffi.new("cron_expr[1]")
    local err = ffi.new("const char*[1]")
    cron.cron_parse_expr(raw_expr, parsed_expr, err)

    if err[0] ~= ffi.NULL then
        return nil, ffi.string(err[0])
    end

    return parsed_expr
end

local next = function(parsed_expr)
    local ts = cron.cron_next(parsed_expr, os.time())
    return tonumber(ts)
end

return {
    parse = parse,
    next = next
}
