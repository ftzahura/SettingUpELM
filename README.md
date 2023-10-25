# SettingUpELM

**Step 1:**
CreateSurfdataDomainNetcdf.ipynb: creates surface and domain netcdfs for user defined resolution and area of interest from a coarse global domain and surface dataset. This python notebook was generated following the MATLAB scripts by Gautam Bisht: https://github.com/bishtgautam/matlab-script-for-clm-sparse-grid/

**Step 2:**
Update_surfdata.ipynb: updates surface dataset generated using coarse resolution global surface dataset with high resolution (1km) data. 

**Step 3:**
ELM_documentation.ipynb contains steps to set up an ELM case on NERSC and submit run for spin up and transient cases.
ELM_spinup_AmericanRiver.sh batch script to submit job on NERSC using previously generated domain and surface datasets.

**Step4:**
Plot_spinup_outputs.ipynb plots spinup results to check if the model becomes stable.
Plot_ELM_outputs.ipynb example script to plot temporal and spatial outputs.
Make_GIF.ipynb example script to genertae gif using time series spatial plots.


