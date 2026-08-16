---
name: lokalise
description: Manage Lokalise translation keys for the VisualCV project. Use when the user wants to add, remove, or sync translation keys in Lokalise.
---

## Project config

- **Token**: read from the `LOKALISE_API_TOKEN` environment variable (set in `~/.lokalise_credentials`, sourced by `.zshrc`)
- **Project ID**: `123586245e4e9a802ada94.19634132`
- **Platform**: `web`
- **Tag**: `client`
- **Base locale file**: `src/locales/en.json`

All keys must have `platforms: ["web"]` and `tags: ["client"]`.

---

## Adding keys

1. If the key is missing from `en.json`, insert it at the correct alphabetical position and get its English value from context (source code, git history, or user).
2. Create keys via the Lokalise REST API (bulk POST):

```python
import os, urllib.request, json

TOKEN = os.environ["LOKALISE_API_TOKEN"]
PROJECT = "123586245e4e9a802ada94.19634132"

keys_to_create = [
    ("key_name", "English value"),
    # ...
]

payload = json.dumps({
    "keys": [
        {
            "key_name": name,
            "platforms": ["web"],
            "tags": ["client"],
            "translations": [{"language_iso": "en", "translation": value}]
        }
        for name, value in keys_to_create
    ]
}).encode()

url = f"https://api.lokalise.com/api2/projects/{PROJECT}/keys"
req = urllib.request.Request(url, data=payload, method="POST",
    headers={"X-Api-Token": TOKEN, "Content-Type": "application/json"})
with urllib.request.urlopen(req) as resp:
    data = json.loads(resp.read())
print(f"Created: {len(data.get('keys', []))} keys")
for k in data.get("keys", []):
    print(f"  {k['key_id']:>10}  {k['key_name']['web']}")
if data.get("errors"):
    print("Errors:", data["errors"])
```

---

## Removing keys

1. Resolve key names → IDs by fetching from API:

```python
import os, urllib.request, urllib.parse, json

TOKEN = os.environ["LOKALISE_API_TOKEN"]
PROJECT = "123586245e4e9a802ada94.19634132"

target_keys = ["key1", "key2"]  # list of key names

all_found = {}
batch_size = 20
for i in range(0, len(target_keys), batch_size):
    batch = target_keys[i:i+batch_size]
    filter_param = urllib.parse.quote(",".join(batch))
    url = f"https://api.lokalise.com/api2/projects/{PROJECT}/keys?filter_keys={filter_param}&include_translations=0&limit=200"
    req = urllib.request.Request(url, headers={"X-Api-Token": TOKEN})
    with urllib.request.urlopen(req) as resp:
        data = json.loads(resp.read())
    for k in data.get("keys", []):
        all_found[k["key_name"]["web"]] = k["key_id"]

not_found = set(target_keys) - set(all_found)
print(f"Found {len(all_found)}, not found: {sorted(not_found)}")
```

2. Bulk delete by ID:

```python
key_ids = list(all_found.values())
payload = json.dumps({"keys": key_ids}).encode()
url = f"https://api.lokalise.com/api2/projects/{PROJECT}/keys"
req = urllib.request.Request(url, data=payload, method="DELETE",
    headers={"X-Api-Token": TOKEN, "Content-Type": "application/json"})
with urllib.request.urlopen(req) as resp:
    data = json.loads(resp.read())
print(data)  # {"keys_removed": true, "keys_locked": 0}
```

---

## Notes

- The `lokalise2` CLI `key delete` requires numeric IDs (not names) and deletes one at a time — use the REST API for bulk operations instead.
- The `lokalise2` CLI `key list --filter-keys` returns 404 (CLI bug) — use the REST API for lookups too.
- After adding keys, run `./scripts/lokalise` to pull updated translations into `src/locales/`.
