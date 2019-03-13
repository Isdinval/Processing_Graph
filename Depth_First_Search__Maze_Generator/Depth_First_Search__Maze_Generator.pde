//********************************************************* //<>//  //<>//
//                        PARAMETERS
//*********************************************************
// Nombre de colonnes et de lignes, width de chaque cellule
int cols, rows;
int w = 30;

// current
Cell current;

// 1D Array
ArrayList<Cell> grid = new ArrayList<Cell>();
ArrayList<Cell> stack = new ArrayList<Cell>();


//*********************************************************
//                          SETUP
//*********************************************************
void setup() {
  size(600, 600);
  cols = floor(width/w);
  rows = floor(height/w);

  for (int j = 0; j < rows; j++) {
    for (int i = 0; i < cols; i++) {
      Cell cell = new Cell(i, j);
      grid.add(cell);
    }
  }
  current = grid.get(0);
  println("Début DFS - Depth First Search");
}

//*********************************************************
//                           DRAW
//*********************************************************
void draw() {
  //*******************************************************
  //                     DISPLAY PART
  //*******************************************************
  background(210);

  for (int i = 0; i < grid.size(); i++) {
    grid.get(i).show();
  }
  
  
  //*******************************************************
  //                     CALCUL PART
  //*******************************************************
  current.visited = true;
  current.highlight();

  // PART I - Make the initial cell the current cell and mark it as visited
  Cell next = current.checkNeighbors();

  if (next != null) {
    next.visited = true;

    // PART 2 - Push the current cell to the stack
    stack.add(current);

    // PART 3 - Remove the wall between the current cell and the chosen cell
    removeWalls(current, next);

    // PART 4- Make the chosen cell the current cell and mark it as visited
    current = next;
  } else if (stack.size() > 0) {
    current = stack.remove(stack.size()-1);
  }
}


//*********************************************************
//                        FUNCTIONS
//*********************************************************
//*********************************************************
// Retire les murs suivant la valeur de a-b
void removeWalls(Cell a, Cell b) {
  int x = a.i - b.i;
  if (x == 1) {
    a.walls[3] = false;
    b.walls[1] = false;
  } else if (x == -1) {
    a.walls[1] = false;
    b.walls[3] = false;
  }
  int y = a.j - b.j;
  if (y == 1) {
    a.walls[0] = false;
    b.walls[2] = false;
  } else if (y == -1) {
    a.walls[2] = false;
    b.walls[0] = false;
  }
}
