# Static dashboard for the Pironman 5 (pm_dashboard API front-end).
# Multi-arch: builds on the Pi's arm64 as well as amd64.
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80
