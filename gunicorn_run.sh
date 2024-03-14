#!/bin/bash
NAME="central"                                   # Name of the application
DJANGODIR=/home/ubuntu/central            # Django project directory
SOCKFILE=/home/ubuntu/vendor_management_system/run/gunicorn.sock   # we will communicate using this unix socket
USER=ubuntu                                     # The user to run as
GROUP=www-data                                   # The group to run as
NUM_WORKERS=3                                   # How many worker processes should Gunicorn spawn
DJANGO_SETTINGS_MODULE=vendor_management_system.settings          # Which settings file should Django use(if __inti__)
DJANGO_WSGI_MODULE=vendor_management_system.wsgi                  # WSGI module name
echo "Starting $NAME as `whoami`"
# Activate the virtual environment
cd $DJANGODIR
source /home/ubuntu/my-env/bin/activate
export DJANGO_SETTINGS_MODULE=$DJANGO_SETTINGS_MODULE
export PYTHONPATH=$DJANGODIR:$PYTHONPATH
# Create the run directory if it doesn't exist
RUNDIR=$(dirname $SOCKFILE)
test -d $RUNDIR || mkdir -p $RUNDIR
# Start your Django Unicorn
exec gunicorn ${DJANGO_WSGI_MODULE}:application \
  --name $NAME \
  --workers $NUM_WORKERS \
  --user $USER \
  --bind=unix:$SOCKFILE
  --log-level=debug \
  --log-file=-
