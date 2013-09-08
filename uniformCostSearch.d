/**
Copyright: Serge Demers 2013
License: <a href="http://www.boost.org/LICENSE_1_0.txt">Boost License 1.0</a>.
*/

module dsearch.uniformCostSearch;

import geomd.utils;
import dsearch.graph;
import dsearch.edge;
import dsearch.node;
import dsearch.searchEdge;
import std.container;
import std.algorithm;
import std.functional;
import std.stdio;
import std.conv;
import std.range;
import std.datetime;

void debugPrint(S...)(S args)
{
    debug
    {
        writeln(args);
    }
}

/**
    UniformCostSearch class
*/
class UniformCostSearch
{
    /**
        Constructor
    */
    this(const Graph graph,
         const Node startingNode,
         const Node goalNode)
    {
        m_graph        = graph;
        m_startingNode = startingNode;
        m_goalNode     = goalNode;
    }

    const(Edge)[] run()
    {
        StopWatch sw;
        sw.start();

        SearchEdgeContainer frontier = new SearchEdgeContainer;
        SearchEdgeContainer explored = new SearchEdgeContainer;

        // Add the first edges to frontier. We add only the edges that
        // are starting with the starting node.
        bool isStartingNode(const Edge e, const Node n) { return e.node1 == n; }
        auto firstFrontier = filterArray!(const Edge, const Node)
            (m_graph.edges, m_startingNode, &isStartingNode);

        foreach (const Edge e; firstFrontier)
        {
            debugPrint("Adding edge: " ~ e.name ~ " weight: " ~ to!string(e.weight));
            auto se = new SearchEdge(null, e);
            frontier.insert(se);
        }

        SearchEdge solution;

        int i = 0;

        bool searching = true;
        while (searching)
        {
            debug
            {
                debugPrint("Frontier:");
                foreach (const SearchEdge e; frontier)
                {
                    write(e.edge.name);
                }
                writeln();
            }

            if (0)//++i == 100)
            {
                searching = false;
                break;
            }

            if (frontier.length == 0)
            {
                searching = false;
                break;
            }

            auto searchEdge = frontier[].front;
            frontier.removeFront;

            debugPrint("Exploring: " ~ searchEdge.edge.name);
            explored.insert(searchEdge);

            debug
            {
                writeln("Path: ");
                foreach (const Edge e; searchEdge.path)
                {
                    write(e.name);
                    //writef("%.2f, %.2f ", e.node2.pos.x, e.node2.pos.y);
                }
                writeln("");
            }

            if (searchEdge.node2 == m_goalNode)
            {
                solution = searchEdge;
                searching = false;
                break;
            }

            debug
            {
                debugPrint("Explored:");
                foreach (const SearchEdge e; explored[])
                {
                    write(e.edge.name ~ " ");
                }
                writeln();
            }

            foreach (const Edge child; searchEdge.node2.edges)
            {
                if (searchEdge.node1 == child.node2 &&
                    searchEdge.node2 == child.node1)
                {
                    continue;
                }

                debugPrint("child of " ~ searchEdge.edge.name ~ ": " ~ child.name);

                auto foundFrontier = find!("a.edge == b")(frontier[], child);
                auto foundExplored = find!("a.edge == b")(explored[], child);

                if (foundFrontier.empty &&
                    foundExplored.empty)
                {
                    auto se = new SearchEdge(searchEdge, child);
                    debugPrint("1 adding " ~ child.name ~ " to frontier, pathCost: " ~ to!string(se.pathCost));
                    //debugPrint("old frontier.length: ", frontier.length);
                    frontier.insert(se);
                    //debugPrint("new frontier.length: ", frontier.length);
                }
                else if (foundFrontier.empty == false &&
                         foundFrontier.front.pathCost > searchEdge.pathCost + child.weight)
                {
                    frontier.remove(foundFrontier);
                    auto se = new SearchEdge(searchEdge, child);
                    debugPrint("2 adding " ~ se.edge.name ~ " to frontier, pathCost: " ~ to!string(se.pathCost));
                    frontier.insert(se);
                }
            }
        }

        sw.stop();
        writefln("Time elapsed: %s msec", sw.peek().msecs);

        if (solution is null)
        {
            const(Edge[]) empty;
            return empty;
        }

        return solution.path;
    }

private:
    const Graph m_graph;
    const Node  m_startingNode;
    const Node  m_goalNode;
}

unittest
{
    import geomd.utils;
    import std.stdio;
    import geomd.point2d;

    auto p1 = new Point2Dd(0.0, 0.0);
    auto p2 = new Point2Dd(1.0, 1.0);
    auto p3 = new Point2Dd(0.0, 1.0);
    auto n1 = new Node("n1", 1, p1);
    auto n2 = new Node("n2", 2, p2);
    auto n3 = new Node("n3", 3, p3);
    auto e1 = new Edge(n1, n2, 1.0, degToRad!double(45), degToRad!double(45));
    auto e2 = new Edge(n2, n3, 2.0, degToRad!double(90), degToRad!double(90));
    auto e3 = new Edge(n1, n3, 4.0, degToRad!double(45), degToRad!double(90));

    auto edges = [e1, e2, e3];
    auto graph = new Graph;
    graph.addEdges(edges);

    auto search = new UniformCostSearch(graph, n1, n3);
    //auto result = search.run();
    //writeln("uniformCostSearch unittest result: ");
    //writeln(result);
}
