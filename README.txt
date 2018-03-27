# multiparametric-flow-cytometry
developed by Carine P. Beatrici and Fabricio A. B. Silva

Detailed tutorial is available in the document multiparametric-flow-cytometry.pdf. 


How to run the program:

In a linux terminal:

1) After the download, compile the code using "make"; 

2) To execute the program, it is necessary to provide the configuration file in.dat.

#file information                                        example

1) name of the fcs file                               Sample_38.fcs
2) number of data columns in the fcs file             11
3) number of fluorescent channels                     7
4) columns to copy into memory                        1 5 6 7 9 10 11 12 13 14 15
first the fsc, ssc and additional data
after the fluorescence channel
5) wavelength values for the channel colors           425 475 525 575 625 675 725
6) Background values                                   20.4  1000.0  12.09  19.33  1000.0  24.01  12.53
7) Compensation values                 100.00    1.63     6.10    0.00    0.70    0.00    0.00
                                        22.36  100.00     6.50    0.00    0.00    0.00    0.00
                                        13.82   29.27   100.00    6.84   37.41    0.00    0.00
                                         2.45   15.04    28.43  100.00   12.94    0.00    0.00
                                         0.00    2.44    10.84   15.73  100.00    0.00    8.74
                                         0.00    0.41     4.90    1.68    0.00  100.00   11.34
                                         0.00    0.00     0.00    0.00    0.00    6.10  100.00
8) Fluorescent channels used in the color trend       0 0 0 0 0 0 0

Helpful observations:
The in.dat must have the above informations in order without any other text;

For itens 2, 3 and 4, to discover the number of columns of the fcs file, just execute the program with the 
in.dat file incomplete and choose from the options displayed by the program output. The counting starts in 1.

5) the wavelength value must be between [400, 750] nm and the values can be related or not to real filters
values. If you choose not to use the filter half value, we suggest to use wavelength values equally spaced
like the example shown above.

6)The background labeling corresponds to the maximum fluorescence value of negative events. Any positive event for a given channel must have superior fluorescence intensity, when compared with the background reference value.
This value must be in agreement with the data.

7) The conventional compensation table. The values must be between [0,100] and the value 100 is set when the same channel is considered for both references.

8) To calculate the color tendency for all the channels, set this value as zeros (one zero for each color channel) or
complete with the sequence according to the number of channels (e.g 1 2 3 4 5 6). 
By doing this, all the channels are taken into account to define the tendency color.

To calculate the tendency value only for positive events for a subset of channels, type the corresponding 
channel numbers followed by zeros, e.g. 2 4 0 0 0 0. 
In this case, only the double positives events for the second and fourth channels will be considered and will receive a color, all the others are going to stay black.

To calculate the tendency value for negative events in a set of channels, just put the number of channels
as negative numbers, e.g 2 -4 0 0 0 0. 
Using this configuration, the events are going to receive a color if and only if they are positive for the second channel and negative for the fourth channel (single positive events).



The cytometry files must be present in the same folder as the executable file.


Dependencies:

1 - This software was developed to run in Linux-based systems;
2 - gfortran compiler;
3 - gnuplot;
4 - R compiler;
5 - the Bioconductor package flowcore;


Files in this package:

FCS2CSV.R -------------------------- R script that converts the FCS file into the text format,
                                     used internally by the multiparametric-flow-cytometry application.
Makefile --------------------------- compiles the code into the executable file.
Sample_37.fcs ---------------------- It is one of the flow cytometry experimental data used
                                     as example (control group of mice).
Sample_39.fcs ---------------------- It is one of the flow cytometry experimental data used
                                     as example (infected group of mice).
in.dat ----------------------------- This configuration file uses the Sample_39.fcs as data source. 
                                     The multiparametric-flow-cytometry application will generate the color 
                                     dot-plot according to this configuration file.    
in_Sample_37.dat ------------------- Another example of configuration file, this time using 
                                     the Sample_37.fcs as imput file.
multiparametric-flow-cytometry.f90 - The fortran program that generates the colored dot-plot.
multiparametric-flow-cytometry.pdf - The tutorial of the program.
script-gnu-cor --------------------- Gnuplot script, this script uses the information in the 
                                     temporary files to generate the colored dot-plot.                                   
script-gnu-pb ---------------------- Gnuplot script, this script generates the trust map 
                                     of the colored dot-plot.
script_linux_filter------------------Resultant color filter script. This script filters resultant colors. 
                                     It requires the fluo.dat file generated by multiparametric-flow-cytometry.

