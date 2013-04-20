/**
Copyright: Serge Demers 2013
License: <a href="http://www.boost.org/LICENSE_1_0.txt">Boost License 1.0</a>.
*/

module dsearch.searchEdge;

import dsearch.edge;
import dsearch.node;

import std.conv;
import std.container;

class SearchEdge
{
    this(const SearchEdge parent, const Edge edge)
    {
        m_edge = edge;

        if (parent is null)
        {
            m_path ~= edge;
            m_cost = edge.weight;
            m_pathCost = edge.weight;
        }
        else
        {
            m_path ~= parent.m_path ~ edge;
            m_cost = edge.weight;
            m_pathCost = parent.m_cost + edge.weight;
        }
    }

    @property const(Edge) edge() const   { return m_edge; }
    @property const(Edge)[] path() const { return m_path; }
    @property double cost() const        { return m_cost; }
    @property double pathCost() const    { return m_pathCost; }

    @property auto node2() { return m_edge.node2(); }

    override string toString() const
    {
        string s = "SearchEdge: " ~ m_edge.node1.name ~ " -> " ~
            m_edge.node2.name ~ " Cost: " ~ to!string(m_cost) ~ " Path: ";
        foreach (const Edge e; m_path)
        {
            s ~= e.toString() ~ ", ";
        }
        return s;
    }

private:
    const(Edge)   m_edge;
    const(Edge)[] m_path;
    double        m_cost;
    double        m_pathCost;
}

alias RedBlackTree!(SearchEdge, "a.cost < b.cost") SearchEdgeContainer;

