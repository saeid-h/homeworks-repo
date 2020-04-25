#!/bin/bash

#SBATCH --partition=normal # sipe

#SBATCH --exclusive

#SBATCH --ntasks=4
 
#SBATCH --ntasks-per-node=4

#SBATCH --workdir=/home/oucs009/SIPE/det
 
#SBATCH --output=/home/oucs009/SIPE/HW3/bvp_%J_stdout.txt
#SBATCH --error=/home/oucs009/SIPE/HW3/bvp_%J_stderr.txt
 
#SBATCH --time=00:30:00
 
#SBATCH --job-name=DET
 
###SBATCH --mail-user=saied@ou.edu
 
#SBATCH --mail-type=ALL
 
echo "Working directory:"
pwd
echo ""

module load OpenMPI
 
mpirun /home/oucs009/SIPE/det/det

