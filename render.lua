local sdf = require 'prospero'

local xs = select('#', ...) > 0 and tonumber(select(1, ...)) or 300
local ys = select('#', ...) > 1 and tonumber(select(2, ...)) or xs

local hnd = io.open('prospero.ppm', 'wb')
hnd:write(string.format('P5\n%i\n%i\n255\n', xs, ys))

local data = {}
for y=-1,1,2/ys do
    for x=-1,1,2/xs do
        data[#data+1] = sdf(x, -y)
    end
end
for i=1,#data do
    hnd:write(data[i] < 0 and string.char(0) or string.char(0xff))
end
hnd:close()