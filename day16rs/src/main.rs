mod parser;
use parser::parse;
use std::ops::RangeInclusive;

#[derive(Debug)]
pub struct Rule {
    name: String,
    fst: RangeInclusive<i32>,
    snd: RangeInclusive<i32>,
}

#[derive(Debug)]
pub struct Notes {
    rules: Vec<Rule>,
    yours: Ticket,
    theirs: Vec<Ticket>,
}

#[derive(Debug)]
pub struct Ticket {
    numbers: Vec<i32>,
}

impl Notes {
    fn new() -> Self {
        Notes {
            rules: Vec::new(),
            yours: Ticket {
                numbers: Vec::new(),
            },
            theirs: Vec::new(),
        }
    }
}

fn main() {
    let path = "example";
    //let path = "input";
    let content = std::fs::read_to_string(path).expect("input file");
    let tickets = parse(&content);
    println!("{:?}", tickets);
}
