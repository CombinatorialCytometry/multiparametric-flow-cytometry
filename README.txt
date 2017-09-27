# multiparametric-flow-cytometry
developed by Carine P. Beatrici


How to use the program:

In a linux terminal:

1) After the download, compile the code "make"; 

2) To execute the program it is necessary the configuration file, in.dat.

#file information                                        example

1) name of the fcs file                                    Sample_38.fcs
2) number of data columns in the fcs file                  11
3) number of fluorescent channels                           7
4) columns to copy into memory                             1 5 6 7 9 10 11 12 13 14 15
first the fsc, ssc and additional data
after the fluorescent channel
5) wavelenght values for the channel colors                425 475 525 575 625 675 725
6) Background values                                       20.4  1000.0  12.09  19.33  1000.0  24.01  12.53
7) Compensation values                                     100.00    1.63     6.10    0.00    0.70    0.00    0.00
                                                            22.36  100.00     6.50    0.00    0.00    0.00    0.00
                                                            13.82   29.27   100.00    6.84   37.41    0.00    0.00
                                                             2.45   15.04    28.43  100.00   12.94    0.00    0.00
                                                             0.00    2.44    10.84   15.73  100.00    0.00    8.74
                                                             0.00    0.41     4.90    1.68    0.00  100.00   11.34
                                                             0.00    0.00     0.00    0.00    0.00    6.10  100.00
8) Fluorescent channels used in the color trend            0 0 0 0 0 0 0

Helpful observations:
The in.dat must have this informations in order without any other text;
2, 3 and 4) to discover the number of columns of the fcs file just execute the program with the in.dat file incomplete
and choose from the options displayed by the program output. The counting star in 1 (sorry for that C programmers!!!).

5) the wavelenght value must be in [400, 750]nm, the values can be related or not with the real filters  values. If you 
choose to not use the filter half value, we suggest to use wavelenght values equally spaced. Like the example.

6) The background value is the fluorescence intensity to consider the event as a positive one for the channel.
This value must be in agreement with the data.

7) The tradiotional compensation table. The values must be in [0,100] and 100 for the channel with itself.

8) To calculate the color tendency for all the channels, let this value as zeros (one zero for each color channel) or
complete with the sequence until the number of channels (e.g 1 2 3 4 5 6). This way all the channels are taken into 
account to the tendency color.

To calculate the tendency only for events positive for just a set of channels put their numbers 
followed by zeros, e.g. 2 4 0 0 0 0.  In this case only the double positives events for the second and fourth 
channels will receive a color, all the other are going to stay black.

And to calculate the tendency for the negative events for a set of channels just put the number of channels
in negative, e.g 2 -4 0 0 0 0. With this configuration the events are going to receive a color if and only if thei are
positive for the second channel and negative for the fourth channel.



The cytometry files must be present in the executable folder.


Dependencies:

1 - This software was build to run in Linux based systems;
2 - gfortran compiler;
3 - gnuplot;
4 - R compiler;
5 - the R package flowcore;

