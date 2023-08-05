import time
import getpass
import requests


if __name__ == '__main__':
    username = input('User UID: ')
    password = getpass.getpass(prompt='Password: ')
    
    try:
        endpoint = 'http://localhost:9090/auth'
        # headers = {'Content-Type': 'application/x-www-form-urlencoded'}
        headers = {'Content-Type': 'application/json'}
        payload = {
            'client_id': 'fais_plus_app',
            'grant_type': 'password',
            'username': username,
            'password': password
        }
        # r = requests.post(endpoint, data=payload, headers=headers)
        r = requests.post(endpoint, json=payload, headers=headers)
        if r.status_code == 200:
            token = r.json()
        else:
            r.raise_for_status()

        print(f'\nLogin and retrieve token, token:\n{token}')

        duration = 5
        print(f'\nSleep for {duration} seconds...\n')
        time.sleep(duration)

        print('\nRefresh token')
        payload = {
            'client_id': 'fais_plus_app',
            'grant_type': 'refresh_token',
            'username': username,  # this is added due to the username check-list in auth/
            'refresh_token': token['refresh_token'],
            'scope': token['scope']
        }
        # r = requests.post(endpoint, data=payload, headers=headers)
        r = requests.post(endpoint, json=payload, headers=headers)
        if r.status_code == 200:
            token = r.json()
        else:
            r.raise_for_status()

        print(f'Successfully refreshed, new token:\n{token}')

    except Exception as e:
        print(str(e))

