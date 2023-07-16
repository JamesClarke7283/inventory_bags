dofile(minetest.get_modpath("inventory_pouches") .. "/functions.lua")

minetest.register_craftitem("inventory_pouches:pouch", {
    description = "Inventory Pouch",
    inventory_image = "inventory_pouches_pouch.png",
    stack_max = 1,
    on_use = function(itemstack, user, pointed_thing)
        local meta = itemstack:get_meta()
        local id = meta:get_string("id")
        if id == "" then
            id = functions.get_next_id()
            meta:set_string("id", tostring(id))
            itemstack:set_name("inventory_pouches:pouch")
        end
        local inv = functions.create_pouch_inventory(itemstack)
        local formspec = "size[9,8.5]" ..
        "label[0,0.1;" .. minetest.formspec_escape(minetest.colorize("#313131", "Inventory pouch")) .. "]" ..
        "listcolors[#AAAAAA;#888888;#FFFFFF]" ..
        "list[detached:pouch_inventory_" .. id .. ";main;0,0.5;9,3;]" ..
        "list[current_player;main;0,4.0;9,3;9]" ..
        "list[current_player;main;0,7.74;9,1;]" ..
        "listring[detached:pouch_inventory_" .. id .. ";main]" ..
        "listring[current_player;main]"

        minetest.show_formspec(user:get_player_name(), "inventory_pouches:pouch" .. id, formspec)
        return itemstack
    end,
})

minetest.register_on_player_receive_fields(function(player, formname, fields)
    if formname == "inventory_pouches:pouch" and fields.quit then
        local inv_list = player:get_inventory():get_list("main")
        for i, itemstack in ipairs(inv_list) do
            if itemstack:get_name() == "inventory_pouches:pouch" then
                functions.update_inventory(itemstack)
            end
        end
    end
end)
