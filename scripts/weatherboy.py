#!/usr/bin/env python

import asyncio
import json
import httpx

CITY = "Bandung"
LAT = -6.9175
LON = 107.6191
MAX_RETRIES = 3

# WMO Weather Interpretation
WMO_MAP = {
    0: ("󰖙", "sunny", "Clear sky"),
    1: ("󰖙", "sunny", "Mainly clear"),
    2: ("󰖕", "cloudy", "Partly cloudy"),
    3: ("󰖐", "cloudy", "Overcast"),
    45: ("󰖑", "mist", "Fog"),
    48: ("󰖑", "mist", "Depositing rime fog"),
    51: ("󰖗", "lightrain", "Light drizzle"),
    53: ("󰖗", "lightrain", "Moderate drizzle"),
    55: ("󰖗", "lightrain", "Dense drizzle"),
    61: ("󰖗", "lightrain", "Slight rain"),
    63: ("󰖗", "lightrain", "Moderate rain"),
    65: ("󰖖", "heavyrain", "Heavy rain"),
    71: ("󰖘", "snow", "Slight snowfall"),
    73: ("󰖘", "snow", "Moderate snowfall"),
    75: ("󰼶", "snow", "Heavy snowfall"),
    80: ("󰖗", "lightrain", "Slight rain showers"),
    81: ("󰖗", "lightrain", "Moderate rain showers"),
    82: ("󰖖", "heavyrain", "Violent rain showers"),
    95: ("󰖓", "thunderyshowers", "Thunderstorm"),
    96: ("󰖓", "thunderyshowers", "Thunderstorm with slight hail"),
    99: ("󰖓", "thunderyshowers", "Thunderstorm with heavy hail"),
}

async def get_weather():
    url = "https://api.open-meteo.com/v1/forecast"
    params = {
        "latitude": LAT,
        "longitude": LON,
        "current": ["temperature_2m", "weathercode"],
        "timezone": "auto",
    }

    async with httpx.AsyncClient(timeout=10) as client:
        payload = None
        for attempt in range(MAX_RETRIES):
            try:
                response = await client.get(url, params=params)
                response.raise_for_status()
                payload = response.json()
                break

            except (httpx.RequestError, httpx.HTTPStatusError) as e:
                if attempt == MAX_RETRIES - 1:
                    raise Exception(f"Failed after {MAX_RETRIES} attempts: {str(e)}")
                await asyncio.sleep(2**attempt)

    if payload:
        current = payload.get("current", {})
        temp = round(current.get("temperature_2m", 0))
        code = current.get("weathercode", 0)

        icon, css_class, description = WMO_MAP.get(code, ("󰖐", "cloudy", "Unknown"))

        data = {
            "text": f"{icon}  {temp}°C",
            "tooltip": f"Condition: {description}\nLocation: {CITY}",
            "class": css_class,
        }
        print(json.dumps(data))

if __name__ == "__main__":
    try:
        asyncio.run(get_weather())
    except Exception as e:
        error_output = {"text": "Weather Error", "tooltip": str(e), "class": "error"}
        print(json.dumps(error_output))
