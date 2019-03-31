//********************************************************* //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
//                        PARAMETERS
//*********************************************************
// Nombre de colonnes et de lignes
int cols = 30;
int rows = 30;
// Width et Height de chaque cellule de la grille
int w, h;

// Compteur pour le nombre de points lors de la reconstruction du chemin
int cnt  = 0;

// 2D Array
Node[][] grid = new Node[cols][rows];

// Start, end et current
Node start;
Node end;
Node current;

// Open and closed set
// A besoin de import java.util.*;
List<Node> openSet_BFS               = new ArrayList<Node>();
List<Node> closedSet_BFS             = new ArrayList<Node>();
List<Node> openSet_GreedyBFS         = new ArrayList<Node>();
List<Node> closedSet_GreedyBFS       = new ArrayList<Node>();
List<Node> openSet_ASTAR_Euclidian   = new ArrayList<Node>();
List<Node> closedSet_ASTAR_Euclidian = new ArrayList<Node>();
List<Node> openSet_ASTAR_Manhattan   = new ArrayList<Node>();
List<Node> closedSet_ASTAR_Manhattan = new ArrayList<Node>();
List<Node> openSet_ASTAR_Chebyshev   = new ArrayList<Node>();
List<Node> closedSet_ASTAR_Chebyshev = new ArrayList<Node>();


// Le chemin directeur (lorsque le goal a été trouvé)
List<Node> path_BFS                  = new ArrayList<Node>();
List<Node> path_GreedyBFS            = new ArrayList<Node>();
List<Node> path_ASTAR_Euclidian      = new ArrayList<Node>();
List<Node> path_ASTAR_Manhattan      = new ArrayList<Node>();
List<Node> path_ASTAR_Chebyshev      = new ArrayList<Node>();

// Affiche la grille quand le goal a été atteint
boolean end_BFS             = false;
boolean end_GreedyBFS       = false;
boolean end_ASTAR_Euclidian = false;
boolean end_ASTAR_Manhattan = false;
boolean end_ASTAR_Chebyshev = false;


// Commence l'application lorsque la touche "ENTER" est appuyé.
boolean startAlgorithms = false;
// Nbr de lignes sur la gride pour la partie informative
int textSeparator = 5;
// Score pour A* algorithms
float tentative_gScore;
// Autorise les mouvements en diagonale.
boolean allow_diagonale = true;

// Button parameters
Button b_BFS, b_GreedyBFS, b_ASTAR_euclidian, b_ASTAR_manhattan, b_ASTAR_chebyshev, b_reset;
boolean BFS, GreedyBFS, ASTAR_euclidian, ASTAR_manhattan, ASTAR_chebyshev, reset;


//*********************************************************
//                          SETUP
//*********************************************************
void setup() {
  size(900, 900);
  
  w = width/cols;
  h = height/rows;

  createAllNodes();
  addAllNeighbors(allow_diagonale);

  // Start et End position, position aléatoire
  start = grid[cols/2][rows/2];
  end   = grid[(int)random(0, cols-1)][(int)random(textSeparator, rows-1)];
  // Les noeuds start et end ne peuvent être un mur du labyrinthe
  start.wall = false;
  end.wall   = false;

  // openSet commence avec le noeud Start uniquement.
  openSet_BFS            .add(start);
  openSet_GreedyBFS      .add(start);
  openSet_ASTAR_Euclidian.add(start);
  openSet_ASTAR_Manhattan.add(start);
  openSet_ASTAR_Chebyshev.add(start);

  // Init button
  float widthButton          = 90;
  float widthLargeButton     = 150;
  float heightButton         = 35;
  float offsetLeftScreen     = 10;
  float offsetBetweenButtons = 20;
  b_BFS             = new Button(offsetLeftScreen, 4.7 * w/2, widthButton, heightButton, "BFS");
  b_GreedyBFS       = new Button(offsetLeftScreen + widthButton + offsetBetweenButtons, 4.7 * w/2, 1.1*widthButton, heightButton, "GreedyBFS");
  b_ASTAR_euclidian = new Button(offsetLeftScreen + 2.1*widthButton + 2*offsetBetweenButtons, 4.7 * w/2, widthLargeButton, heightButton, "A* - Euclidian");
  b_ASTAR_manhattan = new Button(offsetLeftScreen + 2.1*widthButton + widthLargeButton + 3*offsetBetweenButtons, 4.7 * w/2, widthLargeButton, heightButton, "A* - Manhattan");
  b_ASTAR_chebyshev = new Button(offsetLeftScreen + 2.1*widthButton + 2*widthLargeButton + 4*offsetBetweenButtons, 4.7 * w/2, widthLargeButton, heightButton, "A* - Chebyshev");
  b_reset           = new Button(width - widthButton - offsetBetweenButtons, 4.7 * w/2, widthButton, heightButton, "Reset");
}


