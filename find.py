#!/usr/bin/env python3

from typing import Any
import os
import argparse

##
## FUNCTIONS
##

def contains(value: Any, element: str) -> bool:
    """
    Check if the value contains the given element
    """
    try:
        value.index(element)
        return True
    except:
        return False


def main():
    ##
    ## ARGUMENT PARSER
    ##

    parser = argparse.ArgumentParser(
            description='Find a content in files'
        )
    parser.add_argument(
            'search',
            type=str,
            help='The string you want to search for'
        )
    parser.add_argument(
            '--extensions',
            help='Specify the extensions of the files you want to search in',
            required=True
        )

    args = parser.parse_args()

    ##
    ## ARGUMENT FETCHING
    ##

    ext_payload = args.extensions
    extensions = ext_payload[0:len(ext_payload)].split(',')
    search = args.search

    ##
    ## FILE ALGORITHM
    ##

    for root, _, files in os.walk(os.getcwd()):
        for file in files:
            try:
                _, fe = os.path.splitext(file)

                fpath = os.path.join(root, file)
                if contains(extensions, fe[1:]):
                    with open(fpath) as f:
                        content = ''.join(f.read())
                        if contains(content, search):
                            print('[Success] ' + fpath)
            except Exception as e:
                print('Error in file: ' + file)
                print(e)

# Only executes the script if it is runned by the console,
# so it doesn't be runned if it gets imported by an
# other script 
if __name__ == '__main__':
    main()
