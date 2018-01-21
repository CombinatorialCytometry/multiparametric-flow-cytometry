! 
! analised_colors......the colors that are going to be taken into account in the tendency 
! use_in_average..=..0 that color is not used in the average calculation
!               .....1 the i color is used to calculate the color tendency
!
!
!
!
program multiparametric_flow_cytometry
implicit none

! Variables declaration *************************************************************************************************
! File names and temporary files
character:: file_name*40,file_name_dat*40,file_name_txt*40
character:: anything*20,command*100,line*1000
integer:: rad_name,number_rows_original_file=0

! Events and couter variables
integer:: control=0,counter,event_accepted
integer:: i,j,k
integer:: total_events_accepted=0, total_events_rejected=0

! file rows informations 
integer:: rows,fluorescent_channels,color_begin,number_color_analysed
logical:: file_fcs_exist

! Calculated Values
real:: average_l,sum_x,sum_y,hue_med,light_med
real:: total_light,max_light

real,allocatable:: values(:,:),average(:),in_data(:)
integer,allocatable:: lambda(:),analised_colors(:),use_in_average(:),choosen_rows(:)
real,allocatable:: hue(:),light(:),compensation(:,:)

! Deleting old output files **********************************************************************************************
file_name=" "
file_name(1:8)="nofl.dat"
inquire( file=trim(file_name), exist=file_fcs_exist )
if(file_fcs_exist)call system("rm nofl.dat")
file_name=" "
file_name(1:8)="fluo.dat"
inquire( file=trim(file_name), exist=file_fcs_exist )
if(file_fcs_exist)call system("rm fluo.dat")
file_name=" "
file_name(1:16)="result_file.eps"
inquire( file=trim(file_name), exist=file_fcs_exist )
if(file_fcs_exist)call system("rm result_file.eps")
file_name=" "
file_name(1:19)="result_file-deb.eps"
inquire( file=trim(file_name), exist=file_fcs_exist )
if(file_fcs_exist)call system("rm result_file-deb.eps")

! Reading the parameters file *******************************************************************************************
open(20,file="in.dat")
file_name=" "
command=" "
read(20,*,ERR=1000,END=1000)file_name
inquire( file=trim(file_name), exist=file_fcs_exist )
if(file_fcs_exist)then
  print *, ''//achar(27)//"[32m File.... ",file_name," found........................"//achar(27)//"[0m"
else
  print *, ''//achar(27)//"[31m File.... ",file_name," not found!!!................."//achar(27)//"[0m"
  print *, "Please make sure the file",file_name," is in the correct folder."
  stop
end if

file_name_txt=file_name
file_name_dat=file_name
do i=1,40
  if(file_name(i:i)=='.')then
    rad_name=i-1
    file_name(i:i+4)  =''
    file_name_txt(i:i+4)  ='.txt'
    file_name_dat(i:i+4)  ='.dat'
    exit
  end if
end do

goto 1001
1000 print *, ''//achar(27)//"[31m Error file.... in.dat............ :/ "//achar(27)//"[0m"
print *, "The file in.dat is needed, to proceed create or edit the file "
print *, "Please add the name of the fcs file analised in the first line of the file in2.dat"
stop
1001 continue

! converting the fcs file to text temporary file **********************************************************************
command = "Rscript "//"FCS2CSV.R "//file_name;
call system(command) 
print *, ''//achar(27)//"[32m File.... ",file_name(1:rad_name),".fcs sucessufully converted"//achar(27)//"[0m"

open(30,file=file_name_txt)
open(40,file="result_file")
line=''
read(30,'(a1000)',END=100,ERR=200)line
write(*,*)"Temporary text file:",file_name_txt,"................................."
write(*,'((a12)$)')"First line:"
do i=1,1000
  if(line(i:i).ne." ")write(*,'((a1)$)')line(i:i)
end do
write(*,*)' '


read(20,*,ERR=1002,END=1002)rows
goto 1003
1002 print *, ''//achar(27)//"[31m Error file ...... in.dat............ :/ "//achar(27)//"[0m"
print *, " in.dat file incomplete "
print *, "Please inform the number of rows of the .fcs file"
stop
1003 continue

