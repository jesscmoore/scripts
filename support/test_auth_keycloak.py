import time
import getpass
import requests


def login(username: str, password: str, client: str, endpoint: str) -> dict:
    """
    Login and retrieve token
    """
    headers = {'Content-Type': 'application/x-www-form-urlencoded'}
    payload = {
        'client_id': client,
        'grant_type': 'password',
        'username': username,
        'password': password
    }
    r = requests.post(endpoint, data=payload, headers=headers)
    if r.status_code == 200:
        return r.json()
    else:
        r.raise_for_status()


def refresh_token(token: dict, client: str, endpoint: str) -> dict:
    """
    Refresh token 
    """
    headers = {'Content-Type': 'application/x-www-form-urlencoded'}
    payload = {
        'client_id': client,
        'grant_type': 'refresh_token',
        'refresh_token': token['refresh_token'],
        'scope': token['scope']
    }
    r = requests.post(endpoint, data=payload, headers=headers)
    if r.status_code == 200:
        return r.json()
    else:
        r.raise_for_status()


if __name__ == '__main__':
    username = input('User UID: ')
    password = getpass.getpass(prompt='Password: ')
    
    my_realm = 'fais_plus_dev'
    my_client = 'fais_plus_app'
    endpoint = f'http://localhost:8080/realms/{my_realm}/protocol/openid-connect/token'
    
    try:
        print('\nLogin and retrieve token')
        token = login(username, password, my_client, endpoint)

        print(f'Successfully authenticated, the token will expire in {token["expires_in"]} seconds\n')
        duration = token['expires_in'] + 1

        print('\nAccess token:')
        print(token['access_token'])

        print(f'\nSleep for {duration} seconds...\n')
        time.sleep(duration)

    except Exception as e:
        print(str(e))
        
    finally:
        print('\nRefresh token')
        token = refresh_token(token, my_client, endpoint)

        print(f'Successfully refreshed, the access token will expire in {token["expires_in"]} seconds\n')

