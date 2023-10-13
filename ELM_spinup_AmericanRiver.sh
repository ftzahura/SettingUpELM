#!/bin/sh
#SBATCH -C cpu
#SBATCH --time=00:13:00
#SBATCH --qos=regular

ngrids=1175
ntasks=128

CASE_NAM=IELM.NLDAS.$ngrids.$ntasks.spinup100.ARW.topo.surf2012
CASE_DIR=~/E3SM/cime/scripts

STOP_OPT=nyears
STOP_NTM=10
RESUB=0
echo -e "\n---------------- E3SM Case: " $CASE_DIR/$CASE_NAM "----------------"
echo -e "---------------- Period:" $RUN_YR_STR" ~ "$RUN_YR_END ",  " Total: $(($STOP_NTM*($RESUB+1))) $STOP_OPT "\n"

##############################
####    create ELM case   ####
##############################

echo -e "\n---------------- Create Case ----------------\n"
RESOLUT=ELM_USRDAT
COMPSET=IELM
PROJECT=m1800

cd ~/E3SM/cime/scripts

./create_newcase -case ${CASE_DIR}/${CASE_NAM} -res ${RESOLUT} -compset ${COMPSET} -project ${PROJECT} 
echo -e "\n-- RES " ${RESOLUT} " -- COMPSET " ${COMPSET} "\n"

##############################
####   set ELM case   ####
##############################

echo -e "\n---------------- UserSet Case ----------------\n"

cd ${CASE_DIR}/${CASE_NAM}

./xmlchange JOB_WALLCLOCK_TIME="03:00:00" --subgroup case.run
./xmlchange NTASKS=$ntasks
./xmlquery  JOB_QUEUE,NTASKS,JOB_WALLCLOCK_TIME

#./xmlchange RUN_STARTDATE=1980-01-01
./xmlchange STOP_N=$STOP_NTM,STOP_OPTION=$STOP_OPT  # year period per run/resubmit
./xmlchange RESUBMIT=$RESUB
./xmlquery  RUN_STARTDATE,STOP_N,STOP_OPTION,RESUBMIT,REST_N,REST_OPTION

# datm forcing period
./xmlchange DATM_MODE=CLMNLDAS2
./xmlchange DATM_CLMNCEP_YR_START=1980
./xmlchange DATM_CLMNCEP_YR_END=1989
./xmlchange DATM_CLMNCEP_YR_ALIGN=1980
./xmlquery  DATM_MODE,DATM_CLMNCEP_YR_START,DATM_CLMNCEP_YR_END,DATM_CLMNCEP_YR_ALIGN

./xmlchange LND_DOMAIN_FILE=domain_${ngrids}x1_sparse_grid_American_230201.nc
./xmlchange ATM_DOMAIN_FILE=domain_${ngrids}x1_sparse_grid_American_230201.nc
./xmlchange LND_DOMAIN_PATH=/global/homes/f/fzahura/mygrids
./xmlchange ATM_DOMAIN_PATH=/global/homes/f/fzahura/mygrids
./xmlquery LND_DOMAIN_FILE,ATM_DOMAIN_FILE
echo -e "-- update: user_nl_elm --"
cat >> user_nl_elm << EOF
fsurdat = '/global/homes/f/fzahura/mygrids/surfdata_1175x1_sparse_grid_2012_American_update1k.nc'
use_top_solar_rad = .true.
EOF

echo -e "-- update: datm.streams --"
./case.setup
cp ${CASE_DIR}/${CASE_NAM}/CaseDocs/datm.streams.txt.CLMNLDAS2.Precip ${CASE_DIR}/${CASE_NAM}/user_datm.streams.txt.CLMNLDAS2.Precip
cp ${CASE_DIR}/${CASE_NAM}/CaseDocs/datm.streams.txt.CLMNLDAS2.Solar ${CASE_DIR}/${CASE_NAM}/user_datm.streams.txt.CLMNLDAS2.Solar
cp ${CASE_DIR}/${CASE_NAM}/CaseDocs/datm.streams.txt.CLMNLDAS2.TPQW ${CASE_DIR}/${CASE_NAM}/user_datm.streams.txt.CLMNLDAS2.TPQW

chmod +rw ${CASE_DIR}/${CASE_NAM}/user_datm.streams.txt.CLMNLDAS2.Precip
chmod +rw ${CASE_DIR}/${CASE_NAM}/user_datm.streams.txt.CLMNLDAS2.Solar
chmod +rw ${CASE_DIR}/${CASE_NAM}/user_datm.streams.txt.CLMNLDAS2.TPQW

sed -i "s@/global/cfs/cdirs/e3sm/inputdata/share/domains/domain.clm@/global/homes/f/fzahura/mygrids@g"  ${CASE_DIR}/${CASE_NAM}/user_datm.streams.txt.CLMNLDAS2.Precip
sed -i "s@/global/cfs/cdirs/e3sm/inputdata/share/domains/domain.clm@/global/homes/f/fzahura/mygrids@g"  ${CASE_DIR}/${CASE_NAM}/user_datm.streams.txt.CLMNLDAS2.Solar
sed -i "s@/global/cfs/cdirs/e3sm/inputdata/share/domains/domain.clm@/global/homes/f/fzahura/mygrids@g"  ${CASE_DIR}/${CASE_NAM}/user_datm.streams.txt.CLMNLDAS2.TPQW

##############################
####   build&submit case  ####
##############################

echo -e "\n---------------- Build&Submit Case ----------------\n"

./case.setup --reset

./case.build

./case.submit --mail-user fariatuz.zahura@pnnl.gov --mail-type all
