#!/usr/bin/env tarantool

local cron = require('cron_parser')

local expr, err = cron.parse('0 */15 * * * *')
if not expr then
    print('Error: '..err)
end

local ts = cron.next(expr)

print(os.date('%Y-%m-%d %H:%M:%S', ts))

--local dt = os.date("*t", ts)
--for k, v in pairs(dt) do
--    print(k..' = '..tostring(v))
--end
