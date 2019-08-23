ArrayList<Collider> colliders;

Collider mouseCollider;
boolean collisionThisFrame;

float Gridsize = 20f;

PVector p1, p2;

ArrayList<PVector> interceptionpoints = new ArrayList<PVector>();

void setup()
{
  size(600, 600);
  colliders = new ArrayList<Collider>();
  colliders.add(new RectangleCollider(new PVector(10, 20), 3, 2));
  colliders.add(new RectangleCollider(new PVector(15, 20), 3, 3));
  colliders.add(new CircleCollider(new PVector(10, 7), 2.5f));
  
  p1 = new PVector(11, 3);
  p2 = new PVector(11, 15);
  
  mouseCollider = new RectangleCollider(new PVector(5, 5), 3.5f, 1.5f);
}

void draw()
{
  background(200);
  translate(0, height);
  scale(Gridsize);
  mouseCollider.Position = new PVector(mouseX / Gridsize, (height - mouseY) / Gridsize);
  collisionThisFrame = false;
  CheckForCollisions();
  DrawAllColliders();
  DrawInterceptionLine();
  GetInterceptionPoints();
  DrawInterceptionPoints();
}

void mouseClicked()
{
  if(mouseButton == LEFT)
  {
    if(mouseCollider instanceof CircleCollider)
    {
      mouseCollider = new RectangleCollider(new PVector(0, 0), 3.5f, 1.5f);
    }
    else
    {
      mouseCollider = new CircleCollider(new PVector(0, 0), 2f);
    }
  }
}

void keyPressed()
{
  if(key == 'a')
  {
    PVector temp = new PVector(mouseX / Gridsize, (height - mouseY) / Gridsize);
    
    if(!temp.equals(p2))
    {
      p1 = temp;
    }
  }
  else if(key == 's')
  {
    PVector temp = new PVector(mouseX / Gridsize, (height - mouseY) / Gridsize);
    
    if(!temp.equals(p1))
    {
      p2 = temp;
    }
  }
}

void DrawInterceptionLine()
{
  line(p1.x, -p1.y, p2.x, -p2.y);
}

void GetInterceptionPoints()
{
  interceptionpoints.clear();
  
  for(Collider c : colliders)
  {
    if(c instanceof CircleCollider)
    {
      CircleCollider circle = (CircleCollider) c;
      ArrayList<PVector> interceptions = Utilities.GetRayCircleInterceptionPoints(new Ray(p1, p2), circle);
      if(interceptions != null)
      {
        interceptionpoints.addAll(interceptions);
        
        for(PVector p : interceptions)
        {
          println(p);
        }
      }
    }
    else if(c instanceof RectangleCollider)
    {
      RectangleCollider rect = (RectangleCollider) c;
      ArrayList<PVector> interceptions = Utilities.CalculateRayBoxInterceptions(new Ray(p1, p2), rect);
      if(interceptions != null)
      {
        interceptionpoints.addAll(interceptions);
      }
    }
  }
}

void DrawInterceptionPoints()
{
  fill(0, 0, 255);
  
  for(PVector point : interceptionpoints)
  {
    ellipse(point.x, -point.y, 0.5, 0.5);
  }
}

void CheckForCollisions()
{
  for(Collider col : colliders)
  {
    if(Utilities.CheckCollision(col, mouseCollider))
    {
      collisionThisFrame = true;
    }
  }
}

void DrawAllColliders()
{
  strokeWeight(2 / Gridsize);
  
  noFill();
  
  for(Collider col : colliders)
  {
    col.Draw();
  }
  
  if(collisionThisFrame)
  {
    fill(255, 0, 0);
  }
  else
  {
    fill(0, 255, 0);
  }
  
  mouseCollider.Draw();
}