allocate(choosen_rows(rows))
choosen_rows=0
read(20,*,ERR=1004,END=1004)fluorescent_channels
read(20,*,ERR=1004,END=1004)choosen_rows
write(*,*)"The rows used:",choosen_rows
goto 1005
1004 print *, ''//achar(27)//"[31m Error file ...... in.dat............ :/ "//achar(27)//"[0m"
print *, " in.dat file incomplete "
print *, "Please check the .fcs file"
stop
1005 continue

!converting the file to only the data it is necessary ************************************************************
do i =1,1000
  if(line(i:i)==',')then
    line(i:i)=' '
    number_rows_original_file=number_rows_original_file+1
  end if
  if(line(i:i)=='"')line(i:i)=' '
end do
write(*,*)"Rows present in the input data:",number_rows_original_file,"............................"
allocate(in_data(number_rows_original_file))
!write(*,*)"first line of the file:",line
do while(control==0)
  line=''
  read(30,'(a1000)',END=100,ERR=200)line
  do i=1,1000
    if(line(i:i)==','.or.line(i:i)=='"')line(i:i)=' '
  end do
  write(40,*)line
end do 
200 write(*,*)"................................................................." 
print *, ''//achar(27)//"[31m There was an error in the ",file_name_txt,".fcs"//achar(27)//"[0m"
print *, ''//achar(27)//"[31m Please check your fcs file and your instalation..................."//achar(27)//"[0m"
stop
100 print *, ''//achar(27)//"[32m The text file is done ........................................ :)"//achar(27)//"[0m"
command="cp result_file "//file_name_txt
call system(command)
close(40)
call system("rm result_file")
close(30)

!reopening the files ***************************************************************************************************
open(30,file=file_name_txt)
open(40,file=file_name_dat)
do while(control==0)
  line=''
  read(30,*,END=400,ERR=300)in_data
  do i =1,rows
    write(40,"(EN15.7E2,3x)",advance="no")in_data(choosen_rows(i))
  end do
  write(40,*)" "
end do
300 print *, ''//achar(27)//"[31m There was an error in the ",file_name_txt,".fcs"//achar(27)//"[0m"
print *, ''//achar(27)//"[31m Please check your fcs file and your instalation..................."//achar(27)//"[0m"


stop
400 print *, ''//achar(27)//"[32m The text file is done ........................................ :)"//achar(27)//"[0m"
write(*,*)"................................................................."
write(*,*)"................................................................." 
close(30)
close(40)

! allocating analisys data ********************************************************************************************
allocate(lambda(fluorescent_channels),hue(fluorescent_channels),light(fluorescent_channels))
allocate(compensation(fluorescent_channels,fluorescent_channels))
read(20,*,ERR=1004,END=1004)lambda
allocate(average(fluorescent_channels),analised_colors(fluorescent_channels))
allocate(use_in_average(fluorescent_channels))
read(20,*,ERR=1004,END=1004)average
do i=1,fluorescent_channels
  read(20,*,ERR=1004,END=1004)compensation(i,1:fluorescent_channels)
  compensation(i,i)=0.0
end do
analised_colors=0
read(20,*,ERR=1004)analised_colors
close(20)

! Final in.dat reading ************************************************************************************************ 

color_begin = rows - fluorescent_channels
write(*,'((a8),10(i3,3x))')"lambda: ",lambda
do i=1,fluorescent_channels
   write(*,'((a2),10(f6.2,3x))')"C:",compensation(i,:)
end do
compensation = compensation/100.00
write(*,*)"................................................................." 
write(*,*)"rows:",rows,"......................................................." 
write(*,*)"number of fluorescent channels choosen:",fluorescent_channels,"............................." 
write(*,*)"what row in the file the color begins: ",color_begin,".................................." 
write(*,'((a40),10(f10.2,3x)$)')"The negative background cut-off values:",average
write(*,*)"The input fcs data file:",file_name_dat,".............................." 

