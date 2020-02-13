# uASPIre

This repository contains the data of _**u**ltradeep **A**cquisition of **S**equence-**P**henotype **I**nter**re**lations_ (uASPIre) and the code for processing raw NGS data as presented in the submitted manuscript of "Large-Scale Sequence-Function Mapping and Deep Learning for Prediction of Biological Properties".

## Organization of the repository

1. [**NGS_data_analysis**](NGS_data_analysis) contains the scripts for raw NGS data analysis that was used to extract the processed data, as presented below. 

2. [**RBS_data**](RBS_data) contains the processed NGS data that were used by our machine learning model (https://github.com/BorgwardtLab/SAPIENs) and other analyses. The data is structured in tab delimited files with header line containing the time points in minutes and the calculated integral of flipping profiles (_IFP480_). The data of the biological replicates (_uASPIre_RBS_300k_r2.txt.gz_ and _...r3_) also contain a column with the IFP value normalized to replicate 1 (_IFP480_fittor1_). The column _total_reads_ shows the sum of all flipped and non-flipped reads over all time points per variant.

3. [**uASPIre_RBS_example**](uASPIre_RBS_example) contains some raw and compressed exemplary NGS data.

## Hardware requirements
This code package requires a Unix system with >10 GB RAM.

## Software requirements
The code runs on Unix systems only, and was developed and tested on Red Hat Enterprise Linux Server release 6.9 (Santiago).

## Software dependencies
This code requires the following UNIX tools and packages:

+ AGREP 3.41.5 (e.g. available via https://github.com/Wikinaut/agrep)
+ TRE agrep 0.8.0 (e.g. available via https://wiki.ubuntuusers.de/tre-agrep/)
+ python 3 including the packages _biopython (Bio.Seq)_, _numpy_, _os_, _sys_, _logging_, _datetime_ and _pandas_

## Date
January 2020

## Contact
simon.hoellerer@bsse.ethz.ch
Simon Höllerer, ETH Zürich, D-BSSE, BPL, Basel, Switzerland 
