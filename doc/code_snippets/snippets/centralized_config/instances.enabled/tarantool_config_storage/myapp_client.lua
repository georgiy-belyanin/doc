function put_config()
    local fio = require('fio')
    local cluster_config_handle = fio.open('../../source.yaml')
    local cluster_config = cluster_config_handle:read()

    -- Connect to a config.storage and put the config.
    local storage_client = config.storage_client:connect({
        '127.0.0.1:4401',
        '127.0.0.1:4402',
        '127.0.0.1:4403',
    })
    local response = storage_client:put('/myapp/config/all', cluster_config)

    -- Put a config to a configured config.storage cluster.
    response = config.storage_client:put('/myapp/config/all', cluster_config)

    cluster_config_handle:close()

    return response
end

function get_config_by_path()
    -- Connect to a config.storage and get /myapp/config/all.
    local storage_client = config.storage_client:connect({
        '127.0.0.1:4401',
        '127.0.0.1:4402',
        '127.0.0.1:4403',
    })
    local response = storage_client:get('/myapp/config/all')

    -- Get /myapp/config/all from a configured config.storage cluster.
    response = config.storage_client:get('/myapp/config/all')
    return response
end

function get_config_by_prefix()
    -- Connect to a config.storage and get values with a /myapp/ prefix.
    local storage_client = config.storage_client:connect({
        '127.0.0.1:4401',
        '127.0.0.1:4402',
        '127.0.0.1:4403',
    })
    local response = storage_client:get('/myapp/')

    -- Get values prefixed /myapp/ from a configured config.storage cluster.
    response = config.storage_client:get('/myapp/')
    return response
end

function make_txn_request()
    -- Connect to a config.storage and execute an atomic request.
    local storage_client = config.storage_client:connect({
        '127.0.0.1:4401',
        '127.0.0.1:4402',
        '127.0.0.1:4403',
    })
    local response = storage_client:txn({
        predicates = { { 'value', '==', 'v0', '/myapp/config/all' } },
        on_success = { { 'put', '/myapp/config/all', 'v1' } },
        on_failure = { { 'get', '/myapp/config/all' } }
    })

    -- Execute an atomic request on a configured config.storage cluster.
    response = config.storage_client:txn({
        predicates = { { 'value', '==', 'v0', '/myapp/config/all' } },
        on_success = { { 'put', '/myapp/config/all', 'v1' } },
        on_failure = { { 'get', '/myapp/config/all' } }
    })

    return response
end

function delete_config()
    -- Connect to a config.storage and delete a key.
    local storage_client = config.storage_client:connect({
        '127.0.0.1:4401',
        '127.0.0.1:4402',
        '127.0.0.1:4403',
    })
    local response = storage_client:delete('/myapp/config/all')

    -- Delete a key on a configured config.storage cluster.
    response = config.storage_client:delete('/myapp/config/all')

    return response
end

function delete_all_configs()
    -- Connect to a config.storage and delete all keys.
    local storage_client = config.storage_client:connect({
        '127.0.0.1:4401',
        '127.0.0.1:4402',
        '127.0.0.1:4403',
    })
    local response = storage_client:delete('/')

    -- Delete all keys from a configured config.storage cluster.
    response = config.storage_client:delete('/')
    return response
end
