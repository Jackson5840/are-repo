from flask import Flask
from flask_apscheduler import APScheduler
import os


class Config(object):
    JOBS = [
        {
            'id': 'job1',
            'func': 'are.check:job1',
            'args': ['/home/bljungqu/temp/neumo/data/'],
            'trigger': 'interval',
            'minutes': 1
        }
    ]

    SCHEDULER_API_ENABLED = True





if __name__ == '__main__':
    app = Flask(__name__)
    app.config.from_object(Config())

    scheduler = APScheduler()
    # it is also possible to enable the API directly
    # scheduler.api_enabled = True
    scheduler.init_app(app)
    scheduler.start()

    app.run()