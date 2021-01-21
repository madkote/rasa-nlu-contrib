#!/usr/bin/env python
# -*- coding: utf-8 -*-
# demo
'''
:author:    madkote
:contact:   madkote(at)bluewin.ch
:copyright: Copyright 2021, madkote RES

demo
---------
Module
'''

from __future__ import absolute_import

import argparse
import logging
import os
import pprint

from rasa_nlu.model import Interpreter
from rasa_nlu.server import main as main_server
from rasa_nlu.train import train

from rasa_nlu.version import __version__

__all__ = []
__author__ = 'madkote <madkote(at)bluewin.ch>'
__version__ = str(__version__)
__copyright__ = 'Copyright 2021, madkote RES'

DEMO_TYPES = ['api', 'http']

model_name = 'nlu'
project_name = 'project_demo'

here = os.path.abspath(os.path.dirname(__file__))
path_config = os.path.join(here, 'sample_configs', 'config_supervised_embeddings.yml')  # noqa E501
path_data = os.path.join(here, 'data', 'examples', 'rasa', 'demo-rasa.md')
path_models = os.path.join(here, 'demo_models')


def demo_python_api(verbose=False):
    trainer, interpreter, persisted_path = train(  # @UnusedVariable
        path_config,
        path_data,
        path=path_models,
        project=project_name,
        fixed_model_name=model_name
    )
    message = "let's see some italian restaurants"
    result = interpreter.parse(message)
    if not verbose:
        pprint.pprint(result)
    #
    interpreter = Interpreter.load(
        os.path.join(path_models, project_name, model_name)
    )
    message = "let's see some italian restaurants"
    result = interpreter.parse(message)
    if not verbose:
        pprint.pprint(result)


def demo_http_api():
    demo_python_api(verbose=True)
    args = argparse.Namespace(
        path=path_models,
        #
        port=5000,
        loglevel=logging.DEBUG,
        pre_load= [],
        endpoints=None,
        config=None,
        max_training_processes=1,
        response_log=None,
        emulate=None,
        storage=None,
        wait_time_between_pulls=10,
        write=None,
        num_threads=1,
        token=None,
        cors='*'
    )
    main_server(args)


def get_parser(version):
    '''
    Get command line parser
    :param path_root: root path of application
    :param version: version of the application
    :return: command line parser
    '''
    parser = argparse.ArgumentParser(
        description='NLU demo',
        formatter_class=argparse.RawDescriptionHelpFormatter
    )
    parser.add_argument(
        dest='demo',
        default='api',
        choices=DEMO_TYPES,
        help='Demo types: %s' % DEMO_TYPES
    )
    parser.add_argument(
        '-v', '--verbose',
        default=1,
        dest='verbose',
        action='count',
        help='set verbosity level [default: %(default)s]'
    )
    parser.add_argument(
        '-V', '--version',
        action='version',
        version=version
    )
    return parser


def main():
    parser = get_parser(__version__)
    params = parser.parse_args()
    if params.demo == 'api':
        demo_python_api()
    elif params.demo == 'http':
        demo_http_api()
    else:
        raise NotImplementedError('demo for %s not implemented' % params.demo)


if __name__ == '__main__':
    main()
