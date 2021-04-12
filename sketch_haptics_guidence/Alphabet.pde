/*
* The alphabet class
*
* @author Bibhushan
* @author Shariff
*/

public class Alphabet {
	ArrayList<FLine> polys;
	ArrayList<Pair> lineSegments;
	FLine outerFShape;
  ArrayList<boolean[]> passedPoints = new ArrayList<boolean[]>();
  int totalPassablePoints = 1;
  int passedPointsCount = 0;
  float currentD;
  float lineSubdivisionSize = 2;

	float temp1, temp2;
		
 /**
  * Constructor
  */  
  public Alphabet(ArrayList<PVector> points, float positionAlphabetX, float positionAlphabetY, float alphabetScale){
		polys = new ArrayList<FLine>();
		lineSegments = new ArrayList<Pair>();
		println("length of the array:"+points.size());
		for (int i = 0; i < points.size() - 1; i++) {
      if (points.get(i) == null || points.get(i + 1) == null)
        continue;
			outerFShape = new FLine(positionAlphabetX + (points.get(i).x) * alphabetScale,
															positionAlphabetY + (points.get(i).y) * alphabetScale,
															positionAlphabetX + (points.get(i + 1).x) * alphabetScale,
															positionAlphabetY + (points.get(i + 1).y) * alphabetScale);
			/* for (int i = 0; i < 2; i++) { */
			/*     println("(" + (int)points.get(i).x + ", " + (int)points.get(i).y + ")"); */
			/*     outerFShape.vertex(positionAlphabetX + (points.get(i).x) * alphabetScale, positionAlphabetY + (points.get(i).y) * alphabetScale); */
			/* } */
			//outerFShape.vertex(outerPoints[0].x, outerPoints[0].y);
			outerFShape.setFill(255, 0, 0);
			outerFShape.setStrokeColor(color(255, 0, 0, 100));
			outerFShape.setStrokeWeight(30.0f);
			// outerFShape.setNoStroke();
			outerFShape.setDensity(0);
			//outerFShape.setDensity(4);
			//confused should setSensor true or false
			outerFShape.setSensor(true);
			//outerFShape.setNoStroke();
			outerFShape.setStatic(true);
			world.add(outerFShape);
			polys.add(outerFShape);

      PVector p1 = new PVector((positionAlphabetX + (points.get(i).x) * alphabetScale) * pixelsPerCentimeter,
                               (positionAlphabetY + (points.get(i).y) * alphabetScale) * pixelsPerCentimeter);
      PVector p2 = new PVector((positionAlphabetX + (points.get(i + 1).x) * alphabetScale) * pixelsPerCentimeter,
                               (positionAlphabetY + (points.get(i + 1).y) * alphabetScale) * pixelsPerCentimeter);
			lineSegments.add(new Pair(p1, p2));

      int subPoints = ceil(PVector.sub(p1, p2).mag() / lineSubdivisionSize);
      boolean[] _passedPoints = new boolean[subPoints];
      totalPassablePoints += _passedPoints.length;
      passedPoints.add(_passedPoints);
		}
	}

	public void removeFromWorld(){
		for (int i = 0; i < polys.size(); i++)
		{
			world.remove(polys.get(i));
		}
	}

	public boolean isTouchedByBody(FBody body)
	{
		for (int i = 0; i < polys.size(); i++)
		{
			if(body.isTouchingBody(polys.get(i)))
				return true;
		}
		return false;
	}

	public ClosestPointResult closestPoint(float x, float y)
	{
		PVector p = new PVector(x, y);
		
		float a, b, c, d, currentA, currentB, currentC, denomSquared, currentDenomSquared, currendD = 10000, currentAC=0;
		a = b = c = currentA = currentB = currentC = currentDenomSquared = 0;
		Pair pair;
		PVector ab=null, ab_n, ac=null, ac_p, cVector=null, currentCVector = null, currentPerpendicularVector=null;
		FLine closestLine = polys.get(0);
    int closestLineIndex = -1;

		for (int i = 0; i < polys.size(); i++)
		{
			//	polys.get(i).setStrokeColor(color(255, 0, 0));
			pair = lineSegments.get(i);

			// method 1 (vector arithmatic)
			// ab = PVector.sub(pair.p2, pair.p1); //  vector from p1 to p2
			// ab_n = new PVector(-ab.y, ab.x); // perpendicular to ab
			// ac_p = PVector.sub(p, pair.p1); // vector from p1 to p
			// d = abs(ac_p.dot(ab_n) / ab_n.mag()) ; // absolute value of scalar projection of ac on ab_n, aka distance

			// method 2 geomatry
			// Get the closest point to p on the line
			// a, b, c being the coefficient of the line
			a = pair.p1.y - pair.p2.y;
			b = pair.p2.x - pair.p1.x;
			c = pair.p1.x * pair.p2.y - pair.p2.x * pair.p1.y;
			denomSquared = pow(a, 2) + pow(b, 2);
			d = abs(a * p.x + b * p.y + c) / sqrt(denomSquared); // orthogonal distance from the line
			if (d < currendD)
			{
				cVector = new PVector((b * (b * p.x - a * p.y) - a * c)/denomSquared, (a * ( -b * p.x + a * p.y ) - b* c) / denomSquared);
				// ac = ab.mult(d);
				ac = PVector.sub(cVector, pair.p1);
				ab = PVector.sub(pair.p2, pair.p1); //  vector from p1 to p2
				if (ac.dot(ab) > 0 && ac.mag() <= ab.mag()) // checking if the point in on the line
				{
					closestLine = polys.get(i);
					currentCVector = cVector;
					currentPerpendicularVector = PVector.sub(p, cVector); // the perpendicular vector from the line to p
					// currentCVector = PVector.add(pair.p1, ac);
					currendD = d;
          closestLineIndex = i;
          currentAC = ac.mag() / ab.mag();
				}
			}
		}
		// closestLine.setStrokeColor(color(0, 0, 0));
    ClosestPointResult result = new ClosestPointResult(currentCVector, currentPerpendicularVector);
    if (result.useThis)
    {
        boolean[] _passedPoints = passedPoints.get(closestLineIndex);
        int _passedPointIndex = floor(currentAC * _passedPoints.length); // the subdivision of the line on which the closest point is
        if (!_passedPoints[_passedPointIndex]) // if this segment is not visited before
        {
            passedPointsCount += 1;
            _passedPoints[_passedPointIndex] = true;
        }
        this.currentD = currendD;
    }
		return result;
	}

  public AlphabetMetrics getMetrics()
  {
      float val = (float)passedPointsCount/(float)totalPassablePoints;
      return new AlphabetMetrics(val, currentD);
  }

	private class Pair
	{
			public PVector p1;
			public PVector p2;
		
			public Pair(PVector p1, PVector p2)
			{
					this.p1 = p1;
					this.p2 = p2;
			}
	}
}

public class ClosestPointResult 
{
		public PVector c;
		public PVector perpendicularVector;
    public boolean useThis;
		
		public ClosestPointResult (PVector c, PVector perpendicularVector) {
				this.c = c;
				this.perpendicularVector = perpendicularVector;
        this.useThis = (c != null && (c.x != 0 || c.y != 0));
		}
}

public class AlphabetMetrics
{
    public float completedPercentage;
    public float currentD;

    public AlphabetMetrics(float completedPercentage, float currentD)
    {
        this.completedPercentage = completedPercentage;
        this.currentD = currentD;
    }
}
