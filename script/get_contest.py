import requests
from datetime import datetime, timedelta, timezone
from bs4 import BeautifulSoup
from rich.console import Console
from rich.table import Table

UTC8 = timezone(timedelta(hours=8))


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
                upcoming_contests.append(
                    {"name": contest["name"], "time": start_time})
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
            upcoming_contests.append({"name": name[4:], "time": time})
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
                upcoming_contests.append({"name": name, "time": time})
    return upcoming_contests


def display_contests(contests):
    console = Console()
    table = Table(title="Upcoming Contests (Next 7 Days)",
                  show_header=True, header_style="bold magenta")
    table.add_column("Platform", style="cyan", justify="center")
    table.add_column("Contest Name", style="yellow")
    table.add_column("Time (UTC+8)", style="green")

    for platform, contest_list in contests.items():
        for contest in contest_list:
            table.add_row(platform, contest["name"], contest["time"].strftime(
                "%Y-%m-%d %H:%M UTC+8"))

    console.print(table)


def main():
    contests = {
        "Codeforces": get_codeforces_contests(),
        "AtCoder": get_atcoder_contests(),
        "Nowcoder": get_nowcoder_contests()
    }
    display_contests(contests)


if __name__ == "__main__":
    main()
