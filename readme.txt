Automatic generation of 3D landmark symbols based on topological perception code
author:Yuan Ding, DongMing Chen,FuMing Jin,XinYu Huang
e-mail:dingyuanhhu@hhu.edu.cn
illustrate:Run the code in sections to output images and save the mesh
Please note that drawing may be slower. Please comment out the drawing code as needed


%%%%%%%%%%%% steps%%%%%%%%%%%%%%%
1.Run MATLAB code according to comments
2. Convert the two output obj files to off files using meshlab
3. Using Cpp code to process two off files
4. Use meshlab to perform Boolean operations and obtain the final 3D symbol in obj format

%%%%%%%%%%%%prompt%%%%%%%%%%%%%%
1. Matlab version R2020b or above
2. CPP requires configuring CGAL environment
3. You can obtain meshlab from the following link
"https://www.meshlab.net/"