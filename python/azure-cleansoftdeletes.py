import subprocess
import requests
import json

# Helper to run az commands via cmd.exe
def run_az_cmd(args):
    return subprocess.check_output(['cmd.exe', '/c', 'az.cmd'] + args).decode().strip()

def run_az_cmd_no_output(args):
    subprocess.run(['cmd.exe', '/c', 'az.cmd'] + args)

# Get subscription ID
try:
    subscription_id = run_az_cmd(['account', 'show', '--query', 'id', '-o', 'tsv'])
except subprocess.CalledProcessError as e:
    print("❌ Failed to get subscription ID.")
    print(e.output.decode())
    exit(1)

# Get access token
try:
    access_token = run_az_cmd(['account', 'get-access-token', '--query', 'accessToken', '-o', 'tsv'])
except subprocess.CalledProcessError as e:
    print("❌ Failed to get access token.")
    print(e.output.decode())
    exit(1)

headers = {"Authorization": f"Bearer {access_token}"}

# Purge soft-deleted Key Vaults
print("🔍 Checking for soft-deleted Key Vaults...")
try:
    kv_list_json = run_az_cmd(['keyvault', 'list-deleted', '-o', 'json'])
    kv_list = json.loads(kv_list_json)
except subprocess.CalledProcessError as e:
    print("❌ Failed to list deleted Key Vaults.")
    print(e.output.decode())
    kv_list = []

for kv in kv_list:
    name = kv.get("name")
    location = kv.get("location")

    if not name or not location:
        print(f"⚠️ Skipping Key Vault with missing data: {json.dumps(kv)}")
        continue

    print(f"🗑️ Purging Key Vault: {name} in {location}")
    try:
        run_az_cmd_no_output(['keyvault', 'purge', '--name', name, '--location', location])
    except subprocess.CalledProcessError as e:
        print(f"❌ Failed to purge Key Vault {name}: {e}")

# Purge soft-deleted Cognitive Services accounts
print("🔍 Checking for soft-deleted Cognitive Services accounts...")
url = f"https://management.azure.com/subscriptions/{subscription_id}/providers/Microsoft.CognitiveServices/deletedAccounts?api-version=2023-05-01"
response = requests.get(url, headers=headers)

if response.status_code != 200:
    print(f"❌ Failed to retrieve deleted Cognitive Services accounts: {response.status_code}")
    print(response.text)
    exit(1)

deleted_accounts = response.json().get("value", [])

for account in deleted_accounts:
    resource_id = account.get("id")
    if not resource_id:
        print(f"⚠️ Skipping Cognitive Account with missing ID: {json.dumps(account)}")
        continue

    print(f"🗑️ Purging Cognitive Account: {resource_id}")
    try:
        run_az_cmd_no_output(['resource', 'delete', '--ids', resource_id])
    except subprocess.CalledProcessError as e:
        print(f"❌ Failed to purge Cognitive Account {resource_id}: {e}")

print("✅ Purge complete.")