#!/usr/bin/env python

import gi

gi.require_version("Playerctl", "2.0")
import urllib.request
from subprocess import Popen

allowed_players = {"spotify"}  # define another player here
from gi.repository import GLib, Playerctl # type: ignore

cache_path = "/tmp/spotify_art.png"

def on_track_change(player, e):
    metadata = player.props.metadata
    if not metadata:
        return

    # extract info
    meta_dict = metadata.unpack()
    art_url = meta_dict.get("mpris:artUrl")
    artist = player.get_artist() or "Unknown Artist"
    title = player.get_title() or "Unknown Title"

    cmd = ["notify-send", "Now Playing", f"{artist} - {title}"]

    if art_url:
        if art_url.startswith("http"):
            try:
                urllib.request.urlretrieve(art_url, cache_path)
                cmd.extend(["-i", cache_path])
            except Exception:
                pass  # fallback to no icon if download fails
        elif art_url.startswith("file://"):
            cmd.extend(["-i", art_url.replace("file://", "")])

    Popen(cmd)


def init_player(manager, name):
    player_name_str = name.name if hasattr(name, "name") else name

    if player_name_str.lower() not in allowed_players:
        return

    player = Playerctl.Player.new_from_name(name)
    player.connect("metadata", on_track_change)
    manager.manage_player(player)


manager = Playerctl.PlayerManager()
manager.connect("name-appeared", init_player)

for name in manager.props.player_names:
    init_player(manager, name)

GLib.MainLoop().run()
