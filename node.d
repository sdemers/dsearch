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
         uint id,
         Point2Dd pos)
    {
        m_name = name;
        m_id = id;
        m_pos = pos;
    }

    auto id() const
    {
        return m_id;
    }

    auto name() const
    {
        return m_name;
    }

    auto pos() const
    {
        return m_pos;
    }

    override bool opEquals(Object other)
    {
        Node x = cast(Node)other;
        return x.m_id == m_id;
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
    uint     m_id;
    Point2Dd m_pos;
    Edge[]   m_edges; // outgoing edges
}
