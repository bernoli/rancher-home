#list keys

curl -s -H "Authorization: token $gh_token" https://api.github.com/repos/${gh_user}/${repo}/keys | jq .[].id

# delete all keys

for key in `curl -s -H "Authorization: token $gh_token" https://api.github.com/repos/${gh_user}/${repo}/keys | jq .[].id`; do curl -s -H "Authorization: token $gh_token" -X DELETE https://api.github.com/repos/${gh_user}/${repo}/keys/${key} ; done