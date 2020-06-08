# uASPIre - raw NGS data analysis

Dear user of uASPIre,

This is the instruction for the NGS data analysis of uASPIre. The data analysis is an all-in-one solution that needs NGS indices, a constant region to identify the randomized diversifier and the length of the randomized diversifier sequence to count the fraction flipped of all different diversifiers over time.

## Execution
To execute the script, specify all necessary options in the config file following the prescribed formatting. Then run the program with

	$ /path/to/script/main_process_raw_NGS_data.sh /path/to/config/config.cfg

The script generates many temporary files in the _output_ folder and writes the final results into the _results_ folder. The _output_ folder can be deleted once the program has successfully been excuted.

Feel free to try the script on the provided sample NGS raw data ('uASPIre_example') and the provided sample config. The expected output is in the 'output' folder. Runtime should be ~10 s for this dummy set and up to 2 h for a full NGS data (400 mio reads) set running on 12 cores.

NGS data in the manuscript was analyzed using the provided configs in the [**configs_used_in_manuscript**](configs_used_in_manuscript) folder.

In case of questions, problems, or comments, feel free to contact me.

## Date
June 2020

## Contact
simon.hoellerer@bsse.ethz.ch
Simon Höllerer, ETH Zürich, D-BSSE, BPL, Basel, Switzerland

## License
BSD 3-Clause License [for the code in this folder only]

Copyright (c) 2020, Simon Höllerer, all rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
