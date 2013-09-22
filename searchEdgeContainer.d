/**
Copyright: Serge Demers 2013
License: <a href="http://www.boost.org/LICENSE_1_0.txt">Boost License 1.0</a>.
*/

module dsearch.searchEdgeContainer;

import dsearch.searchEdge;
import dsearch.edge;
import std.container;
import std.stdio;
import std.conv;

interface ISearchEdgeContainer
{
    void insert(SearchEdge e);
    void remove(SearchEdge e);
    SearchEdge find(const Edge e);
    SearchEdge find(const SearchEdge e);
    uint length() const;
    SearchEdge getLowestCostEdge();
};


//------------------------------------------------------------------------------
//
class FixedArrayContainer : DynArrayContainer
{
public:

    this(ulong size)
    {
        m_container = new SearchEdge[size];
    }

    override void insert(SearchEdge e)
    {
        if (m_container[e.edge.id] is null)
        {
            m_container[e.edge.id] = e;
            ++m_nbElem;

            setLowestCostOnInsert(e);
        }
    }

    override SearchEdge find(const Edge e)
    {
        return m_container[e.id];
    }
};

//------------------------------------------------------------------------------
//
class DynArrayContainer : ISearchEdgeContainer
{
public:

    this()
    {
        m_container = new SearchEdge[500];
    }

    void insert(SearchEdge e)
    {
        if (m_container.length < e.edge.id + 1)
        {
            SearchEdge[] newArray = new SearchEdge[e.edge.id + 1];

            for (int i = 0; i < m_container.length; ++i)
            {
                newArray[i] = m_container[i];
            }

            newArray[e.edge.id] = e;

            m_container = newArray;

            ++m_nbElem;
            setLowestCostOnInsert(e);
        }
        else if (m_container[e.edge.id] is null)
        {
            m_container[e.edge.id] = e;

            ++m_nbElem;
            setLowestCostOnInsert(e);
        }

        debug
        {
            writefln("ArrayContainer insert id: %d, length: %d, size: %d",
                     e.edge.id, m_nbElem, m_container.length);
        }
    }

    protected void setLowestCostOnInsert(SearchEdge e)
    {
        if (m_lowestCost is null ||
            e.pathCost < m_lowestCost.pathCost)
        {
            m_lowestCost = e;
        }
    }

    void remove(SearchEdge e)
    {
        debug
        {
            writefln("remove: %d", e.edge.id);
        }

        m_container[e.edge.id] = null;
        --m_nbElem;

        setLowestCostOnRemove(e);
    }

    SearchEdge find(const SearchEdge e)
    {
        return find(e.edge);
    }

    SearchEdge find(const Edge e)
    {
        if (m_container.length < e.id + 1)
        {
            return null;
        }

        return m_container[e.id];
    }

    uint length() const
    {
        return m_nbElem;
    }

    SearchEdge getLowestCostEdge()
    {
        debug
        {
            writefln("getLowestCostEdge: %d", m_lowestCost.edge.id);
        }

        return m_lowestCost;
    }

    protected void setLowestCostOnRemove(SearchEdge edge)
    {
        assert(m_lowestCost !is null);

        if (edge == m_lowestCost)
        {
            m_lowestCost = null;

            foreach (SearchEdge e; m_container)
            {
                if (e is null)
                {
                    continue;
                }

                if (m_lowestCost is null ||
                    e.pathCost < m_lowestCost.pathCost)
                {
                    debug
                    {
                        writefln("setLowestCostOnRemove: new lowest cost %d", e.edge.id);
                    }
                    m_lowestCost = e;
                }
            }
        }
    }

protected:
    SearchEdge[] m_container;
    uint         m_nbElem = 0;
    SearchEdge   m_lowestCost = null;
};
