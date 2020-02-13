# uASPIre - raw NGS data analysis

Dear user of uASPIre,

This is the instruction for the NGS data analysis of uASPIre. The data analysis is an all-in-one solution that needs NGS indices, a constant region to identify the randomized diversifier and the length of the randomized diversifier sequence to count the fraction flipped of all different diversifiers over time.

## Execution
To execute the script, specify all necessary options in the config file following the prescribed formatting. Then run the program with

	$ /path/to/script/main_process_raw_NGS_data.sh /path/to/config/config.cfg

The script generates many temporary files in the _output_ folder and writes the final results into the _results_ folder. The _output_ folder can be deleted once the program has successfully been excuted.

Feel free to try the script on the provided sample NGS raw data [**uASPIre_RBS_example**](uASPIre_RBS_example) and the provided sample config. The expected output is in the 'output' folder. Runtime should be ~10 s for this dummy set and up to 2 h for a full NGS data (400 mio reads) set running on 12 cores.

NGS data in the manuscript was analyzed using the provided configs in the [**configs_used_in_manuscripts folder**](configs_used_in_manuscripts folder).

In case of questions, problems, or comments, feel free to contact me.

## Date
January 2020

## Contact
simon.hoellerer@bsse.ethz.ch
Simon Höllerer, ETH Zürich, D-BSSE, BPL, Basel, Switzerland 
