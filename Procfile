release: python server/manage.py migrate --noinput
web: gunicorn --chdir server unconf.wsgi --bind 0.0.0.0:$PORT