! counting the total number of events *************************************************************************************
write(*,*)"Counting the number of events...................................." 
open(10,file=file_name_dat)
counter=0
do while(control==0)
  read(10,*,END=20)anything
  counter=counter+1
end do
20 continue
if (counter<=20000) then
  print *, ''//achar(27)//"[32m Number of events in the file .......",counter," "//achar(27)//"[0m"
else
  if (counter <=100000)then
    print *, ''//achar(27)//"[33m Number of events in the file .......",counter," "//achar(27)//"[0m"
  else
    if (counter <= 1000000)then
      print *, ''//achar(27)//"[33m Number of events in the file .......",counter," "//achar(27)//"[0m"
    else
      print *, ''//achar(27)//"[33m WARNING: Number of events in the file .......",counter," too high!!!!!!!!!"//achar(27)//"[0m"
    end if
  end if
end if

close(10)
open(10,file=file_name_dat)

! Memory data alocation ***************************************************************************************************
allocate(values(counter,rows))
do i=1,counter
  read(10,*)values(i,:)
end do
close(10)
! Applying data compensation *********************************************************************************************
write(*,*)"Fluorescence data compensation..................................:"
do i=1,counter
  do j=1,fluorescent_channels
    do k=1,fluorescent_channels
      values(i,color_begin+j)=values(i,color_begin+j)-compensation(k,j)*values(i,color_begin+k)
    end do
  end do
end do
write(*,*)"................................................................." 
! Removing the background values of the data *******************************************************************************
write(*,*)"Removing the background cut-off value:",average,"......................." 
do i=1,counter
  do j=1,fluorescent_channels
    values(i,j+color_begin)=values(i,j+color_begin)-average(j)
    if(values(i,j+color_begin)<0.0)then
      values(i,j+color_begin)=0.0
    end if
  end do
end do
where(values<0.0)values=0.0
write(*,*)"................................................................." 
! Saving the compensated data for other analisys ***************************************************************************
file_name(rad_name+1:rad_name+8)='-cmp.dat'
write(*,*)"Salving the compensated data: ",file_name,"......................." 
open(10,file=file_name)
do i=1,counter
  write(10,*)values(i,:)
end do
close(10)
write(*,*)"................................................................." 

! Building the base vectors
write(*,*)" Building the base vectors......................................." 
do j=1,fluorescent_channels
  hue(j)=((750.0-lambda(j))*(6.2830))/(750.0-400.0)
end do
write(*,*)"hue:",hue
write(*,*)"hue:",hue/6.2830*360
write(*,*)"................................................................."

! The out put files
open(30,file="nofl.dat")
open(20,file="fluo.dat")


number_color_analysed = 0
do i=1,fluorescent_channels
   if(analised_colors(i)/=0)number_color_analysed=number_color_analysed+1
end do
write(*,*)"Number of colors excluded in the color tendency:", number_color_analysed
write(*,*)"List of colors removed from the tendency:", analised_colors
use_in_average=1
do i=1,fluorescent_channels
  if(analised_colors(i)/=0)use_in_average(abs(analised_colors(i)))=0
end do
write(*,*)"vetor use_in_average:", use_in_average

