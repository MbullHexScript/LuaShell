use mlua::prelude::*;

mod lua_bindings;

fn main() -> LuaResult<()> {
    // Initialize Lua VM
    let lua = Lua::new();

    // Register host APIs
    lua_bindings::register_all(&lua)?;

    // Load init.lua to bootstrap Lua layer
    let init_script = include_str!("../lua/init.lua");
    lua.load(init_script).exec()?;

    // Get the main loop function from Lua
    let globals = lua.globals();
    let main_loop: LuaFunction = globals.get("_LuaShell_main_loop")?;

    // Run the main loop
    main_loop.call::<_, ()>(())?;

    Ok(())
}
