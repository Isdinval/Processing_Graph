# Processing_Graph

# I°) Breadth First Search - Pseudocode

Source : Wikipedia : https://en.wikipedia.org/wiki/Breadth-first_search

Breadth first traversal is accomplished by enqueueing each level of a tree sequentially as the root of any subtree is encountered. There are 2 cases in the iterative algorithm.
- Root case: The traversal queue is initially empty so the root node must be added before the general case.
General case: Process any items in the queue, while also expanding their children. Stop if the queue is empty. The general case will halt after processing the bottom level as leaf nodes have no children.
-Input: A search problem. A search-problem abstracts out the problem specific requirements from the actual search algorithm.
- Output: An ordered list of actions to be followed to reach from start state to the goal state.



      def breadth_first_search(problem):

        // a FIFO open_set
        open_set = Queue()

        // an empty set to maintain visited nodes
        closed_set = set()

        // a dictionary to maintain meta information (used for path formation)
        // key -> (parent state, action to reach child)
        meta = dict()

        // initialize
        root = problem.get_root()
        meta[root] = (None, None)
        open_set.enqueue(root)

        // For each node on the current level expand and process, if no children 
        // (leaf) then unwind
        while not open_set.is_empty():

          subtree_root = open_set.dequeue()

          // We found the node we wanted so stop and emit a path.
          if problem.is_goal(subtree_root):
            return construct_path(subtree_root, meta)

          // For each child of the current tree process
          for (child, action) in problem.get_successors(subtree_root):

          // The node has already been processed, so skip over it
          if child in closed_set:
            continue

          // The child is not enqueued to be processed, so enqueue this level of
          // children to be expanded
          if child not in open_set:
            meta[child] = (subtree_root, action) // create metadata for these nodes
            open_set.enqueue(child)              // enqueue these nodes

        // We finished processing the root of this subtree, so add it to the closed 
        // set
        closed_set.add(subtree_root)

        // Produce a backtrace of the actions taken to find the goal node, using the 
        // recorded meta dictionary
        def construct_path(state, meta):
          action_list = list()

          // Continue until you reach root meta data (i.e. (None, None))
          while meta[state][0] is not None:
            state, action = meta[state]
            action_list.append(action)

          action_list.reverse()
          return action_list

# II°) A* search algorithm - Pseudocode

Source : Wikipedia : https://en.wikipedia.org/wiki/A*_search_algorithm

A* is an informed search algorithm, or a best-first search, meaning that it is formulated in terms of weighted graphs: starting from a specific starting node of a graph, it aims to find a path to the given goal node having the smallest cost (least distance travelled, shortest time, etc.). It does this by maintaining a tree of paths originating at the start node and extending those paths one edge at a time until its termination criterion is satisfied.

At each iteration of its main loop, A* needs to determine which of its paths to extend. It does so based on the cost of the path and an estimate of the cost required to extend the path all the way to the goal. Specifically, A* selects the path that minimizes f(n)=g(n)+h(n)
where n is the next node on the path, g(n) is the cost of the path from the start node to n, and h(n) is a heuristic function that estimates the cost of the cheapest path from n to the goal. A* terminates when the path it chooses to extend is a path from start to goal or if there are no paths eligible to be extended.The heuristic function is problem-specific. If the heuristic function is admissible, meaning that it never overestimates the actual cost to get to the goal, A* is guaranteed to return a least-cost path from start to goal.

Typical implementations of A* use a priority queue to perform the repeated selection of minimum (estimated) cost nodes to expand. This priority queue is known as the open set or fringe. At each step of the algorithm, the node with the lowest f(x) value is removed from the queue, the f and g values of its neighbors are updated accordingly, and these neighbors are added to the queue. The algorithm continues until a goal node has a lower f value than any node in the queue (or until the queue is empty).[a] The f value of the goal is then the cost of the shortest path, since h at the goal is zero in an admissible heuristic.

The algorithm described so far gives us only the length of the shortest path. To find the actual sequence of steps, the algorithm can be easily revised so that each node on the path keeps track of its predecessor. After this algorithm is run, the ending node will point to its predecessor, and so on, until some node's predecessor is the start node.

As an example, when searching for the shortest route on a map, h(x) might represent the straight-line distance to the goal, since that is physically the smallest possible distance between any two points.

If the heuristic h satisfies the additional condition h(x) ≤ d(x, y) + h(y) for every edge (x, y) of the graph (where d denotes the length of that edge), then h is called monotone, or consistent. In such a case, A* can be implemented more efficiently—roughly speaking, no node needs to be processed more than once (see closed set below)—and A* is equivalent to running Dijkstra's algorithm with the reduced cost d'(x, y) = d(x, y) + h(y) − h(x)
            function reconstruct_path(cameFrom, current)
                total_path := {current}
                while current in cameFrom.Keys:
                    current := cameFrom[current]
                    total_path.append(current)
                return total_path

            function A_Star(start, goal)

                // The set of nodes already evaluated
                closedSet := {}

                // The set of currently discovered nodes that are not evaluated yet.
                // Initially, only the start node is known.
                openSet := {start}

                // For each node, which node it can most efficiently be reached from.
                // If a node can be reached from many nodes, cameFrom will eventually contain the
                // most efficient previous step.
                cameFrom := an empty map

                // For each node, the cost of getting from the start node to that node.
                gScore := map with default value of Infinity

                // The cost of going from start to start is zero.
                gScore[start] := 0

                // For each node, the total cost of getting from the start node to the goal
                // by passing by that node. That value is partly known, partly heuristic.
                fScore := map with default value of Infinity

                // For the first node, that value is completely heuristic.
                fScore[start] := heuristic_cost_estimate(start, goal)

                while openSet is not empty
                    current := the node in openSet having the lowest fScore[] value
                    if current = goal
                        return reconstruct_path(cameFrom, current)

                    openSet.Remove(current)
                    closedSet.Add(current)

                    for each neighbor of current
                        if neighbor in closedSet
                            continue		// Ignore the neighbor which is already evaluated.

                        // The distance from start to a neighbor
                        tentative_gScore := gScore[current] + dist_between(current, neighbor)

                        if neighbor not in openSet	// Discover a new node
                            openSet.Add(neighbor)
                        else if tentative_gScore >= gScore[neighbor]
                            continue

                        // This path is the best until now. Record it!
                        cameFrom[neighbor] := current
                        gScore[neighbor] := tentative_gScore
                        fScore[neighbor] := gScore[neighbor] + heuristic_cost_estimate(neighbor, goal)