! Colour calculation of each event ********************************************************************************
write(*,*)"Please wait the calculation.............................................."
write(*,*)"For bigger files this can take some time................................."
do i=1,counter
  if(mod(i,int(counter/10))==0)print *, ''//achar(27)//'[32m',int(i/(counter/10))*10,'%........'//achar(27)//'[0m'!write(*,*)int(i/(counter/10))*10,"% ....................."
  ! Calculo do L de cada evento e de cada canal de flourescencia
  if(number_color_analysed==0.or.number_color_analysed==fluorescent_channels)then
    !todos os canais serao considerados
    average_l = sum(values(i,color_begin:rows))/real(fluorescent_channels) 
    do j=1,fluorescent_channels
      light(j) = values(i,j+color_begin)
    end do
    ! cada canal é um vetor, sum vetorial:
    sum_x=0.0
    sum_y=0.0
    do j=1,fluorescent_channels
      sum_x=sum_x+light(j)*cos(hue(j))
      sum_y=sum_y+light(j)*sin(hue(j))
    end do
    light_med = sqrt(sum_x**2+sum_y**2)
    hue_med = atan2(sum_y,sum_x)
    !saida
    do while(hue_med<0)
       hue_med=hue_med+6.2830
    end do
    do while(hue_med>=6.2830)
       hue_med=hue_med-6.2830
    end do
    hue_med = (hue_med/6.2830) * 360.0
    max_light=0.0
    total_light=0.0
    do j=1,fluorescent_channels
      if(values(i,color_begin+j)>max_light)max_light=values(i,color_begin+j)
      total_light=total_light+values(i,color_begin+j)
    end do

    if(light_med<=1.0d-5.or.isnan(hue_med))then
      write(30,*)values(i,1:color_begin),hue_med,1.0,0.5,values(i,color_begin:rows)
      total_events_rejected = total_events_rejected + 1
    else
      if(isnan(hue_med))then
      else
        write(20,*)values(i,1:color_begin),hue_med,1.0,0.5,max_light/total_light,values(i,color_begin:rows)
        total_events_accepted = total_events_accepted + 1
      end if
    end if
  else
    ! one or more fluorescent_channels beeing analised
    average_l=0.0
    do j=1,fluorescent_channels
       average_l = average_l + values(i,color_begin+j)*use_in_average(j)
    end do
    average_l = average_l/real(fluorescent_channels-number_color_analysed+1) 
    do j=1,fluorescent_channels
       light(j) = values(i,j+color_begin)*use_in_average(j)
    end do
    sum_x=0.0
    sum_y=0.0
    do j=1,fluorescent_channels
      sum_x=sum_x+light(j)*cos(hue(j))
      sum_y=sum_y+light(j)*sin(hue(j))
    end do
    hue_med = atan2(sum_y,sum_x)
    light_med = sqrt(sum_x**2+sum_y**2)
    do while(hue_med < 0.0)
      hue_med = hue_med + 6.2830
    end do
    do while(hue_med > 6.2830)
      hue_med = hue_med - 6.2830
    end do
    hue_med = (hue_med/6.2830) * 360
    ! the new test: if the analised_colors is positive test for positive if the analised is negative test for negative 
    event_accepted=1
    do k=1,fluorescent_channels
      if(analised_colors(k)>0)then
        if(values(i,color_begin+analised_colors(k))<=0.0)then
          event_accepted=0
        end if
      else
        if(analised_colors(k)<0)then
          if(values(i,color_begin+abs(analised_colors(k)))>0.0)then
            event_accepted=0
          end if
        end if
      end if
    end do
    max_light=0.0
    total_light=0.0
    do j=1,fluorescent_channels
      if((values(i,color_begin+j)*use_in_average(j))>max_light)max_light=(values(i,color_begin+j)*use_in_average(j))
      total_light=total_light+(values(i,color_begin+j)*use_in_average(j))
    end do
    if(total_light<=0.0)total_light=1.0 
    if(event_accepted==0.or.isnan(hue_med))then
      write(30,*)values(i,1:color_begin),hue_med,1.0,0.5,values(i,color_begin:rows)
      !write(*,*)values(1:color_begin)
    else
      write(20,*)values(i,1:color_begin),hue_med,1.0,0.5,max_light/total_light,values(i,color_begin:rows)
      !write(*,*)values(1:color_begin)
    end if
  end if
end do

! deleting the temporary files
write(*,*)"................................................................."
write(*,*)"Deleting the temporary files ...................................."
command = "rm "//file_name_txt
call system(command)
command = "rm "//file_name_dat
call system(command)
write(*,*)"................................................................."
write(*,*)"Genetaring the images ..........................................."
write(*,*)" Press any key to continue"
call system("gnuplot script-gnu-cor")
call system("gnuplot script-gnu-pb")
deallocate(values)
print *, ''//achar(27)//"[95m .......................THE......END.............................. "//achar(27)//"[0m"
print *, ''//achar(27)//"[95m ...........Execution finished with success!!!.................... :)"//achar(27)//"[0m"
end program



