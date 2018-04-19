package = 'cron-parser'
version = 'scm-1'
source  = {
    url = 'git://github.com/tarantool/cron-parser.git',
    branch = 'master',
}
description = {
    summary  = 'Tarantool cron expression parser',
    homepage = 'https://github.com/tarantool/cron-parser',
    license  = 'Apache',
}
dependencies = {
    'tarantool',
    'lua >= 5.1',
}
build = {
    type = 'builtin',
    modules = {
        ['cron.ccronexpr'] = {
            sources = {'ccronexpr/ccronexpr.c'},
            incdirs = {'ccronexpr'},
        },
        ['cron.parser'] = 'cron-parser.lua',
    }
}
-- vim: syntax=lua
