#!/usr/bin/env python
# coding=utf-8

import os as os
import sys as sys
import csv as csv
import traceback as trb
import argparse as argp
import collections as col
import getpass as gp
import socket as sck
import logging as log
import time as ti
import operator as op


__version__ = '0.1'
__developer__ = 'Peter Ebert'
__email__ = 'peter.ebert@iscb.org'
__log_format__ = '%(asctime)s - %(levelname)s: %(message)s'


def parse_command_line():
    """
    :return:
    """
    parser = argp.ArgumentParser(prog='standardize_peak_files')
    parser.add_argument('--version', '-v', action='version', version='%(prog)s ' + __version__)
    parser.add_argument('--debug', '-dbg', action='store_true', default=False, dest='debug',
                        help='Set this switch to activate debug logging messages to stderr.')
    parser.add_argument('--pipeline-version', '-ppv', type=str, required=True, dest='pipeversion',
                        help='Specify the pipeline version of the DEEP ChIP-seq pipeline'
                             ' (e.g., CHPv5). Default: <empty>')
    parser.add_argument('--sample-table', '-st', type=str, required=True, dest='sampletable',
                        help='Specify the full path to the sample annotation table that'
                             ' is also used during the pipeline initialization. Default: <emtpy>')

    parser.add_argument('--output', '-o', type=str, required=True, dest='output',
                        help='Specify the full path to the metadata output file. If the path'
                             ' does not exist, it will be created.')


    args = parser.parse_args()
    return args


def prepare_section_description(args):
    """
    :param args:
    :return:
    """
    pipe_ver = args.pipeversion
    user = gp.getuser()
    host = sck.getfqdn()
    wd = os.getcwd()
    timestamp = '"' + ti.ctime() + '"'
    sect_desc = col.OrderedDict([('pipeline_version', pipe_ver),
                                 ('user', user), ('host', host),
                                 ('working_dir', wd), ('timestamp', timestamp)])
    return sect_desc


def prepare_section_inputs(args):
    """
    Extract input file information from initial
    sample annotation sheet.

    :param args:
    :return:
    """
    records = []
    items_list = set()
    # define a list of accepted prefixes
    # for column names that refer to the same
    # entity type, e.g., filename_1 and filename_2
    prefixes = ['filename', 'checksum']
    raw_colum = set()
    prefix_column = set()
    with open(args.sampletable, 'r') as tab:
        header = tab.readline().split('\t')
        for h in header:
            if h in ['sample_label', 'filetype', 'filename']:
                raw_colum.add(h)
                items_list.add(h)
            else:
                if any([h.startswith(p) for p in prefixes]):
                    prefix_column.add(h)
                    items_list.add(h)
    assert 'sample_label' in items_list, \
        'Unique sample label is required - \
        could not find "sample_label" column in sample annotation'
    records = col.defaultdict(list)
    with open(args.sampletable, 'r') as tab:
        rows = csv.DictReader(tab, delimiter='\t')
        for row in rows:
            subset = {k: row[k] for k in items_list}
            label = subset['sample_label']
            for k, v in subset.items():
                if k == 'sample_label':
                    continue
                if k in raw_colum:
                    records[label].append(v)
                elif k in prefix_column:
                    prefix = [p for p in prefixes if k.startswith(p)]
                    assert len(prefix) == 1, 'Could not identify column prefix: {} / {}'.format(k, prefix)
                    prefix = prefix[0]
                    records[label + '_' + prefix].append(v)
                else:
                    raise AssertionError('Encountered unexpected column: {} / {}'.format(args.sampletable, k))
    sect_inputs = col.OrderedDict()
    for md_entry in sorted(records.keys()):
        sect_inputs[md_entry] = ','.join(records[md_entry])
    return sect_inputs  


def main():
    """
    :return:
    """
    args = parse_command_line()
    if args.debug:
        log.basicConfig(**{'stream': sys.stderr, 'level': log.DEBUG, 'format': __log_format__})
    else:
        log.basicConfig(**{'stream': sys.stderr, 'level': log.WARNING, 'format': __log_format__})
    logger = log.getLogger()
    logger.debug('Logger initialized')
    logger.debug('Preparing section: pipeline description')
    sect_desc = prepare_section_description(args)
    logger.debug('Preparing section: input files')
    sect_inputs = prepare_section_inputs(args)




if __name__ == '__main__':
    try:
        main()
    except Exception:
        trb.print_exc()
        sys.exit(1)
    else:
        sys.exit(0)
