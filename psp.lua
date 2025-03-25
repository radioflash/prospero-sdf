local s = io.open('prospero.vm')

local t = {}
t[1] = [[
local function add(x, y) return x + y end
local function sub(x, y) return x - y end
local function mul(x, y) return x * y end
local function neg(x) return -x end
local function square(x) return x * x end
local max = math.max
local min = math.min
local sqrt = math.sqrt

return function(x, y)
]]
local lastline
for l in s:lines() do
    if not l:match("%s*#") then
        local line, op, arg1, arg2 = l:match("([%g]+)%s+([%g]+)%s*([%g]*)%s*([%g]*)")

        -- t[#t+1] = '\tlocal '
        t[#t+1] = '\t'
        t[#t+1] = line
        t[#t+1] = ' = '
        
        if op == 'var-x' then
            t[#t+1] = 'x'
        elseif op == 'var-y' then
            t[#t+1] = 'y'
        elseif op == 'const' then
            t[#t+1] = arg1
        elseif op == 'neg' then
            t[#t+1] = '-'
            t[#t+1] = arg1
        elseif op == 'sub' then
            t[#t+1] = arg1
            t[#t+1] = ' - '
            t[#t+1] = arg2
        elseif op == 'add' then
            t[#t+1] = arg1
            t[#t+1] = ' + '
            t[#t+1] = arg2
        elseif op == 'square' then
            t[#t+1] = arg1
            t[#t+1] = ' * '
            t[#t+1] = arg1
        elseif op == 'mul' then
            t[#t+1] = arg1
            t[#t+1] = ' * '
            t[#t+1] = arg2
        else
            t[#t+1] = op
            t[#t+1] = '('
            t[#t+1] = arg1
            if arg2 ~= '' then
                t[#t+1] = ', '
                t[#t+1] = arg2
            end
            t[#t+1] = ')'
        end
        t[#t+1] = '\n'
        lastline = line
    end
end
t[#t+1] = '\n\treturn '
t[#t+1] = lastline
t[#t+1] = '\n'
t[#t+1] = 'end'

local s = table.concat(t)

local hnd = io.open('prospero.lua', 'wb')
hnd:write(s)
hnd:close()

-- local sdf = loadstring(s)()
local sdf = require'prospero'

local n = 200

local hnd = io.open('prospero.ppm', 'wb')
hnd:write(string.format('P5\n%i\n%i\n255\n', n, n))

for r=1,n do
    for c=1,n do
        local x = -1 + 2 * (c-1)/n
        local y = 1 - 2 * (r-1)/n
        hnd:write(sdf(x, y) < 0 and string.char(0xff) or string.char(0))
    end
end
hnd:close()
-- local n = 1024