//*********************************************************
//                           DRAW
//*********************************************************
void draw() {
  background(255);
  //*******************************************************
  //                     CALCUL PART
  //*******************************************************
  boolean BFS             = b_BFS.update();
  boolean GreedyBFS       = b_GreedyBFS.update();
  boolean ASTAR_Euclidian = b_ASTAR_euclidian.update();
  boolean ASTAR_Manhattan = b_ASTAR_manhattan.update();
  boolean ASTAR_Chebyshev = b_ASTAR_chebyshev.update();
  boolean reset           = b_reset.update();



  // Reset les parametres lorsque le bouton "Reset" est pressé.
  if (reset) {
    reset();
    b_reset.state = false; // Permet de cliquer une fois sur le bouton reset au lieu de deux fois.
  }

  if (startAlgorithms == true) {
    if (BFS == true && !end_BFS && !GreedyBFS && !ASTAR_Euclidian && !ASTAR_Manhattan && !ASTAR_Chebyshev) {
      removeAllNeighbors();
      addAllNeighbors(false);
      BFS();
    } else if (end_BFS == true) { 
      showSet();
      showPath(false);
      b_BFS.state = false;
    }
    
    if (GreedyBFS == true && !end_GreedyBFS && !BFS && !ASTAR_Euclidian && !ASTAR_Manhattan && !ASTAR_Chebyshev) {
      removeAllNeighbors();
      addAllNeighbors(false);
      GreedyBFS();
    } else if (end_GreedyBFS == true) { 
      showSet();
      showPath(false);
      b_GreedyBFS.state = false;
    }
    
    if (ASTAR_Euclidian == true && !end_ASTAR_Euclidian && !BFS && !GreedyBFS && !ASTAR_Manhattan && !ASTAR_Chebyshev) {
      removeAllNeighbors();
      addAllNeighbors(false);
      ASTAR_Euclidian();
    } else if (end_ASTAR_Euclidian == true) { 
      showSet();
      showPath(false);
      b_ASTAR_euclidian.state = false;
    }
    
    if (ASTAR_Manhattan == true && !end_ASTAR_Manhattan && !BFS && !GreedyBFS & !ASTAR_Euclidian && !ASTAR_Chebyshev) {
      removeAllNeighbors();
      addAllNeighbors(false);      
      ASTAR_Manhattan();
    } else if (end_ASTAR_Manhattan == true) { 
      showSet();
      showPath(false);
      b_ASTAR_manhattan.state = false;
    }
    
    if (ASTAR_Chebyshev == true && !end_ASTAR_Chebyshev && !BFS && !GreedyBFS && !ASTAR_Manhattan && !ASTAR_Euclidian) {
      removeAllNeighbors();
      addAllNeighbors(false); 
      ASTAR_Chebyshev();
    } else if (end_ASTAR_Chebyshev == true) { 
      showSet();
      showPath(false);
      b_ASTAR_chebyshev.state = false;
    }
  }




  //*******************************************************
  //                     DISPLAY PART
  //*******************************************************

  addTextSeparator();

  //stroke(0);
  fill(61, 43, 31);
  textSize(w/2);
  textAlign(LEFT);
  text("Create the labyrinth by dragging your mouse (LEFT) or erase it (LEFT).", 10, 1.5*w/2);
  text("Move the start (LEFT) and end (RIGHT) nodes by clicking.", 10, 2.5 * w/2);
  text("Choose your algorithm, then press ENTER to begin !!!", 10, 3.5 * w/2);


  b_BFS.display();
  b_GreedyBFS.display();
  b_ASTAR_euclidian.display();
  b_ASTAR_manhattan.display();
  b_ASTAR_chebyshev.display();
  b_reset.display();

  showWall();

  start.showSetColor(color(0, 255, 0));
  end.showSetColor(color(255, 0, 0));
  start.showText("Start");

  end.showText("End");
}


