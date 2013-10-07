/**
Copyright: Serge Demers 2013
License: <a href="http://www.boost.org/LICENSE_1_0.txt">Boost License 1.0</a>.
*/

module dsearch.breadthFirstSearch;

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
    Breadth First Search class
*/
class BreadthFirstSearch
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
        bool shallowest(SearchEdge e1, SearchEdge e2)
        {
            auto be1 = cast(BreadthFirstSearchEdge)e1;
            auto be2 = cast(BreadthFirstSearchEdge)e2;
            return be1.depth < be2.depth;
        }

        ISearchEdgeContainer frontier = new FixedArrayContainer(m_graph.edges.length, &shallowest);
        ISearchEdgeContainer explored = new FixedArrayContainer(m_graph.edges.length, null);

        // Add the first edges to frontier. We add only the edges that
        // are starting with the starting node.
        auto firstFrontier = m_graph.edges.filter!(a => a.node1 == m_startingNode);

        foreach (const Edge e; firstFrontier)
        {
            frontier.insert(new BreadthFirstSearchEdge(null, e, 0));
        }

        BreadthFirstSearchEdge solution;

        bool searching = true;
        while (searching)
        {
            if (frontier.length == 0)
            {
                searching = false;
                break;
            }

            auto searchEdge = cast(BreadthFirstSearchEdge)frontier.getNextEdgeToVisit;
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
                    auto se = new BreadthFirstSearchEdge(searchEdge, child, searchEdge.depth + 1);
                    frontier.insert(se);
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

/**
    Search edge class that also include the current depth
*/
private class BreadthFirstSearchEdge : SearchEdge
{
    this(const SearchEdge parent, const Edge edge, ulong depth)
    {
        super(parent, edge);
        m_depth = depth;
    }

    auto depth() const
    {
        return m_depth;
    }

private:
    ulong m_depth;
}


unittest
{
}
