/**
    Copyright: Serge Demers 2013
    License: <a href="http://www.boost.org/LICENSE_1_0.txt">Boost License 1.0</a>.
*/

module dsearch.lineSegmentEdge;

import geomd.lineSegment;
import geomd.point2d;
import geomd.test;
import geomd.utils;

import dsearch.node;
import dsearch.edge;

import std.conv;

/**
    LineSegmentEdge class
*/
class LineSegmentEdge : Edge
{
    /**
        Constructor
        params:
            id = unique id
            n1 = starting point
            n2 = ending point
    */
    this(uint id, Node n1, Node n2)
    {
        auto line = new LineSegment(n1.pos, n2.pos);

        super(n1, n2, id, line.length, line.initHeading, line.finalHeading);
    }
}
