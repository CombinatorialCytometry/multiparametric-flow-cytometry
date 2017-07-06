# multiparametric-flow-cytometry
developed by Carine P. Beatrici


How to use the program:

In a linux terminal:

1) After the download, compile the code "make"; 

2) To execute the program it is necessary the configuration file, in.dat.

#file information                                        example

name of the fcs file                                    Sample_38.fcs
number of data columns in the fcs file                  11
number of fluorescent channels                           7
columns to copy into memory                             1 5 6 7 9 10 11 12 13 14 15
first the fsc, ssc and additional data
after the fluorescent channel
wavelenght values for the channel colors                425 475 525 575 625 675 725
Background values                                       20.4  1000.0  12.09  19.33  1000.0  24.01  12.53
Compensation values                                     100.00    1.63     6.10    0.00    0.70    0.00    0.00
                                                         22.36  100.00     6.50    0.00    0.00    0.00    0.00
                                                         13.82   29.27   100.00    6.84   37.41    0.00    0.00
                                                          2.45   15.04    28.43  100.00   12.94    0.00    0.00
                                                          0.00    2.44    10.84   15.73  100.00    0.00    8.74
                                                          0.00    0.41     4.90    1.68    0.00  100.00   11.34
                                                          0.00    0.00     0.00    0.00    0.00    6.10  100.00
Fluorescent channels used in the color trend            0 0 0 0 0 0 0


The cytometry files must be present in the executable folder.
