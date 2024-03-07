net_box = require('net.box')
local conn = net_box.connect('127.0.0.1:4401')
local log = require('log')
conn:watch('config.storage:/myapp/config/all', function(key, value)
    log.info("Configuration stored by the '/myapp/config/all' key is changed")
end)
