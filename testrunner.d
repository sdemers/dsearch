/**
Test runner

Copyright: Serge Demers 2013
License: <a href="http://www.boost.org/LICENSE_1_0.txt">Boost License 1.0</a>.
*/

module dsearch.testrunner;

import dsearch.graph;
import dsearch.json;
import dsearch.node;
import dsearch.edge;
import dsearch.uniformCostSearch;
import dsearch.depthLimitedSearch;
import dsearch.breadthFirstSearch;
import std.algorithm;
import std.datetime;
import std.stdio;

void main()
{
    Graph g = loadJSON("data/lines.json");

    debug
    {
        foreach (const Node n; g.nodes)
        {
            writefln("%.2f, %.2f |", n.pos.x, n.pos.y);
        }
    }

    //auto n1 = find!("a.name == \"1055\"")(g.nodes);
    //auto n2 = find!("a.name == \"547\"")(g.nodes);

    auto n1 = find!("a.name == \"1741\"")(g.nodes);
    auto n2 = find!("a.name == \"1957\"")(g.nodes);

    uniformCostSearch(g, n1[0], n2[0]);

    breadthFirstSearch(g, n1[0], n2[0]);

    //depthLimitedSearch(g, n1[0], n2[0]);

    writeln("\n---------------------------------------------------");
}

//------------------------------------------------------------------------------
//
private void uniformCostSearch(Graph g, const(Node) start, const(Node) goal)
{
    writeln("\nUniform Cost Search -------------------------------");

    StopWatch sw;
    sw.start();

    auto ucs = new UniformCostSearch(g, start, goal);
    auto result = ucs.run();

    sw.stop();
    writefln("Time elapsed: %s msec", sw.peek().msecs);

	debug
	{
		foreach (const Edge e; result)
		{
			writefln("%.2f, %.2f", e.node2.pos.x, e.node2.pos.y);
		}
	}
}

//------------------------------------------------------------------------------
//
private void breadthFirstSearch(Graph g, const(Node) start, const(Node) goal)
{
    writeln("\nBreadth First Search -------------------------------");

    StopWatch sw;
    sw.start();

    auto bfs = new BreadthFirstSearch(g, start, goal);
    auto result = bfs.run();

    sw.stop();
    writefln("Time elapsed: %s msec", sw.peek().msecs);

	debug
	{
		foreach (const Edge e; result)
		{
			writefln("%.2f, %.2f", e.node2.pos.x, e.node2.pos.y);
		}
	}
}

//------------------------------------------------------------------------------
//
private void depthLimitedSearch(Graph g, const(Node) start, const(Node) goal)
{
    StopWatch sw;
    sw.start();

    writeln("\nDepth Limited Search -------------------------------");

    auto dls = new DepthLimitedSearch(g, start, goal);

    for (ulong i = 0; i <= 10000; i += 500)
    {
        auto result = dls.run(i);

        writefln("DepthLimitedSearch found a path: %s, limit: %d", result.length == 0 ? "false" : "true", i);

        if (result.length > 0)
        {
            debug
            {
                writeln("DepthLimitedSearch result:");
                foreach (const Edge e; result)
                {
                    writefln("%.2f, %.2f", e.node2.pos.x, e.node2.pos.y);
                }
            }
            break;
        }
    }

    sw.stop();
    writefln("Time elapsed: %s msec", sw.peek().msecs);
}
