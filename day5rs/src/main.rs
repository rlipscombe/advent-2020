// The key insight here is that the input strings are really just binary numbers,
// with F=0, B=1 for the first 7 characters, then L=0, R=1 for the final 3 characters.

fn main() {
    let input = std::fs::read_to_string("input").expect("input file");
    let mut seats: Vec<i32> = input.lines().map(parse).collect();
    println!("{}", seats.iter().max().unwrap());

    // Sort the list and then look for a discontinuity.
    seats.sort();
    println!("{}", find_discontinuity(&seats));
}

fn find_discontinuity(values: &Vec<i32>) -> i32 {
    let mut it = values.iter();
    let mut curr = *it.next().unwrap();
    loop {
        let next = *it.next().unwrap();
        if next != curr + 1 {
            return curr + 1;
        }
        curr = next;
    }
}

fn parse(s: &str) -> i32 {
    let mut seat = 0;
    let s = s.as_bytes();
    // row
    if s[0] == b'B' {seat += 1 << 9; }
    if s[1] == b'B' {seat += 1 << 8; }
    if s[2] == b'B' {seat += 1 << 7; }
    if s[3] == b'B' {seat += 1 << 6; }
    if s[4] == b'B' {seat += 1 << 5; }
    if s[5] == b'B' {seat += 1 << 4; }
    if s[6] == b'B' {seat += 1 << 3; }
    // seat in row
    if s[7] == b'R' {seat += 1 << 2; }
    if s[8] == b'R' {seat += 1 << 1; }
    if s[9] == b'R' {seat += 1 << 0; }
    seat
}

#[test]
fn name() {
    assert_eq!(parse("BFFFBBFRRR"), 567);
    assert_eq!(parse("FFFBBBFRRR"), 119);
    assert_eq!(parse("BBFFBBFRLL"), 820);
}
