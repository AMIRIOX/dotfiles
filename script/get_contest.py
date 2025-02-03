from datetime import datetime, timedelta, timezone
import shutil
import re
import requests
import json
from bs4 import BeautifulSoup
from rich.console import Console
from rich.table import Table
from collections import defaultdict
import os

USER_NAME = "amiriox"
UTC8 = timezone(timedelta(hours=8))
CACHE_FILE = "/home/" + USER_NAME + "/contest_cache.json"


def get_cache():
    if os.path.exists(CACHE_FILE):
        with open(CACHE_FILE, "r", encoding="utf-8") as f:
            try:
                cache = json.load(f)
                cache_date = cache.get("date", "")
                if cache_date == datetime.now().strftime("%Y-%m-%d"):
                    return cache
            except json.JSONDecodeError:
                pass

    return {}


def datetime_converter(o):
    if isinstance(o, datetime):
        return o.isoformat()


def save_cache(data):
    data["date"] = datetime.now().strftime("%Y-%m-%d")
    with open(CACHE_FILE, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False,
                  indent=4, default=datetime_converter)


def get_codeforces_contests():
    url = "https://codeforces.com/api/contest.list"
    response = requests.get(url).json()
    if response["status"] != "OK":
        return []

    upcoming_contests = []
    now = datetime.now(UTC8)
    seven_days_later = now + timedelta(days=7)

    for contest in response["result"]:
        if contest["phase"] == "BEFORE":
            start_time = datetime.fromtimestamp(
                contest["startTimeSeconds"], timezone.utc).astimezone(UTC8)
            if now <= start_time <= seven_days_later:
                # fake language :(
                upcoming_contests.append(
                    {"name": contest["name"], "time": start_time, "platform": "Codeforces"})
    return upcoming_contests


def get_atcoder_contests():
    url = "https://atcoder.jp/contests/"
    response = requests.get(url).text
    soup = BeautifulSoup(response, "html.parser")

    upcoming_contests = []
    now = datetime.now(UTC8)
    seven_days_later = now + timedelta(days=7)

    for row in soup.select("#contest-table-upcoming tbody tr"):
        cols = row.find_all("td")
        name = cols[1].text.strip()
        time = datetime.strptime(
            cols[0].text.strip(), "%Y-%m-%d %H:%M:%S%z").astimezone(UTC8)
        if now <= time <= seven_days_later:
            upcoming_contests.append(
                {"name": name[4:], "time": time, "platform": "AtCoder"})
        # Atcoder Contests be like: "Ⓐ\n◉\nAtCoder Regular ..."
    return upcoming_contests


def get_nowcoder_contests():
    url = "https://ac.nowcoder.com/acm/contest/vip-index"
    response = requests.get(url).text
    soup = BeautifulSoup(response, "html.parser")

    upcoming_contests = []
    now = datetime.now(UTC8)
    seven_days_later = now + timedelta(days=7)

    for contest in soup.select(".platform-item-main"):
        title_element = contest.select_one("h4 a")
        time_element = contest.select_one("li.match-time-icon")

        if title_element and time_element:
            name = title_element.text.strip()
            time_text = time_element.text.strip().split(
                "至")[0].replace("比赛时间：", "").strip()
            time = datetime.strptime(
                time_text, "%Y-%m-%d %H:%M").replace(tzinfo=UTC8)

            if now <= time <= seven_days_later:
                upcoming_contests.append(
                    {"name": name, "time": time, "platform": "Nowcoder"})
    return upcoming_contests


def get_atcoder_adt_contests():
    url = "https://atcoder.jp/contests/adt_top"
    response = requests.get(url).text
    soup = BeautifulSoup(response, "html.parser")

    upcoming_contests = []
    now = datetime.now(UTC8)
    seven_days_later = now + timedelta(days=7)

    date_pattern = re.compile(r"\d{4}/\d{2}/\d{2}")
    time_pattern = re.compile(r"\d{2}:\d{2}")

    contests_by_date = defaultdict(list)

    for row in soup.select("table.table-bordered tr")[1:]:
        cols = row.find_all("td")
        if len(cols) < 2:
            continue

        date_str = cols[0].text.strip()
        time_str = cols[1].text.strip()

        if not date_pattern.fullmatch(date_str) or not time_pattern.fullmatch(time_str):
            continue

        time = datetime.strptime(
            f"{date_str} {time_str}", "%Y/%m/%d %H:%M").replace(tzinfo=UTC8)

        if now <= time <= seven_days_later:
            contests_by_date[date_str].append(time)

    for date, times in contests_by_date.items():
        upcoming_contests.append(
            {"name": "AtCoder ADT Contest", "time": times, "platform": "AtCoder ADT"})

    return upcoming_contests


def display_contests(contests):
    console = Console()
    grouped_contests = defaultdict(list)
    term_width = shutil.get_terminal_size().columns

    for contest in contests:
        if isinstance(contest["time"], list):
            contest["time"] = contest["time"][0]  

        if isinstance(contest["time"], str):
            try:
                contest["time"] = datetime.strptime(
                    contest["time"], "%Y-%m-%dT%H:%M:%S%z")
            except ValueError:
                print(f"无法解析时间: {contest['time']}")

        date_key = contest["time"].strftime("%Y-%m-%d")
        grouped_contests[date_key].append(contest)

    for date in sorted(grouped_contests.keys()):
        table = Table(title=f"Contests on {
                      date} (UTC+8)", show_header=True, header_style="bold magenta", width=term_width)
        table.add_column("Platform", style="cyan", justify="center")
        table.add_column("Contest Name", style="yellow", justify="center")
        table.add_column("Time (UTC+8)", style="green", justify="center")

        for contest in sorted(grouped_contests[date], key=lambda c: c["time"]):
            table.add_row(contest["platform"], contest["name"],
                          contest["time"].strftime("%H:%M"))

        console.print(table)
        console.print('\n')


def main():
    cache = get_cache()
    if cache:
        contests = cache.get("contests", [])
    else:
        contests = (
            get_codeforces_contests() +
            get_atcoder_contests() +
            get_nowcoder_contests() +
            get_atcoder_adt_contests()
        )
        contests.sort(key=lambda c: c["time"][0] if isinstance(
            c["time"], list) else c["time"])
        save_cache({"contests": contests})

    display_contests(contests)


if __name__ == "__main__":
    main()
