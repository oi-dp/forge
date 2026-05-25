#!/usr/bin/env python

## using yahoo API: yfinance

import json
import subprocess
import sys
import threading
import time
from datetime import datetime
import yfinance as yf

# Instruments
symbols = [
    "ES=F",
    "NQ=F",
    "GC=F",
    "AAPL",
    "AMZN",
    "GOOGL",
    "MSFT",
    "NVDA",
    "TSLA",
]

NOTIFICATION_WATCHLIST = ["ES=F", "NQ=F", "SPY", "AAPL", "MSFT", "NVDA"]

cache = []
last_notified_vol = {}

# Threshold - alert if volume is 1.5x the average
VOLSPIKES = 1.5


def fetch_data():
    """Fetches data every 5 minutes"""
    global cache, last_notified_vol  # preventing mako for talking too much
    while True:
        temp_cache = []

        current_hour = datetime.now().hour

        for sym in symbols:
            try:
                ticker = yf.Ticker(sym)

                # Isolated instruments volume spikes detection
                if 14 <= current_hour or current_hour < 4:
                    if sym in NOTIFICATION_WATCHLIST:
                        hist = ticker.history(interval="5m", period="1d")
                        if not hist.empty:
                            current_vol = hist["Volume"].iloc[-1]
                            avg_vol = hist["Volume"].iloc[-13:-1].mean()

                            if avg_vol > 0 and current_vol > (avg_vol * VOLSPIKES):
                                if last_notified_vol.get(sym) != current_vol:
                                    timestamp = datetime.now().strftime("%H:%M")
                                    title = f"🚨 {sym} Volume Spike"
                                    msg = (
                                        f"Time: {timestamp}\n"
                                        f"Current: {current_vol:,.0f}\n"
                                        f"Avg: {avg_vol:,.0f}"
                                    )
                                    subprocess.run(
                                        ["notify-send", "-u", "critical", title, msg]
                                    )

                                    last_notified_vol[sym] = current_vol

                info = ticker.fast_info
                price = info["last_price"]
                change = price - info["previous_close"]

                # Colors
                color = "#8cc85f" if change >= 0 else "#ff5454"
                sign = "+" if change >= 0 else ""
                text = f"{sym}: {price:.2f} ({sign}{change:.2f})"
                temp_cache.append({"text": text, "color": color})

            except Exception:
                continue

        if temp_cache:
            cache = temp_cache
        time.sleep(300)  # in seconds = 5 minutes


threading.Thread(target=fetch_data, daemon=True).start()

while not cache:
    time.sleep(0.1)

# Waybar
# continuous output loop
idx = 0
while True:
    current = cache[idx % len(cache)]
    output = {
        "text": f"<span color='{current['color']}'>{current['text']}</span>",
        "tooltip": "Live Ticker",
    }

    print(json.dumps(output))
    sys.stdout.flush()  # forces waybar to update

    idx += 1
    time.sleep(3)  # cycle to next instruments every 3 seconds
