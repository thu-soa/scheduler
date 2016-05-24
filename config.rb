require 'yaml'

yaml = YAML.load(File.read('./config.yml'))

AUTH_URL_PART_1 = yaml['urls']['auth_host']
AUTH_URL = AUTH_URL_PART_1 + yaml['urls']['auth_login_path']
USER_INFO_URL = AUTH_URL_PART_1 + yaml['urls']['auth_user_info_path']
