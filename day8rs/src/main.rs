#[derive(Copy, Clone)]
enum Instruction {
    Nop(i32),
    Acc(i32),
    Jmp(i32),
    End,
}

fn main() {
    let input = std::fs::read_to_string("input").expect("input file");
    let mut instrs: Vec<Instruction> = input.lines().map(parse).collect();

    let acc = run(&mut instrs);
    println!("part 1 = {}", acc);
}

fn parse(instr: &str) -> Instruction {
    let mut split = instr.split_whitespace();
    let op = split.next().unwrap();
    let arg = split.next().unwrap();

    match op {
        "nop" => Instruction::Nop(arg.parse().expect("integer")),
        "acc" => Instruction::Acc(arg.parse().expect("integer")),
        "jmp" => Instruction::Jmp(arg.parse().expect("integer")),
        _ => todo!(),
    }
}

fn run(instrs: &mut Vec<Instruction>) -> i32 {
    use Instruction::*;

    let mut acc: i32 = 0;
    let mut pc: usize = 0;

    loop {
        // Destructive fetch
        let curr = instrs[pc];
        instrs[pc] = End;

        match curr {
            Nop(_) => {
                pc += 1;
            }
            Acc(arg) => {
                acc += arg;
                pc += 1;
            }
            Jmp(arg) => {
                pc = jmp(pc, arg);
            }
            End => break,
        }
    }

    acc
}

// per https://stackoverflow.com/a/54035801
fn jmp(pc: usize, off: i32) -> usize {
    if off < 0 {
        pc - off.wrapping_abs() as u32 as usize
    } else {
        pc + off as usize
    }
}
