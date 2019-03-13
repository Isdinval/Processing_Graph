class Cell {

  //*********************************************************
  //                        PARAMETERS
  //*********************************************************
  // Position de la cellule
  int i, j;

  // Boolean[] qui indique si le mur fait partie du labyrinthe 
  //(TRUE) ou non (FALSE)
  //// walls = {TOP, RIGHT, BOTTOM, LEFT} 
  boolean[] walls = {true, true, true, true};
  
  // Ai-je déjà été visité?
  boolean visited = false;


  //*********************************************************
  //                        CONSTRUCTOR
  //*********************************************************
  Cell(int i_, int j_) {
    i = i_;
    j = j_;
  }


  //*********************************************************
  //                        FUNCTIONS
  //*********************************************************
  //*********************************************************
  void highlight() {
    int x = this.i*w;
    int y = this.j*w;
    noStroke();
    fill(0, 0, 0, 100);
    rect(x, y, w, w);
  }

  //*********************************************************
  // Organisation des cellules 
  // (x, y)    (x+w, y)
  // (x, y+w)  (x+w, y+w)
  void show() {
    int x = this.i*w;
    int y = this.j*w;
    stroke(0);
    if (this.walls[0]) {
      line(x, y, x + w, y);
    }
    if (this.walls[1]) {
      line(x + w, y, x + w, y + w);
    }
    if (this.walls[2]) {
      line(x + w, y + w, x, y + w);
    }
    if (this.walls[3]) {
      line(x, y + w, x, y);
    }

    if (this.visited) {
      noStroke();
      fill(255, 0, 255, 90);
      rect(x, y, w, w);
    }
  }


  //*********************************************************
  // Retourne l'index de l'Array 1D 
  int index(int i, int j) {
    if (i < 0 || j < 0 || i > cols-1 || j > rows-1) {
      return 0;
    }
    return i + j * cols;
  }
  
  
  //*********************************************************
  // Trouve les voisins de la cellule courante puis en choisis un
  // au hasard. 
  Cell checkNeighbors() { 
    ArrayList<Cell> neighbors = new ArrayList<Cell>();

    Cell top = grid.get(index(i, j-1));
    Cell right = grid.get(index(i+1, j));
    Cell bottom = grid.get(index(i, j+1));
    Cell left = grid.get(index(i-1, j));

    if (top != null && !top.visited) {
      neighbors.add(top);
    }
    if (right != null && !right.visited) {
      neighbors.add(right);
    }
    if (bottom != null && !bottom.visited) {
      neighbors.add(bottom);
    }
    if (left != null && !left.visited) {
      neighbors.add(left);
    }

    if (neighbors.size() > 0) {
      int indexNeighbor = floor(random(0, neighbors.size()));
      return neighbors.get(indexNeighbor);
    } else {
      return null;
    }
  }
}
