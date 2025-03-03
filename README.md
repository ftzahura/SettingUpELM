# SettingUpELM

**Step 1:**
CreateSurfdataDomainNetcdf.ipynb: creates surface and domain netcdfs for user defined resolution and area of interest from a coarse global domain and surface dataset. This python notebook was generated following the MATLAB scripts by Gautam Bisht: https://github.com/bishtgautam/matlab-script-for-clm-sparse-grid/

**Step 2:**
Update_surfdata.ipynb: updates surface dataset (generated in **Step 1** using coarse resolution global surface dataset) with high resolution (1km) data. (Optional, high res data needed)

**Step 3:**
Surf_Domain_insideWS.ipynb: creates surface/domain dataset within shapefile boundary using domain (generated in **Step1**) and updated surface dataset (generated in **Step 2**). 

**Step 4:**
ELM_documentation.ipynb contains steps to set up an ELM case on NERSC and submit run for spin up and transient cases.
ELM_spinup_AmericanRiver.sh batch script to submit job on NERSC using previously generated domain and surface datasets.

**Step 5:**
Plot_spinup_outputs.ipynb plots spinup results to check if the model becomes stable.
Plot_ELM_outputs.ipynb example script to plot temporal and spatial outputs.
Make_GIF.ipynb example script to generate gif using time series spatial plots.


