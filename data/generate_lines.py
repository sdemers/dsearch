#!/usr/bin/env python

import json
import numpy as np

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
        # closests.append((p, (c[0], c[1], c[2])))
        closests.append((p, (c[0], c[1])))
    return closests

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
    if i == len(points) - 1:
        print '{"id": %d, "name": "%d", "x": %.2f, "y": %.2f}' % (p.id, p.id, p.x, p.y)
    else:
        print '{"id": %d, "name": "%d", "x": %.2f, "y": %.2f},' % (p.id, p.id, p.x, p.y)

print """],"edges": ["""

id = 0
for i in xrange(len(cl)):
    (p, c) = cl[i]
    for j in xrange(len(c)):
        p1 = c[j]
        if i == len(cl) - 1 and j == len(c) - 1:
            print '{"id": %d, "type": "line", "name": "%d_%d", "node1": %d, "node2": %d}' % (id, p.id, p1.id, p.id, p1.id)
        else:
            print '{"id": %d, "type": "line", "name": "%d_%d", "node1": %d, "node2": %d},' % (id, p.id, p1.id, p.id, p1.id)
        id = id + 1

print "]}}"
