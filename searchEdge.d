/**
Copyright: Serge Demers 2013
License: <a href="http://www.boost.org/LICENSE_1_0.txt">Boost License 1.0</a>.
*/

module dsearch.searchEdge;

import dsearch.edge;
import dsearch.node;

import std.conv;
import std.container;

import std.stdio;

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
            m_pathCost = parent.m_pathCost + edge.weight;
        }
    }

    override bool opEquals(Object o)
    {
        SearchEdge x = cast(SearchEdge)o;
        assert(x !is null);
        return x.edge.id == edge.id;
    }

    override int opCmp(Object other)
    {
        SearchEdge x = cast(SearchEdge)other;
        return cast(int)(pathCost - x.pathCost);
    }

    const(Edge) edge() const   { return m_edge; }
    const(Edge)[] path() const { return m_path; }
    double cost() const        { return m_cost; }
    double pathCost() const    { return m_pathCost; }

    auto node1() { return m_edge.node1; }
    auto node2() { return m_edge.node2; }

    override string toString() const
    {
        return m_edge.node2.name;
    }


private:
    const(Edge)   m_edge;
    const(Edge)[] m_path;
    double        m_cost;
    double        m_pathCost;
}

//------------------------------------------------------------------------------
//
// Two functions: hack to avoid excessive copying by the compiler
//
bool lessFun(SearchEdge e1, SearchEdge e2)
{
    return e1.pathCost < e2.pathCost;
}

bool lessfun(T)(auto ref T a, auto ref T b)
{
    return a < b;
}
