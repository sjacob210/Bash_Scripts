#!/Users/bin/env/Python

"""
    @Author Samson Jacob 09.26.2018
    Purpose: Generified Script to produce categorical and Numerical Output from MultiQC aggregated file
"""
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import re
import sys
import datetime
import os

# categorical columns in the MultiQC resultant file
categorical_cols=['sequence_duplication_levels','adapter_content','per_base_sequence_content','per_base_sequence_quality','sequence_length_distribution','basic_statistics','overrepresented_sequences','per_sequence_gc_content','per_tile_sequence_quality']
# Color pallete for categorical columns (Stoplight)
palette3 ={"pass":"green","warn":"orange","fail":"red"}

# get values for 5,10 and 20 million in log2
ten_mil = np.round(np.log2(10000000),2)
twe_mil = np.round(np.log2(20000000),2)
fiv_mil = np.round(np.log2(5000000),2)


def create_folder(pth):
    """ create a folder to hold all the generated plots

    :param pth: parent path to create subfolder (str)
    :return: creates a new dir; and moves into that dir
    """
    cur = pth # get the name of the desired directory
    result_dir = 'FASTQC_results' +'_' + datetime.datetime.now().strftime("%Y-%m-%d-%H-%M") # create new path name
    newpth = os.path.join(cur,result_dir) # join cwd to
    os.makedirs(newpth)
    os.chdir(newpth)


def correct_pth(strofpath,val='/MULTI'):
    """ Get the path where the MULTICSV file is

    :param strofpath: parent directory path containing .csv file (str)
    :return: parent plate of the  (str)
    """
    rgx = r'.*?(?=(?:%s)|$)' % (val)
    return(str(re.findall(rgx, strofpath)[0]))

if __name__ == '__main__':

    # load the results
    res = pd.read_csv(sys.argv[1]) # load csv of the resultant files

    #output directory
    outputname=correct_pth(sys.argv[1])
    print(outputname)
    create_folder(outputname)

    # total _seqs
    totalseqs = res[['XID', 'Plate', 'Patient_ID', 'Total_Sequences']]
    totalseqs['lg2_Seqs'] = totalseqs['Total_Sequences'].apply(np.log2)

    # plot the total sequences after log2 transform
    p = sns.stripplot(x='Patient_ID', y='lg2_Seqs', data=totalseqs, hue="Plate", jitter=False, alpha=.5, edgecolor="grey",size=3)

    p_ax = p.axes

    plt.legend(loc='lower center', bbox_to_anchor=(0.5, 1.05), ncol=7, fancybox=True, shadow=True, prop={'size': 5})
    plt.tick_params(axis='x', which='both', bottom=False, top=True, labelbottom=False)
    p_ax.set_xlim(-5, 270)

    # add a line at 20/10 million
    # TODO show the names of the samples that fall below 10 million
    # TODO organize the samples by plate name or sort of some kind

    plt.hlines(y=ten_mil, xmin=-5, xmax=270, color='green')
    plt.text(270, ten_mil, '10 Million Sequences %s' % (ten_mil), ha='left', color='green')
    plt.hlines(y=twe_mil, xmin=-5, xmax=270)
    plt.text(270, twe_mil, '20 Million Sequences %s' % (twe_mil), ha='left')
    plt.hlines(y=fiv_mil, xmin=-5, xmax=270, color='red')
    plt.text(270, fiv_mil, '5 Million Sequences %s' % (fiv_mil), ha='left', color='red')
    plt.tight_layout()
    plt.savefig('Total_Sequences.png', dpi=300,bbox_inches='tight')
    plt.clf()

    #bargraph per categorical
    for col in categorical_cols:
        grpby = (res.groupby(['Plate'])[col].value_counts(normalize=True).rename('percentage').mul(100).reset_index())
        grpby['colors'] = grpby[col].apply(lambda x: palette3[x]).fillna(np.nan)
        mydict = dict(zip(grpby[col].tolist(), grpby['colors'].tolist()))
        plot = sns.barplot(x="Plate", y="percentage", hue=col, data=grpby, palette=mydict)
        plname = str(col) + "_.png"
        plt.legend(bbox_to_anchor=(1.01, 1), loc=2, borderaxespad=0., ncol=1, fancybox=True, shadow=True, prop={'size': 10})
        plt.ylabel('Percentage', color='k', fontsize=10, weight='bold')
        plt.xlabel('Plate Name', color='k', fontsize=12, weight='bold')
        plt.title(str(col), fontsize=15, weight='bold', color='blue')
        plt.savefig(plname, dpi=300, bbox_inches='tight')
        plt.clf()