box.once('bands', function()
    box.schema.create_space('bands', {
        format = {
            { name = 'id', type = 'unsigned' },
            { name = 'bucket_id', type = 'unsigned' },
            { name = 'band_name', type = 'string' },
            { name = 'year', type = 'unsigned' }
        },
        if_not_exists = true
    })
    box.space.bands:create_index('id', { parts = { 'id' }, if_not_exists = true })
    box.space.bands:create_index('bucket_id', { parts = { 'bucket_id' }, unique = false, if_not_exists = true })
end)

function insert_band(id, bucket_id, band_name, year)
    box.space.bands:insert({ id, bucket_id, band_name, year })
end

function get_band(id)
    local tuple = box.space.bands:get(id)
    if tuple == nil then
        return nil
    end
    return { tuple.id, tuple.band_name, tuple.year }
end
