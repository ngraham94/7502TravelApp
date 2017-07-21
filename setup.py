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
    'SMTP_PASSWORD': {
        'description': """Don't worry about this on localhost.
                        This is production only."""
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
"""A list of properties for each key that can be found in .env.template"""

def process_line(line):
    """Prompt user to fill a KEY=VALUE pair if the argument has one
    
    If the argument is either empty, whitespace, or a comment starting 
    with '#', then the argument is returned unmutated.
    
    If the argument is a KEY=VALUE pair, where KEY is found in `FIELDS`,
    then VALUE will be filled in, either by a default value specified
    either in `FIELDS` or `line`, or a user-supplied value. The order
    of precedence for VALUE is as follows:
    
        1. User-Supplied Value
        2. Default value found in `FIELDS`
        3. Default value found in `line`
        
    VALUE cannot be empty, and nor can there be a space on either side
    of the `=` sign.
    
    After VALUE has been assigned, the modified KEY=VALUE pair is returned
    as a string.
    
    Args:
        line (str): A single line from .env.template
    
    Returns:
        str: If `line` is a KEY=VALUE pair, then VALUE will be filled in 
        accordingly. Otherwise, the original string.
    """
    # Check if line is valid. If not, return it.
    stripped = line.strip()
    if not len(stripped) or stripped[0] is "#":
        return line
    # Set value accordingly, if it is a key-value pair split by '='
    split_line = stripped.split('=')
    if split_line[0] in FIELDS:
        key = split_line[0]
        vals = FIELDS[split_line[0]]
        ans = ""
        print('\n')
        while not ans:
            prompt = str(vals['description'])
            #length_line = len(split_line)
            default_val = ""
            if len(split_line) >= 2:
                default_val = split_line[1]
                if 'default' in vals:
                    default_val = vals['default']
                if default_val:
                    prompt += ' [default: ' + default_val + ']'
                if 'subdir' in vals:
                    prompt += \
                        '\n(Must be subdirectory of $DIR_STORAGE)'
            prompt += ': ' + split_line[0] + '='
            ans = str(raw_input(prompt))
            ans = ans if ans else default_val
        ans = ans.strip()
        if 'fscheck' in vals and vals['fscheck']:
            while ans.endswith('/') or ans.endswith('\\'):
                ans = ans[:-1]
        return "" + key + "=" + ans + '\n'
    return line

if __name__ == '__main__':
    with open(ENV_FILE_URL, 'w') as env:
        with open(TEMPLATE_URL, 'rU') as template:
            for line in template:
                env.write(process_line(line))
