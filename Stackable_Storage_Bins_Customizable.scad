// -------------------------------------+---------------------------------------+---------------------------------------+---------------------------------------
// Title:        Stackable Storage Bins Customizable
// Version:      1.1
// Release Date: 2022-06-29
// Author:       Eloy Asensio (eloi.asensio@gmail.com)
// -------------------------------------+---------------------------------------+---------------------------------------+---------------------------------------
//
// Description:
//
// - Parametric Stackable Storage Bins, designed to be printed in one step.
//
//
// Release Notes:
//
// - Version 1.2: Viewer menu
// - Version 1.1: Collect stacks of Bins (puzzle mode)
// - Version 1.0: Stackable Storage Bins basic. Stack Bins.
//
// -------------------------------------+---------------------------------------+---------------------------------------+---------------------------------------
// -------------------------------------+---------------------------------------+---------------------------------------+---------------------------------------
// Constants:
// -------------------------------------+---------------------------------------+---------------------------------------+---------------------------------------


// System constants.
EPS = 0.01+0;
MARGIN_BETWEEN_PIECES = 0.5+0;
TOP_REMOVER_WIDTH = 4+0;
TOP_REMOVER_HEIGHT = 4+0;

// -------------------------------------+---------------------------------------+---------------------------------------+---------------------------------------

/* [View Options] */
design_type = 0; // [0:Storage Bin, 1:Divider, 2:Cover]
/* [Storage Bin - Assembly Parameters] */
// With of  Storage Bins (millimeters). Top and bottom support not included.
width = 80;
// depth of  Storage Bins (in )millimeters). The depth of nose isn't include in this value.
depth = 100;
// Height of  Storage Bins (millimeters). Top support not included.
height = 60;
// Thickness of the walls (millimeters). This value influences almost all parts of the design (walls, supports,...) 
width_Wall=2;

/* [Storage Bin - Nose Parameters] */
// depth of nose (millimeters).
nose_depth=15;
// Distance between the base of the nose and the floor (millimeters)
nose_tall=15;
// Nose height (millimeters)
nose_height=10;
// Show or hide bridge of nose. (true = show bridge | false = hide bridge)
nose_with_bridge = true; 

/* [Storage Bin - Support: Top, Bottom] */
// Top support to make it stackable (true = show | false = hide)
support_top = true;
// Support to make it stackable
support_bottom_right=1; // [0:None, 1:pyramid, 2:puzzle]
// Support to make it stackable
support_bottom_left=1; // [0:None, 1:pyramid, 2:puzzle]

/* [Dividers] */
// Divider for storage bins. Add supports to place the dividers. (values from 0 to N)
dividers_num = 0; // [0:10]
// Shows the layout of a divider and hides the layout of the container (true | false)
dividers_show_template = false; 

/* [Cover] */
// Shows the layout of cover and hides the layout of the container (true | false)
cover_show_template = false; 

// -------------------------------------+---------------------------------------+---------------------------------------+---------------------------------------

BN_ANG = atan(nose_tall/nose_depth);
N_BASE_ANG = 90 - BN_ANG;
N_BASE_TALL = width_Wall / sin(N_BASE_ANG);
N_MID_TALL =  ( tan(BN_ANG) * (nose_depth-width_Wall) ) + N_BASE_TALL;
TOP_NOSE = nose_with_bridge ? height : nose_tall + nose_height;


// -------------------------------------+---------------------------------------+---------------------------------------+---------------------------------------

main();

module main ()
{      
    if( design_type == 1 ){
        divider();
    }
    else if( design_type == 2 ){
        cover();
    }
    else if( design_type == 0 ){
        storageBin();
    }
}

// -------------------------------------+---------------------------------------+---------------------------------------+---------------------------------------

module storageBin(){
    union(){
            translate([0,nose_depth, 0]){
                body();
            };
            translate([EPS, EPS, 0])nose();
            translate([0, EPS, 0])cheek(0);
            translate([0, EPS, 0])cheek( ( width - width_Wall + EPS) );
            supportsTop();
            supportsBottom();
            dividersSupports();  
    }
}

