use itertools::Itertools;

fn main() {
    let values: Vec<i64> = std::fs::read_to_string("input")
        .expect("input file")
        .lines()
        .map(|x| x.parse().expect("integer"))
        .collect();
    let look = 25;
    let part1 = part1(&values, look);
    println!("{}", part1);
}

fn part1(values: &[i64], look: usize) -> i64 {
    let mut pos = look;

    loop {
        // TODO: Does itertools provide a way to do this?
        let prefix = &values[(pos - look)..pos];
        let curr = values[pos];

        //println!("{:?} {}", prefix, curr);

        let pairs = prefix.iter().combinations(2);
        if !itertools::any(pairs, |v| v[0] + v[1] == curr) {
            return curr;
        }

        pos += 1;
    }
}
