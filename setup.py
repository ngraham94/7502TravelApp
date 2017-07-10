from shutil import copyfile
import sys

DOCKER_DIR = "./docker/vacation"
ENV_FILE_URL = DOCKER_DIR + '/.env'
TEMPLATE_URL = ENV_FILE_URL + '.template'

FIELDS = {
    'PG_USER': {
        'description': 'PostGres User',
    },
    'PG_PASSWORD': {
        'description': 'PostGres User\'s Password',
    },
    'DRUPAL_DB_NAME': {
        'description': 'Database Name',
        'default': 'drupal'
    },
    'DIR_STORAGE': {
        'description': 'Persistent Storage Directory URL',
        'fscheck': True,
        'subdir': False
    },
    'DIR_MODULES': {
        'description': 'Persistent Storage Directory URL',
        'fscheck': True,
        'subdir': True
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
    }
}

def process_line(line):
    stripped = line.strip()
    if not len(stripped) or stripped[0] is "#":
        return line
    split_line = stripped.split('=')
    for key, val in FIELDS.items():
        if key == split_line[0]:
            ans = ""
            while not ans:
                prompt = str(val['description'])
                length_line = len(split_line)
                if len(split_line) >= 2 and split_line[1]:
                    prompt += ' [default: ' + split_line[1] + ']'
                    if 'subdir' in val and val['subdir']:
                        prompt += \
                            '\n(Must be subdirectory of $DIR_STORAGE)'
                prompt += ': ' + key + '='
                ans = str(raw_input(prompt))
                ans = ans if ans else split_line[1]
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