module nose ()
{
    polyhedron(
        points=[
            [0, nose_depth ,0], //0 Throat Bottom
            [width-EPS*2, nose_depth ,0], //1  Throat Bottom
            [width, nose_depth, N_BASE_TALL], //2 Throat Bottom
            [0,nose_depth , N_BASE_TALL], //3 Throat Bottom

            [0, 0, nose_tall], //4 Throat Top
            [width-EPS*2, 0 ,nose_tall], //5  Throat Top
            [width-EPS*2, width_Wall, N_MID_TALL], //6 nose Bottom
            [0, width_Wall, N_MID_TALL ], //7 nose Bottom

            [0, 0, nose_tall + nose_height], //8 nose Top
            [width-EPS*2, 0, nose_tall + nose_height], //9  nose Top
            [width-EPS*2, width_Wall, nose_tall + nose_height], //10 nose Top
            [0, width_Wall, nose_tall + nose_height ], //11 nose Top
        ],
        faces=[
            [0,1,2,3], // Throat bottom
            [3,2,6,7], // Throat Front
            [0,4,5,1], // Throat Back

            [0,3,7], // Throat Left1
            [0,7,4], // Throat Left2
            [4,7,11], // Nose Left3
            [4,11,8], // Nose Left4

            [1,5,6], // Throat Right1
            [1,6,2], // Throat Right2
            [5,10,6], // Nose Right3
            [5,9,10], // Nose Right4

            [8,11,10,9], // Nose Top
            [4,8,9,5], // Nose Front
            [7,6,10,11], // Nose Back
        ]
    );
}

module cheek(xPosition){
     
    polyhedron(
        points=[
            [xPosition, nose_depth+EPS , N_BASE_TALL], //0 Throat Bottom
            [xPosition, width_Wall-EPS, N_MID_TALL ], //1 nose Bottom
            [xPosition, width_Wall-EPS, nose_tall + nose_height ], //2 nose Top
            [xPosition, nose_depth+EPS, TOP_NOSE ], //3 nose Top
            [xPosition + width_Wall, nose_depth+EPS , N_BASE_TALL], //4 Throat Bottom
            [xPosition + width_Wall, width_Wall-EPS, N_MID_TALL ], //5 nose Bottom
            [xPosition + width_Wall, width_Wall-EPS, nose_tall + nose_height ], //6 nose Top
            [xPosition + width_Wall, nose_depth+EPS, TOP_NOSE ], //7 nose Top
        ],
        faces=[
            [0,1,2,3],
            [4,7,6,5],
            [2,6,7,3],
            [1,0,4,5],
            [1,5,6,2],
            [0,3,7,4],
        ]
    );
}

module body(){
    difference() 
    {
        cube( [width,depth,height] );
        translate([width_Wall,0-EPS, width_Wall]) {
            cube([
                width-(width_Wall*2)+EPS,
                depth - (width_Wall),
                height
            ]);
        };
    };
}

module supportsTop(){
    if( support_top == true ){
        translate([width - EPS,depth + nose_depth,height - 4.86]){
            oneSupportTop();
        };
        translate([0 + EPS, nose_depth,height - 4.86]){
            rotate(a=180, v=[0,0,1]){
                oneSupportTop();
            }
        }
    }
}

module oneSupportTop(){
    rotate(a=90, v=[1,0,0]){
        difference() {
            linear_extrude(depth) {
                polygon(
                    [
                        [0,0],
                        [6,4.86],
                        [6,4.86 + 4],
                        [0,4.86 + 4]],
                    [
                        [0,1,2,3]
                    ]
                );
            }
            translate([0-EPS,4.86+EPS,2+EPS]){
                linear_extrude(depth - (width_Wall * 2)){
                    square(TOP_REMOVER_WIDTH,TOP_REMOVER_HEIGHT);
                }
            }
            translate([0-EPS,6.86+EPS,6+EPS]){
                linear_extrude(depth){
                    square([1,4],true);
                }
            }
        }
    }
}

module supportsBottom(){
    if( is_num(search(support_bottom_right, [1,2])[0]) || is_num(search(support_bottom_left, [1,2])[0]) 
        ){
        // pyramid right
        if( support_bottom_right == 1){
            translate([EPS, nose_depth + depth - 2 - 0.5])
                oneSupportBottomPyramid();
        }
        // puzzle right
        else if(support_bottom_right == 2){
            translate([EPS, nose_depth + depth - 2 - 0.5])
                oneSupportAssemblableBottomPuzzleLeft();  
        }
        // pyramid left
        if( support_bottom_left == 1){
            translate([width-EPS,nose_depth + 2 + 0.5])
                rotate(a=180, v=[0,0,1])
                    oneSupportBottomPyramid();
        }
        // puzzle left
        else if(support_bottom_left == 2){
                translate([width-EPS,nose_depth + 2 + 0.5])
                    oneSupportAssemblableBottomPuzzleRight();
        }
    }
}


module oneSupportAssemblableBottomPuzzleLeft(){
    lDepth = depth - 2 - 2 - 1;
    lDepthPlus = 3;
    lHeight = 2.81;
    lWidth = 6+0.4;
    lWidthPLus = 3;
    adder = 0.2;
    rotate(a=180, v=[0,0,1]){
        linear_extrude(lHeight) {
             polygon(
                [
                    [0,0],
                    [0, lDepth],
                    [lWidth,lDepth],
                    [lWidth, lDepth-lDepthPlus*2],
                    [lWidth+lWidthPLus+adder, lDepth-lDepthPlus-adder],
                    [lWidth+lWidthPLus+adder, lDepthPlus+adder],
                    [lWidth, lDepthPlus*2],
                    [lWidth,0]
                ],
                [
                    [0,1,2,3,4,5,6,7]
                ]
            );
        }
    }
    
}

