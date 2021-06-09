#
# Util methods for api
#

import http
import json
import os
import requests
import socket

from api import app

def send_post(path, payload, debug=False):
    controller_url = get_controller_url()
    headers = {'Content-type': 'application/json', 'Accept': 'application/json'}
    if debug:
        http.client.HTTPConnection.debuglevel = 1
    response = requests.post(controller_url + path, headers = headers, data = json.dumps(payload))
    http.client.HTTPConnection.debuglevel = 0
    return response

def send_delete(path, debug=False):
    controller_url = get_controller_url()
    headers = {'Content-type': 'application/json', 'Accept': 'application/json'}
    if debug:
        http.client.HTTPConnection.debuglevel = 1
    response = requests.delete(controller_url + path, headers = headers)
    http.client.HTTPConnection.debuglevel = 0
    return response

def get_controller_url():
    return "{0}://{1}:{2}".format(
        app.config['CONTROLLER_SCHEME'],
        app.config['CONTROLLER_HOST'],
        app.config['CONTROLLER_PORT']
    )

def get_hostname():
    if 'hostname' in os.environ:
        hostname = os.environ['hostname']
    else:
        hostname = socket.gethostname()
    return hostname