# UThPb = U-Pb + disequilibria

## Description
This repository contains software to make plots and perform calculations for U-Pb geochronology data subject to intermediate daughter isotope disequilibrium conditions that can be measured or assumed.  These comprise the 238U - 234U - 230Th - 226Ra - 206Pb and the 235U - 231Pa - 207Pb decay chains.

The algorithms that underpin the plots and calculations are being documented in a manuscript titled, "New Ways to Calculate U-Th and U-Th-Pb dates and uncertainties."  

These algorithms and software tools were created from discussion and collaboration with Chris Smith and David Richards (U of Bristol), and Nick Roberts and Dan Condon (NIGL/BGS) as part of the "Sharpening the U-Th Chronometer" NERC grant.

#### Table of Contents
* [Installation](#installation)
* [User Guide](#user-Guide)
* [Algorithms](#algorithms)
* [License](#license)


## Installation

* [Mac instructions](#mac-instructions)
* [PC instructions](#pc-instructions)

Go to the [releases](https://github.com/noahmclean/UThPb/releases) page at the UThPb GitHub repository to find the latest release.  If you don't want to use the link above, it's in the center of the page, above the orange bar and below the keywords.   

### Mac instructions
Download the __Install_UThPb.app.zip__ file to your hard drive.  Your browser could warn you that the file "may be dangerous."  Ignore this (e.g., in Chrome, click the ^ symbol by the download, then select 'Keep').

Double-click the .zip file to 'unzip' it.  Next, double-click the resulting Install_UThPb.app icon to begin the installation.  

If your security settings do not allow you to open apps downloaded from the internet, you might get a warning message that says "Install_UThPb can't be opened because it is from an unidentified developer..."  Hit the OK button, then right-click (or control-click) Install_UThPb and select 'Open' from the top of the menu.  Hit the 'Open' button on the pop-up window, and the app will begin to download the installation wizard.

If your security settings require to you enter a password before applications make changes, then you'll see a popup window that says 'java wants to make changes'.  Enter the password for your User Name (the same one you use to log in to your Mac) and hit 'OK'.

An UThPb Installer window should open and direct you through the install process. You should select an installation folder for the UThPb app, and another for a "MATLAB Runtime."  This ~600 MB install allows you to run MATLAB-produced apps like this one without buying a MATLAB product.  Accept the license agreement and place your first-born child in a FedEx box addressed to MathWorks -- just think of the savings on childcare!  After download and install, ignore the 'Product Configuration Notes' if they mean nothing to you.


### PC instructions
Download the __Install_UThPb.exe__ file to your hard drive.  Your browser could warn you that the file "may be dangerous."  Ignore this (e.g., in Chrome, click the ^ symbol by the download, then select 'Keep').

If your security settings do not allow you to open apps downloaded from the internet, you might get a warning message that says "Windows protected your PC..."  Click the 'More Info' link after the message, then hit the Run Anyway button.  

You may see a popup window asking 'Do you want to allow an app from an unknown publisher to make changes to your device'.  Click Yes to start the installer.

An UThPb Installer window will open and direct you through the install process. You should select an installation folder for the UThPb program, and another for a "MATLAB Runtime."  This ~600 MB install allows you to run MATLAB-produced apps like this one without buying a MATLAB product.  Accept the license agreement and place your first-born child in a FedEx box addressed to MathWorks -- just think of the savings on childcare!  


## User Guide

For detailed instructions, see the [UThPb User Guide](https://github.com/noahmclean/UThPb/wiki/User-Guide).

To run UThPb, navigate to the path where you installed it (the default is the Applications folder on a Mac or Program Files on a PC), then click the UThPb folder.  Inside the application folder, double-click the UThPb app/exe to run the program.

The UThPb window contains several components -- a U-Pb data table at the left, a U-Th data and results column in the middle, and a concordia plot on the right.  If the margins of one or more of these components is not showing correctly (e.g., a missing U-Pb label at the top left, a missing y-axis label, etc.), you can generally make these re-appear with a small adjustment to the UThPb window size.  

For more detailed instructions on inputting data, performing calculations, generating plots, and interpreting results, please see the [UThPb User Guide](https://github.com/noahmclean/UThPb/wiki/User-Guide).


## Algorithms

This program uses several mathematical algorithms to calculate ages, initial or current activity ratios, and generate plots.  Linear regression through U-Pb data uses the algorithm of [McLean (2014)](https://www.sciencedirect.com/science/article/pii/S0016703713004870), currently in just two dimensions.  The McLean algorithm yields the same results as the conventional York (1969, 2004) algorithm in 2D.

Modeling the U-series intermediate daughter disequilibria and radiogenic Pb ingrowth efficiently requires solving a system of first-order linear differential equations with several matrix exponential expressions.  The approach is outlined in an [2016 AGU poster](https://agu.confex.com/agu/fm16/meetingapp.cgi/Paper/198460), posted [here](link), and will be the subject of a journal article in preparation, called "New ways to calculate U-Th and U-Th-Pb dates."  


## License

[GNU General Public License v3.0](https://github.com/noahmclean/UThPb/blob/master/LICENSE)
