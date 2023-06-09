import requests
import sys
import os
import getpass

# Post messages
# curl -u jmoore:[PASSWORD] "https://cloud.ecosysl.net/ocs/v2.php/apps/spreed/api/v1/chat/nbyeyf5k" -H "Content-Type: application/json" -H "Accept: application/json" -H 'cache-control: no-cache' -H "OCS-APIRequest: true" --data-raw '{"message":"test via curl"}'  # noqa E501
# Output:
# {"ocs":{"meta":{"status":"ok","statuscode":201,"message":"OK"},"data":{"id":484,"token":"nbyeyf5k","actorType":"users","actorId":"jmoore","actorDisplayName":"Jess","timestamp":1686229606,"message":"test via curl","messageParameters":[],"systemMessage":"","messageType":"comment","isReplyable":true,"referenceId":"","reactions":{},"expirationTimestamp":0}}}%  # noqa E501
# Converted to py with https://www.scrapingbee.com/curl-converter/python/


def get_username():
    """
    Get Username

    Username can be looked up from the Users menu, accessed by clicking your
    profile icon.
    """
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


def nc_send_msg(host, room, id, password, message):  # , to_Whom):

    # headers
    headers = {
        # Already added when you pass json=
        # 'Content-Type': 'application/json',
        'Accept': 'application/json',
        'cache-control': 'no-cache',
        'OCS-APIRequest': 'true',
    }

    # Reference: https://nextcloud-talk.readthedocs.io/en/latest/
    api = host + '/ocs/v2.php/apps/spreed/api/v1'
    endpoint = '/chat/' + room
    url = api + endpoint

    # assemble the formating for sending a message.
    data = {'message': message}
    # data = {'message': message + ' @' + to_Whom}

    # create nextcloud requests session
    nextcloud_session = requests.Session()

    # post message. creating x for the sole purpose of the status code.
    x = nextcloud_session.post(url=url, auth=(id, password),
                               json=data,  # https://stackoverflow.com/questions/61531824/convert-curl-command-into-python-using-requests  # noqa E501
                               headers=headers)

    # close session
    nextcloud_session.close()

    if x.status_code == 201:
        print("Post successful (" + str(x.status_code) + "): " + host +
              "/index.php/call/" + room)
    else:
        print("Post failed: " + str(x.status_code))


host = 'https://cloud.ecosysl.net'
id = get_username()  # Find username in user management view
password = get_password()

try:
    message = sys.argv[1]
    room = sys.argv[2]
except IndexError:
    raise SystemExit(f"Usage: {sys.argv[0]} <'message'> <'String ending talk chat room url'>")  # noqa E501

print("Message to post: " + message)
print("Room id: " + room)

nc_send_msg(host, room, id, password, message)
