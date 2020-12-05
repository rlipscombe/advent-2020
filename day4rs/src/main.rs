#[derive(Default, Debug)]
struct Passport<'a> {
    byr: Option<&'a str>,
    iyr: Option<&'a str>,
    eyr: Option<&'a str>,
    hgt: Option<&'a str>,
    hcl: Option<&'a str>,
    ecl: Option<&'a str>,
    pid: Option<&'a str>,
    cid: Option<&'a str>,
}

fn parse(x: &str) -> Passport {
    let mut passport: Passport = Default::default();

    for x in x.split_whitespace() {
        //        println!("{:?}", x);

        let mut s = x.split(':');
        match s.next() {
            Some("byr") => {
                passport.byr = s.next();
            }
            Some("iyr") => {
                passport.iyr = s.next();
            }
            Some("eyr") => {
                passport.eyr = s.next();
            }
            Some("hgt") => {
                passport.hgt = s.next();
            }
            Some("hcl") => {
                passport.hcl = s.next();
            }
            Some("ecl") => {
                passport.ecl = s.next();
            }
            Some("pid") => {
                passport.pid = s.next();
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
