"""Minimal `rofi -dmenu` stand-in for the qute-autofill-keepassxc scripts.

Lists go to `noctalia dmenu`; `-password` goes to pinentry (Noctalia's picker
would echo the typed characters). Only the flags those scripts use are handled:
-dmenu, -p, -i (ignored), -format i, -filter (ignored), -password.
"""
import os
import re
import subprocess
import sys
import urllib.parse


def parse(argv):
    opts = {"dmenu": False, "prompt": "", "fmt": "s", "password": False}
    it = iter(argv)
    for arg in it:
        if arg == "-dmenu":
            opts["dmenu"] = True
        elif arg == "-p":
            opts["prompt"] = next(it, "")
        elif arg == "-format":
            opts["fmt"] = next(it, "s")
        elif arg == "-filter":
            next(it, None)  # no prefill in noctalia dmenu; the caller also lists it as a candidate
        elif arg == "-password":
            opts["password"] = True
    return opts


def ask_password(prompt):
    pinentry = os.environ.get("QUTE_PINENTRY", "pinentry")
    text = prompt.replace("%", "%25").replace("\r", " ").replace("\n", " ")
    script = f"SETTITLE qutebrowser\nSETPROMPT {text}:\nGETPIN\nBYE\n".encode()
    try:
        proc = subprocess.run([pinentry], input=script, capture_output=True, check=False)
    except OSError as exc:
        print(f"rofi shim: cannot run {pinentry}: {exc}", file=sys.stderr)
        return 1
    pin = None
    for line in proc.stdout.split(b"\n"):
        if line.startswith(b"ERR"):
            return 1
        if line.startswith(b"D "):
            pin = urllib.parse.unquote_to_bytes(line[2:]).decode("utf-8", "replace")
    print(pin or "")
    return 0


def pick(prompt, fmt):
    lines = sys.stdin.read().split("\n")
    if lines and lines[-1] == "":
        lines.pop()
    index_mode = fmt == "i"
    seen = {}
    for line in lines:
        seen[line] = seen.get(line, 0) + 1
    # Identical rows would be ambiguous once only text comes back, so tag duplicates.
    shown = [f"{line}\t#{i}" if index_mode and seen[line] > 1 else line
             for i, line in enumerate(lines)]
    try:
        proc = subprocess.run(
            ["noctalia", "dmenu", "-p", prompt or "Pick"],
            input="".join(s + "\n" for s in shown), stdout=subprocess.PIPE, text=True, check=False,
        )
    except OSError as exc:
        print(f"rofi shim: cannot run noctalia: {exc}", file=sys.stderr)
        return 1
    if proc.returncode != 0:
        return 1  # Escape / closed, same as rofi
    choice = proc.stdout[:-1] if proc.stdout.endswith("\n") else proc.stdout
    if not index_mode:
        print(choice)
        return 0
    match = re.search(r"\t#(\d+)$", choice)
    if match and int(match.group(1)) < len(shown) and shown[int(match.group(1))] == choice:
        print(int(match.group(1)))
    elif choice in lines:
        print(lines.index(choice))
    else:
        print(-1)  # typed text that matched no row, which is what rofi prints too
    return 0


def main():
    opts = parse(sys.argv[1:])
    if opts["password"]:
        return ask_password(opts["prompt"])
    if not opts["dmenu"]:
        print("rofi shim: only -dmenu is supported", file=sys.stderr)
        return 2
    return pick(opts["prompt"], opts["fmt"])


if __name__ == "__main__":
    sys.exit(main())
