$fs = 0.01;

// キーキャップ穴の大きさ
hole_side_len = 13.8;

// キーキャップ穴の大きさ / 2
hsl = hole_side_len / 2;

// ツメの高さ
hook_height = 0.6;

// キーキャップ穴の大きさ / 2 + ツメの高さ
hsl_hh = hsl + hook_height;

// pcbの厚さ
pcb_thick = 1.5;

// ツメとホルダーの間の厚さ
holding_hook_thick = 1;

// ツメの三角形部分
module diamond(){
    translate([0, 0, -hook_height/2])
        polyhedron(
            points = [
                [hsl_hh, hsl, 0], [hsl_hh, -hsl, 0], [-hsl_hh, -hsl, 0], [-hsl_hh, hsl, 0],
                [0, hsl, -hsl_hh/2], [0, -hsl, -hsl_hh/2], [0, hsl, hsl_hh/2], [0, -hsl, hsl_hh/2] ],
            faces = [
                [0, 3, 4], [1, 5, 2], [0, 4, 5, 1], [2, 5, 4, 3],
                [0, 6, 3], [1, 2, 7], [0, 1, 7, 6], [2, 3, 6, 7]
                ]);
}

module rounded_cube(height) {
    h = 0.01;
    minkowski () {
        cube([hole_side_len - 1.5, hole_side_len - 1.5, height + h], center = true);
        cylinder(r = 0.75, h = h);
    }
}

// キースイッチ用の角穴に引っ掛けるツメ部分
// pcb厚1.2㎜を想定
module holding_hook() {
    translate([0, 0, -pcb_thick])
        difference() {
            union() {
                translate([0, 0, (pcb_thick+0.5)/2]) rounded_cube(pcb_thick + 0.5);
                union(){
                    intersection() {
                        diamond();
                        rounded_cube(18);
                    }
                    intersection() {
                        diamond();
                        translate([-9,-3,-13]) cube([18, 6, 18]);
                    }
                }
            }
            translate([-(hole_side_len - holding_hook_thick * 2)/2, -8, -20])
                cube([hole_side_len - holding_hook_thick * 2, 16, 25]);
            translate([-hsl-0.5, -3.5, 0])
                cube([hole_side_len + 1, 7, 2]);
        }
}

// トラックボール保持部
module holder() {
    x = 17.3 / 2;
    y = 9.0;
    z = 6.9;
    polyhedron(
        points = [
            [x, y, 0], [x, -y, 0], [-x, -y, 0], [-x, y, 0],
            [x, y, z], [x, -y, z], [0, -y, z - 0.2], [-x, -y, z], [-x, y, z], [0, y, z - 0.2]
        ],
        faces = [
            [0, 1, 5, 4], [1, 2, 7, 6, 5], [2, 3, 8, 7], [3, 0, 4, 9, 8],
            [0, 3, 2, 1], [4, 5, 6, 9], [6, 7, 8, 9]
        ]);
}

// ホルダー本体
module trackball_unit_holder() {
    holding_hook();
    difference(){
        translate([-10, -8, 0])
            cube([20, 16, 9.5]);
        translate([0, 0, 1.5])
            holder();
        translate([-5, -9, 2])
            cube([10, 18, 15]);
        translate([-4.1, -9, -2])
            cube([10, 5, 4]);
    }
}

for (x = [0: 0]) {
    for (y = [0: 0]) {
        translate([x * 22, y * 18, 0])
            trackball_unit_holder();
    }
}
