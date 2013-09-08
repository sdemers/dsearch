/**
Copyright: Serge Demers 2013
License: <a href="http://www.boost.org/LICENSE_1_0.txt">Boost License 1.0</a>.
*/

module dsearch.bezierEdge;

import geomd.bezierCurve;
import geomd.point2d;
import geomd.test;
import geomd.utils;

import dsearch.node;
import dsearch.edge;

import std.conv;

/**
    BezierEdge class
*/
class BezierEdge : Edge
{
    /**
        Constructor
    */
    this(Node n1,
         Node cp1,
         Node cp2,
         Node n2)
    {
        m_cp1 = cp1;
        m_cp2 = cp2;

        m_curve = new BezierCurve(n1.pos, cp1.pos, cp2.pos, n2.pos);

        super(n1, n2, m_curve.length, m_curve.initHeading, m_curve.finalHeading);
    }

    const(Node) cp1() const { return m_cp1; }
    Node cp1()              { return m_cp1; }
    const(Node) cp2() const { return m_cp2; }
    Node cp2()              { return m_cp2; }

private:
    Node m_cp1;     /// control point 1
    Node m_cp2;     /// control point 2

    BezierCurve m_curve;
}
