fn main() {
    let values: Vec<Vec<u8>> = std::fs::read_to_string("input")
        .expect("input file")
        .lines()
        .map(|x| x.as_bytes().to_vec())
        .collect();

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
        x += 3;
        x %= values[y].len();
        y += 1;
    }

    println!("{}", trees);
}