//*********************************************************
//                        FUNCTIONS
//*********************************************************
//*********************************************************
// Allow to create the labyrinth by dragging the mouse.
// It only activate a boolean about the nodes dragged
// Have to been conbined with node.show();
void mouseDragged() {
  float X = mouseX;
  float Y = mouseY;
  X = map(X, 1, width, 0, cols);
  Y = map(Y, 1, height, 0, rows);

  // Create labyrinthe
  if (!BFS || !GreedyBFS || !ASTAR_euclidian || !ASTAR_manhattan || !ASTAR_chebyshev) {
    if (mouseButton == LEFT) {
      if (grid[int(X)][int(Y)] != end && grid[int(X)][int(Y)] != start) {
        grid[int(X)][int(Y)].wall = true;
      }
    }
    // Erase labyrinthe
    if (mouseButton == RIGHT) {
      if (grid[int(X)][int(Y)] != end && grid[int(X)][int(Y)] != start) {
        grid[int(X)][int(Y)].wall = false;
      }
    }
  }
}


//*********************************************************
// Allow to move the start and end nodes by clicking on the grid
// It is not possible to put end close to start, and vice versa. 
void mouseClicked() {
  float X = mouseX;
  float Y = mouseY;
  X = map(X, 1, width, 0, cols);
  Y = map(Y, 1, height, 0, rows);
  if (!BFS || !GreedyBFS || !ASTAR_euclidian || !ASTAR_manhattan || !ASTAR_chebyshev) {
    if (Y > textSeparator) { // Forbide the motion of nodes to text zone
      // ... rows of the grid are reserved for this text zone 

      if (mouseButton == LEFT) {
        if ((int)X != end.x || (int)Y != end.y) {
          openSet_BFS            .remove(start);
          openSet_GreedyBFS      .remove(start);
          openSet_ASTAR_Euclidian.remove(start);
          openSet_ASTAR_Manhattan.remove(start);
          openSet_ASTAR_Chebyshev.remove(start);

          start = grid[(int)X][(int)Y];
          start.wall = false;
          start.showSetColor(color(0, 255, 0));

          openSet_BFS            .add(start);
          openSet_GreedyBFS      .add(start);
          openSet_ASTAR_Euclidian.add(start);
          openSet_ASTAR_Manhattan.add(start);
          openSet_ASTAR_Chebyshev.add(start);
        }
      } else if (mouseButton == RIGHT) {
        if ((int)X != start.x || (int)Y != start.y) {
          end = grid[(int)X][(int)Y];
          end.wall = false;
          end.showSetColor(color(255, 0, 0));
        }
      }
    }
  }
}


//*********************************************************
// 
void keyPressed() {
  if ( key == ENTER) {
    startAlgorithms = true;
  }
}


