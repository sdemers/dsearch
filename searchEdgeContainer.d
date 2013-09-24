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


/**
    Interface for search edge containers.
*/
interface ISearchEdgeContainer
{
    void insert(SearchEdge e);
    void remove(SearchEdge e);
    SearchEdge find(const Edge e);
    SearchEdge find(const SearchEdge e);

    /**
        Returns the length of the container, i.e. the number of valid SearchEdge
        contained in it.
    */
    uint length() const;

    /**
        Returns the next SearchEdge according to an heuristic
    */
    SearchEdge getNextEdgeToVisit();
};

/**
    Class that implements ISearchEdgeContainer using a statically sized array
*/
class FixedArrayContainer : DynArrayContainer
{
public:

    /**
        Constructor
            Params:
            size = array size
    */
    this(ulong size,
         bool delegate(SearchEdge, SearchEdge) heuristic)
    {
        super(heuristic);
        m_container = new SearchEdge[size];
    }

    override void insert(SearchEdge e)
    {
        if (m_container[e.edge.id] is null)
        {
            m_container[e.edge.id] = e;
            ++m_nbElem;

            setNextToVisitOnInsert(e);
        }
    }

    override SearchEdge find(const Edge e)
    {
        return m_container[e.id];
    }
};

/**
  Class that implements ISearchEdgeContainer using a dynamically sized array
 */
class DynArrayContainer : ISearchEdgeContainer
{
public:

    this(bool delegate(SearchEdge, SearchEdge) heuristic)
    {
        m_heuristic = heuristic;
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
            setNextToVisitOnInsert(e);
        }
        else if (m_container[e.edge.id] is null)
        {
            m_container[e.edge.id] = e;

            ++m_nbElem;
            setNextToVisitOnInsert(e);
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

        setEdgeToVisitOnRemove(e);
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

    SearchEdge getNextEdgeToVisit()
    {
        return m_nextEdgeToVisit;
    }

    protected void setNextToVisitOnInsert(SearchEdge e)
    {
        if (m_nextEdgeToVisit is null ||
            m_heuristic(e, m_nextEdgeToVisit))
        {
            m_nextEdgeToVisit = e;
        }
    }

    protected void setEdgeToVisitOnRemove(SearchEdge edge)
    {
        assert(m_nextEdgeToVisit !is null);

        if (edge == m_nextEdgeToVisit)
        {
            m_nextEdgeToVisit = null;

            foreach (SearchEdge e; m_container)
            {
                if (e is null)
                {
                    continue;
                }

                if (m_nextEdgeToVisit is null ||
                    m_heuristic(e, m_nextEdgeToVisit))
                {
                    m_nextEdgeToVisit = e;
                }
            }
        }
    }

protected:
    SearchEdge[] m_container;
    uint         m_nbElem = 0;
    SearchEdge   m_nextEdgeToVisit = null;

    bool delegate(SearchEdge, SearchEdge) m_heuristic;
};
