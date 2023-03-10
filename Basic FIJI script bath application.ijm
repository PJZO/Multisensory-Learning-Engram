macro "ROI_bath application" {
path = File.openDialog("Choose a File"); 
     print("path:", path); 
     print("name:", File.getName(path)); 
     print("directory:", File.getParent(path));
open(path)

filename=getTitle;
filesize=nSlices;

//Get DFF ASAP signal 

//Prepare ASAP channel 
selectWindow(filename);
run("Make Substack...", " slices=1-"+filesize+"-3");
run("Fire");
run("In [+]");
run("In [+]");
run("Image Stabilizer", "transformation=Translation maximum_pyramid_levels=1 template_update_coefficient=0.90 maximum_iterations=200 error_tolerance=0.0000001");
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
Dialog.addNumber("To1", 190);
Dialog.show();
to1 = Dialog.getNumber();
from1 = to1 - 180;
if (to1 <= from1) exit("Error: To value must be greater than from value");
nAvg1 = to1 - from1 + 1;

print("\\Clear");

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

// Calculate DF/F 1
dff1 = newArray(numSlices);
for (i=0; i<nSlices; i++) dff1[i] = -((f[i] - f01) / f01);

// Print
for (i=0; i<nSlices; i++) {
print(dff1[i]);
String.append(dff1[i]+"\n");
};
selectWindow("Log");
waitForUser("Done");
run("Close All");
}
