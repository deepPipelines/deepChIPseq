#!/usr/bin/env python
# coding=utf-8

import os as os
import sys as sys
import io as io
import csv as csv
import argparse as argp
import traceback as trb


__version__ = '0.1'
__developer__ = 'Peter Ebert'
__email__ = 'peter.ebert@iscb.org'


def parse_command_line():
    """
    :return:
    """
    parser = argp.ArgumentParser(prog='standardize_peak_files')
    parser.add_argument('--version', '-v', action='version', version='%(prog)s ' + __version__)
    parser.add_argument('--input-format', '-if', choices=['histoneHMM', 'macs2'],
                        required=True, dest='inputformat',
                        help='Specify the input format of the peak files. Options'
                             ' are histoneHMM or macs2')
    parser.add_argument('--peak-file', '-pf', type=str, dest='peakfile', required=True,
                        help='Specify path to peak file.')
    parser.add_argument('--blacklist-overlap', '-blo', type=str, dest='blacklistovl', required=True,
                        help='Specify path to file containing peaks overlapping'
                             ' with blacklist regions.')
    parser.add_argument('--input-overlap', '-ipo', type=str, dest='inputovl', required=False,
                        help='Specify path to file containing histone peaks that'
                             ' overlap peaks called on the input control. Only required'
                             ' for input format histoneHMM')
    parser.add_argument('--output', '-o', type=str, dest='output', required=True,
                        help='Specify full path to desired output file.'
                             ' If the directory path to the file does'
                             ' not exist, it will be created.')
    args = parser.parse_args()
    return args


def read_flagged_peaks(fpath):
    """
    :param fpath:
    :return:
    """
    flagged = set()
    with open(fpath, 'r') as bed:
        for line in bed:
            if line.strip():
                cols = line.split('\t')
                # record location of peaks that
                # overlap with either the blacklist
                # or with input peaks
                flagged.add('-'.join(cols[:3]))
    return flagged


def rescale_scores(scores):
    """
    Simple min-max scaling w/o introducing additional
    dependencies (e.g., numpy)

    :param scores:
    :return:
    """
    max_score = max(scores)
    min_score = min(scores)
    scores = [int(min(((x - min_score) / (max_score - min_score) * 1000), 1000)) for x in scores]
    return scores


def standardize_histonehmm(cli_args):
    """
    :param cli_args:
    :return:
    """
    peakfile = cli_args.peakfile
    blacklist_file = cli_args.blacklistovl
    input_file = cli_args.inputovl

    # Assuming that the code is supposed to
    # generalize to other file naming schemas,
    # the following can no longer be assumed
    # to work...
    # if '_Input_' in peakfile:
    #     inputenriched = set()
    # else:
    #     inputenriched = read_flagged_peaks(input_file)

    # ===================================================
    # this might break depending on the pipeline call
    # has to be tested with real data
    inputenriched = read_flagged_peaks(input_file)
    # ===================================================

    blacklisted = read_flagged_peaks(blacklist_file)
    peak_header = ['chrom', 'start', 'end', 'dist']
    sample_id, _ = os.path.basename(peakfile).split('.', 1)
    peaks = []
    with open(peakfile, 'r') as table:
        rows = csv.DictReader(table, delimiter='\t', fieldnames=peak_header)
        for ln, row in enumerate(rows, start=1):
            row['linenum'] = ln
            row['strand'] = '.'
            key = '-'.join([row['chrom'], row['start'], row['end']])
            if key in inputenriched:
                row['name'] = 'INPUTENRICHED'
            if key in blacklisted:
                row['name'] = 'BLACKLISTED'
            if 'name' not in row:
                row['name'] = sample_id + '_peak_' + str(ln)
            post, _ = row['dist'].split(';')
            post = float(post.replace('avg_posterior=', ''))
            score = min(int(post * 1000), 1000)
            row['score'] = score
            row['signalValue'] = round(post, 5)
            row['pValue'] = -1
            row['qValue'] = -1
            peaks.append(row)
    peaks = sorted(peaks, key=lambda d: (d['chrom'], int(d['start'])))
    header = ['chrom', 'start', 'end', 'name', 'score',
              'strand', 'signalValue', 'pValue', 'qValue']
    outbuffer = io.StringIO()
    # extrasection=ignore gets rid of the line number
    writer = csv.DictWriter(outbuffer, delimiter='\t',
                            extrasaction='ignore', fieldnames=header)
    writer.writerows(peaks)
    return outbuffer


def standardize_macs(cli_args):
    """
    :param cli_args: Namespace object
    :return:
    """
    peakfile = cli_args.peakfile
    assert os.path.isfile(peakfile), 'Path to peak file is invalid: {}'.format(peakfile)
    blacklist = cli_args.blacklistovl
    assert os.path.isfile(blacklist), 'Path to blacklist overlap file is invalid: {}'.format(blacklist)
    if peakfile.endswith('narrowPeak'):
        header = ['chrom', 'start', 'end', 'name', 'score', 'strand',
                  'signalValue', 'pValue', 'qValue', 'peak']
    elif peakfile.endswith('broadPeak'):
        header = ['chrom', 'start', 'end', 'name', 'score', 'strand',
                  'signalValue', 'pValue', 'qValue']
    else:
        raise ValueError('Unrecognized peak file format: {}'.format(peakfile))
    blacklisted = read_flagged_peaks(blacklist)
    peaks = []
    scores = []
    with open(peakfile, 'r') as table:
        rows = csv.DictReader(table, delimiter='\t', fieldnames=header)
        for ln, row in enumerate(rows):
            key = '-'.join([row['chrom'], row['start'], row['end']])
            if key in blacklisted:
                row['name'] = 'BLACKLISTED'
            # this just to keep original MACS sorting order
            row['linenum'] = ln
            peaks.append(row)
            # not clear how exactly MACS is computing the score,
            # but narrow/broadPeak format requires score to be in the range
            # 0...1000, so collect and rescale later
            scores.append(int(row['score']))
    scores = rescale_scores(scores)
    for pk, score in zip(peaks, scores):
        pk['score'] = score
    peaks = sorted(peaks, key=lambda d: d['linenum'])
    outbuffer = io.StringIO()
    # the extrasection=ignore is needed
    # to ignore the line numbers
    writer = csv.DictWriter(outbuffer, fieldnames=header,
                            delimiter='\t', extrasaction='ignore')
    writer.writerows(peaks)
    return outbuffer


def main():
    """
    :return:
    """
    cargs = parse_command_line()
    if cargs.inputformat == 'macs2':
        norm_peaks = standardize_macs(cargs)
    elif cargs.inputformat == 'histoneHMM':
        norm_peaks = standardize_histonehmm(cargs)
    else:
        # this is avoided by choices, but triggers
        # in case the above if is not updated
        raise ValueError('Unknown input format: {}'.format(cargs.inputformat))
    fpath = os.path.dirname(cargs.output)
    os.makedirs(fpath, exist_ok=True)
    with open(cargs.output, 'w') as dump:
        _ = dump.write(norm_peaks.getvalue())
    return 0


if __name__ == '__main__':
    try:
        main()
    except Exception:
        trb.print_exc()
        sys.exit(1)
    else:
        sys.exit(0)
