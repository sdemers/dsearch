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

    auto run()
    {
        // Add the first edges to frontier. We add only the edges that
        // are starting with the starting node.
        bool isStartingNode(const Edge e, const Node n) { return e.node1 == n; }
        auto firstFrontier = filterArray!(const Edge, const Node)
            (m_graph.edges, m_startingNode, &isStartingNode);

        foreach (const Edge e; firstFrontier)
        {
            writeln(e);
            m_frontier ~= new SearchEdge(null, e);
        }

        SearchEdge solution;

        int i = 0;
        bool searching = true;
        while (searching)
        {
            //if (++i > 2) break;

            writeln("---------");
            if (m_frontier.length == 0)
            {
                searching = false;
                break;
            }

            writeln("Frontier: ");
            foreach (const SearchEdge f; m_frontier)
            {
                writeln(f.toString());
            }
            writeln("---");

            sort!("a.cost < b.cost")(m_frontier);

            auto edge = popFront(m_frontier);

            writeln("Frontier after pop: ");
            foreach (const SearchEdge f; m_frontier)
            {
                writeln(f.toString());
            }
            writeln("---");

            writeln("visiting " ~ edge.node2().toString());

            m_explored ~= edge;

            if (edge.node2() == m_goalNode)
            {
                solution = edge;
                searching = false;
                break;
            }

            foreach (const Edge child; edge.node2().edges())
            {
                writeln("child of " ~ edge.node2().toString() ~ ": " ~ child.toString());

                auto foundFrontier = findSearchEdge(m_frontier, child);
                auto foundExplored = findSearchEdge(m_explored, child);

                if (foundFrontier is null &&
                    foundExplored is null)
                {
                    m_frontier ~= new SearchEdge(edge, child);
                    writeln("adding " ~ child.toString() ~ " to frontier");
                }
                else if (foundFrontier !is null &&
                         foundFrontier.pathCost > edge.cost + child.weight)
                {
                    foundFrontier = new SearchEdge(edge, child);
                }
            }
        }

        if (solution is null)
        {
            const(Edge[]) empty;
            return empty;
        }

        return solution.path;
    }

    private auto findSearchEdge(SearchEdge[] se, const Edge e)
    {
        foreach (SearchEdge s; se)
        {
            if (s.edge == e)
            {
                return s;
            }
        }
        return null;
    }

private:
    const Graph m_graph;
    const Node  m_startingNode;
    const Node  m_goalNode;

    SearchEdge[]  m_frontier;
    SearchEdge[]  m_explored;
}

unittest
{
    import geomd.utils;
    import std.stdio;
    import geomd.point2d;

    auto p1 = new Point2Dd(0.0, 0.0);
    auto p2 = new Point2Dd(1.0, 1.0);
    auto p3 = new Point2Dd(0.0, 1.0);
    auto n1 = new Node("n1", p1);
    auto n2 = new Node("n2", p2);
    auto n3 = new Node("n3", p3);
    auto e1 = new Edge(n1, n2, 1.0, degToRad!double(45), degToRad!double(45));
    auto e2 = new Edge(n2, n3, 2.0, degToRad!double(90), degToRad!double(90));
    auto e3 = new Edge(n1, n3, 4.0, degToRad!double(45), degToRad!double(90));

    auto edges = [e1, e2, e3];
    auto graph = new Graph;
    graph.addEdges(edges);

    auto search = new UniformCostSearch(graph, n1, n3);
    auto result = search.run();
    writeln(result);
}
