#!/Users/bin/env/Python

"""
    @Author Samson Jacob 09.26.2018
    Purpose: For a given parent directory find the MultiQC output from the subfolder;
"""

import os
import re


def flat_lol(lol):
    return [val for subl in lol for val in subl]

def find_sub_direct(pth):
    direct = [os.path.join(pth, x) for x in os.listdir(pth)]
    dd = [os.path.abspath(x) for x in direct if os.path.isdir(x)] # list of all subdirectories
    return dd

def find_folder_w_multiqc(pth1):
    outlocs=[]
    all_folders = os.listdir(pth1) # get all the subfolders from the top level
    for sub in all_folders: # for each plate
        nupth= test+sub # create a new path to check
        outlocs.append(find_sub_direct(nupth))
    checks = [x for x in outlocs if len(x) > 0 ]# sanity check to ake sure no missing list items
    return flat_lol(checks)

def find_texts(pth,target="multiqc_fastqc.txt"):
    out=[]
    y = find_folder_w_multiqc(pth)
    multi= flat_lol(map(find_sub_direct, y))
    multi= flat_lol(map(find_sub_direct,multi))
    for cor in multi:
        out.append([os.path.join(cor, x) for x in os.listdir(cor) if target in x][0])
    return out





