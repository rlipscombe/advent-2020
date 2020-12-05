use regex::Regex;
use std::ops::RangeBounds;

#[derive(Default, Debug)]
struct Passport<'a> {
    byr: Option<i32>,
    iyr: Option<i32>,
    eyr: Option<i32>,
    hgt: Option<Height>,
    hcl: Option<&'a str>,
    ecl: Option<Eyes>,
    pid: Option<&'a str>,
    cid: Option<&'a str>,
}

#[derive(Debug)]
enum Height {
    In(i32),
    Cm(i32),
}

#[derive(Debug)]
enum Eyes {
    Amb,
    Blu,
    Brn,
    Gry,
    Grn,
    Hzl,
    Oth,
}

fn parse(x: &str) -> Passport {
    let mut passport: Passport = Default::default();

    for x in x.split_whitespace() {
        //        println!("{:?}", x);

        let mut s = x.split(':');
        match s.next() {
            Some("byr") => {
                passport.byr = validate_byr(s.next());
            }
            Some("iyr") => {
                passport.iyr = validate_iyr(s.next());
            }
            Some("eyr") => {
                passport.eyr = validate_eyr(s.next());
            }
            Some("hgt") => {
                passport.hgt = validate_hgt(s.next());
            }
            Some("hcl") => {
                passport.hcl = validate_hcl(s.next());
            }
            Some("ecl") => {
                passport.ecl = validate_ecl(s.next());
            }
            Some("pid") => {
                passport.pid = validate_pid(s.next());
            }
            Some("cid") => {
                passport.cid = s.next();
            }
            _ => todo!(),
        }
    }

    //println!("{:?}", passport);
    passport
}

fn validate_byr(s: Option<&str>) -> Option<i32> {
    validate_year(s, 1920..=2002)
}

fn validate_iyr(s: Option<&str>) -> Option<i32> {
    validate_year(s, 2010..=2020)
}

fn validate_eyr(s: Option<&str>) -> Option<i32> {
    validate_year(s, 2020..=2030)
}

fn validate_year<R: RangeBounds<i32>>(s: Option<&str>, r: R) -> Option<i32> {
    match s {
        None => None,
        Some(s) => match s.parse() {
            Ok(n) => {
                if r.contains(&n) {
                    Some(n)
                } else {
                    None
                }
            }
            Err(_) => None,
        },
    }
}
fn validate_hgt(s: Option<&str>) -> Option<Height> {
    s.and_then(|s| {
        let re = Regex::new(r"^(\d+)(cm|in)$").unwrap();
        let c = re.captures(s);
        c.and_then(|c| {
            //                    println!("{:?}", c);
            let h: i32 = c[1].parse().unwrap();
            match &c[2] {
                "cm" => {
                    if h >= 150 && h <= 193 {
                        Some(Height::Cm(h))
                    } else {
                        None
                    }
                }
                "in" => {
                    if h >= 59 && h <= 76 {
                        Some(Height::In(h))
                    } else {
                        None
                    }
                }
                _ => None,
            }
        })
    })
}

fn validate_hcl(s: Option<&str>) -> Option<&str> {
    s.and_then(|s| {
        let re = Regex::new(r"^#[0-9a-f]{6}$").unwrap();
        if re.is_match(s) {
            Some(s)
        } else {
            None
        }
    })
}

fn validate_ecl(s: Option<&str>) -> Option<Eyes> {
    match s {
        Some("amb") => Some(Eyes::Amb),
        Some("blu") => Some(Eyes::Blu),
        Some("brn") => Some(Eyes::Brn),
        Some("gry") => Some(Eyes::Gry),
        Some("grn") => Some(Eyes::Grn),
        Some("hzl") => Some(Eyes::Hzl),
        Some("oth") => Some(Eyes::Oth),
        _ => None,
    }
}

fn validate_pid(s: Option<&str>) -> Option<&str> {
    s.and_then(|s| {
        let re = Regex::new(r"^\d{9}$").unwrap();
        if re.is_match(s) {
            Some(s)
        } else {
            None
        }
    })
}

fn is_valid(p: &Passport) -> bool {
    p.byr.is_some()
        && p.iyr.is_some()
        && p.eyr.is_some()
        && p.hgt.is_some()
        && p.hcl.is_some()
        && p.ecl.is_some()
        && p.pid.is_some()
    //&& p.cid.is_some()
}

fn main() {
    let input = std::fs::read_to_string("input").expect("input file");
    let records: Vec<&str> = input.split("\n\n").collect();

    let passports: Vec<Passport> = records.iter().map(|&v| parse(v)).collect();
    println!("{}", passports.iter().filter(|p| is_valid(p)).count());
}
