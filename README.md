# uASPIre

This repository contains the data of _**u**ltradeep **A**cquisition of **S**equence-**P**henotype **I**nter**re**lations_ (uASPIre) and the code for processing raw NGS data as presented in the submitted manuscript "Large-scale DNA-based phenotypic recording and deep learning enable highly accurate sequence-function mapping".

## Organization of the repository

1. [**NGS_data_analysis**](NGS_data_analysis) contains the scripts for raw NGS data analysis that was used to extract the processed data, as presented below. 

2. [**RBS_data**](RBS_data) contains the processed NGS data that were used by our machine learning model (https://github.com/BorgwardtLab/SAPIENs) and other analyses. The data is structured in tab delimited files with header line containing the time points in minutes and the calculated integral of flipping profiles (_IFP480_). The data of the biological replicates (_uASPIre_RBS_300k_r2.txt.gz_ and _...r3_) also contain a column with the IFP value normalized to replicate 1 (_IFP480_fittor1_). The column _total_reads_ shows the sum of all flipped and non-flipped reads over all time points per variant.

3. [**uASPIre_RBS_example**](uASPIre_RBS_example) contains some raw and compressed exemplary NGS data.

## Hardware requirements
This code package requires a Unix system with >10 GB RAM and optimally multiple cores.

## Software requirements
The code runs on Unix systems only, and was developed and tested on Red Hat Enterprise Linux Server release 6.9 (Santiago).

## Installation
No installation is needed, the code can be run as is.

## Software dependencies
This code requires the following UNIX tools and packages:

+ AGREP 3.41.5 (e.g. available via https://github.com/Wikinaut/agrep)
+ TRE agrep 0.8.0 (e.g. available via https://wiki.ubuntuusers.de/tre-agrep/)
+ python 3 including the packages _biopython (Bio.Seq)_, _numpy_, _os_, _sys_, _logging_, _datetime_ and _pandas_

## Functionality
"The algorithms for processing of NGS data for this project were written in bash and python. Briefly, forward and reverse reads retrieved from fastq files were paired and all reads with more than six consecutive unidentified nucleotides were removed. Afterwards, target fragments were selected by a 10-bp constant region (GAGCTCGCAT, max. 3 mismatches) and sequences from different samples were deconvoluted by their unique combination of two 6-bp indices (Supplementary Tab. 3). Next, the discriminator state was determined by searching for the presence of an attP or attR site corresponding to the sequences GGGTTTGTACCGTACAC or GCCCGGATGATCCTGAC, respectively (max. 3 mismatches). RBS sequences were determined by retrieving the 17 nucleotides upstream of the bxb1 start codon." (from Höllerer _et al_., 2020)


## License
Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)

(c) Simon Höllerer, 2020, ETH Zurich

https://creativecommons.org/licenses/by-nc-nd/4.0/legalcode

This is valid for the data and the code shared in this repository.


## Date
June 2020

## Contact
simon.hoellerer@bsse.ethz.ch

Simon Höllerer, ETH Zürich, D-BSSE, BPL, Basel, Switzerland 
