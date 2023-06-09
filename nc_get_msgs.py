import requests
import sys
import os
import getpass

# Get messages
# Requires lookIntoFuture=0 to avoid continuing to poll the talk chat room
# curl -X GET -u jmoore:[PASSWORD] "https://cloud.ecosysl.net/ocs/v2.php/apps/spreed/api/v1/chat/nbyeyf5k?lookIntoFuture=0" -H "Content-Type: application/json" -H "Accept: application/json" -H 'cache-control: no-cache' -H "OCS-APIRequest: true"  # noqa E501
# Converted to py with https://www.scrapingbee.com/curl-converter/python/


def get_username():
    """Get Username"""
    # Order: env var > stdin
    if os.environ.get("NC_USERNAME"):
        username = os.environ.get("NC_USERNAME")
        source = "environment variable NC_USERNAME"
    else:
        try:
            username = input("Username: ")
            source = "prompt"
        except Exception:
            raise Exception("a username is required to continue.")

    if username == "":
        raise Exception(f"empty username according to {source}.")

    # print(f"username obtained from {source}.")

    return username


def get_password():
    """Get Password"""
    # Order: env var > stdin
    if os.environ.get("NC_PASSWORD"):
        password = os.environ.get("NC_PASSWORD")
        source = "environment variable NC_PASSWORD"
    else:
        try:
            password = getpass.getpass()
            source = "prompt"
        except Exception:
            raise Exception("a password is required to continue")

    if password == "":
        raise Exception(f"empty password according to {source}.")

    # print(f"password obtained from {source}.")

    return password


def nc_get_msgs(host, room, id, password):

    # headers
    headers = {
        # Already added when you pass json=
        # 'Content-Type': 'application/json',
        'Accept': 'application/json',
        'cache-control': 'no-cache',
        'OCS-APIRequest': 'true',
    }

    # Reference: https://nextcloud-talk.readthedocs.io/en/latest/
    # v1: https://nextcloud-talk.readthedocs.io/en/latest/settings/
    # v3: https://nextcloud-talk.readthedocs.io/en/latest/internal-signaling/
    api = host + '/ocs/v2.php/apps/spreed/api/v1'
    endpoint = '/chat/' + room
    params = "lookIntoFuture=0"
    url = api + endpoint + "?" + params

    # create nextcloud requests session
    nextcloud_session = requests.Session()

    # post message. creating x for the sole purpose of the status code.
    x = nextcloud_session.get(url=url, auth=(id, password), headers=headers)

    # close session.
    nextcloud_session.close()

    if x.status_code == 200:
        print("Get messages successful (" + str(x.status_code) + "): " + host +
              "/index.php/call/" + room)
        print(x.json())
    else:
        print("Get messages failed: " + str(x.status_code))


host = 'https://cloud.ecosysl.net'
id = get_username()  # Find username in user management view
password = get_password()

try:
    room = sys.argv[1]
except IndexError:
    raise SystemExit(f"Usage: {sys.argv[0]} <'String ending talk chat room url'>")  # noqa E501

print("Room id: " + room)

nc_get_msgs(host, room, id, password,)
