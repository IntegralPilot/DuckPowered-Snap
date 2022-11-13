#![cfg_attr(
    all(not(debug_assertions), target_os = "windows"),
    windows_subsystem = "windows"
)]

use std::process::{Command, Stdio};

// Learn more about Tauri commands at https://tauri.app/v1/guides/features/command
#[tauri::command]
fn usage() -> String {
    let output = Command::new("cat")
    .arg("/etc/duckpowered/dp_cur_use.duck")
    .stdout(Stdio::piped())
    .output()
    .unwrap();
    let stdout = String::from_utf8(output.stdout).unwrap();
    format!("{}", stdout)
}

#[tauri::command]
fn max_clock() -> String {
    let output = Command::new("cat")
    .arg("/etc/duckpowered/dp_max_mhz.duck")
    .stdout(Stdio::piped())
    .output()
    .unwrap();
    let stdout = String::from_utf8(output.stdout).unwrap();
    format!("{}mHz", stdout)
}


#[tauri::command]
fn new_clock() -> String {
    let output = Command::new("cat")
    .arg("/etc/duckpowered/dp_new_clock.duck")
    .stdout(Stdio::piped())
    .output()
    .unwrap();
    let mut stdout = String::from_utf8(output.stdout).unwrap();
    stdout = stdout.trim().to_string();
    let mut my_int: usize = stdout.parse().unwrap();
    my_int = my_int/1000usize;
    format!("{}mHz", my_int)
}


fn main() {
    tauri::Builder::default()
        .invoke_handler(tauri::generate_handler![usage, max_clock, new_clock])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
