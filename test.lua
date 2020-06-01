#!/usr/bin/env tarantool

local cron  = require('cron')
local cjson = require("cjson")
local expr, err = cron.parse('0 0 1 * * *')
if not expr then
    print('Error: '..err)
end

local ts = cron.next(expr)
print("-> cron.next(exp)")
print(os.date('%Y-%m-%d %H:%M:%S', ts))

local now = os.time()+3600
ts = cron.next(expr, now)

print("")
print("-> cron.next(exp, base_time)")
print(os.date('%Y-%m-%d %H:%M:%S', ts))
--local dt = os.date("*t", ts)
--for k, v in pairs(dt) do
--    print(k..' = '..tostring(v))
--end

local now = os.time()
local ts = cron.next(expr, now)
print("----",cjson.encode(expr))
print(os.date('%Y-%m-%d %H:%M:%S', ts))

ts = cron.next(expr, ts)

print(os.date('%Y-%m-%d %H:%M:%S', ts))

ts = cron.next(expr, ts)


print(os.date('%Y-%m-%d %H:%M:%S', ts))