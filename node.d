/**
Copyright: Serge Demers 2013
License: <a href="http://www.boost.org/LICENSE_1_0.txt">Boost License 1.0</a>.
*/

module dsearch.node;

import geomd.point2d;
import geomd.test;
import geomd.utils;
import dsearch.edge;
import std.conv;
import std.algorithm;
import std.array;

/**
    Node class
*/
class Node
{
    /**
        Constructor
    */
    this(string name,
         Point2Dd pos)
    {
        m_name = name;
        m_pos = pos;
    }

    @property auto name() const
    {
        return m_name;
    }

    @property auto pos() const
    {
        return m_pos;
    }

    /**
        Adds an edge connected to the node. Only outgoing edges are kept.
    */
    void addEdge(Edge edge)
    {
        if (edge.node1 == this)
        {
            if (find(m_edges, edge).empty)
            {
                m_edges ~= edge;
            }
        }
    }

    auto edges() const
    {
        return m_edges;
    }

    /**
        Returns the direct distance between two nodes.
    */
    auto getDistance(const Node node) const
    {
        return m_pos.getDistance(node.pos);
    }

    override string toString() const
    {
        string s = "Node [" ~ m_name ~ "]: (" ~ to!string(pos.x) ~
                   "," ~ to!string(pos.y) ~ ")";
        return s;
    }

private:
    string   m_name;
    Point2Dd m_pos;
    Edge[]   m_edges; // outgoing edges
}
