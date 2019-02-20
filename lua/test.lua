-- level1.level2.level3[].level4(d).level5
-- . . . . . . . . . . .
function table.removeKey(t, k)
	local i = 0
	local keys, values = {},{}
	for k,v in pairs(t) do
		i = i + 1
		keys[i] = k
		values[i] = v
	end
 
	while i>0 do
		if keys[i] == k then
			table.remove(keys, i)
			table.remove(values, i)
			break
		end
		i = i - 1
	end
 
	local a = {}
	for i = 1,#keys do
		a[keys[i]] = values[i]
	end
 
	return a
end

function isExist(t, key)
	for k,v in pairs(t) do
		if (k == key) then
			return true;
		end
		if (type(v) == "table") then
			return isExist(v, key);
		end
	end
	return false
end

-- split a string
function split(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={}
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                table.insert(t, str)
        end
        return t
end
-- Determine with a Lua table can be treated as an array.
-- Explicitly returns "not an array" for very sparse arrays.
-- Returns:
-- -1   Not an array
-- 0    Empty table
-- >0   Highest index in the array
local function is_array(table)
    local max = 0
    local count = 0
    for k, v in pairs(table) do
        if type(k) == "number" then
            if k > max then max = k end
            count = count + 1
        else
            return -1
        end
    end
    if max > count * 2 then
        return -1
    end

    return max
end 

local function starts_with(str, start)
   return str:sub(1, #start) == start
end

local function ends_with(str, ending)
   return ending == "" or str:sub(-#ending) == ending
end

function getValueAtPathString(t, path)
	local pathSplit = split(path, ".")
	local tab = t
	for k,p in pairs(pathSplit) do
		if (ends_with(p, "[]") and is_array(tab[p])) 
			
		tab = tab[p]
	end
	return tab
end

function getValueAtPath(t, path)
	if (#path == 0) then
		return
	end
	local head = table.remove(path,1)
	if 
end
t = {["foo"] = {["foo"] = "bar"}, ["123"] = 456}
-- t = table.removeKey(t, "foo")
-- print(isExist(t, "foo"))
print(getValueAtPath(t, "foo.foo"))
-- for key,value in pairs(t) do print(key,value) end
