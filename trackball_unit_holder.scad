
// ツメの三角形部分
module diamond(){
    translate([0, 0, -0.5])
        polyhedron(
            points = [
                [8, 6.95, 0], [8, -6.95, 0], [-8, -6.95, 0], [-8, 6.95, 0],
                [0, 6.95,-12], [0, -6.95,-12], [0, 6.95, 4], [0, -6.95, 4] ],
            faces = [
                [0, 3, 4], [1, 5, 2], [0, 4, 5, 1], [2, 5, 4, 3],
                [0, 6, 3], [1, 2, 7], [0, 1, 7, 6], [2, 3, 6, 7]
                ]);
}

// 14*14の角穴に引っ掛けるツメ部分
// pcb厚1.2㎜を想定
module holding_hook() {
    translate([0, 0, -1.3])
        difference() {
            union() {
                translate([-6.95,-6.95, 0]) cube([13.9, 13.9, 1.4]);
                union(){
                    intersection() {
                        diamond();
                        translate([-6.95, -6.95, -12.5]) cube([13.9, 13.9, 18]);
                    }
                    difference() {
                        diamond();
                        translate([-9,-3,-13]) cube([18, 6, 18]);
                    }
                }
            }
            translate([-5.95, -8, -12.5]) cube([11.9, 16, 18]);
        }
}

// ホルダー本体
module trackball_unit_holder() {
    holding_hook();
    difference(){
        translate([-10, -8, 0])
            cube([20, 16, 9.5]);
        translate([-8.5, -9, 1.5])
            cube([17, 18, 7]);
        translate([-6, -9, 2])
            cube([12, 18, 10]);
        translate([-4.05, -9, -2])
            cube([10, 5, 4]);
    }
}

for (x = [0: 1]) {
    for (y = [0: 1]) {
        translate([x * 22, y * 18, 0])
            trackball_unit_holder();
    }
}