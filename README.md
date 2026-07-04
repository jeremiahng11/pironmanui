# pironmanui

A single-file, zero-build web dashboard for the **Pironman 5** (SunFounder) that
talks directly to the native `pironman5` / `pm_dashboard` REST API. Built to run
alongside the stock service as a nicer front-end — deploy it standalone (e.g. on
Coolify) while `pironman5.service` keeps doing the sensor polling and hardware
control.

![type: single-file HTML + Chart.js](https://img.shields.io/badge/build-none-blue)

## Features

- Live gauges: CPU load, CPU/GPU temperature, memory, disk, fan, network up/down
- Per-core CPU bars
- Rolling history chart (CPU %, CPU °C, Mem %)
- Hardware controls wired to the real API: RGB enable/style/color/brightness/speed,
  fan mode, reboot / shutdown
- Configurable API endpoint (gear icon, stored in `localStorage`)
- Dark, responsive, no build step, no dependencies beyond a CDN Chart.js

## The backend it targets

The stock Pironman 5 install serves a Flask API at `http://<pi>:34001/api/v1.0/`.
This UI consumes:

| Endpoint | Use |
|---|---|
| `GET /get-data?n=1` | live metrics |
| `GET /get-device-info` | name / version / config path |
| `GET /get-config` | current RGB / fan settings |
| `POST /set-rgb-enable` `{enable}` | toggle RGB |
| `POST /set-rgb-style` `{style}` | solid, breathing, flow, flow_reverse, rainbow, rainbow_reverse, hue_cycle |
| `POST /set-rgb-color` `{color}` | hex `#rrggbb` |
| `POST /set-rgb-brightness` `{brightness}` | 0–100 |
| `POST /set-rgb-speed` `{speed}` | 0–100 |
| `POST /set-fan-mode` `{mode}` | 0–4 |
| `POST /set-reboot` / `POST /set-shutdown` | power |

CORS is enabled server-side (`flask-cors`), so hosting this on a different
origin/port than `:34001` works out of the box.

## Run it

### Just open it
Open `index.html` in a browser on your LAN. If it can't reach the API, click
**⚙ API** and enter `http://<pi-ip>:34001`.

### Docker / Coolify
```bash
docker build -t pironmanui .
docker run -d -p 8080:80 --name pironmanui pironmanui
```
In Coolify: new resource → from this Git repo → it auto-detects the `Dockerfile`.
Then browse to the app and set the API endpoint to your Pi's `:34001`.

## Notes

- This is a front-end only. It does **not** replace `pironman5.service` — keep that
  running; this UI is a client of its API.
- Disk key names are read dynamically (`disk_/dev/nvme0n1_percent` etc.), so it
  adapts to whatever drive the Pi reports.
