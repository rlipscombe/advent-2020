enum Cell {
    Floor,
    Empty,
    Occupied,
}

type Grid = Vec<Vec<Cell>>;

fn main() {
    //let path = "input";
    let path = "example";
    let grid: Vec<Vec<Cell>> = std::fs::read_to_string(path)
        .expect("input file")
        .lines()
        .map(parse_line)
        .collect();

    // Does Rust have ncurses support, or am I just going to clear the screen each time?
    render(grid);
}

fn parse_line(line: &str) -> Vec<Cell> {
    line.chars()
        .map(|c| match c {
            'L' => Cell::Empty,
            '.' => Cell::Floor,
            '#' => Cell::Occupied,
            _ => panic!()
        })
        .collect()
}

fn render(grid: Grid) {
    print!("{}{}", termion::clear::All, termion::cursor::Goto(1, 1));
    for r in grid {
        for c in r {
            render_cell(c);
        }
        println!();
    }
}

fn render_cell(cell: Cell) {
    match cell {
        Cell::Empty => { print!("L"); }
        Cell::Floor => { print!("."); }
        Cell::Occupied => { print!("#"); }
    }
}