//*********************************************************
// Reset background // TO DO
void reset() {
  // Remove closedSet and openSet
  while (!closedSet_GreedyBFS.isEmpty()) {
    closedSet_GreedyBFS.remove(closedSet_GreedyBFS.get(0));
  }
  while (!openSet_GreedyBFS.isEmpty()) {
    openSet_GreedyBFS.remove(openSet_GreedyBFS.get(0));
  }

  while (!closedSet_BFS.isEmpty()) {
    closedSet_BFS.remove(closedSet_BFS.get(0));
  }
  while (!openSet_BFS.isEmpty()) {
    openSet_BFS.remove(openSet_BFS.get(0));
  }

  while (!closedSet_ASTAR_Euclidian.isEmpty()) {
    closedSet_ASTAR_Euclidian.remove(closedSet_ASTAR_Euclidian.get(0));
  }
  while (!openSet_ASTAR_Euclidian.isEmpty()) {
    openSet_ASTAR_Euclidian.remove(openSet_ASTAR_Euclidian.get(0));
  }

  while (!closedSet_ASTAR_Manhattan.isEmpty()) {
    closedSet_ASTAR_Manhattan.remove(closedSet_ASTAR_Manhattan.get(0));
  }
  while (!openSet_ASTAR_Manhattan.isEmpty()) {
    openSet_ASTAR_Manhattan.remove(openSet_ASTAR_Manhattan.get(0));
  }

  while (!closedSet_ASTAR_Chebyshev.isEmpty()) {
    closedSet_ASTAR_Chebyshev.remove(closedSet_ASTAR_Chebyshev.get(0));
  }
  while (!openSet_ASTAR_Chebyshev.isEmpty()) {
    openSet_ASTAR_Chebyshev.remove(openSet_ASTAR_Chebyshev.get(0));
  }



  openSet_BFS            .add(start);
  openSet_GreedyBFS      .add(start);
  openSet_ASTAR_Euclidian.add(start);
  openSet_ASTAR_Manhattan.add(start);
  openSet_ASTAR_Chebyshev.add(start);

  end_BFS             = false;
  end_GreedyBFS       = false;
  end_ASTAR_Euclidian = false;
  end_ASTAR_Manhattan = false;
  end_ASTAR_Chebyshev = false;

  tentative_gScore = 0;

  for (int i = 0; i < cols; i++) {
    for (int j = textSeparator; j < rows; j++) {
      grid[i][j].visited = false;
      grid[i][j].previous = null;
      grid[i][j].heuristic_GreedyBFS = 0;
      grid[i][j].f_ASTAR = 0;
      grid[i][j].g_ASTAR = 0;
      grid[i][j].heuristic_ASTAR = 0;
    }
  }
}


//*********************************************************
// Create all Nodes
void createAllNodes() {
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      grid[i][j] = new Node(i, j);
    }
  }
}


//*********************************************************
// Add all neighbors
void addAllNeighbors(boolean allow_diagonale) {
  for (int i = 0; i < cols; i++) {
    for (int j = textSeparator; j < rows; j++) {
      grid[i][j].addNeighbors(grid, allow_diagonale);
    }
  }
}

//*********************************************************
// Add all neighbors
void removeAllNeighbors() {
  for (int i = 0; i < cols; i++) {
    for (int j = textSeparator; j < rows; j++) {
      grid[i][j].removeNeighbors(grid);
    }
  }
}


//*********************************************************
// Add all neighbors
void addTextSeparator() {
  stroke(136, 66, 29, 180);
  strokeWeight(3);
  line(0, (textSeparator-1)*h, width, (textSeparator-1)*h);
  strokeWeight(1);

  noStroke();
  //fill(230);
  fill(142, 84, 52, 90);
  rect(0, 0, width, (textSeparator-1)*h);
}


//*********************************************************
// Affiche la grille avec le nbr de cols & rows donnés
void showGrid() {
  stroke(0);
  for (int i = 0; i < width; i++) {
    for (int j = textSeparator-1; j < height; j++) {
      if (grid[int(X)][int(Y)].wall == true) {
        fill(0);
        rect(i*w, j*h, w, h);
      } else {
        fill(255);
        rect(i*w, j*h, w, h);
      }
    }
  }
}


//*********************************************************
//Affiche les murs du labyrinthe, chaque mur possède 40% de 
//chance de l'être
//int num = Nbr entre 0 et 100. 
void showWall() {
  stroke(0);
  for (int i = 0; i < cols; i++) {
    for (int j = textSeparator-1; j < rows; j++) {
      grid[i][j].show();
    }
  }
}


