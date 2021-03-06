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
import dsearch.searchEdgeContainer;
import std.container;
import std.algorithm;
import std.functional;
import std.stdio;
import std.conv;
import std.range;

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
        bool lowestCost(SearchEdge e1, SearchEdge e2)
        {
            return e1.pathCost < e2.pathCost;
        }

        ISearchEdgeContainer frontier = new FixedArrayContainer(m_graph.edges.length, &lowestCost);
        ISearchEdgeContainer explored = new FixedArrayContainer(m_graph.edges.length, null);

        // Add the first edges to frontier. We add only the edges that
        // are starting with the starting node.
        auto firstFrontier = m_graph.edges.filter!(a => a.node1 == m_startingNode);

        foreach (const Edge e; firstFrontier)
        {
            auto se = new SearchEdge(null, e);
            frontier.insert(se);
        }

        bool searching = true;
        while (searching)
        {
            if (frontier.length == 0)
            {
                searching = false;
                break;
            }

            auto searchEdge = frontier.getNextEdgeToVisit;
            frontier.remove(searchEdge);
            explored.insert(searchEdge);

            if (searchEdge.node2 == m_goalNode)
            {
                return searchEdge.path;
            }

            foreach (const Edge child; searchEdge.node2.edges)
            {
                auto foundFrontier = frontier.find(child);
                auto foundExplored = explored.find(child);

                if (foundFrontier is null &&
                    foundExplored is null)
                {
                    frontier.insert(new SearchEdge(searchEdge, child));
                }
                else if (foundFrontier !is null &&
                         foundFrontier.pathCost > searchEdge.pathCost + child.weight)
                {
                    frontier.remove(foundFrontier);
                    frontier.insert(new SearchEdge(searchEdge, child));
                }
            }
        }

        const(Edge[]) empty;
        return empty;
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
    auto e1 = new Edge(n1, n2, 1, 1.0, degToRad!double(45), degToRad!double(45));
    auto e2 = new Edge(n2, n3, 2, 2.0, degToRad!double(90), degToRad!double(90));
    auto e3 = new Edge(n1, n3, 3, 4.0, degToRad!double(45), degToRad!double(90));

    auto edges = [e1, e2, e3];
    auto graph = new Graph;
    graph.addEdges(edges);

    auto search = new UniformCostSearch(graph, n1, n3);
    //auto result = search.run();
    //writeln("uniformCostSearch unittest result: ");
    //writeln(result);
}
