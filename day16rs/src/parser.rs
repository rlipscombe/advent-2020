use super::{Notes, Rule, Ticket};

use regex::Regex;

#[derive(Clone, Copy, Debug)]
enum ParseState {
    Rules,
    Yours,
    Theirs,
}

pub fn parse(content: &str) -> Notes {
    let mut notes = Notes::new();

    let rule_re = Regex::new(r"^([a-z]+): (\d+)-(\d+) or (\d+)-(\d+)$").unwrap();
    let mut state = ParseState::Rules;
    for line in content.lines() {
        //        println!("{} {:?}", line, state);

        match (state, line) {
            (ParseState::Rules, "your ticket:") => {
                state = ParseState::Yours;
            }
            (ParseState::Rules, "") => {}
            (ParseState::Rules, rule) => {
                if let Some(captures) = rule_re.captures(rule) {
                    let name = captures[1].to_string();
                    let a0 = captures[2].parse::<i32>().expect("number");
                    let a1 = captures[3].parse::<i32>().expect("number");
                    let b0 = captures[4].parse::<i32>().expect("number");
                    let b1 = captures[5].parse::<i32>().expect("number");
                    //                    println!("{}: {:?} or {:?}", name, a0..=a1, b0..=b1);

                    let rule = Rule {
                        name,
                        fst: a0..=a1,
                        snd: b0..=b1,
                    };
                    notes.rules.push(rule);
                }
            }
            (ParseState::Yours, "nearby tickets:") => {
                state = ParseState::Theirs;
            }
            (ParseState::Yours, "") => {}
            (ParseState::Yours, numbers) => {
                let numbers: Vec<i32> = numbers
                    .split(",")
                    .map(|x| x.parse::<i32>().expect("number"))
                    .collect();
                //                println!("{:?}", numbers);
                notes.yours = Ticket { numbers };
            }
            (ParseState::Theirs, numbers) => {
                let numbers: Vec<i32> = numbers
                    .split(",")
                    .map(|x| x.parse::<i32>().expect("number"))
                    .collect();
                //                println!("{:?}", numbers);
                notes.theirs.push(Ticket { numbers });
            }
        }
    }

    notes
}
