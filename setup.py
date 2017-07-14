#!/usr/bin/python

from shutil import copyfile
import sys
import os

DOCKER_DIR = "./docker/vacation"
ENV_FILE_URL = DOCKER_DIR + '/.env'
TEMPLATE_URL = ENV_FILE_URL + '.template'

FIELDS = {
    'SITE': {
        'description': """
            Domain Name of hosted site. To stop HTTPS,
            you must explicitly declare protocol and port
            in the URL. i.e.: http://site.com:80"""
    },
    'PG_USER': {
        'description': 'PostGres User',
    },
    'PG_PASSWORD': {
        'description': 'PostGres User\'s Password',
    },
    'DRUPAL_DB_NAME': {
        'description': 'Database Name'
    },
    'DIR_STORAGE': {
        'description': 'Persistent Storage Directory URL',
        'default': str(os.getcwd()),
        'fscheck': True,
        'subdir': False
    },
    'DIR_PROFILES': {
        'description': 'Persistent Storage Directory URL',
        'fscheck': True,
        'subdir': True
    },
    'DIR_SITES': {
        'description': 'Persistent Storage Directory URL',
        'fscheck': True,
        'subdir': True
    },
    'DIR_THEMES': {
        'description': 'Persistent Storage Directory URL',
        'fscheck': True,
        'subdir': True
    },
    'DIR_LIBRARIES': {
        'description': 'Persistent Storage Directory URL',
        'fscheck': True,
        'subdir': True
    },
    'DRUPAL_UID': {
        'description': 'UID of executing Drupal instance',
        'default': str(os.geteuid())
    },
    'DRUPAL_GID': {
        'description': 'GID of executing Drupal instance',
        'default': str(os.getegid())
    }
}

def process_line(line):
    # Check if line is valid. If not, return it.
    stripped = line.strip()
    if not len(stripped) or stripped[0] is "#":
        return line
    # Set value accordingly, if it is a key-value pair split by '='
    split_line = stripped.split('=')
    for key, val in FIELDS.items():
        if key == split_line[0]:
            ans = ""
            print('\n')
            while not ans:
                prompt = str(val['description'])
                length_line = len(split_line)
                if len(split_line) >= 2 and split_line[1]:
                    default_val = split_line[1]
                    if 'default' in val and val['default']:
                        default_val = str(val['default'])
                    prompt += ' [default: ' + default_val + ']'
                    if 'subdir' in val and val['subdir']:
                        prompt += \
                            '\n(Must be subdirectory of $DIR_STORAGE)'
                prompt += ': ' + key + '='
                ans = str(raw_input(prompt))
                ans = ans if ans else default_val
            ans = ans.strip()
            if 'fscheck' in val and val['fscheck']:
                while ans.endswith('/') or ans.endswith('\\'):
                    ans = ans[:-1]
            return "" + key + "=" + ans + '\n'
    return line



if __name__ == '__main__':
    with open(ENV_FILE_URL, 'w') as env:
        with open(TEMPLATE_URL, 'rU') as template:
            for line in template:
                env.write(process_line(line))
