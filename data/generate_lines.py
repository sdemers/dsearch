#!/usr/bin/env python

import numpy as np
import sys

class Point:
    def __init__(self, id, x=0, y=0):
        self.id = id
        self.x = x
        self.y = y

    def __copy__(self):
        return self.__class__(self.id, self.x, self.y)

    def __repr__(self):
        return 'Point[%d](%.2f, %.2f)' % (self.id, self.x, self.y)

def sqr(p):
    return p * p;

def distance(p0, p1):
    return np.sqrt(sqr(p1.x - p0.x) + sqr(p1.y - p0.y))

def sortByDistance(point, points):
    dists = [(distance(point, o), o) for o in points]
    dists.sort()
    d = [p for (d, p) in dists]
    return d[1::] # skip self

def findClosests(points):
    closests = []
    for p in points:
        c = sortByDistance(p, points)
        closests.append((p, (c[0], c[1], c[2])))
        #closests.append((p, (c[0], c[1])))
    return closests

def outputLine(id, p0, p1, end=',\n'):
    out = '{{"id": {0}, "type": "line", "name": "{1}_{2}", "node1": {3}, "node2": {4}}}'\
            .format(id, p0.id, p1.id, p0.id, p1.id)
    sys.stdout.write(out)
    sys.stdout.write(end)

def outputLineCoord(p0, p1):
    out = '{0} {1}, {2} {3}|\n'.format(p0.x, p0.y, p1.x, p1.y)
    sys.stdout.write(out)

################## Main ####################

data = np.loadtxt("2dpoints.txt", dtype=int)

i = 0
points = []
for p in data:
    points.append(Point(i, p[0], p[1]))
    i = i + 1

cl = findClosests(points)

# output points
print """{"data":{"nodes":["""
for i in xrange(len(points)):
    p = points[i]
    out = '{{"id": {0}, "name": "{0}", "x": {1}.00, "y": {2}.00}}'.format(p.id, p.x, p.y)
    sys.stdout.write(out)
    if i == len(points) - 1:
        sys.stdout.write('\n')
    else:
        sys.stdout.write(',\n')

print """],"edges": ["""

lines = []
id = 0
for i in xrange(len(cl)):
    (p, c) = cl[i]
    for j in xrange(len(c)):
        p1 = c[j]
        end = ',\n'
        if i == len(cl) - 1 and j == len(c) - 1:
            end = '\n'
        line_name = '{0}_{1}'.format(p.id, p1.id)
        if line_name not in lines:
            lines.append(line_name)
            outputLine(id, p, p1, end)
            #outputLineCoord(p, p1)
            id = id + 1

        line_name = '{0}_{1}'.format(p1.id, p.id)
        if line_name not in lines:
            lines.append(line_name)
            outputLine(id, p1, p, end)
            #outputLineCoord(p1, p)
            id = id + 1

print "]}}"
