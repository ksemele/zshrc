#!/bin/sh
input=$(cat)

user=$(whoami)
host=$(hostname -s)
dir=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
short_dir=$(basename "$dir")

model=$(echo "$input" | jq -r '.model.display_name // empty')

branch=$(git -C "$dir" --no-optional-locks rev-parse --abbrev-ref HEAD 2>/dev/null)

used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

line=""

printf "\033[32m%s\033[0m@\033[36m%s\033[0m \033[34m%s\033[0m" "$user" "$host" "$short_dir"

if [ -n "$branch" ]; then
  printf " \033[33m(%s)\033[0m" "$branch"
fi

if [ -n "$model" ]; then
  printf " \033[35m[%s]\033[0m" "$model"
fi

five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
week_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

# Function to pick color based on usage percentage
color_for_pct() {
  pct="$1"
  val=$(printf '%.0f' "$pct")
  if [ "$val" -le 50 ]; then
    printf '\033[32m'   # green
  elif [ "$val" -le 80 ]; then
    printf '\033[33m'   # yellow
  else
    printf '\033[31m'   # red
  fi
}

bar_for_pct() {
  pct="$1"
  val=$(printf '%.0f' "$pct")
  filled=$(( val / 10 ))
  empty=$(( 10 - filled ))
  bar=""
  i=0
  while [ $i -lt $filled ]; do bar="${bar}█"; i=$(( i + 1 )); done
  i=0
  while [ $i -lt $empty ]; do bar="${bar}░"; i=$(( i + 1 )); done
  printf '%s' "$bar"
}

if [ -n "$used" ] || [ -n "$five_pct" ] || [ -n "$week_pct" ]; then
  printf " "
fi

if [ -n "$used" ]; then
  color=$(color_for_pct "$used")
  bar=$(bar_for_pct "$used")
  val=$(printf '%.0f' "$used")
  printf "%sctx:%s %s%%\033[0m" "$color" "$bar" "$val"
fi

if [ -n "$five_pct" ]; then
  color=$(color_for_pct "$five_pct")
  bar=$(bar_for_pct "$five_pct")
  val=$(printf '%.0f' "$five_pct")
  printf " %s5h:%s %s%%\033[0m" "$color" "$bar" "$val"
fi

if [ -n "$week_pct" ]; then
  color=$(color_for_pct "$week_pct")
  bar=$(bar_for_pct "$week_pct")
  val=$(printf '%.0f' "$week_pct")
  printf " %s7d:%s %s%%\033[0m" "$color" "$bar" "$val"
fi

total_tokens=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')
if [ -n "$total_tokens" ]; then
  printf " \033[90mtokens:%s\033[0m" "$total_tokens"
fi

echo ""
