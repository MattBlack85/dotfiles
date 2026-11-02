#!/bin/bash
# Current weather from wttr.in (location guessed from IP), e.g. "☀️ +12°C"
curl -sf --max-time 5 'https://wttr.in/?format=%c%t' || echo "n/a"
