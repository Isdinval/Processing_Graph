# Processing_Graph

# I°) Breadth First Search - Pseudocode

Breadth first traversal is accomplished by enqueueing each level of a tree sequentially as the root of any subtree is encountered. There are 2 cases in the iterative algorithm.

- Root case: The traversal queue is initially empty so the root node must be added before the general case.
General case: Process any items in the queue, while also expanding their children. Stop if the queue is empty. The general case will halt after processing the bottom level as leaf nodes have no children.
Input: A search problem. A search-problem abstracts out the problem specific requirements from the actual search algorithm.

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
