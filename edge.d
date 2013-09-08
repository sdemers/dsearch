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
         uint id,
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

    const(Node) node1() const { return m_node1; }
    const(Node) node2() const { return m_node2; }
    Node node1()              { return m_node1; }
    Node node2()              { return m_node2; }
    auto initHeading()  const { return m_radInitHeading; }
    auto finalHeading() const { return m_radFinalHeading; }
    auto weight()       const { return m_weight; }

    string name() const
    {
        string s = "[" ~ m_node1.name ~ "->" ~ m_node2.name ~ "]";
        return s;
    }

    override string toString() const
    {
        string s = "Edge\n    " ~ m_node1.toString() ~ " -> "
                   ~ m_node2.toString() ~ " weight: " ~ to!string(weight);
        return s;
    }

    override bool opEquals(Object other)
    {
        Edge x = cast(Edge)other;
        return x.m_node1 == m_node1 && x.m_node2 == m_node2;
    }

protected:
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
