/**
Copyright: Serge Demers 2013
License: <a href="http://www.boost.org/LICENSE_1_0.txt">Boost License 1.0</a>.
*/

module dsearch.depthLimitedSearch;

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

/**
    DepthLimitedSearch class
*/
class DepthLimitedSearch
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

    const(Edge)[] run(ulong limit)
    {
        auto solution = RecursiveDLS(m_startingNode, limit);

        return solution;
    }

    const(Edge)[] RecursiveDLS(const Node currentNode, ulong limit)
    {
        bool insertFunc(SearchEdge e1, SearchEdge e2)
        {
            return true;
        }

        m_explored = new FixedArrayContainer(m_graph.edges.length, &insertFunc);

        auto firstChilds = m_graph.edges.filter!(a => a.node1 == currentNode);

        auto firstEdges = firstChilds.map!(a => new SearchEdge(null, a));

        foreach (SearchEdge e; firstEdges)
        {
            auto solution = RecursiveDLS(e, limit);
            if (solution.empty == false)
            {
                return solution;
            }

            m_explored.clear();
        }

        const(Edge[]) empty;
        return empty;
    }

    const(Edge)[] RecursiveDLS(SearchEdge currentEdge, ulong limit)
    {
        m_explored.insert(currentEdge);

        if (currentEdge.node2 == m_goalNode)
        {
            return currentEdge.path;
        }
        else if (limit > 0)
        {
            auto childs = currentEdge.node2.edges.filter!(a => a.node2 != currentEdge.node1)
                            .filter!(a => m_explored.find(a) is null)
                            .map!(a => new SearchEdge(currentEdge, a));

            foreach (SearchEdge e; childs)
            {
                auto solution = RecursiveDLS(e, limit - 1);

                if (solution.empty == false)
                {
                    return solution;
                }
            }
        }

        const(Edge[]) empty;
        return empty;
    }

private:
    const Graph          m_graph;
    const Node           m_startingNode;
    const Node           m_goalNode;
    ISearchEdgeContainer m_explored;
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

    //auto result = search.run();
    //writeln("uniformCostSearch unittest result: ");
    //writeln(result);
}
