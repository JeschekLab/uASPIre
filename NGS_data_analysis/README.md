# uASPIre - raw NGS data analysis

Dear user of uASPIre,

This is the instruction for the NGS data analysis of uASPIre. The data analysis is an all-in-one solution that needs NGS indices, a constant region to identify the randomized diversifier and the length of the randomized diversifier sequence to count the fraction flipped of all different diversifiers over time.

## Dependencies
The code requires the following tools and packages:
+ AGREP 3.41.5 (e.g. available via https://github.com/Wikinaut/agrep)
+ TRE agrep 0.8.0 (e.g. available via https://wiki.ubuntuusers.de/tre-agrep/)
+ python 3 including the packages _biopython (Bio.Seq)_, _numpy_, _os_, _sys_, _logging_, _datetime_ and _pandas_

## Execution
To execute the script, specify all necessary options in the config file following the prescribed formatting. Then run the program with

	$ /path/to/script/main_process_raw_NGS_data.sh /path/to/config/config.cfg

The script generates many temporary files in the _output_ folder and writes the final results into the _results_ folder. The _output_ folder can be deleted once the program has successfully been excuted.

Feel free to try the script on the provided sample NGS raw data [**uASPIre_RBS_example**](uASPIre_RBS_example) and the provided sample config.

In case of questions, problems, or comments, feel free to contact me.

## Date
January 2020

## Contact
simon.hoellerer@bsse.ethz.ch
Simon Höllerer, ETH Zürich, D-BSSE, BPL, Basel, Switzerland 
