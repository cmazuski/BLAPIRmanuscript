import numpy as np
import os
import pandas as pd
from sklearn import metrics
from sklearn.metrics import roc_auc_score
from astropy.convolution import convolve, Gaussian1DKernel
from scipy import stats


def bar(group1, group2, colorscheme, ax_x):
    semgroup1 = stats.sem(group1)
    semgroup2 = stats.sem(group2)
    ax_x.bar((0, 1), (np.mean(group1), np.mean(group2)), facecolor='white', edgecolor=(colorscheme), lw=2,
             yerr=(semgroup1, semgroup2))
    return ax_x


def scatter(group1, number, color, ax_x):
    ax_x.scatter((np.full(len(group1), number)), group1, color=color, s=30, alpha=0.5, marker='P')
    return ax_x


def plotformat(ax_x):
    ax_x.grid(False)
    ax_x.set_facecolor('white')
    ax_x.spines['left'].set_color('k')
    ax_x.spines['bottom'].set_color('k')
    ax_x.spines['top'].set_color('white')
    ax_x.spines['right'].set_color('white')
    return ax_x


def extractSpikes(neuron, start, stop):
    neurontemp = neuron[neuron <= stop]
    neurontemp2 = neurontemp[neurontemp >= start]
    return neurontemp2


def firingrate(spiketimes, binsize, start, stop, smooth=False, smoothkernel=1):
    binrange = np.arange(start, stop, binsize)
    [fr, bins] = np.histogram(spiketimes, bins=binrange)
    if smooth:
        smoothed_fr = convolve(fr, Gaussian1DKernel(smoothkernel))
    else:
        smoothed_fr = fr
    return smoothed_fr


def extractspkfr(neu, binsize, time1, time2):
    spk = extractSpikes(neu, time1, time2)
    fr = firingrate(spk, binsize, time1, time2)
    return fr


def calcROC(firing1, firing2, exclusionthreshold=0):
    if np.sum(firing1) <= exclusionthreshold or np.sum(firing2) <= exclusionthreshold:
        auROC = np.nan
        fpr = np.nan
        tpr = np.nan
    else:
        firing = np.append(firing1, firing2)
        classifier = np.hstack((np.zeros(len(firing1)), np.ones(len(firing2))))
        fpr, tpr, thresholds = metrics.roc_curve(classifier, firing)
        auROC = roc_auc_score(classifier, firing)

    return auROC, fpr, tpr


def pullinfo(sheetname='FileInformation'):
    scope = ['https://spreadsheets.google.com/feeds', 'https://www.googleapis.com/auth/drive']
    creds = ServiceAccountCredentials.from_json_keyfile_name(
        'C:/Users/Cristina/Downloads/fileorganization-89aa77070ba6.json', scope)
    client = gspread.authorize(creds)
    sheet = client.open(sheetname)
    sheet_instance = sheet.get_worksheet(0)
    info = pd.DataFrame.from_dict(sheet_instance.get_all_records())
    return info


def makefolder(savepath):
    if not os.path.exists(savepath):
        os.mkdir(savepath)


def extractxyprob(coordinates, threshold=0.99):
    xcoord = coordinates[:, np.arange(0, coordinates.shape[1], 3)]
    ycoord = coordinates[:, np.arange(1, coordinates.shape[1], 3)]
    probcoord = coordinates[:, np.arange(2, coordinates.shape[1], 3)]

    xcoord[probcoord < threshold] = np.nan
    ycoord[probcoord < threshold] = np.nan

    return xcoord, ycoord


def extractbouts(idxarray):
    loc = np.where(np.diff(idxarray) != 1)[0]
    start = np.append(idxarray[0], idxarray[loc + 1])
    stop = np.append(idxarray[loc] + 1, idxarray[-1])
    bouts = np.transpose(np.vstack((start, stop)))
    return bouts
