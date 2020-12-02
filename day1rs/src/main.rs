use std::iter::Iterator;
fn main() {
    let values: Vec<i64> = std::fs::read_to_string("input")
        .expect("input file")
        .lines()
        .map(|x| x.parse().expect("integer"))
        .collect();

    let arity = 3;
    let goal: i64 = 2020;

    let result = combination::combine::combine_vec(&values, arity)
        .iter()
        .filter(|&vals| vals.iter().sum::<i64>() == goal)
        .map(|vals| vals.iter().fold(1, |a, b| a * b))
        .next()
        .unwrap();
    println!("{}", result);
}
