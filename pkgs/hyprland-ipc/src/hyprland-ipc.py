#!/usr/bin/env python

import sys
import subprocess
import json
from typing import List
from itertools import takewhile


def main():
    for line in iter(sys.stdin.readline, b""):
        event, args = line.rstrip().split(">>")

        match event:
            case "openwindow":
                run_openwindow_handler(args)
            case "windowtitle":
                run_windowtitle_handler(args)
            case _:
                pass


def run_openwindow_handler(args: str):
    window_addr, workspace_name, window_class, window_title = args.split(",", 4)

    if window_title == "Firefox — Sharing Indicator":
        dispatch(["closewindow", f"address:0x{window_addr}"])


def run_windowtitle_handler(window_addr):
    client = hyprctl_get_client_by_address(window_addr)
    title = client["title"]

    if client["initialClass"] == "firefox" and title.startswith("FW"):
        # Used with https://addons.mozilla.org/en-US/firefox/addon/window-titler/
        title = client["title"].removeprefix("FW")
        digits = takewhile(lambda char: char.isdigit(), title)
        workspace = "".join(digits)
        dispatch([f"movetoworkspacesilent {workspace}, address:0x{window_addr}"])

    if title == "Extension: (Bitwarden Password Manager) - Bitwarden — Mozilla Firefox":
        dispatch([f"fullscreen 0, address:0x{window_addr}"])


def dispatch(dispatchers: List[str]):
    if len(dispatchers) == 1:
        args = ["hyprctl", "dispatch", dispatchers[0]]
        subprocess.run(args)
    else:
        dispatchers = list(
            map(lambda dispatcher: f"dispatch {dispatcher}", dispatchers)
        )
        joined_dispatchers = ";".join(dispatchers)
        args = ["hyprctl", "--batch", joined_dispatchers]
        subprocess.run(args)


def hyprctl_get_client_by_address(address):
    clients = hyprctl_clients()

    address = f"0x{address}"
    for client in clients:
        if client["address"] == address:
            return client

    raise RuntimeError(f"couldn't find a client with the address {address}")


def hyprctl_clients():
    output = subprocess.check_output(["hyprctl", "clients", "-j"], text=True)
    return json.loads(output)


if __name__ == "__main__":
    main()
