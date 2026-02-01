use mlua::prelude::*;
use std::env;
use std::fs;
use std::io::{self, Write};
use std::process::Command;
use rustyline::DefaultEditor;

pub fn register_all(lua: &Lua) -> LuaResult<()> {
    register_term_module(lua)?;
    register_fs_module(lua)?;
    register_process_module(lua)?;
    register_env_module(lua)?;
    Ok(())
}

// ============================================================
// TERM MODULE - Terminal I/O operations
// ============================================================
fn register_term_module(lua: &Lua) -> LuaResult<()> {
    let term = lua.create_table()?;

    // term.print(text)
    let print_fn = lua.create_function(|_, text: String| {
        print!("{}", text);
        io::stdout().flush().ok();
        Ok(())
    })?;
    term.set("print", print_fn)?;

    // term.println(text)
    let println_fn = lua.create_function(|_, text: String| {
        println!("{}", text);
        Ok(())
    })?;
    term.set("println", println_fn)?;

    // term.read_line() -> string
    let read_line_fn = lua.create_function(|_, prompt: String| {
        let mut rl = DefaultEditor::new()
            .map_err(|e| LuaError::RuntimeError(e.to_string()))?;

        match rl.readline(&prompt) {
            Ok(line) => Ok(line),
            Err(rustyline::error::ReadlineError::Interrupted) => Ok(String::new()),
            Err(rustyline::error::ReadlineError::Eof) => Ok("exit".to_string()),
            Err(e) => Err(LuaError::RuntimeError(e.to_string())),
        }
    })?;
    term.set("read_line", read_line_fn)?;

    // term.clear()
    let clear_fn = lua.create_function(|_, ()| {
        print!("\x1B[2J\x1B[1;1H");
        io::stdout().flush().ok();
        Ok(())
    })?;
    term.set("clear", clear_fn)?;

    lua.globals().set("term", term)?;
    Ok(())
}

// ============================================================
// FS MODULE - File system operations
// ============================================================
fn register_fs_module(lua: &Lua) -> LuaResult<()> {
    let fs_mod = lua.create_table()?;

    // fs.chdir(path) -> (bool, error_msg?)
    let chdir_fn = lua.create_function(|lua, path: String| {
        match env::set_current_dir(&path) {
            Ok(_) => Ok((true, LuaValue::Nil)),
            Err(e) => {
                let err_msg = lua.create_string(&format!("{}", e))?;
                Ok((false, LuaValue::String(err_msg)))
            }
        }
    })?;
    fs_mod.set("chdir", chdir_fn)?;

    // fs.getcwd() -> string
    let getcwd_fn = lua.create_function(|_, ()| {
        match env::current_dir() {
            Ok(path) => Ok(path.to_string_lossy().to_string()),
            Err(e) => Err(LuaError::RuntimeError(e.to_string())),
        }
    })?;
    fs_mod.set("getcwd", getcwd_fn)?;

    // fs.exists(path) -> bool
    let exists_fn = lua.create_function(|_, path: String| {
        Ok(std::path::Path::new(&path).exists())
    })?;
    fs_mod.set("exists", exists_fn)?;

    // fs.list_dir(path) -> table
    let list_dir_fn = lua.create_function(|lua, path: String| {
        let entries = fs::read_dir(&path)
            .map_err(|e| LuaError::RuntimeError(e.to_string()))?;

        let table = lua.create_table()?;
        for (i, entry) in entries.enumerate() {
            if let Ok(entry) = entry {
                if let Some(name) = entry.file_name().to_str() {
                    table.set(i + 1, name)?;
                }
            }
        }
        Ok(table)
    })?;
    fs_mod.set("list_dir", list_dir_fn)?;

    lua.globals().set("fs", fs_mod)?;
    Ok(())
}

// ============================================================
// PROCESS MODULE - External command execution
// ============================================================
fn register_process_module(lua: &Lua) -> LuaResult<()> {
    let process = lua.create_table()?;

    // process.exec(cmd, args_table) -> exit_code
    let exec_fn = lua.create_function(|_, (cmd, args): (String, LuaTable)| {
        let mut command = Command::new(&cmd);

        // Convert Lua table to Vec<String>
        for pair in args.pairs::<i32, String>() {
            if let Ok((_, arg)) = pair {
                command.arg(arg);
            }
        }

        match command.status() {
            Ok(status) => Ok(status.code().unwrap_or(-1)),
            Err(_) => {
                eprintln!("LuaShell: command not found: {}", cmd);
                Ok(127) // Command not found
            }
        }
    })?;
    process.set("exec", exec_fn)?;

    lua.globals().set("process", process)?;
    Ok(())
}

// ============================================================
// ENV MODULE - Environment variables
// ============================================================
fn register_env_module(lua: &Lua) -> LuaResult<()> {
    let env_mod = lua.create_table()?;

    // env.get(key) -> value or nil
    let get_fn = lua.create_function(|_, key: String| {
        Ok(env::var(&key).ok())
    })?;
    env_mod.set("get", get_fn)?;

    // env.set(key, value)
    let set_fn = lua.create_function(|_, (key, value): (String, String)| {
        env::set_var(key, value);
        Ok(())
    })?;
    env_mod.set("set", set_fn)?;

    // env.list() -> table
    let list_fn = lua.create_function(|lua, ()| {
        let table = lua.create_table()?;
        for (key, value) in env::vars() {
            table.set(key, value)?;
        }
        Ok(table)
    })?;
    env_mod.set("list", list_fn)?;

    lua.globals().set("env", env_mod)?;
    Ok(())
}
