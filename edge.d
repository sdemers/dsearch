/**
Copyright: Serge Demers 2013
License: <a href="http://www.boost.org/LICENSE_1_0.txt">Boost License 1.0</a>.
*/

module dsearch.edge;

import geomd.point2d;
import geomd.test;
import geomd.utils;

import dsearch.node;

import std.conv;

/**
    Edge class
*/
class Edge
{
    /**
        Constructor
    */
    this(Node n1,
         Node n2,
         double weight,
         double radInitHeading,
         double radFinalHeading)
    {
        m_node1           = n1;
        m_node2           = n2;
        m_weight          = weight;
        m_radInitHeading  = radInitHeading;
        m_radFinalHeading = radFinalHeading;

        n1.addEdge(this);
    }

    @property const(Node) node1() const  { return m_node1; }
    @property const(Node) node2() const  { return m_node2; }
    @property Node node1() { return m_node1; }
    @property Node node2() { return m_node2; }
    @property auto initHeading()  const { return m_radInitHeading; }
    @property auto finalHeading() const { return m_radFinalHeading; }
    @property auto weight()       const { return m_weight; }

    override string toString() const
    {
        string s = "Edge\n    " ~ m_node1.toString() ~ " -> "
                   ~ m_node2.toString() ~ " weight: " ~ to!string(weight);
        return s;
    }

private:
    Node m_node1;     /// Initial end
    Node m_node2;     /// Final end
    double m_weight;
    double m_radInitHeading;
    double m_radFinalHeading;
}

public bool isStartingNode(ref Edge edge, ref Node node)
{
	return edge.node1 == node;
}
