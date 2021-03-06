#!/usr/bin/python2.7
from itertools import izip
import sys, getopt

def _count_lines_and_errors(answers, predictions):
    lines = errors = 0
    for a, p in izip(answers, predictions):
        a = float(a.split(',')[1])
        p = float(p)
        lines += 1
        if a != p:
            # print 'Got mismatch on line ' + str(lines) + ' with a=' + str(a) + ' and p=' + str(p)
            errors += 1

    return lines, errors


if __name__ == '__main__':
    try:
        if len(sys.argv) != 5:
            raise getopt.GetoptError('Must specify exactly 2 arguments -a "answers_file.csv" and -p "preditions_file"')
        opts, args = getopt.getopt(sys.argv[1:], "a:p:")
    except getopt.GetoptError as err:
        print str(err)
        sys.exit(1)

    answers = predictions = None
    for o, a in opts:
        if o == '-a':
            answers = a
        elif o == '-p':
            predictions = a

    if answers is None or predictions is None:
        print 'Must specify exactly 2 arguments -a "answers_file.csv" and -p "preditions_file"'
        sys.exit(1)

    with open(answers, 'r') as A, open(predictions, 'r') as P:
        lines, errors = _count_lines_and_errors(A, P)
        print 'Results are ' + str(lines) + ' and ' + str(errors) + ' errors'
        print 'Error ratio: ' + str(float(errors)/lines)
