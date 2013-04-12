/**
Copyright: Serge Demers 2013
License: <a href="http://www.boost.org/LICENSE_1_0.txt">Boost License 1.0</a>.
*/

module dsearch.edge;

import geomd.point2d;
import geomd.test;
import geomd.utils;

import dsearch.node;

class Edge
{
    this(ref Node n1, ref Node n2, double weight,
         double radInitHeading, double radFinalHeading)
    {
        m_node1 = n1;
        m_node2 = n2;
        m_weight = weight;
        m_radInitHeading = radInitHeading;
        m_radFinalHeading = radFinalHeading;
    }

    @property auto node1() const        { return m_node1; }
    @property auto node2() const        { return m_node2; }
    @property auto initHeading() const  { return m_radInitHeading; }
    @property auto finalHeading() const { return m_radFinalHeading; }
    @property auto weight() const       { return m_weight; }

private:
    Node    m_node1;
    Node    m_node2;
    double  m_weight;
    double  m_radInitHeading;
    double  m_radFinalHeading;
}
