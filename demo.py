#!/usr/bin/env python
# -*- coding: utf-8 -*-
# setup
'''
:author:    madkote
:contact:   madkote(at)bluewin.ch
:copyright: Copyright 2021, madkote

demo
-----
Demo script
'''

# import json
import os
import pprint

from rasa_nlu.model import Interpreter
from rasa_nlu.train import train


def main():
    here = os.path.abspath(os.path.dirname(__file__))
    #
    # data
    data = os.path.join(here, 'data', 'examples', 'rasa', 'demo-rasa.md')
    #
    # configuration
    config = os.path.join(here, 'sample_configs', 'config_supervised_embeddings.yml')
    #
    # train
    trainer, interpreter, persisted_path = train(
        config,
        data,
        path=os.path.join(here, 'demo_models'),
        project='project_current',
        fixed_model_name='nlu'
    )
    message = "let's see some italian restaurants"
    result = interpreter.parse(message)
    # print(json.dumps(result, indent=2))
    pprint.pprint(result)
    #
    #
    interpreter = Interpreter.load(os.path.join(here, 'demo_models', 'project_current', 'nlu'))
    message = "let's see some italian restaurants"
    result = interpreter.parse(message)
    # print(json.dumps(result, indent=2))
    pprint.pprint(result)


if __name__ == '__main__':
    main()
