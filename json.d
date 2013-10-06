/**
Copyright: Serge Demers 2013
License: <a href="http://www.boost.org/LICENSE_1_0.txt">Boost License 1.0</a>.
*/

module dsearch.json;

import dsearch.edge;
import dsearch.bezierEdge;
import dsearch.lineSegmentEdge;
import dsearch.node;
import dsearch.graph;
import geomd.point2d;
import std.stdio;
import std.json;
import std.conv;
import std.file;
import std.algorithm;
import std.datetime;

/**
    Load JSON. Reads a JSON file and return the resulting Graph.
*/
public auto loadJSON(const string filename)
{
    auto content = to!string(read(filename));

    JSONValue[string] document = parseJSON(content).object;

    auto data = document["data"].object;
    auto nodes = data["nodes"].array;
    auto edges = data["edges"].array;

    Node[long] nodeMap;
    foreach (nodeJson; nodes)
    {
        JSONValue[string] node = nodeJson.object;

        string name = node["name"].str;
        double x = node["x"].floating;
        double y = node["y"].floating;

        auto pt = new Point2Dd(x, y);
        long id = node["id"].integer;

        nodeMap[id] = new Node(name, cast(uint)id, pt);
    }

    Edge[long] edgeMap;
    foreach (edgeJson; edges)
    {
        JSONValue[string] edge = edgeJson.object;

        long id = edge["id"].integer;

        long node1 = edge["node1"].integer;
        long node2 = edge["node2"].integer;

        Node n1 = nodeMap[node1];
        Node n2 = nodeMap[node2];

        switch (edge["type"].str)
        {
            case "bezier":
                double cp1x = edge["cpx0"].floating;
                double cp1y = edge["cpy0"].floating;
                double cp2x = edge["cpx1"].floating;
                double cp2y = edge["cpy1"].floating;

                edgeMap[id] = new BezierEdge(cast(uint)id,
                                             n1,
                                             new Node(n1.name ~ "_cp1", n1.id, new Point2Dd(cp1x, cp1y)),
                                             new Node(n2.name ~ "_cp2", n2.id, new Point2Dd(cp2x, cp2y)),
                                             n2);
                break;

            case "line":
                edgeMap[id] = new LineSegmentEdge(cast(uint)id, n1, n2);
                break;

            default:
                break;
        }
    }

    auto graph = new Graph();
    foreach (Edge edge; edgeMap)
    {
        Edge e = cast(Edge)edge;
        graph.addEdge(e);
    }

    return graph;
}


unittest
{
    import dsearch.uniformCostSearch;
    import dsearch.depthLimitedSearch;

    writeln("Begin JSON test");

    Graph g = loadJSON("data/lines.json");

    debug
    {
        foreach (const Node n; g.nodes)
        {
            writefln("%.2f, %.2f |", n.pos.x, n.pos.y);
        }
    }

    auto n1 = find!("a.name == \"1055\"")(g.nodes);
    auto n2 = find!("a.name == \"547\"")(g.nodes);

    debug
    {
        writeln(n1[0]);
        writeln(n2[0]);
    }

    StopWatch sw;
    sw.start();

    writeln("Uniform cost search -------------------------------");

    auto search = new UniformCostSearch(g, n1[0], n2[0]);
    auto result = search.run();

	debug
	{
        writeln("JSON result:");
		foreach (const Edge e; result)
		{
			writefln("%.2f, %.2f length: %.2f", e.node2.pos.x, e.node2.pos.y, e.weight);
		}
		writeln(result);
	}

    sw.stop();
    writefln("Time elapsed: %s msec", sw.peek().msecs);

    writeln("Limited depth search -------------------------------");

    sw.reset();
    sw.start();

    auto dls = new DepthLimitedSearch(g, n1[0], n2[0]);

    for (ulong i = 0; i <= 10000; i += 100)
    {
        auto dlsResult = dls.run(i);

        writefln("DepthLimitedSearch found a path: %s, limit: %d", dlsResult.length == 0 ? "false" : "true", i);

        if (dlsResult.length > 0)
        {
            debug
            {
                writeln("DepthLimitedSearch result:");
                foreach (const Edge e; dlsResult)
                {
                    writefln("%.2f, %.2f", e.node2.pos.x, e.node2.pos.y);
                }
            }
            break;
        }
    }

    sw.stop();
    writefln("Time elapsed: %s msec", sw.peek().msecs);

    writeln("End JSON test");
}
