for i,v in ipairs({
    {966,2004.3,-1350.2,23,0,0,0},
    {968,2004.26,-1350.188,23.7,0,0,0},
    {1215,2019,-1408.4,16.6,0,0,0},
    {1215,2038.2,-1401.7,16.9,0,0,0},
    {1215,2043.8,-1408.4,16.7,0,0,0},
    {967,2003.5,-1352.7,23,0,0,90},
    {1215,2043.6,-1426.2,16.7,0,0,0},
    {1364,2043.4,-1411.3,17,0,0,270},
    {966,2103.3,-1444.4,23,0,0,90},
    {1364,2043.4,-1417.4,17,0,0,270},
    {968,2103.2891,-1444.42,23.78,0,0,90},
    {1364,2043.4,-1423.3,17,0,0,270},
    {1364,2043.4,-1429.1,17,0,0,270},
    {1215,2043.9004,-1431.5996,16.7,0,0,0},
    {1215,2043.5,-1414.3,16.7,0,0,0},
    {1215,2043.5,-1420.2998,16.7,0,0,0},
    {967,2100.6001,-1445.6,23,0,0,0},
    {1569,2015.8,-1408.05,16,0,0,0},
    {1569,2018.8,-1408.05,16,0,0,180},
    {1215,2021.0996,-1401.7002,16.7,0,0,0},
    {1215,2015.5,-1408.4,16.6,0,0,0},
}) do
    local obj = createObject(v[1], v[2], v[3], v[4], v[5], v[6], v[7])
    setObjectScale(obj, 1)
    setElementDimension(obj, 0)
    setElementInterior(obj, 0)
    setElementDoubleSided(obj, true)
	setObjectBreakable(obj, false)
end