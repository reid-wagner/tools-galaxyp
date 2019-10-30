"""Create paramter xml file for a specific MaxQuant version from yaml or command line input
and a template parameter file.
"""

import argparse
import os

from mqparam import MQParam

parser = argparse.ArgumentParser()

parser.add_argument('--yaml', '-y', help="""Yaml config file. Only those parameters differing
from the template need to be specified.""")

parser.add_argument('--exp_design', '-e', help="Experimental design template as it is created by the MaxQuant GUI.")

parser.add_argument('template', help="Template Parameter File.")

parser.add_argument('--mqpar_out', '-o', help="Output file, will be ./mqpar.xml if omitted.")

parser.add_argument('--substitution_rx', '-s', help="""Regular expression for filename substitution.
Necessary for usage in the Galaxy tool. Can usually be ignored.""")

parser.add_argument('--version', '-v', help="""A version number. Raises exception if it doesn't
match the MaxQuant version of the template. For usage in the Galaxy tool.""")

args = parser.parse_args()
kwargs = dict()
if args.substitution_rx:
    kwargs['substitution_rx'] = ''
else:
    mqparam = MQParam(args.template, args.exp_design)
if args.version and mqparam.version != args.version:
    raise Exception('mqpar version is ' + mqparam.version +
                    '. Tool uses version {}.'.format(args.version))

mqparam.from_yaml(args.yaml)

mqparam.write(args.mqpar_out if args.mqpar_out else 'mqpar.xml')
