#!/bin/bash

echo "=================================="
echo "      SERVER PERFORMANCE STATS"
echo "=================================="

echo ""
echo "CPU Usage:"
LC_ALL=C top -bn1 | awk -F',' '
/Cpu\(s\)/ {
    for (i = 1; i <= NF; i++) {
        if ($i ~ /id/) {
            idle = $i
            gsub(/[^0-9.]/, "", idle)
            printf "Total CPU Usage: %.1f%%\n", 100 - idle
            found = 1
        }
    }
}
END {
    if (!found) print "CPU usage unavailable"
}'

echo ""
echo "Memory Usage:"
free -h | awk '/^Mem:/ {
    printf "Total: %s\nUsed: %s\nFree: %s\nAvailable: %s\n",
    $2, $3, $4, $7
}'

free -b | awk '/^Mem:/ {
    total = $2
    used = $3
    free = $4

    if (total > 0) {
        printf "Used: %.2f%%\nFree: %.2f%%\n",
        used / total * 100, free / total * 100
    }
}'

echo ""
echo "Disk Usage:"
df -h / | awk 'NR == 2 {
    printf "Total: %s\nUsed: %s\nAvailable: %s\nUsage: %s\n",
    $2, $3, $4, $5
}'

echo ""
echo "Top 5 Processes by CPU Usage:"
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6

echo ""
echo "Top 5 Processes by Memory Usage:"
ps -eo pid,comm,%mem --sort=-%mem | head -n 6

echo ""
echo "Operating System:"
grep PRETTY_NAME /etc/os-release | cut -d '"' -f 2

echo ""
echo "System Uptime:"
uptime -p

echo ""
echo "Load Average:"
awk '{print $1, $2, $3}' /proc/loadavg
