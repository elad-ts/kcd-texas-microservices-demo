#!/bin/zsh

# url_timer.sh - A script to measure the time it takes to access a URL
# Usage: ./url_timer.sh https://example.com [repetitions]

if [ $# -eq 0 ]; then
    echo "Usage: $0 <url> [repetitions]"
    echo "Example: $0 https://example.com 5"
    exit 1
fi

URL="$1"
REPS=${2:-1}  # Default to 1 repetition if not specified

echo "Measuring access time for: $URL (${REPS} repetition(s))"

# Variables to track totals for averaging
total_time=0
total_dns=0
total_connect=0
total_tls=0
total_pretransfer=0
total_starttransfer=0
total_curl=0

# Run the test REPS times
for ((i=1; i<=$REPS; i++)); do
    echo -e "\nRun $i of $REPS:"
    
    # Basic timing
    start_time=$(date +%s.%N)
    curl -s -L -o /dev/null "$URL"
    end_time=$(date +%s.%N)
    
    # Calculate the time difference and convert to ms with 2 decimal places
    time_diff=$(echo "scale=2; ($end_time - $start_time) * 1000" | bc)
    total_time=$(echo "$total_time + $time_diff" | bc)
    #echo "Time taken: ${time_diff}ms"
    
    # Detailed timing with curl's built-in features
    echo "Detailed timing:"
    timing=$(curl -s -L -o /dev/null -w "dns=%{time_namelookup},connect=%{time_connect},tls=%{time_appconnect},pretransfer=%{time_pretransfer},starttransfer=%{time_starttransfer},total=%{time_total}" "$URL")
    
    # Extract timing components, convert to ms with 2 decimal places
    dns=$(echo "scale=2; $(echo $timing | cut -d',' -f1 | cut -d'=' -f2) * 1000" | bc)
    connect=$(echo "scale=2; $(echo $timing | cut -d',' -f2 | cut -d'=' -f2) * 1000" | bc)
    tls=$(echo "scale=2; $(echo $timing | cut -d',' -f3 | cut -d'=' -f2) * 1000" | bc)
    pretransfer=$(echo "scale=2; $(echo $timing | cut -d',' -f4 | cut -d'=' -f2) * 1000" | bc)
    starttransfer=$(echo "scale=2; $(echo $timing | cut -d',' -f5 | cut -d'=' -f2) * 1000" | bc)
    curl_total=$(echo "scale=2; $(echo $timing | cut -d',' -f6 | cut -d'=' -f2) * 1000" | bc)
    
    # Update totals for averaging
    total_dns=$(echo "$total_dns + $dns" | bc)
    total_connect=$(echo "$total_connect + $connect" | bc)
    total_tls=$(echo "$total_tls + $tls" | bc)
    total_pretransfer=$(echo "$total_pretransfer + $pretransfer" | bc)
    total_starttransfer=$(echo "$total_starttransfer + $starttransfer" | bc)
    total_curl=$(echo "$total_curl + $curl_total" | bc)
    
    echo "  DNS Lookup: ${dns}ms"
    echo "  Connect: ${connect}ms"
    echo "  TLS Setup: ${tls}ms"
    echo "  Pre-transfer: ${pretransfer}ms"
    echo "  Start-transfer: ${starttransfer}ms"
    echo "  Total: ${curl_total}ms"
    
    # Add a small delay between requests
    if [ $i -lt $REPS ]; then
        sleep 1
    fi
done

# Calculate and display averages if more than one repetition
if [ $REPS -gt 1 ]; then
    avg_time=$(echo "scale=2; $total_time / $REPS" | bc)
    avg_dns=$(echo "scale=2; $total_dns / $REPS" | bc)
    avg_connect=$(echo "scale=2; $total_connect / $REPS" | bc)
    avg_tls=$(echo "scale=2; $total_tls / $REPS" | bc)
    avg_pretransfer=$(echo "scale=2; $total_pretransfer / $REPS" | bc)
    avg_starttransfer=$(echo "scale=2; $total_starttransfer / $REPS" | bc)
    avg_curl=$(echo "scale=2; $total_curl / $REPS" | bc)
    
    echo -e "\n==== AVERAGE TIMINGS OVER $REPS RUNS ===="
    # echo "Basic timing: ${avg_time}ms"
    echo "Curl timing details:"
    echo "  DNS Lookup: ${avg_dns}ms"
    echo "  Connect: ${avg_connect}ms"
    echo "  TLS Setup: ${avg_tls}ms"
    echo "  Pre-transfer: ${avg_pretransfer}ms"
    echo "  Start-transfer: ${avg_starttransfer}ms"
    echo "  Total: ${avg_curl}ms"
fi