//*********************************************************
// Affiche openSet and closedSet en vert et rouge respectivement
void showSet() {
  stroke(0);

  for (int i = 0; i < closedSet_BFS.size(); i++) {
    closedSet_BFS.get(i).showSetColor(color(223, 109, 20, 90));
  }
  for (int i = 0; i < openSet_BFS.size(); i++) {
    openSet_BFS.get(i).showSetColor(color(136, 66, 29, 180));
  }

  for (int i = 0; i < closedSet_GreedyBFS.size(); i++) {
    closedSet_GreedyBFS.get(i).showSetColor(color(223, 109, 20, 90));
  }
  for (int i = 0; i < openSet_GreedyBFS.size(); i++) {
    openSet_GreedyBFS.get(i).showSetColor(color(136, 66, 29, 180));
  }

  for (int i = 0; i < closedSet_ASTAR_Euclidian.size(); i++) {
    closedSet_ASTAR_Euclidian.get(i).showSetColor(color(223, 109, 20, 90));
  }
  for (int i = 0; i < openSet_ASTAR_Euclidian.size(); i++) {
    openSet_ASTAR_Euclidian.get(i).showSetColor(color(136, 66, 29, 180));
  }
  for (int i = 0; i < closedSet_ASTAR_Manhattan.size(); i++) {
    closedSet_ASTAR_Manhattan.get(i).showSetColor(color(223, 109, 20, 90));
  }
  for (int i = 0; i < openSet_ASTAR_Manhattan.size(); i++) {
    openSet_ASTAR_Manhattan.get(i).showSetColor(color(136, 66, 29, 180));
  }

  for (int i = 0; i < closedSet_ASTAR_Chebyshev.size(); i++) {
    closedSet_ASTAR_Chebyshev.get(i).showSetColor(color(223, 109, 20, 90));
  }
  for (int i = 0; i < openSet_ASTAR_Chebyshev.size(); i++) {
    openSet_ASTAR_Chebyshev.get(i).showSetColor(color(136, 66, 29, 180));
  }
}

//*********************************************************
// Affiche openSet and closedSet en vert et rouge respectivement
void showPath(boolean allow) {

  // Trouve le chemin en le refaisant à l'envers
  List<Node> path = new ArrayList<Node>();
  Node temp = current;
  path.add(temp);
  while (temp.previous != null) {
    path.add(temp.previous);
    temp = temp.previous;
  }
  noFill();
  stroke(38, 196, 236);
  strokeWeight(w / 3);
  beginShape();
  for (int i = 0; i < path.size(); i++) {
    vertex(path.get(i).x * w + w / 2, path.get(i).y * h + h / 2);
    if (end_BFS || end_GreedyBFS || end_ASTAR_Euclidian || end_ASTAR_Manhattan || end_ASTAR_Chebyshev ) {
      cnt++;
      if (allow) {
        println("Point n°" + cnt + " --> x = " + path.get(i).x + ", y = " + path.get(i).y);
      }
    }
  }
  if (end_BFS && allow) {
    println("END BFS - Breadth First Search");
  }
  if (end_GreedyBFS && allow) {
    println("END GREEDY BFS - Greedy Breadth First Search");
  }
  if (end_ASTAR_Euclidian && allow) {
    println("END A* - ASTAR, Euclidian Heuristic");
  }
  if (end_ASTAR_Manhattan && allow) {
    println("END A* - ASTAR, Manhattan Heuristic");
  }
  if (end_ASTAR_Chebyshev && allow) {
    println("END A* - ASTAR, Chebyshev Heuristic");
  }
  endShape();

  if (end_BFS || end_GreedyBFS || end_ASTAR_Euclidian || end_ASTAR_Manhattan || end_ASTAR_Chebyshev) {
    cnt = 0;
  }
}

