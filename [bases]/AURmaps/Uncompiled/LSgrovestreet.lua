for i,v in ipairs({
    {2169,2462.8,-1707.8,12.5,0,0,0},
    {1280,2436.8999,-1680.6,13.2,0,0,270},
    {1280,2432.8,-1680.5,13.2,0,0,270},
    {1280,2428.3,-1680.5,13.2,0,0,270},
    {1280,2424.2,-1680.5,13.2,0,0,270},
    {2169,2464.7,-1707.8,12.5,0,0,0},
    {1580,2462.8,-1707.8,13.28,0,0,50},
    {1215,2430.5,-1680.5,13.4,0,0,0},
    {1215,2434.7998,-1680.7002,13.4,0,0,0},
    {1579,2463.8,-1707.8,13.28,0,0,348},
    {1215,2426.2,-1680.5,13.4,0,0,0},
    {1575,2464.8,-1707.7,13.28,0,0,86},
    {1576,2464.98,-1707.7,13.4,0,40,0},
    {12986,2531.1001,-1717.2,14,0,0,90},
    {1577,2465.8,-1707.7,13.3,0,0,19.28},
    {356,2462.2,-1707.5,12.8,10,270,90},
    {356,2462.2,-1707.8,12.8,9.998,270,90},
    {348,2464.23,-1707.8,13.33,270,0,30},
    {1362,2431.8,-1674.4,13.3,0,0,0},
}) do
    local obj = createObject(v[1], v[2], v[3], v[4], v[5], v[6], v[7])
    setObjectScale(obj, 1)
    setElementDimension(obj, 0)
    setElementInterior(obj, 0)
    setElementDoubleSided(obj, true)
	setObjectBreakable(obj, false)
end