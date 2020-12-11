//use std::{thread, time};

#[derive(Clone, Copy, PartialEq)]
enum Cell {
    Floor,
    Empty,
    Occupied,
}

#[derive(Clone)]
struct Grid {
    cells: Vec<Vec<Cell>>,
    height: usize,
    width: usize,
}

impl Grid {
    fn new(cells: Vec<Vec<Cell>>) -> Self {
        let height = cells.len();
        let width = cells[0].len();
        Self {
            cells,
            height,
            width,
        }
    }
}

#[derive(PartialEq, Debug)]
enum Dirty {
    Unchanged,
    Changed,
}

fn main() {
    let path = "input";
    //let path = "example";
    let cells: Vec<Vec<Cell>> = std::fs::read_to_string(path)
        .expect("input file")
        .lines()
        .map(parse_line)
        .collect();
    let mut grid = Grid::new(cells);

    grid.render();
    loop {
        //thread::sleep(time::Duration::from_millis(2000));
        let (next, changed) = iterate(grid.clone());
        next.render();
        if changed == Dirty::Unchanged {
            break;
        }
        grid = next;
    }

    let count = count_occupied(grid);
    println!("{}", count);
}

fn parse_line(line: &str) -> Vec<Cell> {
    line.chars()
        .map(|c| match c {
            'L' => Cell::Empty,
            '.' => Cell::Floor,
            '#' => Cell::Occupied,
            _ => panic!(),
        })
        .collect()
}

impl Grid {
    fn render(&self) {
        print!("{}{}", termion::clear::All, termion::cursor::Goto(1, 1));
        for r in 0..self.height {
            for c in 0..self.width {
                let cell = self.cells[r][c];
                render_cell(cell);
            }
            println!();
        }
    }
}

fn render_cell(cell: Cell) {
    match cell {
        Cell::Empty => {
            print!("L");
        }
        Cell::Floor => {
            print!(".");
        }
        Cell::Occupied => {
            print!("#");
        }
    }
}

fn iterate(grid: Grid) -> (Grid, Dirty) {
    let mut result = grid.clone();
    let mut dirty = Dirty::Unchanged;

    // Then, for each cell in the automaton, apply the rule.
    for r in 0..grid.height {
        for c in 0..grid.width {
            result.cells[r][c] = mutate(r, c, &grid);
            if result.cells[r][c] != grid.cells[r][c] {
                dirty = Dirty::Changed;
            }
        }
    }

    (result, dirty)
}

fn count_occupied(grid: Grid) -> usize {
    let mut count = 0;

    for r in 0..grid.height {
        for c in 0..grid.width {
            if grid.cells[r][c] == Cell::Occupied {
                count += 1;
            }
        }
    }

    count
}

fn mutate(r: usize, c: usize, grid: &Grid) -> Cell {
    let occupied = count_occupied_adjacent(r, c, grid);

    let cell = grid.cells[r][c];

    // If a seat is empty, and there are no occupied seats adjacent, it becomes occupied.
    // If a seat is occupied and four or more seats are occupied, it becomes empty.
    if cell == Cell::Empty && occupied == 0 {
        Cell::Occupied
    } else if cell == Cell::Occupied && occupied >= 4 {
        Cell::Empty
    } else {
        cell
    }
}

fn count_occupied_adjacent(r: usize, c: usize, grid: &Grid) -> usize {
    let adjacent = get_adjacent(r, c, grid.height, grid.width);

    let mut result = 0;

    for (r, c) in adjacent {
        if grid.cells[r][c] == Cell::Occupied {
            result += 1;
        }
    }

    result
}

fn get_adjacent(r: usize, c: usize, height: usize, width: usize) -> Vec<(usize, usize)> {
    let mut result = Vec::new();

    /*
       (r-1,c-1) (r-1,c) (r-1,c+1)
       (r,c-1)   (r,c)   (r,c+1)
       (r+1,c-1) (r+1,c) (r+1,c+1)
    */
    if r > 0 && c > 0 {
        result.push((r - 1, c - 1));
    }
    if r > 0 {
        result.push((r - 1, c));
    }
    if r > 0 && c < width - 1 {
        result.push((r - 1, c + 1));
    }

    if c > 0 {
        result.push((r, c - 1));
    }
    if c < width - 1 {
        result.push((r, c + 1));
    }

    if r < height - 1 && c > 0 {
        result.push((r + 1, c - 1));
    }
    if r < height - 1 {
        result.push((r + 1, c));
    }
    if r < height - 1 && c < width - 1 {
        result.push((r + 1, c + 1));
    }

    result
}
