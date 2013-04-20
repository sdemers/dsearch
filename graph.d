/**
Copyright: Serge Demers 2013
License: <a href="http://www.boost.org/LICENSE_1_0.txt">Boost License 1.0</a>.
*/

module dsearch.graph;

import dsearch.edge;
import dsearch.node;
import geomd.point2d;
import geomd.test;
import std.conv;
import std.algorithm;
import std.array;

/**
    Graph class. Contains nodes and edges.
*/
class Graph
{
    this()
    {
    }

    /**
        Adds many edges to the graph.
    */
    auto addEdges(Edge[] edges)
    {
        foreach (Edge e; edges)
        {
            addEdge(e);
        }
        return this;
    }

    /**
        Adds an edge to the graph. Makes sure the edge is present
        only once.
    */
    auto addEdge(Edge edge)
    {
        if (find(m_edges, edge).empty)
        {
            m_edges ~= edge;
        }
        return this;
    }

    @property const nodes() const
    {
        return m_nodes;
    }

    @property const edges() const
    {
        return m_edges;
    }

    /**
        Returns the graph as a string.
    */
    override string toString() const
    {
        string s = "Graph\n";
        foreach (int i, const Edge e; edges)
        {
            s ~= to!string(i) ~ " " ~ e.toString() ~ "\n";
        }
        return s;
    }

    private void addNode(Node node)
    {
        if (find(m_nodes, node).empty)
        {
            m_nodes ~= node;
        }
    }

    private void addNodes(Edge edge)
    {
        addNode(edge.node1);
        addNode(edge.node2);

        edge.node1.addEdge(edge);
    }

protected:
    Edge[] m_edges;
    Node[] m_nodes;
}


/**
    Applies a function on a graph and returns a new graph.
*/
auto applyFunc(const Graph graph, void delegate(const Graph, Graph) func)
{
    auto newGraph = new Graph();
    func(graph, newGraph);
    return newGraph;
}

unittest
{
    import geomd.utils;
    import std.stdio;

    auto p1 = new Point2Dd(0.0, 0.0);
    auto p2 = new Point2Dd(1.0, 1.0);
    auto p3 = new Point2Dd(0.0, 1.0);
    auto n1 = new Node("n1", p1);
    auto n2 = new Node("n2", p2);
    auto n3 = new Node("n3", p3);
    auto e1 = new Edge(n1, n2, 1.0, degToRad!double(45), degToRad!double(45));
    auto e2 = new Edge(n2, n3, 2.0, degToRad!double(90), degToRad!double(90));
    auto e3 = new Edge(n1, n3, 3.0, degToRad!double(45), degToRad!double(90));

    auto g1 = new Graph();
    auto edges = [e1, e2, e3];
    g1.addEdges(edges);
    check!ulong(g1.edges.length, cast(ulong)3);
    g1.addEdge(e1).addEdge(e2).addEdge(e3);
    check!ulong(g1.edges.length, cast(ulong)3);

    writeln(g1.toString());
}
