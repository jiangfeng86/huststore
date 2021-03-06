local tid = 1
local threads = {}
local addrs = {}

function get_loop(path)
    local f = io.open(path, "r")
    if f then
        local loop = f:read("*number")
        f:close()
        return loop
    end
    return 0
end

local loop = get_loop("$var_loop")
local status_file = string.format("loop.%d.$var_status_file", loop)

wrk.method = "$var_method"
wrk.headers["Content-Type"] = "text/plain"
wrk.headers["Authorization"] = "Basic $var_auth"

function split(s, delimiter)
    result = {}
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end

function file_exists(file)
    local f = io.open(file, "rb")
    if f then f:close() end
    return f ~= nil
end

function set_loop(path, loop)
    local f = io.open(path, "w")
    if f then
        f:write(tostring(loop))
        f:close()
    end
end

function get_hosts(path)
    hosts = {}
    if not file_exists(path) then
        return hosts
    end
    for line in io.lines(path) do
        if not (line == "") then
            host = split(split(line, "\r")[1], "\n")[1]
            table.insert(hosts, host)
        end
    end
    return hosts
end

function get_key(loop, id, requests)
    return string.format("benchmark_key_%d_%d_%d", loop, id, requests)
end

function get_hash_tb(id)
    return string.format("benchmark_hash_%d", id)
end

function get_sset_tb(id)
    return string.format("benchmark_sset_%d", id)
end

function get_zset_tb(id)
    return string.format("benchmark_zset_%d", id)
end

function get_queue(id)
    return string.format("benchmark_queue_%d", id)
end