//*********************************************************
// Affiche openSet and closedSet en vert et rouge respectivement
void BFS() {
  //*******************************************************
  //                     CALCUL PART
  //*******************************************************
  if (openSet_BFS.size() > 0) {
    current = openSet_BFS.get(0);
    current.visited = true;

    if (current == end) {
      // On a trouvé le goal, on stop!!!
      end_BFS = true;
      println("DONE !!! Goal has been found");
    }

    openSet_BFS.remove(current);
    closedSet_BFS.add(current);

    // Vérifie chaque voisin
    List<Node> neighbors = current.neighbors;
    for (int i = 0; i < neighbors.size(); i++) {
      Node neighbor = neighbors.get(i);
      // Est-ce un meilleur chemin que le precedent?
      boolean newPath_BFS = false;
      if (closedSet_BFS.contains(neighbors) && !neighbor.wall ) {
        //Le noeud a déjà été vérifié, on passse au suivant
      } else if (!closedSet_BFS.contains(neighbors) && !neighbor.wall) {
        if (!openSet_BFS.contains(neighbor)&& !neighbor.visited) {
          openSet_BFS.add(neighbor);
          newPath_BFS = true;
        }
      }
      if (newPath_BFS) {
        neighbor.previous = current;
      }
    }
  } else {
    println("No solutions!");
  }

  //*******************************************************
  //                     DISPLAY PART
  //*******************************************************
  if (startAlgorithms == true) {
    showPath(true);
    showSet();
  }
}

//*********************************************************
// An educated guess of how far it is between two points
float heuristic_GreedyBFS(Node a, Node b) {
  float d = dist(a.x, a.y, b.x, b.y);
  return d;
}

//*********************************************************
void GreedyBFS() {
  //*******************************************************
  //                     CALCUL PART
  //*******************************************************
  if (openSet_GreedyBFS.size() > 0) {

    // La meilleure nouvelle option
    int winner = 0;
    for (int i = 0; i < openSet_GreedyBFS.size(); i++) {
      if (openSet_GreedyBFS.get(i).heuristic_GreedyBFS< openSet_GreedyBFS.get(winner).heuristic_GreedyBFS) {
        winner = i;
      }
    }
    current = openSet_GreedyBFS.get(winner);
    //current = openSet.get(0);
    current.visited = true;

    if (current == end) {
      // On a trouvé le goal, on stop!!!
      end_GreedyBFS = true;
      println("DONE !!! Goal has been found");
    }

    openSet_GreedyBFS.remove(current);
    closedSet_GreedyBFS.add(current);

    // Vérifie chaque voisin
    List<Node> neighbors = current.neighbors;
    for (int i = 0; i < neighbors.size(); i++) {
      Node neighbor = neighbors.get(i);

      // Est-ce un meilleur chemin que le precedent?
      boolean newPath_GreedyBFS = false;
      if (closedSet_GreedyBFS.contains(neighbors) && !neighbor.wall ) {
        //Le noeud a déjà été vérifié, on passse au suivant
      } else if (!closedSet_GreedyBFS.contains(neighbors) && !neighbor.wall) {
        if (!openSet_GreedyBFS.contains(neighbor)&& !neighbor.visited) {
          openSet_GreedyBFS.add(neighbor);
          newPath_GreedyBFS = true;
        }
      }
      if (newPath_GreedyBFS) {
        neighbor.previous = current;
        neighbor.heuristic_GreedyBFS = heuristic_GreedyBFS(current, end);
      }
    }
  } else {
    println("No solutions!");
  }

  //*******************************************************
  //                     DISPLAY PART
  //*******************************************************
  if (startAlgorithms == true) {
    showPath(true);
    showSet();
  }
}

//*********************************************************
// Intuition concernant le chemin approprié entre deux noeuds
float heuristic_ASTAR_Euclidian(Node N1, Node N2) {
  float distance = 0;
  float D = 1;
  float p = 1/10;
  float dx = abs(N1.x - N2.x);
  float dy = abs(N1.y - N2.y);
  distance = D * sqrt(dx*dx + dy*dy);
  distance *= (1.0 + p);
  return distance;
}

//*********************************************************
// Intuition concernant le chemin approprié entre deux noeuds
float heuristic_ASTAR_Manhattan(Node N1, Node N2) {
  float D = 1;
  float distance = 0;
  float p = 1/10;
  float dx = abs(N1.x - N2.x);
  float dy = abs(N1.y - N2.y);
  distance = D * (dx + dy);
  distance *= (1.0 + p);
  return distance;
}

