# Cron Parser Lua Wrapper

cron-parser is a Lua wrapper of ccronexpr C library. It parses a cron-format schedule and calculates the nearest
event date.

# Installation

````
tarantoolctl rocks install cron-parser
````

# Example

````
local cron = require('cron')

local expr, err = cron.parse('0 */15 * * * *')
if not expr then
    print('Error: '..err)
end

local ts = cron.next(expr)

print(os.date('%Y-%m-%d %H:%M:%S', ts))
````

# References

ccronexpr library: https://github.com/staticlibs/ccronexpr