module oneSupportAssemblableBottomPuzzleRight(){
    remover = 0.5;
    lDepth = depth - 2 - 2 - 1;
    lDepthPlus = 3 - remover;
    lHeight = 2.81;
    lWidth = 6 +0.4-remover;
    lWidthPLus = 3 + remover;
    plus_fix = 1;
    linear_extrude(lHeight) {
         polygon(
            [
                [0,0],
                [0, lDepth],
                [lWidth,lDepth],
                [lWidth, lDepth-lDepthPlus*2],
                [lWidth-lWidthPLus, lDepth-lDepthPlus],
                [lWidth-lWidthPLus, lDepthPlus],
                [lWidth, lDepthPlus*2],
                [lWidth,0]
            ],
            [
                [0,1,2,3,4,5,6,7]
            ]
        );
    }
}


module oneSupportBottomPyramid(){
    rotate(a=90, v=[1,0,0]){
        rotate(a=90, v=[0,0,1]){
            linear_extrude(depth - 2 - 2 - 1) {
                polygon(
                    [
                        [0,0],
                        [0, 3.75],
                        [2.81,0]
                    ],
                    [
                        [0,1,2]
                    ]
                );
            }
        }
    }
}

module dividersSupports(){
    if(dividers_num > 0){
        widthCenterDivider = (width - (width_Wall*2)) / (dividers_num+1);
        for(i=[1:(dividers_num)]) {      
            echo ((widthCenterDivider * i) + width_Wall);
            dividersSupport( (widthCenterDivider * i) + width_Wall );
        }
    }
}

module dividersSupport(x){
    linearExtrude = ((depth-width_Wall)/4);
    translate([x-(width_Wall/2), nose_depth + (depth/2) + (linearExtrude/2),width_Wall-EPS]){
        rotate(a=90, v=[1,0,0]){
            rotate(a=90, v=[0,0,1]){
                dividersHalfSupport(linearExtrude);
            }
        }
        translate([width_Wall,0,0]){
            rotate(a=90, v=[1,0,0]){
                dividersHalfSupport(linearExtrude);
            }
        }
    }
    translate([x-(width_Wall/2), nose_depth + (depth - width_Wall),height-EPS]){
        rotate(a=180, v=[1,0,0]){
            rotate(a=90, v=[0,0,1]){
                dividersHalfSupport(height-width_Wall);
            }
        }
        translate([width_Wall,0,0]){
            rotate(a=180, v=[1,0,0]){
                dividersHalfSupport(height-width_Wall);
            }
        }
    }
}

module dividersHalfSupport(x){
    translate([0,0, 0]){
        linear_extrude( x ) {
            polygon(
                [
                    [0,0],
                    [0, width_Wall],
                    [width_Wall,0]
                ],
                [
                    [0,1,2]
                ]
            );
        }
    }
}

module divider(){
    linear_extrude(width_Wall-(0.4)) {
        k = 1.5;
        scale([1,1,1]){
            if(nose_with_bridge){
                polygon(
                    [
                        [nose_depth+EPS, N_BASE_TALL], //0 Throat Bottom
                        [width_Wall-EPS, N_MID_TALL ], //1 nose Bottom
                        [width_Wall-EPS, nose_tall + nose_height ], //2 nose Top
                        [nose_depth+EPS, height], //3 nose Top
                        [nose_depth+EPS+depth-(width_Wall*1.5), height], //4 nose Top
                        [nose_depth+EPS+depth-(width_Wall*1.5), N_BASE_TALL ], //5 nose Top
                    ],
                    [
                        [0,1,2,3,4,5]
                    ]
                );
            }
            else{
                polygon(
                    [
                        [nose_depth+EPS, width_Wall], //0 Throat Bottom
                        [nose_depth+EPS, height], //3 nose Top
                        [nose_depth+EPS+depth-width_Wall, height], //4 nose Top
                        [nose_depth+EPS+depth-width_Wall, width_Wall ], //5 nose Top
                    ],
                    [
                        [0,1,2,3]
                    ]
                );
            }
        }
        
    }
}

module cover(){
    cover_depth  = depth - (width_Wall * 2) - MARGIN_BETWEEN_PIECES;
    cover_width  = width + (TOP_REMOVER_WIDTH * 2) - MARGIN_BETWEEN_PIECES;
    cover_height = TOP_REMOVER_HEIGHT;
    translate([0,0,3])
        cube([cover_width, cover_depth, cover_height], center=true);
}




