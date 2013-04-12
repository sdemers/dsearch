/**
Copyright: Serge Demers 2013
License: <a href="http://www.boost.org/LICENSE_1_0.txt">Boost License 1.0</a>.
*/

module dsearch.node;

import geomd.point2d;
import geomd.test;
import geomd.utils;

import dsearch.edge;

class Node
{
    this(ref Point2Dd pos)
    {
        m_pos = pos;
    }

    @property auto ref pos() const
    {
        return m_pos;
    }

    void addEdge(ref Edge edge)
    {
        m_edges ~= edge;
    }

    auto getDistance(const ref Node node) const
    {
        return m_pos.getDistance(node.pos);
    }

private:
    Point2Dd m_pos;
    Edge[]   m_edges;
    Node[]   m_nodes;
}
