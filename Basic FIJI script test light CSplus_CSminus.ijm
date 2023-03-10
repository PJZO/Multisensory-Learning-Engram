macro "ROI_visual test" {
path = File.openDialog("Choose a File"); 
     print("path:", path); 
     print("name:", File.getName(path)); 
     print("directory:", File.getParent(path));
open(path)

filename=getTitle;
filesize=nSlices;

//Get light info
selectWindow(filename);
run("Make Substack...", " slices=2-"+filesize+"-3");
run("Plot Z-axis Profile");
odour = newArray(filesize);
for (i=0; i<filesize/3; i++) {
	light[i] = getResult("Min", i); 
};
waitForUser("Next");
roiManager("reset");
run("Select None");
print("\\Clear");


//Get DFF ASAP signal 

//Prepare ASAP channel 
selectWindow(filename);
run("Make Substack...", " slices=1-"+filesize+"-3");
run("Fire");
run("In [+]");
run("In [+]");

//Remove frames where image acquistion was off due to light stimulation
run("Slice Remover", "first=462 last=466 increment=1");
run("Slice Remover", "first=447 last=451 increment=1");
run("Slice Remover", "first=432 last=436 increment=1");
run("Slice Remover", "first=417 last=421 increment=1");
run("Slice Remover", "first=224 last=228 increment=1");
run("Slice Remover", "first=209 last=213 increment=1");
run("Slice Remover", "first=194 last=198 increment=1");
run("Slice Remover", "first=179 last=183 increment=1");

run("Z Project...", "projection=[Max Intensity]");
waitForUser("check best region");
run("Close");
run("Window/Level...");

//Select ROIs using
waitForUser("select signal ROI press t and then background ROI press t");

{
numSlices = nSlices;
title = getTitle();

//nAvg = getNumber("Average F0 over first X frames: (enter X)", 50);
//Select first F01
Dialog.create("Frames over which to average F0_1");
Dialog.addNumber("To1", 172);
Dialog.show();
to1 = Dialog.getNumber();
//to1 = 172;
from1 = to1 - 12;
if (to1 <= from1) exit("Error: To value must be greater than from value");
nAvg1 = to1 - from1 + 1;

// Select second F02
Dialog.create("Frames over which to average F0_2");
Dialog.addNumber("To2", 360);
Dialog.show();
to2 = Dialog.getNumber();
//to2 = 380;
from2 = to2 - 12;
if (to2 <= from2) exit("Error: To value must be greater than from value");
nAvg2 = to2 - from2 + 1;

// Select third F03
//Dialog.create("Frames over which to average F0_3");
//Dialog.addNumber("To3", 588);
//Dialog.show();
//to3 = Dialog.getNumber();
//to3 = 588;
//from3 = to3 - 12;
//if (to3 <= from3) exit("Error: To value must be greater than from value");
//nAvg3 = to3 - from3 + 1;

// Select fourth F04
//Dialog.create("Frames over which to average F0_4");
//Dialog.addNumber("To4", 796);
//Dialog.show();
//to4 = Dialog.getNumber();
//to4 = 796;
//from4 = to4 - 12;
//if (to4 <= from4) exit("Error: To value must be greater than from value");
//nAvg4 = to4 - from4 + 1;

print("\\Clear");

selectWindow(title);

// Select ASAP signal as the second-to-last ROI in ROI manager
roiManager("select", (roiManager("count") - 2));
run("Plot Z-axis Profile");
f = newArray(numSlices);
for (i=0; i<numSlices; i++) f[i] = getResult("Mean", i);
selectWindow("Results");
run("Close","Don't Save");
run("Close");

selectWindow(title);

// Select the background signal as the last ROI in ROI manager
roiManager("select", (roiManager("count") - 1));
run("Plot Z-axis Profile");
bkgnd = newArray(numSlices);
for (i=0; i<numSlices; i++) bkgnd[i] = getResult("Mean", i);
selectWindow("Results");
run("Close","Don't Save");
run("Close");

// Subtract background to the ASAP signal
for (i=0; i<numSlices; i++) f[i] = f[i] - bkgnd[i];

// Calculate average over frames specified by from-to 1
sum = 0;
for (i=from1-1; i<to1; i++) sum = sum + f[i];
f01 = sum / nAvg1;

// Calculate average over frames specified by from-to 2
sum = 0;
for (i=from2-1; i<to2; i++) sum = sum + f[i];
f02 = sum / nAvg2;

// Calculate DF/F 1
dff1 = newArray(numSlices);
for (i=0; i<nSlices; i++) dff1[i] = -((f[i] - f01) / f01);
// Calculate DF/F 2
dff2 = newArray(numSlices);
for (i=0; i<nSlices; i++) dff2[i] = -((f[i] - f02) / f02);

// Print
for (i=0; i<nSlices; i++) {
print(shock[i]+"	"+light[i]+"	"+dff1[i]+"	"+dff2[i]);
String.append(shock[i]+"	"+light[i]+"	"+dff1[i]+"	"+dff2[i]+"\n");
};
selectWindow("Log");
waitForUser("Done");
run("Close All");
}
