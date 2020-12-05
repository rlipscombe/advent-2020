fn main() {
    let values: Vec<Vec<u8>> = std::fs::read_to_string("input")
        .expect("input file")
        .lines()
        .map(|x| x.as_bytes().to_vec())
        .collect();

    let dx = 3;
    let dy = 1;

    println!("{}", count_trees(&values, dx, dy));
}

fn count_trees(values: &Vec<Vec<u8>>, dx: usize, dy: usize) -> i32 {
    let mut trees = 0;

    let mut x = 0;
    let mut y = 0;

    while y < values.len() {
        // '.' = 46 = space
        // '#' = 35 = tree
        let curr = values[y][x];
        //println!("{}", curr);
        if curr == 35 {
            trees += 1;
        }
        x += dx;
        x %= values[y].len();
        y += dy;
    }

    trees
}
