# IISRD
Insect inspired self-righting for fixed wing drones

In this repository we provide the source code accompanying our article: "Insect inspired self-righting for fixed wing drones".
Specifically, we provide the MATLAB Simulink simulation of our self-righting drone which can be modified to test different types of self-righting configurations. 
Moreover we supply the MATLAB scripts we used for analyzing and visualizing the aerodynamic data we collected with our wind-tunnel configuration. 
Finally the CAD for the drone is provided which can be used to adapt the proposed self-righting mechanism to any conventional UAV and to build it.
## Requirements
For developing and runnning the simulation and the scripts, we used MATLAB R2020a with the Simulink extention in a Windows 10 x64 operating system.

## Usage
The repository has three main components. 
- A folder called `CAD`, which contains the Inventor part (.ipt) and assembly (.iam) files.
- A folder called `scripts`, which contains the dynamic and aerodynamic analysis and visualization scripts.
- A folder called `simulation`, which contains the MATLAB Simulink simulation files.


Each file contains its own `README.md` file with dedicated instructions on how to use them.

## Dataset
The dataset of both the dynamic and the aerodynamic experiments can be found in [Zenodo](10.5281/zenodo.4568184).

## Citation 
If you use this work in an academic context, please cite the following article:
```bibtex
@article{vourtsis_iisr_2021,
    title   = {Insect Inspired Self-Righting for Fixed-Wing Drones},
    author  = {Vourtsis, Charalampos and Ramirez Serrano, Francisco and Casas Rochel, Victor and Stewart, William and Floreano, Dario},
    journal = {-},
    year    = {2021},
    pages   = {7},
}
```
## License
This project is released under the [MIT License](https://opensource.org/licenses/MIT). Please refer to the `LICENSE` for more details.

