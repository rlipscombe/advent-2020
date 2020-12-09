use itertools::Itertools;

fn main() {
    //let (path, look) = ("example", 5);
    let (path, look) = ("input", 25);
    let values: Vec<i64> = std::fs::read_to_string(path)
        .expect("input file")
        .lines()
        .map(|x| x.parse().expect("integer"))
        .collect();
    let part1 = part1(&values, look);
    println!("part1 = {}", part1);

    let part2 = part2(&values, part1).unwrap();
    //println!("{:?}", part2);

    // Want the smallest and largest number in that slice.
    println!(
        "part2 = {}",
        part2.iter().min().unwrap() + part2.iter().max().unwrap()
    );
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

fn part2(values: &[i64], target: i64) -> Option<&[i64]> {
    // Start at some position in the list of values. Add up the contiguous numbers
    // from there until we've matched (yay!) or exceeded (sad face) the target number,
    // or fallen off the end.
    // Alternatively, meh: just sum the range.
    // If we can't find it, advance one position and try again.
    for len in 2..values.len() {
        for pos0 in 0..values.len() - len {
            let pos1 = pos0 + len;
            let sum: i64 = values[pos0..=pos1].iter().sum();
            //println!("{:?} {}", &values[pos0..=pos1], sum);
            if sum == target {
                return Some(&values[pos0..=pos1]);
            }
        }
    }
    /*for pos0 in 0..values.len() {
        for pos1 in (pos0 + 1)..values.len() {
            let sum: i64 = values[pos0..=pos1].iter().sum();
            //println!("{:?} {}", &values[pos0..=pos1], sum);
            if sum == target {
                return Some(&values[pos0..=pos1]);
            }
        }
    }*/

    None
}
