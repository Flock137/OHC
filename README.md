# Temporary Repository for Oldham Coupling simulation

Update: The code is ready for simulation. You may take a look at it and adjust to your liking. However, note that, this simulation is a bit different from the mathematical model that we have built. Probably because the elliptical trammel didn't account for the movement of the middle flange.

# Documentation 
- `oldham_coupling_continuous.m` - This is our main code for simulation of Oldham coupling.
- `oldham_obsidian.m` - Is an Elliptical Trammel simulation - the "root" of the script above, albeit have difference in the overall math used 
- `Media` folder - Storage of pictures/videos of simulation from Matlab, may come with annotations

# Notes
- Although the movement around the axis may look off center, but, rest assured, this is still the theoretically correct movements of the mechanism.

# Limitation 
The mathematical model of the Oldham Coupling, is regrettably, speculative, due to the fact that there is way too few research on its kinematic model. It was built mainly on the fact that this is a double-crank slider mechanism, and the assumption of dynamics similarity to the Elliptical Trammel. And, therefore, despite the project deadline, this is an "unfinished" project, at least until a formal research on the mechanism is conducted.

# Future Updates
These files would be updated in the future, including, but not limited to: 
- A Python counterpart of the script. Since MATLAB is proprietary, and is also unsuitable for this task, due to its nature as a Matrix Laboratory.
- A Fusion360 and FreeCAD model with (hopefully) animations.

# Credits
- Nguyen Dinh Phong: SOLIDWORK design (the 3D model of this mechanism), Pure math model.  
- Le The Doan: Pure math model. 
- Professor Do Tho Truong: The initial project suggestion is his.