//*********************************************************
// Intuition concernant le chemin approprié entre deux noeuds
float heuristic_ASTAR_Diagonale(Node N1, Node N2) {
  float D = 1;
  float D2 = 10;
  float distance = 0;
  float p = 1/10;
  float dx = abs(N1.x - N2.x);
  float dy = abs(N1.y - N2.y);
  distance = D * (dx + dy) + (D2 - 2*D)*min(dx, dy);
  distance *= (1.0 + p);
  return distance;
}

//*********************************************************
// Intuition concernant le chemin approprié entre deux noeuds
float heuristic_ASTAR_Chebyshev(Node N1, Node N2) {
  float D = 1;
  float D2 = 1;
  float distance = 0;
  float p = 1/10;
  float dx = abs(N1.x - N2.x);
  float dy = abs(N1.y - N2.y);
  distance = D * (dx + dy) + (D2 - 2*D)*min(dx, dy);
  distance *= (1.0 + p);
  return distance;
}


//*********************************************************
void ASTAR_Euclidian() {
  //*******************************************************
  //                     CALCUL PART
  //*******************************************************
  // Suis-je encore en train de chercher
  if (openSet_ASTAR_Euclidian.size() > 0) {
    // La meilleure nouvelle option
    int winner = 0;
    for (int i = 0; i < openSet_ASTAR_Euclidian.size(); i++) {
      if (openSet_ASTAR_Euclidian.get(i).f_ASTAR < openSet_ASTAR_Euclidian.get(winner).f_ASTAR) {
        winner = i;
      }
    }
    current = openSet_ASTAR_Euclidian.get(winner);

    if (current == end) {
      end_ASTAR_Euclidian = true;
    }

    // La meilleur option passe de openSet à closedSet ArrayList
    openSet_ASTAR_Euclidian.remove(current);
    closedSet_ASTAR_Euclidian.add(current);

    // Vérifie chaque voisin
    List<Node> neighbors = current.neighbors;
    for (int i = 0; i < neighbors.size(); i++) {
      Node neighbor = neighbors.get(i);

      // Ce node est-il valide?
      if (!closedSet_ASTAR_Euclidian.contains(neighbor) && !neighbor.wall) {
        // La distance de current à neighbor
        tentative_gScore = current.g_ASTAR + heuristic_ASTAR_Euclidian(current, neighbor);
        // Est-ce un meilleur chemin que le precedent?
        boolean newPath = false;
        if (openSet_ASTAR_Euclidian.contains(neighbor)) {
          if (tentative_gScore < neighbor.g_ASTAR) {
            neighbor.g_ASTAR = tentative_gScore;
            newPath = true;
          }
        } else {
          neighbor.g_ASTAR = tentative_gScore;
          newPath = true;
          openSet_ASTAR_Euclidian.add(neighbor);
        }

        if (newPath) {
          neighbor.heuristic_ASTAR = heuristic_ASTAR_Euclidian(neighbor, end);
          neighbor.f_ASTAR = neighbor.g_ASTAR + neighbor.heuristic_ASTAR;
          neighbor.previous = current;
        }
      }
    }
  } else {
    println("No solutions!");
  }

  //*******************************************************
  //                     DISPLAY PART
  //*******************************************************
  if (startAlgorithms == true) {
    showPath(true);
    showSet();
  }
}

