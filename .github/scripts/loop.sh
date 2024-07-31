time_left=$((28 * 60))
while [ $time_left -gt 0 ]; do
  echo "WF exits in $((time_left / 60))m $((time_left % 60))s"
  cat cache-pub-key.pem
  sleep 5
  cat cloudflared.log | grep -E 'https.*trycloudflare.com' | cut -d "|" -f 2 | tr -s "[:blank:]"
  sleep 5
  cat cache-pub-key.pem
  cat cloudflared.log | grep -E 'https.*trycloudflare.com' | cut -d "|" -f 2 | tr -s "[:blank:]"
  ((time_left = time_left - 10))
done
