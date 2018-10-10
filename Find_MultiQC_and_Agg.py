#!/Users/bin/env/Python

"""
    @Author Samson Jacob 09.26.2018
    Purpose: For a given parent directory find the MultiQC output from the subfolders (currently 2 layers down);
    then combine all the results from all of the subdirectories for data visualization in MultiQC_generic.py script

"""
import os
import re
import pandas as pd
import sys

def flat_lol(lol):
    """
    Flattens list of lists

    :param lol: list of lists
    :return: flattened list of lists
    """
    return [val for subl in lol for val in subl]

def find_sub_direct(pth):
    """
    Finds subdirectories from parent path

    :param pth: parentpath (str)
    :return: list of subdirectories (list)
    """
    direct = [os.path.join(pth, x) for x in os.listdir(pth)]
    dd = [os.path.abspath(x) for x in direct if os.path.isdir(x)] # list of all subdirectories
    return dd

def find_folder_w_multiqc(pth1):
    """
    Helper function for discovering subfolders within a parent directory
    NOTE: This will fail to get to the next level if there are more than 1 subdirectories ;
    It is designed to find FASTQC results folder from Plate Folder and MULTIQC results folder
    from FASTQC results folder



    :param pth1: path to directory (str)
    :return: a flattened list of lists of subdirectories
    """
    outlocs=[]
    all_folders = os.listdir(pth1) # get all the subfolders from the top level
    for sub in all_folders: # for each plate
        nupth= test+sub # create a new path to check
        outlocs.append(find_sub_direct(nupth))
    checks = [x for x in outlocs if len(x) > 0 ]# sanity check to ake sure no missing list items
    return flat_lol(checks)

def find_texts(pth,target="multiqc_fastqc.txt"):
    """

    :param pth: main folder path (str)
    :param target: name of the file that contains the important results from FASTQC (str)

    :return: a full path to the location of the target for loading into pandas (str)
    """
    out=[]
    y = find_folder_w_multiqc(pth)
    multi= flat_lol(map(find_sub_direct, y))
    multi= flat_lol(map(find_sub_direct,multi))
    for cor in multi:
        out.append([os.path.join(cor, x) for x in os.listdir(cor) if target in x][0])
    return out

def plate_name_frompath(strofpath):
    """ Get the name of the Plate from the Parent directory

    :param strofpath: parent directory path (str)
    :return: sample plate (str)
    """
    #rgx=r'(?<=/RESULTS_)(.*)(?=_Merged_multiqc)'
    rgx=r'(?=[^\/]*$)(.*)(?=_Merged)' # everything after the last slash but before _Merged
    return(str(re.findall(rgx, strofpath)[0]))


def read_in_doc_add_plate_col(doc,parent):
    """

    :param doc: location of the target file (str)
    :param parent: location of the parent directory (str)
    :return: dataframe with Plate Name column and corrected Patient IDs (Pandas DataFrame)
    """
    df = pd.read_table(doc,sep='\t',engine='python')
    col = plate_name_frompath(parent)
    df['Plate']=col
    df['Patient_ID']= df.Sample.replace('merged_R*\d','',regex=True)
    return df

if __name__ == '__main__':
    dflist=[] # establish an empty list to retain all of the resultant dataframes for each plate
    test = sys.argv[1] # should be a path to the top directory containing the plates
    parent_lis = find_sub_direct(test) # assumes all folders have results
    location_of_files= find_texts(test) # get the locations of the multiqc output file of interest
    for x,i in zip(location_of_files,parent_lis):
        dflist.append(read_in_doc_add_plate_col(x,i)) # extract the dataframe per plate and append to list
    merged = pd.concat(dflist) # concatenate
    merged.columns = [c.replace('.', '_') for c in merged.columns] # correct columns
    merged.columns = [c.replace(' ', '_') for c in merged.columns] # correct columns
    merged['XID'] = merged.groupby(['Patient_ID']).ngroup()
    merged.XID = merged.XID + 2
    merged.XID = merged.XID * 2
    merged.to_csv('MULTIQC_AGGREGATED_RESULTS.csv')


