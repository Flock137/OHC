# Oldham Coupling simulation

Update (To my teammates): The code is ready for simulation. You may take a look at it and adjust to your liking. However, note that, this simulation is a bit different from the mathematical model that we have built. Probably because the elliptical trammel didn't account for the movement of the middle flange, although the Oldham Coupling and the Elliptical Trammel are both double-slider crank mechansim.

# Files
- `oldham_coupling_continuous.m` - This is our main code for simulation of Oldham coupling. Although incorrect, it serves a purpose to help the viewer visuallize the similarity between OHC and the Elliptical Trammel. One of my proudest work.
- `oldham_obsidian.m` - Is an Elliptical Trammel simulation - the "root" of the script above, albeit have difference in the overall math used 
- `Media` folder - Storage of pictures/videos of simulation from Matlab, may come with annotations
- `oldham_coupling.m` - This is an accurate version of the simulation, where flange 1 and 3 doesn't move

# Notes
Although the movement around the axis may look off center, but, rest assured, this is still the theoretically correct movements of the mechanism. Perhaps they are the same mathematical model but differs in terms of how one would alter the elements in the function. 

# Limitation 
The mathematical model of the Oldham Coupling, is regrettably, speculative, due to the fact that there is way too few research on its kinematic model. It was built mainly on the fact that this is a double-crank slider mechanism, and the assumption of dynamics similarity to the Elliptical Trammel. And, therefore, despite the project deadline, this is an "unfinished" project, at least until a formal research on the mechanism is conducted.

# Future Updates
These files would be updated in the future, including, but not limited to: 
- A Python counterpart of the script. Since MATLAB is proprietary, and is also unsuitable for this task, due to its nature as a Matrix Laboratory, which makes the fucntions solely relying on matrix, while it need not necessary to be like such.
- A Fusion360 and FreeCAD model that may come with animations.
- A concise literature review, or at least some remarks on the mechanism's previous researches.

# Credits
- Nguyen Dinh Phong: SOLIDWORK design (the 3D model of this mechanism), Pure math model.  
- Le The Doan: Pure math model. 
- Professor Do Tho Truong: The initial project suggestion is his.