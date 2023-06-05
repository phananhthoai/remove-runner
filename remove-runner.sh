set -ex

github_token=${{ GITHUB_TOKEN }}
for item in elofun-devops; do
  page=0
  while true; do
    page=$(expr ${page} + 1)
    runners=$(curl -s -u token:${github_token} "https://api.github.com/orgs/${item}/actions/runners?page=${page}")
    if [ $(echo ${runners} | jq -r '.runners | length') == 0 ]; then
      break
    fi
    for runner in $(echo ${runners} | jq -r '.runners[] | select(.status == "offline") | tojson'); do
      echo ${runner} | jq -r .
      runner_id=$(echo ${runner} | jq -r .id)
      curl -s -u token:${github_token} -X DELETE "https://api.github.com/orgs/${item}/actions/runners/${runner_id}"
    done
  done
done