//*********************************************************
void ASTAR_Manhattan() {
  //*******************************************************
  //                     CALCUL PART
  //*******************************************************
  // Suis-je encore en train de chercher
  if (openSet_ASTAR_Manhattan.size() > 0) {
    // La meilleure nouvelle option
    int winner = 0;
    for (int i = 0; i < openSet_ASTAR_Manhattan.size(); i++) {
      if (openSet_ASTAR_Manhattan.get(i).f_ASTAR < openSet_ASTAR_Manhattan.get(winner).f_ASTAR) {
        winner = i;
      }
    }
    current = openSet_ASTAR_Manhattan.get(winner);

    if (current == end) {
      end_ASTAR_Manhattan = true;
    }

    // La meilleur option passe de openSet à closedSet ArrayList
    openSet_ASTAR_Manhattan.remove(current);
    closedSet_ASTAR_Manhattan.add(current);

    // Vérifie chaque voisin
    List<Node> neighbors = current.neighbors;
    for (int i = 0; i < neighbors.size(); i++) {
      Node neighbor = neighbors.get(i);

      // Ce node est-il valide?
      if (!closedSet_ASTAR_Manhattan.contains(neighbor) && !neighbor.wall) {
        // La distance de current à neighbor
        tentative_gScore = current.g_ASTAR + heuristic_ASTAR_Manhattan(current, neighbor);
        // Est-ce un meilleur chemin que le precedent?
        boolean newPath = false;
        if (openSet_ASTAR_Manhattan.contains(neighbor)) {
          if (tentative_gScore < neighbor.g_ASTAR) {
            neighbor.g_ASTAR = tentative_gScore;
            newPath = true;
          }
        } else {
          neighbor.g_ASTAR = tentative_gScore;
          newPath = true;
          openSet_ASTAR_Manhattan.add(neighbor);
        }

        if (newPath) {
          neighbor.heuristic_ASTAR = heuristic_ASTAR_Manhattan(neighbor, end);
          neighbor.f_ASTAR = neighbor.g_ASTAR + neighbor.heuristic_ASTAR;
          neighbor.previous = current;
        }
      }
    }
  } else {
    println("No solutions!");
  }

  //*******************************************************
  //                     DISPLAY PART
  //*******************************************************
  if (startAlgorithms == true) {
    showPath(true);
    showSet();
  }
}


//*********************************************************
void ASTAR_Chebyshev() {
  //*******************************************************
  //                     CALCUL PART
  //*******************************************************
  // Suis-je encore en train de chercher
  if (openSet_ASTAR_Chebyshev.size() > 0) {
    // La meilleure nouvelle option
    int winner = 0;
    for (int i = 0; i < openSet_ASTAR_Chebyshev.size(); i++) {
      if (openSet_ASTAR_Chebyshev.get(i).f_ASTAR < openSet_ASTAR_Chebyshev.get(winner).f_ASTAR) {
        winner = i;
      }
    }
    current = openSet_ASTAR_Chebyshev.get(winner);

    if (current == end) {
      end_ASTAR_Chebyshev = true;
    }

    // La meilleur option passe de openSet à closedSet ArrayList
    openSet_ASTAR_Chebyshev.remove(current);
    closedSet_ASTAR_Chebyshev.add(current);

    // Vérifie chaque voisin
    List<Node> neighbors = current.neighbors;
    for (int i = 0; i < neighbors.size(); i++) {
      Node neighbor = neighbors.get(i);

      // Ce node est-il valide?
      if (!closedSet_ASTAR_Chebyshev.contains(neighbor) && !neighbor.wall) {
        // La distance de current à neighbor
        tentative_gScore = current.g_ASTAR + heuristic_ASTAR_Chebyshev(current, neighbor);
        // Est-ce un meilleur chemin que le precedent?
        boolean newPath = false;
        if (openSet_ASTAR_Chebyshev.contains(neighbor)) {
          if (tentative_gScore < neighbor.g_ASTAR) {
            neighbor.g_ASTAR = tentative_gScore;
            newPath = true;
          }
        } else {
          neighbor.g_ASTAR = tentative_gScore;
          newPath = true;
          openSet_ASTAR_Chebyshev.add(neighbor);
        }

        if (newPath) {
          neighbor.heuristic_ASTAR = heuristic_ASTAR_Chebyshev(neighbor, end);
          neighbor.f_ASTAR = neighbor.g_ASTAR + neighbor.heuristic_ASTAR;
          neighbor.previous = current;
        }
      }
    }
  } else {
    println("No solutions!");
  }

  //*******************************************************
  //                     DISPLAY PART
  //*******************************************************
  if (startAlgorithms == true) {
    showPath(true);
    showSet();
  }
}
