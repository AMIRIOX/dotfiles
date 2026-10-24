#!/usr/bin/env python3
"""wttr.in -> waybar custom module (JSON).

Icons are Material Design Icons from Nerd Fonts (md-weather_*), so the bar
keeps one monochrome icon family instead of mixing colour emoji.
Codepoints are written as ints (they live above U+FFFF, so U+XXXX escapes
would silently truncate them).
"""

import json
from datetime import datetime

import requests

SUNNY = 0xF0599
PARTLY_CLOUDY = 0xF0595
CLOUDY = 0xF0590
FOG = 0xF0591
POURING = 0xF0596
RAINY = 0xF0597
SNOWY = 0xF0598
HAIL = 0xF0592
LIGHTNING = 0xF0593
LIGHTNING_RAINY = 0xF067E
SNOWY_RAINY = 0xF067F

WEATHER_CODES = {
    # clear / partly cloudy / cloudy
    "113": SUNNY,
    "116": PARTLY_CLOUDY,
    "119": CLOUDY,
    "122": CLOUDY,
    # fog
    "143": FOG,
    "248": FOG,
    "260": FOG,
    # drizzle / freezing drizzle
    "176": POURING,
    "185": POURING,
    "263": POURING,
    "266": POURING,
    "281": POURING,
    "284": POURING,
    "311": POURING,
    "314": POURING,
    # rain
    "293": RAINY,
    "296": RAINY,
    "299": RAINY,
    "302": RAINY,
    "305": POURING,
    "308": POURING,
    "353": RAINY,
    "356": POURING,
    "359": POURING,
    # sleet
    "182": SNOWY_RAINY,
    "317": SNOWY_RAINY,
    "320": SNOWY_RAINY,
    "362": SNOWY_RAINY,
    "365": SNOWY_RAINY,
    # snow
    "179": SNOWY,
    "227": SNOWY,
    "230": SNOWY,
    "323": SNOWY,
    "326": SNOWY,
    "329": SNOWY,
    "332": SNOWY,
    "335": SNOWY,
    "338": SNOWY,
    "368": SNOWY,
    "371": SNOWY,
    # ice pellets
    "350": HAIL,
    "374": HAIL,
    "377": HAIL,
    # thunder
    "200": LIGHTNING,
    "386": LIGHTNING_RAINY,
    "389": LIGHTNING_RAINY,
    "392": SNOWY_RAINY,
    "395": SNOWY_RAINY,
}


def icon(code):
    return chr(WEATHER_CODES.get(str(code), CLOUDY))


def format_time(time):
    return time.replace("00", "").zfill(2)


def format_temp(temp):
    return (str(temp) + "°").ljust(3)


def format_chances(hour):
    chances = {
        "chanceoffog": "Fog",
        "chanceoffrost": "Frost",
        "chanceofovercast": "Overcast",
        "chanceofrain": "Rain",
        "chanceofsnow": "Snow",
        "chanceofsunshine": "Sunshine",
        "chanceofthunder": "Thunder",
        "chanceofwindy": "Wind",
    }

    conditions = []
    for event, label in chances.items():
        value = int(hour[event])
        if value > 0:
            conditions.append(f"{label} {value}%")
    return ", ".join(conditions)


def main():
    weather = requests.get("https://wttr.in/Harbin?format=j1", timeout=20).json()
    current = weather["current_condition"][0]

    data = {
        "text": f"{icon(current['weatherCode'])} {current['FeelsLikeC']}°C",
        "tooltip": (
            f"<b>{current['weatherDesc'][0]['value']} {current['temp_C']}°C</b>\n"
            f"Feels like: {current['FeelsLikeC']}°C\n"
            f"Wind: {current['windspeedKmph']}Km/h\n"
            f"Humidity: {current['humidity']}%\n"
        ),
    }

    for i, day in enumerate(weather["weather"]):
        prefix = "Today, " if i == 0 else "Tomorrow, " if i == 1 else ""
        data["tooltip"] += f"\n<b>{prefix}{day['date']}</b>\n"
        data["tooltip"] += (
            f"Max {day['maxtempC']}° Min {day['mintempC']}° "
            f"Sunrise {day['astronomy'][0]['sunrise']} Sunset {day['astronomy'][0]['sunset']}\n"
        )
        for hour in day["hourly"]:
            if i == 0 and int(format_time(hour["time"])) < datetime.now().hour - 2:
                continue
            data["tooltip"] += (
                f"{format_time(hour['time'])} {icon(hour['weatherCode'])} "
                f"{format_temp(hour['FeelsLikeC'])} {hour['weatherDesc'][0]['value']}, "
                f"{format_chances(hour)}\n"
            )

    print(json.dumps(data))


if __name__ == "__main__":
    main()
