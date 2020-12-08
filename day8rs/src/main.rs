#[derive(Copy, Clone)]
enum Instruction {
    Nop(i32),
    Acc(i32),
    Jmp(i32),
    Trap,
    End,
}

fn main() {
    let input = std::fs::read_to_string("input").expect("input file");
    let mut instrs: Vec<Instruction> = input.lines().map(parse).collect();
    instrs.push(Instruction::End);

    let mut scratch = instrs.clone();
    let acc = run(&mut scratch);
    println!("part 1 = {:?}", acc.unwrap_err());

    // Do it all again by mutating exactly *one* instruction.
    for i in 0..instrs.len() {
        let result = std::panic::catch_unwind(|| {
            let mut mutated = instrs.clone();
            mutate(&mut mutated, i);
            run(&mut mutated)
        });

        match result {
            Err(_) => { /* it panicked */ }
            Ok(Err(_)) => { /* it looped */ }
            Ok(Ok(result)) => {
                println!("part 2 = {:?}", result);
            }
        }
    }
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

fn run(instrs: &mut Vec<Instruction>) -> Result<i32, i32> {
    use Instruction::*;

    let mut acc: i32 = 0;
    let mut pc: usize = 0;

    loop {
        if pc >= instrs.len() {
            // Fell off the world.
            return Err(acc);
        }

        // Destructive fetch
        let curr = instrs[pc];
        instrs[pc] = Trap;

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
            Trap => return Err(acc),
            End => return Ok(acc)
        }
    }
}

// per https://stackoverflow.com/a/54035801
fn jmp(pc: usize, off: i32) -> usize {
    if off < 0 {
        pc - off.wrapping_abs() as u32 as usize
    } else {
        pc + off as usize
    }
}

fn mutate(instrs: &mut Vec<Instruction>, pc: usize) {
    use Instruction::*;

    match instrs[pc] {
        Nop(arg) => {
            instrs[pc] = Jmp(arg);
        }
        Jmp(arg) => {
            instrs[pc] = Nop(arg);
        }
        _ => {},
    }
}
